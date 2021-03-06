Config = require '../../lib/config'
return if Config.runOneSpec

format = require 'string-format'
format.extend(String.prototype)

# ClassModel = require '../../lib/model/class-model'
Json2Java = require '../../lib/gen-code/json-java-url'

describe 'Json2Java Class test', ->
  it "test toJava()", ->
    json2Java = new Json2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'UrlTestClassSpec'        # [require]
      genSetter: true                      # [option default true]
      genGetter: true                      # [option default true]
      genInnerClass: true                  # [option default true]
    }
    # jsonData = require './json-data/simple.json'
    jsonData = require './json-data/baiduyun.json'
    json = JSON.stringify(jsonData)

    window.json2Java = json2Java
    window.opts = opts
    window.json = json

    javaSrc = json2Java.toJava json, opts
    console.log javaSrc
