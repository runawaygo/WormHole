redis = require('redis')

# redisClient.set('abc','123')
# redisClient.get('abc', (err, reply)-> console.log(reply.toString()))

class UserRepository
  constructor:(@server)->
    @redisClient = redis.createClient(null, server, redis.print)

  bindUser:(wechatId, accessToken)->
    redisClient.set('wechat:' + wechatId, accessToken)
    redisClient.set('accessToken:' + accessToken, wechatId)

  getAccessToken:(wechatId, callback) ->
    redisClient.get('wechat:' + wechatId, (err, reply) ->
      console.log('redis get error..........>>>> ' + err)
      if err
        # FIXME
        process.stdout.write err
        return
      callback(reply) if callback
    )

module.exports = UserRepository
