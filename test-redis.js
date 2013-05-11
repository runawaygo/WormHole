var redis = require("redis"),
    client = redis.createClient();

  // if you'd like to select database 3, instead of 0 (default), call
  // client.select(3, function() { /* ... */ });

  client.on("error", function (err) {
    console.log("Error " + err);
  });

  client.set("string key", "string val", redis.print);
  client.hset("hash key11", "hashtest 1", "some value", redis.print);
  client.hset(["hash key", "hashtest 2", "some other value"], redis.print);
  client.hkeys("hash key11", function (err, replies) {
    console.log(replies.length + " replies:");
    replies.forEach(function (reply, i) {
      console.log("    " + i + ": " + reply);
    });
  });

  client.get("string key", function(err, reply) {
    // reply is null when the key is missing
    console.log(reply);
  });

  client.lpush("superwolf", 1,21,21,2,13,1,21, function(){
    client.llen("superowlf", function(err, reply){
      console.log('superwolf')
      console.log(err);
      console.log(reply);
    
      client.lrange("superwolf",0,reply-1, function(err, replies){
        console.log(err)
        console.log(replies)
      });  
    });
  });



  