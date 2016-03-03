Filed = require '../../lib/model/filed'

describe 'Model Filed test', ->
  it "test new Filed()", ->
    filed = new Filed('String','name','ylw','name string')
    buffer = [];
    source = filed.toSource buffer
    expect(buffer.join('\\n')).toBe 'private String name = "ylw"; // name string'

    filed = new Filed('String','name','ylw')
    buffer = [];
    source = filed.toSource buffer
    expect(buffer.join('\\n')).toBe 'private String name = "ylw";'

    filed = new Filed('String','name')
    buffer = [];
    source = filed.toSource buffer
    expect(buffer.join('\\n')).toBe 'private String name;'

    filed = new Filed('float','age',14)
    buffer = [];
    source = filed.toSource buffer
    expect(buffer.join('\\n')).toBe 'private float age = 14;'
