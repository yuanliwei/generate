ClassModel = require '../model/class-model'
Modifiers = require '../model/modifiers'
Filed = require '../model/filed'
StringUtil = require '../utils/string-util'

###
Fileds 转 Java model
使用：
    Fileds2Java = require './filed-java'
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
    return "fileds is null" unless fileds?.length > 0

    fileds.forEach (item) ->
      filed = new Filed()
      result = filed.fromSource item
      model.fileds.push filed if result
    builder = []
    model.toSource builder
    # console.dir model

    java_src = builder.join('\n')
    jsBeautify = require('js-beautify').js_beautify
    b_java_src = jsBeautify(java_src, { })

  getModel: (name)->
    model = new ClassModel()
    model.name = name
    model.genGetter = @genGetter
    model.genSetter = @genSetter
    model
