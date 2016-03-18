Config = require '../../lib/config'
return if Config.runOneSpec

qs = require 'qs'
request = require 'request'

describe "test for request", ->
  it "simple test", ->
    request 'http://www.baidu.com', (error, response, body) ->
      if !error && response.statusCode == 200
        console.log body

  it "request for options", ->
    opts = {
      "method": "POST",
      "url": "http://www.baidu.com",
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
    queryString = qs.stringify opts.queryString
    s = ''
    s = '?' if queryString.length > 0
    s = '&' if opts.url.indexOf('?') > 0
    opts.url += s + queryString
    console.dir opts
    console.dir qs
    console.dir queryString
    # return
    request opts, (error, response, body) ->
      console.dir error
      console.dir response
      console.dir body


  it "request for har", ->
    request {
      har: {
          "method": "GET",
          "url": "http://www.baidu.com",
          "httpVersion": "HTTP/1.1",
          "headers": [
            {
              "name": "Pragma",
              "value": "no-cache"
            },
            {
              "name": "Accept-Encoding",
              "value": "gzip, deflate, sdch"
            }
          ],
          "queryString": [
            {
              "name": "pageNo",
              "value": "1"
            },
            {
              "name": "pageSize",
              "value": "50"
            }
          ]
        }
    }, (error, response, body) ->
      console.dir error
      console.dir response
      console.dir body
