config = require('../config').config

getOpts = ->
  opts = {
    packageName: ''                      # [option]
    className: 'TestClassSpec'           # [require]
    genSetter: true                      # [option default true]
    genGetter: true                      # [option default true]
    genInnerClass: true                  # [option default false]
  }
  opts.packageName = config.gen_java.packageName if config.gen_java.packageName?
  opts.className = config.gen_java.className if config.gen_java.className?
  opts


exports.json_java = (jsonStr) ->
  Json2Java = require './json-java'
  json2Java = new Json2Java()
  json = jsonStr
  javaSrc = json2Java.toJava json, getOpts()

exports.json_java_url = (jsonStr) ->
  Json2Java = require './json-java-url'
  json2Java = new Json2Java()
  json = jsonStr
  javaSrc = json2Java.toJava json, getOpts()

exports.json_java_db_xutils = (jsonStr) ->
  Json2Java = require './json-java-db-xutils'
  json2Java = new Json2Java()
  json = jsonStr
  javaSrc = json2Java.toJava json, getOpts()

exports.json_java_db_ormlite = (jsonStr) ->
  Json2Java = require './json-java-db-ormlite'
  json2Java = new Json2Java()
  json = jsonStr
  javaSrc = json2Java.toJava json, getOpts()
