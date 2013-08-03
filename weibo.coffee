connect = require("connect")
url = require('url')
request = require('request')
https = require('https')

updatePathUrl = "/2/statuses/update.json?access_token=TOKEN&status=STATUS"


exports.sendUpdate = (access_token, content, callback)->

  options = 
    hostname: 'api.weibo.com'
    port: 443
    path: updatePathUrl.replace('TOKEN', access_token).replace('STATUS',  content)
    method: 'POST'
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Length': 0
    }

  req = https.request(options, (res)->
    res.on 'data',(d)-> 
      process.stdout.write(d)
      console.log "*****"
      typeof d
      callback?(d)
  )

  req.write("")
  req.end()

  req.on 'error', (e) ->
    console.error(e);


