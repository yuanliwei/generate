ClassModel = require '../model/class-model'
Modifiers = require '../model/modifiers'
Filed = require '../model/filed'
StringUtil = require '../utils/string-util'

###
Fileds 转 Java model
使用：
    Fileds2Java = require './filed-java-db-ormlite'
    fileds2Java = new Fileds2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'TestClassSpec'           # [require]
      genSetter: true                      # [option default true]
      genGetter: true                      # [option default true]
    }
    filedStr = """
        private String schoolName; // "语音风暴"
        private String studentName; // "老师3"
        private int userType; // 1030410
        """
    javaSrc = fileds2Java.toJava filedStr, opts
    console.log javaSrc
###
module.exports = class Fileds2Java

  constructor: () ->
    @className = 'ClassName'
    @genSetter = true
    @genGetter = true
    @genInnerClass = false

  toJava: (filedStr, opts) ->
    @packageName = opts.packageName if 'packageName' of opts
    @className = opts.className if 'className' of opts
    @genSetter = opts.genSetter if 'genSetter' of opts
    @genGetter = opts.genGetter if 'genGetter' of opts
    @genInnerClass = opts.genInnerClass if 'genInnerClass' of opts

    model = @getModel @className
    model.package = @packageName

    fileds = filedStr.trim().split /\n/g
    console.dir fileds
    return "fileds is null" unless fileds?.length > 0

    fileds.forEach (item) ->
      filed = new DbFiled()
      result = filed.fromSource item
      model.fileds.push filed if result
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

class DbCLassModel extends ClassModel
  genClassName: (builder) ->
    # @DatabaseTable(tableName = "baidu_fans")
    tem = '@DatabaseTable(tableName = "{0}")'
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
    # @DatabaseField(id = true, unique = true, columnName = "fans_uk")
    # @DatabaseField(columnName = "album_count")
    tem0 = '@DatabaseField(id = true, unique = true, columnName = "{0}")'
    tem = '@DatabaseField(columnName = "{0}")'
    tem = tem0 if first
    columeName = StringUtil.format @name, 4
    buffer.push tem.format columeName
    tem = '{0} {1} {2}{3};{4}'
    name_ = StringUtil.format @name, 2
    buffer.push StringUtil.formatStr tem, @getModifier(), @type, name_, @getValue(), @getComment()
