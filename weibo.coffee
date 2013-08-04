require('coffee-script')
redis = require('redis')

url = require('url')
request = require('request')
https = require('https')
UserRepository = require('./lib/userRepository')


serverAddress = "112.124.14.246"
updatePathUrl = "/2/statuses/update.json?access_token=TOKEN&status=STATUS"
monitorPathUrl = "/2/friendships/groups/timeline.json"
MONITOR_INTERVAL = 5000

appkey = "3973039044"
appSecret = "43c040c670cc378728c70283270e7187"


weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=#{appkey}&response_type=code&redirect_uri=http://#{serverAddress}/callback"
accessTokenLoginUrl = "https://api.weibo.com/oauth2/access_token?client_id=#{appkey}&client_secret=#{appSecret}&grant_type=authorization_code&redirect_uri=http://#{serverAddress}/callback&code=CODE"


class WeiboRequest
  constructor: (method, path, query, headers) ->
    console.log 'holyshit'
    console.log query
    # FIXME, query string not encoded in this quick prototyping
    queryString = ""
    if query
      for paramName of query
        if queryString.length > 0
          queryString += "&"
        queryString += paramName + "=" + query[paramName]
    console.log queryString
    @options =
      hostname: 'api.weibo.com'
      port: 443
      method: method
      path: path + '?' + queryString
      headers: headers

  send: (responseHandler, requestBody) ->
    console.log @options
    request = https.request(@options, responseHandler)
    request.on 'error', (e) ->
      console.error(e);
    if requestBody
      request.write(requestBody)
    request.end()


userRepository = new UserRepository(serverAddress)

exports.getAccessToken = (req, res, callback)->
  accessTokenLoginUrl = accessTokenLoginUrl.replace('CODE', req.query.code)
  request.post(accessTokenLoginUrl,(err, localResponse, body)->
    bodyJSON = JSON.parse body
    unless bodyJSON.access_token
      console.log localResponse
      console.log body
    callback?(null, bodyJSON.access_token)
  )

exports.sendUpdate = (access_token, content, callback)->
  path = updatePathUrl.replace('TOKEN', access_token).replace('STATUS',  content)
  headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Content-Length': 0
  }
  responseHandler = (res)->
    res.on 'data',(d)-> 
      process.stdout.write(d)
      console.log "*****"
      typeof d
      callback?(d)
  new WeiboRequest('POST', path, null, headers).send(responseHandler, "")

redisClient = redis.createClient(null, serverAddress, redis.print)

exports.registerMonitoredList = (accessToken, listId) ->
  redisClient.set("listId:" + accessToken, listId)

exports.startMonitor = (accessTokenList, newWeiboHandler) ->
  for accessToken in accessTokenList
    redisClient.get("listId:" + accessToken, (err, listId) ->
      return if err
      redisClient.get("since:" + accessToken, (err, since) ->
        return if err
        # FIXME Not a good idea, just for this quick prototype
        setInterval((() -> checkListUpdate(accessToken, listId.toString(), since.toString(), newWeiboHandler)), MONITOR_INTERVAL)
      )
    )

###
accessToken:2.00t27bEC43faDB96f2bf5e05MzkK2E
listId:201012230017819693
since:null
(data)->console.log data
###
exports.checkListUpdate = (accessToken, listId, since, newWeiboHandler)->
  query = 
    'access_token': accessToken
    'list_id': listId
    'count':5
    'since_id': since
  queryString = ("#{key}=#{value}" for key, value of query).join('&')
  console.log queryString

  responseHandler = (res) ->
    console.log res
    console.log res.body
    bodyJSON = JSON.parse res.body
    if bodyJSON.statuses.length == 0 then return
    newWeiboHandler(accessToken, bodyJSON.statuses)

  request.get("https://api.weibo.com"+monitorPathUrl+'?'+queryString, (err, res, body)->
    console.log err
    console.log body
    newWeiboHandler(accessToken, body)    

  )
  # new WeiboRequest('GET', monitorPathUrl, query, null).send(responseHandler)

