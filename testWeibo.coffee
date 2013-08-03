require('coffee-script')
weibo = require("./weibo")
weibo.sendUpdate "2.00t27bEC43faDB96f2bf5e05MzkK2E", "sldfjas;df", (updateResponseBody) ->
  console.log updateResponseBody
