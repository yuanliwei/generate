Config = require '../../lib/config'
# return if Config.runOneSpec

format = require 'string-format'
format.extend(String.prototype)

# ClassModel = require '../../lib/model/class-model'
Json2Java = require '../../lib/gen-code/json-java'

describe 'Json2Java Class test', ->
  it "test toJava()", ->
    json2Java = new Json2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'TestClassSpec'          # [require]
      genSetter: 'true'               # [option default 'false']
      genGetter: 'true'               # [option default 'false']
      genInnerClass: 'true'           # [option default 'true']
    }
    pkg = require '../../package.json'
    json = JSON.stringify(pkg)
    javaSrc = json2Java.toJava json, opts
    console.log javaSrc
