config = require('../config').config
format = require 'string-format'
format.extend(String.prototype)

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

exports.json_java_db_xutils3 = (jsonStr) ->
  Json2Java = require './json-java-db-xutils3'
  json2Java = new Json2Java()
  json = jsonStr
  javaSrc = json2Java.toJava json, getOpts()

exports.json_java_db_ormlite = (jsonStr) ->
  Json2Java = require './json-java-db-ormlite'
  json2Java = new Json2Java()
  json = jsonStr
  javaSrc = json2Java.toJava json, getOpts()

exports.fileds_java = (filedStr) ->
  Fileds2Java = require './filed-java'
  fileds2Java = new Fileds2Java()
  fileds = filedStr
  javaSrc = fileds2Java.toJava fileds, getOpts()

exports.fileds_java_db_xutils = (filedStr) ->
  Fileds2Java = require './filed-java-db-xutils'
  fileds2Java = new Fileds2Java()
  fileds = filedStr
  javaSrc = fileds2Java.toJava fileds, getOpts()

exports.fileds_java_db_xutils3 = (filedStr) ->
  Fileds2Java = require './filed-java-db-xutils3'
  fileds2Java = new Fileds2Java()
  fileds = filedStr
  javaSrc = fileds2Java.toJava fileds, getOpts()

exports.fileds_java_ormlite = (filedStr) ->
  Fileds2Java = require './filed-java-db-ormlite'
  fileds2Java = new Fileds2Java()
  fileds = filedStr
  javaSrc = fileds2Java.toJava fileds, getOpts()


genTem = """
      menus/generate.cson
      -----------------------------
      {
        'label': '{name}'
        'command': 'generate:{name}'
      }

      package.json
      ----------------------------
      "generate:{name}",

      generate.coffee
      ----------------------------
      'generate:{name}': => {{XXX}}.{method}()

      """

exports.gen_menu_command = (selectionText) ->
  rep = {
    name: selectionText.replace /_/g, '-'
    method: selectionText
  }
  genTem.format(rep)

exports.gen_style_xml = (selectionText) ->
  lines = selectionText.trim().split /\n/g
  return "lines is null" unless lines?.length > 0
  arr = []
  tem = '<item name="{0}">{1}</item>'
  lines.forEach (item) ->
    ss = item.split '='
    if ss.length is 2
      name = ss[0].trim()
      value = ss[1].trim()
      value = value.replace /^"(.*)"$/, (match, first) ->
        first
      arr.push tem.format name, value
  arr.join '\n'
