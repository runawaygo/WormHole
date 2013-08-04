redis = require('redis')

# redisClient.set('abc','123')
# redisClient.get('abc', (err, reply)-> console.log(reply.toString()))

class UserRepository
  constructor:(@server)->
    @redisClient = redis.createClient(null, @server, redis.print)

  bindUser:(wechatId, accessToken)->
    console.log wechatId
    console.log accessToken
    wechatId = "o1bv-jm6b8mUf0x307mZPRxdVs8k; JSESSIONID.540cecb1=9d19bffef28421392abca914e0d2a566; JSESSIONID.820e5cfc=2b50f797fd5829450189a98d85ed5f99; screenResolution=1280x800"
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
