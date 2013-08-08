require('coffee-script')
superagent = require('superagent')
weiboApiUrls = require('./weibo_api_urls')

class WeiboAuth
  constructor:(@appkey, @secretKey, @serverAddress)->
    @redirectUrl = "http://#{@serverAddress}/callback"
    @weiboLoginUrl = "https://api.weibo.com/oauth2/authorize?client_id=#{@appkey}&response_type=code&redirect_uri=#{@redirectUrl}"
    @accessTokenUrl = "https://api.weibo.com/oauth2/access_token?client_id=#{@appkey}&client_secret=#{@secretKey}&grant_type=authorization_code&redirect_uri=#{@redirectUrl}&code=CODE"
    @agent = superagent.agent()

  onCallback:(req, res, next)=>
    @accessTokenUrl = @accessTokenUrl.replace('CODE', req.query.code)
    @agent
      .post(@accessTokenUrl)
      .set('Content-Type', 'application/x-www-form-urlencoded')
      .set('Content-Length', 0)
      .end (err, _res)=>
        @access_token = JSON.parse(_res.text).access_token
        next()

class WeiboApi
  constructor:(@access_token)->
    @agent = superagent.agent()

generateApi = (key, api)->
  methodName = /(\w+)\.json$/.exec(api.url)[1]
  WeiboApi::["#{key}_#{methodName}"] = (args, callback)->
    if typeof args is 'function'
      callback = args
      args = {}
    args.access_token = @access_token

    queryString = ("#{key}=#{value}" for key, value of args).join('&')
    url = api.url+'?'+queryString
    process.stdout.write "Request #{api.doc} : #{url}\n"
    switch api.method
      when 'POST'
        @agent.post(url, (err, res)->  
          callback err, JSON.parse res.text
        )    
      else
        @agent.get(url, (res)->  
          console.log res
          console.log res.text
          callback null, res.text
        ) 

for key, item of weiboApiUrls
  generateApi key,api for api in item.apis

        

exports.WeiboApi = WeiboApi
exports.WeiboAuth = WeiboAuth