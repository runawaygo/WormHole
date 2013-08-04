require('coffee-script')
weibo = require("./weibo")
# weibo.sendUpdate "2.00t27bEC43faDB96f2bf5e05MzkK2E", "sldfjas;df", (updateResponseBody) ->
#   console.log updateResponseBody 

weibo.checkListUpdate "2.00t27bEC43faDB96f2bf5e05MzkK2E", '201012230017819693',0, ((data)->console.log data)
