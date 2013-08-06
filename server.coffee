require('coffee-script')
connect = require("express")
url = require('url')
request = require('request')
https = require('https')

WeiboApi = require('./weibo').WeiboApi

appkey = "969200639"
appSecret = "9d00536a5ef653c2ff549e47ade7f06a"
server = "leto.com:8000"

weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=#{appkey}&response_type=code&redirect_uri=http://#{server}/callback"
accessTokenLoginUrl = 'https://api.weibo.com/oauth2/access_token?client_id=#{appkey}&client_secret=#{appSecret}&grant_type=authorization_code&redirect_uri=http://#{server}/callback&code=CODE'
timelineUrl = "https://api.weibo.com/2/statuses/public_timeline.json?access_token=TOKEN"
updatePathUrl = "/2/statuses/update.json?access_token=TOKEN&status=STATUS"

weiboApi = new WeiboApi(appkey, appSecret, server)

connect()
.use(connect.logger())
.use(connect.query())
.use(connect.bodyParser())
.use('/regist', (req,res)->
  res.redirect(weiboApi.weiboLoginUrl)
)
.use('/callback', weiboApi.onCallback)
.listen(8000) 