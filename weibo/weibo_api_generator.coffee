fs = require('fs')
data = fs.readFileSync __dirname+'/weibo_api_source.txt','utf8'
regex3 = ///
  (\S+)\s+(\S+)\s+(\S+)
///
regex2 = ///
  (\S+)\s+(\S+)
///
regex1 = /^(\s|\xA0)+|(\s|\xA0)+$/

baseUrl = 'https://api.weibo.com/2/'
apiArray = []
apiObj = {}
curGroup = null
curType = null
for line in data.split('\n')
  if regex3.test line
    [_, type, url, doc] = regex3.exec(line)
    if type.indexOf('读取') isnt -1
      curType = {method: "GET", doc:type}
    else
      curType = {method: "POST", doc:type}

    if not curGroup.name 
      curGroup.name = /^\w+/.exec(url)[0]

    curGroup.apis.push({url:baseUrl+url+'.json', doc:doc,method:curType.method})

  else if regex2.test line
    [_, url, doc] = regex2.exec(line)
    curGroup.apis.push({url:baseUrl+url+'.json', doc:doc,method:curType.method})
  else
    group = line.replace(regex1, '')
    curGroup = {doc:group, apis:[]}
    apiArray.push(curGroup)

for group in apiArray
  if apiObj[group.name]
    apiObj[group.name].apis = apiObj[group.name].apis.concat(group.apis)
  else
    apiObj[group.name] = group

fs.writeFile(__dirname+"/weibo_api_urls.coffee", "module.exports="+JSON.stringify(apiObj))
