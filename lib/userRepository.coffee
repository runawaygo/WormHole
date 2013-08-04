redis = require('redis')

# redisClient.set('abc','123')
# redisClient.get('abc', (err, reply)-> console.log(reply.toString()))

class UserRepository
  constructor:(@server)->
    @redisClient = redis.createClient(null, @server, redis.print)

  bindUser:(wechatId, accessToken)->
    console.log wechatId
    console.log accessToken
    @redisClient.set('wechat:'+wechatId, accessToken)
    @redisClient.set('accessToken:'+accessToken, wechatId)

  getAccessToken:(wechatId, callback) ->
    @redisClient.get('wechat:' + wechatId, (err, reply) ->
      if err
        process.stdout.write err
        console.log('redis get error..........>>>> ' + err)
        return

      callback(reply) if callback
    )

module.exports = UserRepository
