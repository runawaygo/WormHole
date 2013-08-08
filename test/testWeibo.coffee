require('coffee-script')
require("mocha")
require('should')
WeiboApi = require("../weibo").WeiboApi

weiboApi = new WeiboApi("2.00t27bEC43faDB96f2bf5e05MzkK2E")
console.log 'superwolf'
console.log weiboApi.statuses_public_timeline
console.log weiboApi