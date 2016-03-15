ClassModel = require '../model/class-model'
Filed = require '../model/filed'

###
JSON 转 Java model
使用：
    Json2Java = require './json-java'
    j2j = new Json2Java()
    [option]
    opts = {
        packageName: 'com.ylw.generate' [option]
        className: 'TestClass'          [require]
        genSetter: 'true'               [option default 'false']
        genGetter: 'true'               [option default 'false']
        genInnerClass: 'true'           [option default 'true']
    }
    jsonStr = '{"name": "ylw", "age": "12"}'
    javaSrc = j2j.toJava jsonStr, opts
    console.log javaSrc
###
module.exports = class Json2Java

  className = 'ClassName'
  genSetter = false
  genGetter = false
  genInnerClass = true

  toJava: (jsonStr, opts) ->
    @packageName = opts.packageName if 'packageName' in opts
    @className = opts.className if 'className' in opts
    @genSetter = opts.genSetter if 'genSetter' in opts
    @genGetter = opts.genGetter if 'genGetter' in opts
    @genInnerClass = opts.genInnerClass if 'genInnerClass' in opts

    @model = @getModel @className
    @model.package = @packageName

    jsObj = JSON.parse jsonStr
    @parseJsonToJava jsObj, @model

  getModel: (name)->
    model = new ClassModel()
    model.name = name
    model.genGetter = @genGetter
    model.genSetter = @genSetter
    model

  parseJsonToJava: (jsObj, model) ->
    window.jsObj = jsObj
    console.dir jsObj
    switch ((jsObj).constructor)
      when Object
        console.log "Object"
      when Array
        console.log "Array"
      when String
        console.log "String"
      when Number
        console.log "Number"
      when Boolean
        console.log "Boolean"


###
判断js数据类型
    console.log([].constructor == Array);
    console.log({}.constructor == Object);
    console.log("string".constructor == String);
    console.log((123).constructor == Number);
    console.log(true.constructor == Boolean);
###
