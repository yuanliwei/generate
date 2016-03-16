Config = require '../../lib/config'
# return if Config.runOneSpec

format = require 'string-format'
format.extend(String.prototype)

describe 'Json2JavaDb Class test', ->
  it "test json-java-db-xutils toJava()", ->
    Json2Java = require '../../lib/gen-code/json-java-db-xutils'
    json2Java = new Json2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'TestClassSpec'           # [require]
      genSetter: true                      # [option default true]
      genGetter: true                      # [option default true]
      genInnerClass: false                 # [option default false]
    }
    jsonData = require './json-data/gen-db.json'
    json = JSON.stringify(jsonData)
    window.json2Java = json2Java
    javaSrc = json2Java.toJava json, opts
    # console.log javaSrc

  it "test json-java-db-ormlite toJava()", ->
    Json2Java = require '../../lib/gen-code/json-java-db-ormlite'
    json2Java = new Json2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'TestClassSpec'           # [require]
      genSetter: true                      # [option default true]
      genGetter: true                      # [option default true]
      genInnerClass: false                 # [option default false]
    }
    jsonData = require './json-data/gen-db.json'
    json = JSON.stringify(jsonData)
    window.json2Java = json2Java
    javaSrc = json2Java.toJava json, opts
    console.log javaSrc
