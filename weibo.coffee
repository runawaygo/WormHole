require('coffee-script')

url = require('url')
request = require('request')
https = require('https')
UserRepository = require('./lib/userRepository')


serverAddress = "112.124.14.246"
updatePathUrl = "/2/statuses/update.json?access_token=TOKEN&status=STATUS"

appkey = "3973039044"
appSecret = "43c040c670cc378728c70283270e7187"


weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=#{appkey}&response_type=code&redirect_uri=http://#{serverAddress}/callback"
accessTokenLoginUrl = "https://api.weibo.com/oauth2/access_token?client_id=#{appkey}&client_secret=#{appSecret}&grant_type=authorization_code&redirect_uri=http://#{serverAddress}/callback&code=CODE"

userRepository = new UserRepository(serverAddress)

exports.getAccessToken = (req, res, callback)->
  accessTokenLoginUrl = accessTokenLoginUrl.replace('CODE', req.query.code)
  request.post(accessTokenLoginUrl,(err, localResponse, body)->
    bodyJSON = JSON.parse body
    unless bodyJSON.access_token
      console.log localResponse
      console.log body
    callback?(bodyJSON.access_token)
  )
exports.sendUpdate = (access_token, content, callback)->

  options = 
    hostname: 'api.weibo.com'
    port: 443
    path: updatePathUrl.replace('TOKEN', access_token).replace('STATUS',  content)
    method: 'POST'
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Length': 0
    }

  req = https.request(options, (res)->
    res.on 'data',(d)-> 
      process.stdout.write(d)
      console.log "*****"
      typeof d
      callback?(d)
  )

  req.write("")
  req.end()

  req.on 'error', (e) ->
    console.error(e);


