require('coffee-script')
connect = require("express")
url = require('url')
request = require('request')
https = require('https')

WeiboApi = require('./weibo').WeiboApi
WeiboAuth = require('./weibo').WeiboAuth

appkey = "969200639"
appSecret = "9d00536a5ef653c2ff549e47ade7f06a"
server = "leto.com:8000"

weiboAuth = new WeiboAuth(appkey, appSecret, server)

connect()
.use(connect.logger())
.use(connect.query())
.use(connect.bodyParser())
.use('/regist', (req,res)->
  res.redirect(weiboAuth.weiboLoginUrl)
)
.use('/callback', weiboAuth.onCallback)
.use('/callback', (req,res)->
  weiboApi = new WeiboApi(weiboAuth.access_token)
  weiboApi.statuses_public_timeline((err, data)->
    console.log weiboAuth.access_token
    console.log '************'
    console.log data
    res.end data
  )
)
.listen(8000)