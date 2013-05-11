fino = require('./data/dataAccess')
redis = require("redis")
client = redis.createClient()

expenses = (info)->
  client.info.content.split ' '
  client.lpush "superwolf", [1,21,21,2,13,1,21]
category = (info)->