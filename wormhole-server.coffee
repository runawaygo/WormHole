express = require('express');
webot = require('weixin-robot');

app = express();
app.use(express.logger())
app.use('/test', (req,res)->
  res.end('superwolf')
)

webot.set('hi', 'hello');

webot.set('subscribe',{
  pattern: (info)-> info.is('event') and info.param.event is 'subscribe'
  handler: (info)-> 'hello'
})

webot.watch(app, { token: 'wormhole', path: '/wormhole' });

app.listen(80)
