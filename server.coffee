express = require('express')
webot = require('weixin-robot')
require('coffee-script')

app = express().use(express.logger())

webot.set('hi', "Hi, I'm Webot.")

webot.set('subscribe',
  pattern: (info)-> info.event is 'subscribe'
  handler: (info)-> 'Thank you for subscribe.'
)

webot.watch(app, { token:'superwolf', path: 'html5移动开发' })

app.listen(8000)



