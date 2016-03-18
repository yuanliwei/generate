Config = require '../../lib/config'
# return if Config.runOneSpec

format = require 'string-format'
format.extend(String.prototype)

IndexUrl = require '../../lib/get-url/index-url'
indexUrl = new IndexUrl()

describe 'IndexUrl Class test', ->
  it "test index-url insertUrl()", ->
    indexUrl.insertUrl()
