return
Http = require 'http'
describe 'Http test', ->
  it "test http GET method", ->
    Http.get("http://cnodejs.org/", (res) ->
        size = 0
        chunks = []
        res.on 'data', (chunk) ->
            size += chunk.length
            chunks.push chunk
        res.on 'end', ->
            data = Buffer.concat chunks, size
            str = data.toString()
            console.log str
            expect(str.indexOf('html') > 0).toBe true
      ).on 'error', (e) ->
        console.log "Got error: #{e.message}"

    # expect(StringUtil.upperBegin 'wer').toBe 'Wer'
    # expect(StringUtil.upperBegin 'WER').toBe 'WER'
    # expect(StringUtil.upperBegin 'wER').toBe 'WER'
    # expect(StringUtil.upperBegin 'Wer').toBe 'Wer'
