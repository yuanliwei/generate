Config = require '../config'
http = require 'http'
fs = require 'fs'
low = require 'lowdb'
storage = require 'lowdb/file-sync'
format = require 'string-format'
cheerio = require 'cheerio'
async = require 'async'

format.extend(String.prototype)

g_basePath = "#{Config.basePath}data/data-url/"
fs.mkdir g_basePath if not fs.existsSync g_basePath

db = low "#{g_basePath}config_db.json", {storage}
db0 = low "#{g_basePath}index_db.json", {storage}
db1 = low "#{g_basePath}url_config_db.json", {storage}
db2 = low "#{g_basePath}last_urldata_db.json", {storage}

module.exports = class IndexUrl
  listUrls: ->
    console.log "listUrls"
  insertUrl: ->
    console.log "insertUrl"
  saveUrlConfig: ->
    console.log "saveUrlConfig"
  requestUrl: ->
    console.log "requestUrl"
