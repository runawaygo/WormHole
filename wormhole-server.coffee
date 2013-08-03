express = require('express');
webot = require('weixin-robot');

app = express();

# 指定回复消息
webot.set('hi', '你好');

webot.set('subscribe', {
  pattern: (info)->
    return info.is('event') && info.param.event === 'subscribe';
  handler: (info)->
    return '欢迎订阅微信机器人'
  }
});

# 接管消息请求
webot.watch(app, { token: 'wormhole', path: '/wormhole' });