Config = require '../../lib/config'
return if Config.runOneSpec

format = require 'string-format'
format.extend(String.prototype)

# ClassModel = require '../../lib/model/class-model'
ClassModel = require '../../lib/model/extend-class-model'
Filed = require '../../lib/model/filed'
Modifiers = require '../../lib/model/modifiers'

describe 'Model Class test', ->
  it "test new Filed()", ->
    model = new ClassModel()
    model.package = "com.ylw.gen"
    model.name = "TestModel"
    model.genSetter = true
    filed1 = new Filed('String','name','ylw','name string')
    model.fileds.push filed1
    filed2 = new Filed('String','name1','ylw','name string')
    model.fileds.push filed2
    filed3 = new Filed('String','name2','ylw','name string')
    filed3.modifier |= Modifiers.static
    model.fileds.push filed3
    filed4 = new Filed('String','name3','ylw','name string')
    model.fileds.push filed4

    model1 = new ClassModel()
    # model.package = "com.ylw.gen"
    model1.name = "InnerModel"
    model1.genSetter = true
    model1.genGetter = true
    model1.fileds.push filed1
    model1.fileds.push filed2
    model1.fileds.push filed3
    model1.fileds.push filed4

    console.dir model
    console.dir model1

    model.innerClass.push model1
    builder = []
    model.toSource builder
    console.log "result for model : "
    console.dir model
    console.log "end -->>>>>>>>>>>>>"
    console.log builder.join('\n')
    console.log "end------<<<<<<<<<<<<<<<<<<"
    window.model = model
