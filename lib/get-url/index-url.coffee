Config = require '../config'
http = require 'http'
fs = require 'fs'
low = require 'lowdb'
storage = require 'lowdb/file-sync'
format = require 'string-format'
cheerio = require 'cheerio'
async = require 'async'
request = require 'request'
qs = require 'qs'

format.extend(String.prototype)

g_basePath = "#{Config.basePath}data/data-url/"
mkdirp = require 'mkdirp'
mkdirp.sync g_basePath if not fs.existsSync g_basePath

db = low "#{g_basePath}config_db.json", {storage}
db0 = low "#{g_basePath}index_db.json", {storage}
db1 = low "#{g_basePath}url_config_db.json", {storage}
db2 = low "#{g_basePath}last_urldata_db.json", {storage}

module.exports = class IndexUrl
  listUrls: (filter) ->
    console.log "listUrls"
    db0('index_urls').chain().filter(filter).value()

  insertUrl: (urlObj) ->
    size = db0('index_urls').chain().filter({name: urlObj.name}).value().length
    db0('index_urls').chain().find({name: urlObj.name}).assign(urlObj).value() if size > 0
    db0('index_urls').push urlObj if size is 0
    console.log "insertUrl"

  saveUrlConfig: (urlConfig) ->
    console.log "saveUrlConfig"
    size = db1('url_config').chain().filter({url: urlConfig.url}).value().length
    db1('url_config').chain().find({url: urlConfig.url}).assign(urlConfig).value() if size > 0
    db1('url_config').push urlConfig if size is 0

  getUrlConfig: (url) ->
    console.log "getUrlConfig"
    filter = {url: url}
    db1('url_config').chain().filter(filter).value()

  requestUrl: (urlConfig, callback) ->
    console.log "requestUrl"
    opts = urlConfig.opts
    queryString = qs.stringify opts.queryString
    s = '?' if queryString.length > 0
    s = '&' if urlConfig.url.indexOf('?') > 0
    s = '' unless s?
    opts.url = urlConfig.url + s + queryString
    console.dir opts
    console.dir qs
    console.dir queryString
    request opts, (error, response, body) ->
      callback error, response, body
