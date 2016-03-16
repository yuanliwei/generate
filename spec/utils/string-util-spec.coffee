Config = require '../../lib/config'
return if Config.runOneSpec

StringUtil = require '../../lib/utils/string-util'

describe 'StringUtil test', ->
  it "test upperBegin method", ->
    expect(StringUtil.upperBegin 'wer').toBe 'Wer'
    expect(StringUtil.upperBegin 'WER').toBe 'WER'
    expect(StringUtil.upperBegin 'wER').toBe 'WER'
    expect(StringUtil.upperBegin 'Wer').toBe 'Wer'

  it "test lowerBegin method", ->
    expect(StringUtil.lowerBegin 'wer').toBe 'wer'
    expect(StringUtil.lowerBegin 'WER').toBe 'wER'
    expect(StringUtil.lowerBegin 'wER').toBe 'wER'
    expect(StringUtil.lowerBegin 'Wer').toBe 'wer'

  it "test formatJavaType method", ->
    expect(StringUtil.formatJavaType 'char').toBe 'String'
    expect(StringUtil.formatJavaType 'string').toBe 'String'
    expect(StringUtil.formatJavaType 'datetime').toBe 'String'
    expect(StringUtil.formatJavaType 'text').toBe 'String'
    expect(StringUtil.formatJavaType 'int').toBe 'int'
    expect(StringUtil.formatJavaType 'decimal').toBe 'double'
    expect(StringUtil.formatJavaType 'float').toBe 'float'
    expect(StringUtil.formatJavaType 'double').toBe 'double'
    expect(StringUtil.formatJavaType 'doublek' ).toBe 'ERROR TYPE'

  it "test formatDbType method", ->
    expect(StringUtil.formatDbType 'String' ).toBe 'TEXT'
    expect(StringUtil.formatDbType 'int' ).toBe 'INTEGER'
    expect(StringUtil.formatDbType 'float' ).toBe 'DOUBLE'
    expect(StringUtil.formatDbType 'other' ).toBe 'ERROR TYPE'

  it "test formatJavaVarName method", ->
    expect(StringUtil.formatJavaVarName 'AaaAaAAa' ).toBe 'aaaAaAAa'
    expect(StringUtil.formatJavaVarName 'AAAAAA' ).toBe 'aAAAAA'
    expect(StringUtil.formatJavaVarName 'aaaaaa' ).toBe 'aaaaaa'
    expect(StringUtil.formatJavaVarName 'a_a_aAA_aa' ).toBe 'aAAAAAa'
    expect(StringUtil.formatJavaVarName 'ZZ_Zzz_zz' ).toBe 'zZZzzZz'
    expect(StringUtil.formatJavaVarName 'zZzZzZ__' ).toBe 'zZzZzZ_'

  it "test formatJSONVarName method", ->
    expect(StringUtil.formatJSONVarName 'AaaAaAAAAaA' ).toBe 'aaa_aa_a_a_a_aa_a'
    expect(StringUtil.formatJSONVarName 'AZZzz' ).toBe 'a_z_zzz'
    expect(StringUtil.formatJSONVarName 'Azz' ).toBe 'azz'
    expect(StringUtil.formatJSONVarName 'aZZAaa' ).toBe 'a_z_z_aaa'
    expect(StringUtil.formatJSONVarName 'aZsdsdWrdd' ).toBe 'a_zsdsd_wrdd'
    expect(StringUtil.formatJSONVarName 'e_yg_jW_g' ).toBe 'e_yg_j_w_g'
    expect(StringUtil.formatJSONVarName 'A_ft_EE' ).toBe 'a_ft_e_e'

  it "test format method", ->
    # gh_uji_kfg -> GhUjiKfg
    result = StringUtil.format "gh_uji_kfg",2,0
    expect(result).toBe "GhUjiKfg"

  it "test ascii2native method", ->
    expect(StringUtil.ascii2native '\\u8fd9\\u662f\\u4e00\\u4e2a\\u4f8b\\u5b50,this is a example').toBe '这是一个例子,this is a example'
    expect(StringUtil.ascii2native 'is \\u662f\\u7684a e\\u662f\\u7684xa\\u65b9\\u6cd5mple').toBe 'is 是的a e是的xa方法mple'

  it "test native2ascii method", ->
    expect(StringUtil.native2ascii '这是一个例子,this is a example').toBe '\\u8fd9\\u662f\\u4e00\\u4e2a\\u4f8b\\u5b50,this is a example'
    expect(StringUtil.native2ascii 'is 是的a e是的xa方法mple').toBe 'is \\u662f\\u7684a e\\u662f\\u7684xa\\u65b9\\u6cd5mple'

  it "test formatStr method", ->
    str = "hello {0} bye {1} , {1} hahaha {2}"
    expect(StringUtil.formatStr str,'p0','p1','p2').toBe 'hello p0 bye p1 , p1 hahaha p2'

  it "test string-format lib", ->
    format = require 'string-format'
    expect(format 'hello {}','Alice').toBe 'hello Alice'

  it "test string-format lib format.extend()", ->
    format = require 'string-format'
    format.extend(String.prototype, {})
    expect('name:{0} age:{1}'.format('ylw',12)).toBe 'name:ylw age:12'
