require('coffee-script')
connect = require("express")
url = require('url')
request = require('request')
https = require('https')

Weibo = require('./weibo')

appkey = "969200639"
appSecret = "9d00536a5ef653c2ff549e47ade7f06a"
server = "leto.com:8000"

weiboAuth = new Weibo.WeiboAuth(appkey, appSecret, server)

connect()
.use(connect.logger())
.use(connect.query())
.use(connect.bodyParser())
.use('/regist', weiboAuth.regist)
.use('/callback', weiboAuth.onCallback)
.use('/callback', (req,res)->
  weiboApi = new Weibo.WeiboApi(weiboAuth.access_token)
  weiboApi.statuses_public_timeline((err, data)->
    res.end data
  )
)
.listen(8000)