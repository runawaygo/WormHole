connect = require("connect")
url = require('url')
request = require('request')
https = require('https')
weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=969200639&response_type=code&redirect_uri=http://leto.com:8000/callback"
accessTokenLoginUrl = 'https://api.weibo.com/oauth2/access_token?client_id=969200639&client_secret=9d00536a5ef653c2ff549e47ade7f06a&grant_type=authorization_code&redirect_uri=http://leto.com:8000/callback&code=CODE'
timelineUrl = "https://api.weibo.com/2/statuses/public_timeline.json?access_token=TOKEN"
updateUrl = "https://api.weibo.com/2/statuses/update.json?access_token=TOKEN&status=STATUS"
updatePathUrl = "/2/statuses/update.json?access_token=TOKEN&status=STATUS"

connect()
.use(connect.logger())
.use(connect.query())
.use(connect.bodyParser())
.use('/', connect.static(__dirname+'/'))
.use('/callback', (req,userRes)->
  console.log req.query
  accessTokenLoginUrl = accessTokenLoginUrl.replace('CODE', req.query.code)
  request.post(accessTokenLoginUrl,(err, localResponse, body)->
    bodyJSON = JSON.parse body
    request.get(timelineUrl.replace('TOKEN', bodyJSON.access_token), (err, localResponse,body)->
      access_token = bodyJSON.access_token ? "2.00t27bEC43faDB96f2bf5e05MzkK2E"
    
      _updateUrl = updateUrl.replace('TOKEN', access_token).replace('STATUS', "superwolf")
      _updateUrl = _updateUrl.split('?')

      options = 
        hostname: 'api.weibo.com'
        port: 443
        path: updatePathUrl.replace('TOKEN', access_token).replace('STATUS', "superwolf")
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
          userRes.end(d.toString())
      )

      req.write("")
      req.end()

      req.on 'error', (e) ->
        console.error(e);
    )
  )
)
.listen(8000) 