Config = require '../../lib/config'
return if Config.runOneSpec

fs = require 'fs'
low = require 'lowdb'
storage = require 'lowdb/file-sync'

dataPath = "#{Config.basePath}data/"
mkdirp = require 'mkdirp'
mkdirp.sync dataPath if not fs.existsSync dataPath
db = low "#{dataPath}test_db.json", {storage}

describe "test for db-util", ->

  it "test insert data", ->
    count = db('test').size()
    db('test').push { time: "#{new Date().toLocaleString()}", title: "h1"}
    expect(db('test').size()).toBe(count+1)

  it "test find data", ->
    value = db('test').chain().filter({title: 'h1'}).value()[0]
    expect(value.title).toBe("h1")

  it "test update data", ->
    oldSize = db('test').size()
    console.log "oldSize : #{oldSize}"
    db('test').chain().find({title: 'h1'}).assign({title:'h1_'}).value()
    newSize = db('test').size()
    console.log "newSize : #{newSize}"
    expect(newSize).toBe(oldSize)

  it "test delete data", ->
    db('test').push {title: "h2", time: "#{new Date().toLocaleString()}"}
    count = db('test').size()
    console.log "count : #{count}"
    db('test').remove({ title: 'h2' })
    count1 = db('test').size()
    console.log "count1 : #{count1}"
    expect(count1).toBe(count-1)

  it "test save or update", ->
    obj = { time: "#{new Date().toLocaleString()}", title: "h3"}
    size = db('test').chain().filter({title: obj.title}).value().length
    db('test').chain().find({title: obj.title}).assign(obj).value() if size > 0
    db('test').push obj if size is 0
    size1 = db('test').chain().filter({title: obj.title}).value().length
    if size is 0
      expect(size1).toBe(1)
    else
      expect(size1).toBe(size)
