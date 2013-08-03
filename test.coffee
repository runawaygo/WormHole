fs = require('fs')
request = require("request")

weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=969200639&response_type=code&redirect_uri=http://leto.com:8000/callback"
accessTokenLoginUrl = 'https://api.weibo.com/oauth2/access_token?client_id=969200639&client_secret=9d00536a5ef653c2ff549e47ade7f06a&grant_type=authorization_code&redirect_uri=YOUR_REGISTERED_REDIRECT_URI&code=CODE'
request(url, (err,response)->
  console.log err
  console.log response
).pipe(fs.createWriteStream(__dirname+'/t.txt'))