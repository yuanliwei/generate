Config = require '../../lib/config'
return if Config.runOneSpec

http = require 'http'

describe "http test", ->

  it "test get method", ->
    http.get("http://cnodejs.org/", (res) ->
        size = 0
        chunks = []
        res.on 'data', (chunk) ->
            size += chunk.length
            chunks.push chunk
        res.on 'end', ->
            data = Buffer.concat chunks, size
            str = data.toString()
            expect(str.indexOf('html') > 0).toBe true
            console.log "test get method passed"
      ).on 'error', (e) ->
        console.log "Got error: #{e.message}"
