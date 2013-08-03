connect = require("connect")
url = require('url')
request = require('request')
https = require('https')

updatePathUrl = "/2/statuses/update.json?access_token=TOKEN&status=STATUS"


exports.sendUpdate = (access_token, content, callback)->
  _updateUrl = updateUrl.replace('TOKEN', access_token).replace('STATUS', "superwolf")
  _updateUrl = _updateUrl.split('?')

  options = 
    hostname: 'api.weibo.com'
    port: 443
    path: updatePathUrl.replace('TOKEN', access_token).replace('STATUS', "superwolf")
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
      userRes.end(d.toString())
  )

  req.write("")
  req.end()

  req.on 'error', (e) ->
    console.error(e);


