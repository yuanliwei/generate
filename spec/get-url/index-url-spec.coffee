Config = require '../../lib/config'
return if Config.runOneSpec

format = require 'string-format'
format.extend(String.prototype)

IndexUrl = require '../../lib/get-url/index-url'
indexUrl = new IndexUrl()

describe 'IndexUrl Class test', ->
  it "test index-url insertUrl()", ->
    filter = {name:"test:getData", url: "http://www.baidu.com"}
    size1 = indexUrl.listUrls(filter).length
    console.log "size1 : #{size1}"
    urlObj = {name:"test:getData", url: "http://www.baidu.com"}
    indexUrl.insertUrl(urlObj)
    size2 = indexUrl.listUrls(filter).length
    if size1 is 0
      expect(size2).toBe(1)
    else
      expect(size2).toBe(size1)


  it "test index-url listUrls()", ->
    filter = (item) ->
      item.name.match /.*getd.*/i

    urls = indexUrl.listUrls(filter)
    console.dir urls

  it "test index-url saveUrlConfig()", ->
    urlConfig = {
      "url": "http://www.baidu.com",
      "opts": {
        "method": "GET",
        "headers": {
          "Accept": "text/html",
          "Cache-Control": "no-cache"
          },
        "queryString": {
          "name":"ylw",
          "age": 123
          },
        "formData": {
          "name":"ylw",
          "age": 123
        }
      }
    }
    indexUrl.saveUrlConfig(urlConfig)

  it "test index-url getUrlConfig()", ->
    url = "http://www.baidu.com"
    urlConfig = indexUrl.getUrlConfig(url)
    console.dir urlConfig

  it "test index-url requestUrl()", ->
    urlConfig = {
      "url": "http://www.baidu.com",
      "opts": {
        "method": "GET",
        "headers": {
          "Accept": "text/html",
          "Cache-Control": "no-cache"
          },
        "queryString": {
          "name":"ylw",
          "age": 123
          },
        "formData": {
          "name":"ylw",
          "age": 123
        }
      }
    }
    indexUrl.requestUrl urlConfig, (error, response, body) ->
      console.log "-------------------------"
      console.dir error
      console.dir response
      console.dir body
      cheerio = require 'cheerio'
      $ = cheerio.load body
      console.log "$$$$$$$$$$$$$$$$$$$$$$$$$$$"
      console.dir $
      console.log "$$$$$$$$$$$$$$$$$$$$$$$$$$$"


  it "test for gen menu command", ->
    genTem = """
          menus/generate.cson
          -----------------------------
          {
            'label': '{name}'
            'command': 'generate:{name}'
          }

          package.json
          ----------------------------
          "generate:{name}",

          generate.coffee
          ----------------------------
          'generate:{name}': => GetUrl.{method}()

          """
    # menus/generate.cson
    # -----------------------------
    # {
    #   'label': 'get-url-show-url-config'
    #   'command': 'generate:get-url-show-url-config'
    # }
    #
    # package.json
    # ----------------------------
    # "generate:get-url-show-url-config",
    #
    # generate.coffee
    # ----------------------------
    # 'generate:get-url-show-url-config': => GetUrl.get_url_show_url_config()


    selectionText = 'gen_menu_command'
    rep = {
      name: selectionText.replace /_/g, '-'
      method: selectionText
    }
    console.log genTem.format(rep)

  it "test for string 2 json and json 2 string", ->
    string = "{\"result\":{\"code\":\"-1\",\"msg\":\"缺少uclassid参数,uclassid=null\"},\"data\":{}}"
    console.log "============================================================="
    console.dir string
    b = {"body": "#{string}"}
    console.dir b
    console.log b.body
