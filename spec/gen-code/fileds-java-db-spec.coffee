Config = require '../../lib/config'
return if Config.runOneSpec

format = require 'string-format'
format.extend(String.prototype)

filedStr = """
    private String schoolName; // "语音风暴"
    private String studentName; // "老师3"
    private int userType; // 1030410
    private String studentUuid; // "FE8D6C7064BF2A3B0BACFC30978F53B7"
    private String username; // "laoshi3"
    private int studentId; // 9030
    private int classId; // 18676
    private String className; // "语音风暴内部测试"
    private String accessToken; // "6e93dc0fcc10479584fe603aa4af1288"
    private int schoolId; // 1264
    private int gradeId; // 11414
    """

describe 'filed2Java Class test', ->
  it "test filed-java toJava()", ->
    Fileds2Java = require '../../lib/gen-code/filed-java'
    fileds2Java = new Fileds2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'TestClassSpec'           # [require]
      genSetter: true                      # [option default true]
      genGetter: true                      # [option default true]
    }
    javaSrc = fileds2Java.toJava filedStr, opts
    console.log javaSrc

  it "test filed-java-db-xutils toJava()", ->
    Fileds2Java = require '../../lib/gen-code/filed-java-db-xutils'
    fileds2Java = new Fileds2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'TestClassSpec'           # [require]
      genSetter: true                      # [option default true]
      genGetter: true                      # [option default true]
    }
    javaSrc = fileds2Java.toJava filedStr, opts
    console.log javaSrc

  it "test filed-java-db-ormlite toJava()", ->
    Json2Java = require '../../lib/gen-code/filed-java-db-ormlite'
    json2Java = new Json2Java()
    opts = {
      packageName: 'com.ylw.generate.spec' # [option]
      className: 'TestClassSpec'           # [require]
      genSetter: true                      # [option default true]
      genGetter: true                      # [option default true]
    }
    javaSrc = json2Java.toJava filedStr, opts
    console.log javaSrc
