# express = require('express')
# webot = require('weixin-robot')
# require('coffee-script')

# app = express().use(express.logger())

# webot.set('hi', "Hi, I'm Webot.")

# webot.set('subscribe',
#   pattern: (info)-> info.event is 'subscribe'
#   handler: (info)-> 'Thank you for subscribe.'
# )

# webot.watch(app, { token:'superwolf', path: 'html5移动开发' })

# app.listen(8000)

# browser = require("browser");
# browser.browse("shinout.net", (err, out)->
#   console.log(out.result);
# );


browser = require("browser")
userdata = {
  email: "ygd.weibo.superwolf@gmail.com",
  pass : "superwolf"
}

browser = require("browser")
$b = new browser()
$b.browse('login', 'http://weibo.com/', {debug: true})

$b.browse((err, out)->
  jsdom = require("jsdom").jsdom
  jquery = require("jquery")
  window = jsdom(out.result).createWindow()
  $ = jquery.create(window)
  postdata = 
    Email  : userdata.email
    Passwd : userdata.pass

  url = $("#gaia_loginform").attr("action")
  # get hidden fields, and register them to post data
  $("input").each (k, el)->
    $el = $(el)
    name = $el.attr("name")
    type = $el.attr("type")
    val = $el.val()
    if type is "hidden" or type is "submit" 
      postdata[name] = val

  return [url, {
    data  : postdata, # set post data
    method: "POST"    # set HTTP method (default: GET)
  }]
)
.after("login") # browse after browsing with label="login"

$b.browse('https://mail.google.com/mail/u/0/?ui=html&zy=d').after() # browse after previously registered function

$b.on("end", (err, out)->
  console.log(out.result)
)
$b.run()
