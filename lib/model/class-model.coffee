async = require 'async'
format = require 'string-format'
format.extend(String.prototype)

Modifiers = require './modifiers'

module.exports = class Class

  package: ''
  name: 'Class'
  fileds: []
  innerClass: []
  genGetter: false
  genSetter: false
  constructor: () ->
    @fileds = []
    @innerClass = []

  toSource: (builder) ->
    @genPackage builder
    @genClassName builder
    @genStaticFiled builder
    @genNormalFiled builder
    @insertOtherCode builder
    @genInnerClass builder
    @genGetterSetter builder
    @genCloseClass builder

  genPackage: (builder) ->
    tem = "package {0};"
    builder.push(tem.format(@package)) if @package and @package.trim().length > 0
  genClassName: (builder) ->
    tem = "public class {0} {"
    builder.push(tem.format(@name))
  genStaticFiled: (builder) ->
    @fileds.forEach (filed) ->
      filed.toSource(builder) if (filed.modifier & Modifiers.static) > 0
  genNormalFiled: (builder) ->
    @fileds.forEach (filed) ->
      filed.toSource(builder) if (filed.modifier & Modifiers.static) == 0
  insertOtherCode: (builder) ->
    console.log "implament in sub class"
  genInnerClass: (builder) ->
    @innerClass.forEach (model) ->
      model.toSource builder
  genGetterSetter: (builder) ->
    outter = @
    @fileds.forEach (filed) ->
      if (filed.modifier & (Modifiers.static|Modifiers.final|Modifiers.public)) == 0
        filed.toSetter builder if outter.genSetter
        filed.toGetter builder if outter.genGetter
  genCloseClass: (builder) ->
    builder.push '}'
