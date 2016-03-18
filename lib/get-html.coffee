Config = require './config'
http = require 'http'
fs = require 'fs'
low = require 'lowdb'
storage = require 'lowdb/file-sync'
format = require 'string-format'
cheerio = require 'cheerio'
async = require 'async'

format.extend(String.prototype)

g_basePath = "#{Config.basePath}data/"
fs.mkdir g_basePath if not fs.existsSync g_basePath

db = low "#{g_basePath}config_db.json", {storage}
db0 = low "#{g_basePath}index_db.json", {storage}
db1 = low "#{g_basePath}html_content_db.json", {storage}
db2 = low "#{g_basePath}final_content_db.json", {storage}

config = {
  urlIndex: "http://blog.sina.com.cn/s/articlelist_3781886340_0_{0}.html"
  begin: 1
  end: 1
  txtPath: "#{g_basePath}result.txt"
}

main = () ->
  console.log "hello ylw...."
  # return
  # 下载目录数据
  loadIndexData()
  # 下载网页内容
  loadHtmlData()
  # 解析网页内容
  parseHtmlToText()
  # 组装文档
  buildTxtFile()
  console.log "run over!"

exports.run = main

loadIndexData = () ->
  q = async.queue (task, callback) ->
      queryUrl task.index, task.url, callback
    , 5
  q.drain = -> console.log "loadIndexData : all items have benn processed"
  for i in [config.begin..config.end]
    console.log "loadIndexData - #{i}"
    url = config.urlIndex.format(i)
    q.push {index: i, url: url}

# 请求目录数据，把目录的url存到index_db中
queryUrl = (index, url, callback) ->
  http.get(url, (res) ->
    size = 0
    chunks = []
    res.on 'data', (chunk) ->
      size += chunk.length
      chunks.push chunk
    res.on 'end', ->
      data = Buffer.concat chunks, size
      $ = cheerio.load data.toString()
      arr = $("span.atc_title a")
      for a, i in arr
        db0('index').push { pPage: index, order: i, title: $(a).text(), href: $(a).attr('href')}
      console.log "over #{url}"
      callback()
    ).on 'error',(e) ->
      console.log "#{innerIndex} - Got error : #{e.message}"
      callback e

loadHtmlData = ->
  console.log "loadHtmlData begin.."
  q = async.queue (task, callback) ->
      queryUrlForHtml task.index, task.url, callback
    , 5
  q.drain = -> console.log "loadIndexData : all items have benn processed"

  indexUrls = db0('index').chain().sortBy('order').sortBy('pPage').value()
  indexUrls.reverse()
  for value, index in indexUrls
    console.log "loadIndexData - #{index}"
    url = value.href
    q.push {index: index, url: url}

queryUrlForHtml = (index, url, callback) ->
  http.get(url, (res) ->
    size = 0
    chunks = []
    res.on 'data', (chunk) ->
      size += chunk.length
      chunks.push chunk
    res.on 'end', ->
      data = Buffer.concat chunks, size
      db1('htmls').push {index:index, html: data.toString(), url: url}
      console.log "queryUrlForHtml over : #{url}"
      callback()
    ).on 'error',(e) ->
      console.log "queryUrlForHtml - Got error : #{e.message} - #{url}"
      callback e

parseHtmlToText = ->
  values = db1('htmls').chain().sortBy('index').value()
  for value in values
    $ = cheerio.load value.html
    title = $($('.articalTitle .titName')).text()
    time = $($('.articalTitle .time')).text()
    time = time.substr(1,time.length-2)
    content = $($('.articalContent')).text()
    if(content.length > 0)
      db2('content').push {index:value.index, title: title, time: time, content: content, url: value.url}
      console.log "parseHtmlToText over - #{value.url}"
    else
      console.error "parseHtmlToText errpr - #{value.url}"

buildTxtFile = ->
  values = db2('content').chain().sortBy('index').value()
  txtPath = config.txtPath
  options = { encoding: 'utf8', mode: 666, flag: 'a+' }
  for value in values
    buffer = []
    buffer.push '\n\n\n'
    buffer.push value.title.trim()
    buffer.push '\n\t'
    buffer.push value.time
    buffer.push '\n\n\n'
    buffer.push value.content.trim()
    fs.appendFileSync txtPath, buffer.join(), options, (err) ->
      throw err if err
  console.log "buildTxtFile over!"
