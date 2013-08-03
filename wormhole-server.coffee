express = require('express')
webot = require('weixin-robot')
redis = require('redis')

redisClient = redis.createClient(null, '112.124.14.246', redis.print)
# redisClient.set('abc','123')
# redisClient.get('abc', (err, reply)-> console.log(reply.toString()))



bindUser(wechatId, accessToken)->
  redisClient.set('wechat:' + wechatId, accessToken)
  redisClient.set('accessToken:' + accessToken, wechatId)
getAccessToken(wechatId, callback) ->
  redisClient.get('wechat:' + wechatId, (err, reply) ->
    console.log('redis get error..........>>>> ' + err)
    if err
      # FIXME
      return
    else
      if callback then callback(reply.toString()))

app = express()
app.usa.logger())
app.use('/test', (req,res)->
  res.end('superwolf')
)

webot.set('subscribe',{
  pattern: (info)-> info.is('event') and info.param.event is 'subscribe'
  handler: (info)-> 'hello'
})

webot.set('message-from-wechat-user', {
  pattern: /.*/,
  handler: (info, next) ->
    from = info.fromUsername
    content = info.content
    console.warn("From: " + from + ", To: " + info.toUsername + ", Type: " + info.type + ", Content: " + content)
    getAccessToken( from, (accessToken) ->
      postWeibo(accessToken, content, () ->
        return next(null, 'weibo posted'))))
})

webot.watch(app, { token: 'wormhole', path: '/wormhole' })

app.listen(80)
