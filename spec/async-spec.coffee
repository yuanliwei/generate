async = require 'async'
fs = require 'fs'
http = require 'http'

describe "test for async", ->
  return
  ###
  序列化执行函数列表中的方法
  ###
  it "test for sync series", ->
    window.async = async
    async.series {
      one: (callback) ->
        console.log "dddddddddddd"
        callback null, 1
    	two: (callback) ->
        console.log "fffffffffffffffffffff"
        callback(null, 2)
      }, (err, results) ->
        console.log "sync result - #{results}"
        window.results = results
    expect(true).toBe(true)


  ###
  瀑布流方式，前一个方法的结果可以传到下一个方法的参数中
  test for async waterfall one
  async-spec.coffee:29 test for async waterfall two - arg1:one arg2:two
  async-spec.coffee:32 test for async waterfall three - arg1three
  async-spec.coffee:35 test for async waterfall result - down
  ###
  it "test for async waterfall", ->
    async.waterfall [
      (callback) ->
        console.log "test for async waterfall one"
        callback null, 'one', 'two'
      (arg1, arg2, callback) ->
        console.log "test for async waterfall two - arg1:#{arg1} arg2:#{arg2}"
        callback null, 'three'
      (arg1, callback) ->
        console.log "test for async waterfall three - arg1#{arg1}"
        callback null, 'down'
      ], (err, result) ->
        console.log "test for async waterfall result - #{result}"

  ###
  多个任务并发执行
  ###
  it "test for async parallel", ->
    async.parallel [
      (callback) ->
        callback null, "one"
      (callback) ->
        callback null, "two"
      ], (err, results) ->
        for result in results
          console.log "test for async parallel results - #{result}"

  ###
  多个任务并发执行，限制并发数量为2
  ###
  it "test for async parallelLimit", ->
    async.parallelLimit [
      (callback) ->
        console.log "one"
        callback null, "one"
      (callback) ->
        console.log "two"
        callback null, "two"
      ], 2, (err, results) ->
        for result in results
          console.log "test for async parallelLimit results - #{result}"

  ###
  测试async map()
  ###
  it "test for async map()", ->
    basePath = "C:\\Users\\y\\Desktop\\coffee-test\\"
    async.map [
      "#{basePath}demo.coffee"
      "#{basePath}demo.js"
      "#{basePath}not_exists"
    ], fs.stat, (err, results) ->
      # window.results = results
      console.log "got the map results"

  ###
  测试async filter()
  ###
  it "test for async filter()", ->
    basePath = "C:\\Users\\y\\Desktop\\coffee-test\\"
    async.filter [
      "#{basePath}demo.coffee"
      "#{basePath}demo.js"
      "#{basePath}not_exists"
    ], fs.exists, (results) ->
      # window.results = results
      # results is - ["C:\Users\y\Desktop\coffee-test\demo.coffee", "C:\Users\y\Desktop\coffee-test\demo.js"]
      console.log "got the filter results - #{results}"

  it "test for async parallel()", ->
    # 并行执行
    async.parallel [
      ->
        console.log "first"
      ->
        console.log "second"
      ->
        console.log "thired"
    ], (result) ->
      console.log result

  it "test for async series()", ->
    # 串行执行
    async.series [
      (callback) ->
        console.log "first"
        callback null,"first"
      (callback) ->
        console.log "second"
        callback null, "second"
      (callback) ->
        console.log "thired"
        callback null, "thired"
    ], (err, results) ->
      console.log "results - #{results}"
      console.dir results

  it "test for async queue()", ->
    q = async.queue (task, callback) ->
        # console.log "hello #{task.name}"
        task(callback)
        # callback()
      , 5
    q.drain = -> console.log "all items have benn processed"

    for i in [0..100]
      q.push task, (err) ->
        console.log "finished processing task"
    console.log "----------is running #{q.running()}"

index = 0
task = (callback)->
  console.log "begin task #{index}"
  url = 'http://search.sina.com.cn/'
  innerIndex = index++
  http.get(url, (res) ->
    size = 0
    chunks = []
    res.on 'data', (chunk) ->
      size += chunk.length
      chunks.push chunk
    res.on 'end', ->
      data = Buffer.concat chunks, size
      console.log "#{innerIndex} : data - length is " + data.toString().length
      callback()
    ).on 'error',(e) ->
      console.log "#{innerIndex} - Got error : #{e.message}"
      callback e
