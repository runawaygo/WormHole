connect = require("connect")
url = require('url')
request = require('request')
weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=969200639&response_type=code&redirect_uri=http://leto.com:8000/callback"
accessTokenLoginUrl = 'https://api.weibo.com/oauth2/access_token?client_id=969200639&client_secret=9d00536a5ef653c2ff549e47ade7f06a&grant_type=authorization_code&redirect_uri=http://leto.com:8000/callback&code=CODE'
timelineUrl = "https://api.weibo.com/2/statuses/public_timeline.json?access_token=TOKEN"

connect()
.use(connect.logger())
.use(connect.query())
.use(connect.bodyParser())
.use('/', connect.static(__dirname+'/'))
.use('/callback', (req,res)->
  console.log req.query
  accessTokenLoginUrl = accessTokenLoginUrl.replace('CODE', req.query.code)
  request.post(accessTokenLoginUrl,(err, localResponse, body)->
    console.log 'superwolf1'
    console.log localResponse
    console.log 'superwolf2'
    console.log body
    console.log typeof body
    bodyJSON = JSON.parse body
    console.log 'superwolf3'

    console.log timelineUrl.replace('TOKEN', bodyJSON.access_token)

    request.get(timelineUrl.replace('TOKEN', bodyJSON.access_token), (err, localResponse,body)->
      console.log localResponse
      console.log body
      res.end body
    )
  )
)
.use('/tokenCallback', (req,res)->
  console.log req.query
  console.log req.url
  res.end JSON.stringify req.query
)
.listen(8000) 