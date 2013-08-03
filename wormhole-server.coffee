express = require('express')
webot = require('weixin-robot')
redis = require('redis')
require('coffee-script')
weibo = require("./weibo")

redisClient = redis.createClient(null, '112.124.14.246', redis.print)
# redisClient.set('abc','123')
# redisClient.get('abc', (err, reply)-> console.log(reply.toString()))

bindUser = (wechatId, accessToken)->
  redisClient.set('wechat:' + wechatId, accessToken)
  redisClient.set('accessToken:' + accessToken, wechatId)

getAccessToken = (wechatId, callback) ->
  callback "2.00t27bEC43faDB96f2bf5e05MzkK2E"
  return
  redisClient.get('wechat:' + wechatId, (err, reply) ->
    console.log('redis get error..........>>>> ' + err)
    if err
      # FIXME
      process.stdout.write err
      return
    
    callback(reply.toString())) if callback

app = express()
app.use(express.logger())
app.use('/test', (req,res)->
  res.end('superwolf')
)

webot.set('subscribe',{
  pattern: (info)-> info.is('event') and info.param.event is 'subscribe'
  handler: (info)-> 'hello'
})

webot.set('hi', "Weibo was posted successfully!")


webot.set('message-from-wechat-user', {
  pattern: /.*/
  handler: (info, next)->

    console.log info
    from = info.uid # Could be wrong
    to = info.sp # Could be wrong
    type = info.type
    content = info.text
    console.warn("From: " + from + ", To: " + to + ", Type: " + type + ", Content: " + content)

    getAccessToken( from, (accessToken) ->
      weibo.sendUpdate(accessToken, content, () ->
        return next(null, 'weibo posted')
      )
    )
})

webot.watch(app, { token: 'wormhole', path: '/wormhole' })

app.listen(8000)
