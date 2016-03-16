ClassModel = require '../model/class-model'
Modifiers = require '../model/modifiers'
Filed = require '../model/filed'
StringUtil = require '../string-util-s'

###
JSON 转 Java model
使用：
    Json2Java = require './json-java'
    j2j = new Json2Java()
    [option]
    opts = {
        packageName: 'com.ylw.generate' [option]
        className: 'TestClass'          [require]
        genSetter: true                 [option default true]
        genGetter: true                 [option default true]
        genInnerClass: false            [option default false]
    }
    jsonStr = '{"name": "ylw", "age": "12"}'
    javaSrc = j2j.toJava jsonStr, opts
    console.log javaSrc
###
module.exports = class Json2Java

  constructor: () ->
    @className = 'ClassName'
    @genSetter = true
    @genGetter = true
    @genInnerClass = false

  toJava: (jsonStr, opts) ->
    @packageName = opts.packageName if 'packageName' of opts
    @className = opts.className if 'className' of opts
    @genSetter = opts.genSetter if 'genSetter' of opts
    @genGetter = opts.genGetter if 'genGetter' of opts
    @genInnerClass = opts.genInnerClass if 'genInnerClass' of opts

    model = @getModel @className
    model.package = @packageName

    jsObj = JSON.parse jsonStr
    @parseJsonToJava jsObj, model
    builder = []
    model.toSource builder
    # console.dir model

    java_src = builder.join('\n')
    jsBeautify = require('js-beautify').js_beautify
    b_java_src = jsBeautify(java_src, { })

  getModel: (name)->
    model = new DbCLassModel()
    model.name = name
    model.genGetter = @genGetter
    model.genSetter = @genSetter
    model

  parseJsonToJava: (jsObj, model) ->
    # window.jsObj = jsObj
    # console.dir jsObj
    switch ((jsObj).constructor)
      when Object
        # console.log "Object"
        @parseJsonObject jsObj, model
      when Array
        console.log "Array"
      when String
        console.log "String"
      when Number
        console.log "Number"
      when Boolean
        console.log "Boolean"

  parseJsonObject: (jsObj, model) ->
    for name of jsObj
      # console.log name
      # (type, @name, @value, @comment)
      value = jsObj[name]
      type = @getType value, name, model
      comment = JSON.stringify value
      filed = new DbFiled(type, name, null, comment)
      model.fileds.push filed
      # name

  getType: (jsObj, name, model) ->
    switch ((jsObj).constructor)
      when Object
        name_ = StringUtil.format name, 2, 0
        console.dir @genInnerClass
        if @genInnerClass
          innerModel = @getModel name_
          model.innerClass.push innerModel
          @parseJsonToJava jsObj, innerModel
        name_
      when Array
        name_ = StringUtil.format name, 2, 0
        if @genInnerClass
          innerModel = @getModel name_
          model.innerClass.push innerModel
          @parseJsonToJava jsObj[0], innerModel if jsObj.length > 0
        "List<#{name_}>"
      when String
        "String"
      when Number
        vstr = "#{jsObj}"
        if vstr.match /^\d{1,10}$/
          "int"
        else if vstr.match /^\d+$/
          "long"
        else if vstr.match /^\d+\.\d+$/
          "float"
        else
          "Number"
      when Boolean
        "boolean"
      else "unkonwn type"
###
判断js数据类型
    console.log([].constructor == Array);
    console.log({}.constructor == Object);
    console.log("string".constructor == String);
    console.log((123).constructor == Number);
    console.log(true.constructor == Boolean);
###

class DbCLassModel extends ClassModel
  genClassName: (builder) ->
    # @Table(name = "tree_chapter_info")
    tem = '@Table(name = "{0}")'
    tableName = StringUtil.format @name, 3
    builder.push(tem.format(tableName))
    super builder
  genNormalFiled: (builder) ->
    first = true
    @fileds.forEach (filed) ->
      if (filed.modifier & Modifiers.static) == 0
        filed.toSource(builder, first)
        first = false

class DbFiled extends Filed
  toSource: (buffer, first) ->
    # @Id(column = "id")
    # @Column(column = "pid")
    tem0 = '@Id(column = "{0}")'
    tem = '@Column(column = "{0}")'
    tem = tem0 if first
    columeName = StringUtil.format @name, 4
    buffer.push tem.format columeName
    tem = '{0} {1} {2}{3};{4}'
    name_ = StringUtil.format @name, 2
    buffer.push StringUtil.formatStr tem, @getModifier(), @type, name_, @getValue(), @getComment()
