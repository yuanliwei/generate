Config = require '../../lib/config'
return if Config.runOneSpec

Filed = require '../../lib/model/filed'

describe 'Model Filed test', ->
  it "test new Filed()", ->
    filed = new Filed('String','name','ylw','name string')
    buffer = [];
    source = filed.toSource buffer
    expect(buffer.join('\\n')).toBe 'private String name = "ylw"; // name string'
    # setter
    setter = """
      public void setName(String name) {
        this.name = name;
      }
    """
    buffer = [];
    source = filed.toSetter buffer
    expect(buffer.join('\\n')).toBe setter
    # getter
    getter = """
      public String getName() {
        return this.name;
      }
    """
    buffer = [];
    source = filed.toGetter buffer
    expect(buffer.join('\\n')).toBe getter

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

    filed = new Filed()
    source = 'private String name = "ylw"; // this is comment'
    filed.fromSource source
    buffer = [];
    source = filed.toSource buffer
    expect(buffer.join('\\n')).toBe 'private String name = "ylw"; // this is comment'

    # setter
    setter = """
      public void setName(String name) {
        this.name = name;
      }
    """
    buffer = [];
    source = filed.toSetter buffer
    expect(buffer.join('\\n')).toBe setter
    # getter
    getter = """
      public String getName() {
        return this.name;
      }
    """
    buffer = [];
    source = filed.toGetter buffer
    expect(buffer.join('\\n')).toBe getter
