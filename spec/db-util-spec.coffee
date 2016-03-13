db = require('../lib/util/db-util').db

describe "test for db-util", ->
  return
  it "test insert data", ->
    count = db('test').size()
    db('test').push { time: "#{new Date().toLocaleString()}", title: "h1"}
    expect(db('test').size()).toBe(count+1)

  it "test find data", ->
    value = db('test').chain().filter({title: 'h1'}).value()[0]
    expect(value.title).toBe("h1")

  it "test update data", ->
    oldSize = db('test').chain().filter({title: 'h1'}).value().size
    db('test').chain().find({title: 'h1'}).assign({title:'h2'}).value()
    newSize = db('test').chain().filter({title: 'h2'}).value().size
    expect(newSize).toBe(oldSize)

  it "test delete data", ->
    count = db('test').size()
    db('test').remove({ title: 'h2' })
    expect(db('test').size()).toBe(count-1)
