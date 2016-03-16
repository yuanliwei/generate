

exports.json_java = (jsonStr) ->
  Json2Java = require './json-java'
  json2Java = new Json2Java()
  opts = {
    packageName: ''                      # [option]
    className: 'TestClassSpec'           # [require]
    genSetter: true                      # [option default true]
    genGetter: true                      # [option default true]
    genInnerClass: true                  # [option default true]
  }
  json = jsonStr
  javaSrc = json2Java.toJava json, opts

exports.json_java_url = (jsonStr) ->
  Json2Java = require './json-java-url'
  json2Java = new Json2Java()
  opts = {
    packageName: ''                      # [option]
    className: 'UrlTestClassSpec'        # [require]
    genSetter: true                      # [option default true]
    genGetter: true                      # [option default true]
    genInnerClass: true                  # [option default true]
  }
  json = jsonStr
  javaSrc = json2Java.toJava json, opts

exports.json_java_db_xutils = (jsonStr) ->
  Json2Java = require './json-java-db-xutils'
  json2Java = new Json2Java()
  opts = {
    packageName: ''                      # [option]
    className: 'TestClassSpec'           # [require]
    genSetter: true                      # [option default true]
    genGetter: true                      # [option default true]
    genInnerClass: false                 # [option default false]
  }
  json = jsonStr
  javaSrc = json2Java.toJava json, opts

exports.json_java_db_ormlite = (jsonStr) ->
  Json2Java = require './json-java-db-ormlite'
  json2Java = new Json2Java()
  opts = {
    packageName: ''                      # [option]
    className: 'TestClassSpec'           # [require]
    genSetter: true                      # [option default true]
    genGetter: true                      # [option default true]
    genInnerClass: false                 # [option default false]
  }
  json = jsonStr
  javaSrc = json2Java.toJava json, opts
