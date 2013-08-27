express = require('express')
webot = require('weixin-robot')
require('coffee-script')
weibo = require("./weibo")
UserRepository = require('./lib/userRepository.coffee')


Weibo = require('./weibo')

appkey = "969200639"
appSecret = "9d00536a5ef653c2ff549e47ade7f06a"
serverAddress = '112.124.14.246'
registAction = "http://#{serverAddress}/regist"
registUrl = "http://#{serverAddress}/client/regist.html"
getAccessTokenSuccessUrl = "http://#{serverAddress}/client/success.html"
console.log Weibo
weiboAuth = new Weibo.WeiboAuth(appkey, appSecret, serverAddress)

console.log registUrl

userRepository = new UserRepository(serverAddress)

app = express()
app.use(express.logger())
app.use(express.cookieParser())
app.use(express.bodyParser())
app.use('/client', express.static(__dirname+'/client/'))
app.use('/test', (req,res)->
  res.end('holy shit')
)
app.use('/testCookie', (req,res)->
  console.log req.cookies
  res.end JSON.stringify req.cookies
)
app.use('/regist', (req,res)->
  console.log req.query
  wechatId = req.query.wechatId
  res.cookie('wechatId', wechatId, { expires: new Date(Date.now() + 900000), httpOnly: true })
  res.redirect(registUrl)
)
app.use('/callback', weiboAuth.onCallback)
app.use('/callback', (req,res)->
  wechatId = req.cookies.wechatId
  userRepository.bindUser(wechatId, weiboAuth.access_token)
  res.redirect(getAccessTokenSuccessUrl)
)

webot.set('subscribe',{
  pattern: (info)-> info.is('event') and info.param.event is 'subscribe'
  handler: (info)->
    console.log info
    return 'hello'
})

webot.set('hi', "Weibo was posted successfully!")

webot.set('pull-request', {
  pattern: /l/
  handler: (info, next)->
    # console.log info
    wechatId = info.uid
    type = info.type

    userRepository.getAccessToken(wechatId, (err, access_token)->
      return next(null, registAction+'?wechatId='+wechatId) unless access_token

      weiboApi = new Weibo.WeiboApi(access_token)
      weiboApi.statuses_home_timeline((data)->
        message = ("@"+item.user.screen_name+':   \n'+item.text for item in data.statuses[0...5]).join('\n-----------------\n')
        next(null, message)
      ) 
    )
})

webot.set('message-from-wechat-user', {
  pattern: /.*/
  handler: (info, next)->
    # console.log info
    wechatId = info.uid
    type = info.type
    content = info.text

    userRepository.getAccessToken(wechatId, (err, access_token)->
      return next(null, registAction+'?wechatId='+wechatId) unless access_token
      weiboApi = new Weibo.WeiboApi(access_token)
      weiboApi.statuses_update(content,->
        next(null, 'weibo posted')
      ) 
    )
})

webot.watch(app, { token: 'wormhole', path: '/wormhole' })

app.listen(8000)
