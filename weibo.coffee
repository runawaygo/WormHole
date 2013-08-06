require('coffee-script')
redis = require('redis')

url = require('url')
superagent = require('superagent')
https = require('https')
UserRepository = require('./lib/userRepository')


serverAddress = "112.124.14.246"
updatePathUrl = "/2/statuses/update.json?access_token=TOKEN&status=STATUS"
monitorPathUrl = "/2/friendships/groups/timeline.json"
public_timeline = "https://api.weibo.com/2/statuses/public_timeline.json"
MONITOR_INTERVAL = 5000

class WeiboApi
  constructor:(@appkey, @secretKey, @serverAddress)->
    @redirectUrl = "http://#{@serverAddress}/callback"
    @weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=#{@appkey}&response_type=code&redirect_uri=#{@redirectUrl}"
    @accessTokenUrl = "https://api.weibo.com/oauth2/access_token?client_id=#{@appkey}&client_secret=#{@secretKey}&grant_type=authorization_code&redirect_uri=#{@redirectUrl}&code=CODE"
    @agent = superagent.agent()

  onCallback:(req, res, next)=>
    @accessTokenUrl = @accessTokenUrl.replace('CODE', req.query.code)
    @agent
      .post(@accessTokenUrl)
      .set('Content-Type', 'application/x-www-form-urlencoded')
      .set('Content-Length', 0)
      .end (err, _res)=>
        # console.log _res
        # console.log "&=(************"
        # console.log _res.text
        # console.log _res.error
        # console.log "&=(************"
        @access_token = JSON.parse(_res.text).access_token
        next()

  public_timeline:()->
    @agent.get(public_timeline + "?access_token=#{@access_token}")
      .end (err,res)->
        console.log res.text

exports.WeiboApi = WeiboApi


# appkey = "3973039044"
# appSecret = "43c040c670cc378728c70283270e7187"


# weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=#{appkey}&response_type=code&redirect_uri=http://#{serverAddress}/callback"
# accessTokenLoginUrl = "https://api.weibo.com/oauth2/access_token?client_id=#{appkey}&client_secret=#{appSecret}&grant_type=authorization_code&redirect_uri=http://#{serverAddress}/callback&code=CODE"


# class WeiboRequest
#   constructor: (method, path, query, headers) ->
#     console.log 'holyshit'
#     console.log query
#     # FIXME, query string not encoded in this quick prototyping
#     queryString = ""
#     if query
#       for paramName of query
#         if queryString.length > 0
#           queryString += "&"
#         queryString += paramName + "=" + query[paramName]
#     console.log queryString
#     @options =
#       hostname: 'api.weibo.com'
#       port: 443
#       method: method
#       path: path + '?' + queryString
#       headers: headers

#   send: (responseHandler, requestBody) ->
#     console.log @options
#     request = https.request(@options, responseHandler)
#     request.on 'error', (e) ->
#       console.error(e);
#     if requestBody
#       request.write(requestBody)
#     request.end()


# userRepository = new UserRepository(serverAddress)

exports.getAccessToken = (req, res, callback)->
  accessTokenLoginUrl = accessTokenLoginUrl.replace('CODE', req.query.code)
  request.post(accessTokenLoginUrl,(err, localResponse, body)->
    bodyJSON = JSON.parse body
    unless bodyJSON.access_token
      console.log localResponse
      console.log body
    callback?(null, bodyJSON.access_token)
  )

# exports.sendUpdate = (access_token, content, callback)->
#   path = updatePathUrl.replace('TOKEN', access_token).replace('STATUS',  content)
#   headers = {
#     'Content-Type': 'application/x-www-form-urlencoded',
#     'Content-Length': 0
#   }
#   responseHandler = (res)->
#     res.on 'data',(d)-> 
#       process.stdout.write(d)
#       console.log "*****"
#       typeof d
#       callback?(d)
#   new WeiboRequest('POST', path, null, headers).send(responseHandler, "")

# redisClient = redis.createClient(null, serverAddress, redis.print)

# exports.registerMonitoredList = (accessToken, listId) ->
#   redisClient.set("listId:" + accessToken, listId)

# ###
# accessToken:2.00t27bEC43faDB96f2bf5e05MzkK2E
# listId:201012230017819693
# since:null
# (data)->console.log data
# ###
# exports.checkListUpdate = (accessToken, listId, since, newWeiboHandler)->
#   query = 
#     'access_token': accessToken
#     'list_id': listId
#     'count':5
#     'since_id': since

#   queryString = ("#{key}=#{value}" for key, value of query).join('&')

#   request("https://api.weibo.com"+monitorPathUrl+'?'+queryString, (err, res, body)->  
#     newWeiboHandler JSON.parse body
#   )
exports.testSA = ->
  agent = superagent.agent()
  agent
    .get('http://www.baidu.com')
    .end (err, res)->
      console.log res
