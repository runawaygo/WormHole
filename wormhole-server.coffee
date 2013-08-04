express = require('express')
webot = require('weixin-robot')
require('coffee-script')
weibo = require("./weibo")
UserRepository = require('./lib/userRepository.coffee')


serverAddress = '112.124.14.246'
registAction = "http://#{serverAddress}/regist"
registUrl = "http://#{serverAddress}/client/regist.html"
getAccessTokenSuccessUrl = "http://#{serverAddress}/client/success.html"

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
  res.redirect('/client/regist.html')
)
app.use('/callback', (req,res)->
  weibo.getAccessToken(req, res, (err, accessToken)->
    if err
      console.log err
  
    wechatId = req.cookies.wechatId
    console.log '************'
    userRepository.bindUser(wechatId, accessToken)
    res.redirect(getAccessTokenSuccessUrl)
  )
)

webot.set('subscribe',{
  pattern: (info)-> info.is('event') and info.param.event is 'subscribe'
  handler: (info)->
    console.log info
    return 'hello'
})

webot.set('hi', "Weibo was posted successfully!")


webot.set('message-from-wechat-user', {
  pattern: /.*/
  handler: (info, next)->
    # console.log info
    wechatId = info.uid
    type = info.type
    content = info.text

    userRepository.getAccessToken(wechatId, (accessToken) ->
      console.log accessToken
      if accessToken
        weibo.sendUpdate(accessToken, content, () ->
          return next(null, 'weibo posted')
        )
      next(null, registAction+'?wechatId='+wechatId)
    )
})

webot.watch(app, { token: 'wormhole', path: '/wormhole' })

app.listen(8000)
