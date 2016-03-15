Config = require '../../lib/config'
return if Config.runOneSpec

request = require 'request'

describe "test for request", ->
  it "simple test", ->
    request 'http://www.baidu.com', (error, response, body) ->
      if !error && response.statusCode == 200
        console.log body
