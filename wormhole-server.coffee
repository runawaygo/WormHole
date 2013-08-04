express = require('express')
webot = require('weixin-robot')
require('coffee-script')
weibo = require("./weibo")
UserRepository = require('./lib/userRepository.coffee')


serverAddress = '112.124.14.246'
registUrl = "http://#{serverAddress}/client/regist.html"

console.log registUrl

userRepository = new UserRepository(serverAddress)

app = express()
app.use(express.logger())
app.use(express.static(__dirname+'/client/'))
app.use('/test', (req,res)->
  res.end('holy shit')
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
    console.log info
    from = info.uid
    type = info.type
    content = info.text

    userRepository.getAccessToken( from, (accessToken) ->
      if accessToken
        weibo.sendUpdate(accessToken, content, () ->
          return next(null, 'weibo posted')
        )
      next(null, registUrl)
    )
})

webot.watch(app, { token: 'wormhole', path: '/wormhole' })

app.listen(8000)
