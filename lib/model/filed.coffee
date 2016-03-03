StringUtil = require '../string-util-s'

module.exports = class Filed

  annotations: []
  modifier:'private'
  type: 'String'
  constructor: (type, @name, @value, @comment) ->
    @type = type || @type

  ###
  private String name = "value"; // this is comment
  ###
  fromSource: (source) ->
    source = source.trim()
    i = source.indexOf('//')
    if i > 3
      @comment = source.substr(i+2).trim() if i > 3
      source = source.substr(0, i).trim();
    i = source.indexOf('=')
    if i > 3
      @value = source.split('=')[1]
      @value = @value.replace /[\\"|\\s|;| ]/g,''
      source = source.substr(0, i).trim();

  ###
  private String name = "value"; // this is comment
  private String name = "value";
  private String name; // this is comment
  private String name;
  ###
  toSource: (buffer) ->
    tem = '{0} {1} {2}{3};{4}'
    buffer.push StringUtil.formatStr tem, @modifier, @type, @name, @getValue(), @getComment()

  ###
  public void setName(String name) {
    this.name = name
  }
  ###
  toSetter: (buffer) ->
    tem = """
      public void set{0}({1} {2}) {
        this.{2} = {2};
      }
    """
    buffer.push StringUtil.formatStr tem, StringUtil.upperBegin(@name), @type, @name

  ###
  public String getName() {
    return this.name;
  }
  ###
  toGetter: (buffer) ->
    tem = """
      public {0} get{1}() {
        return this.{2};
      }
    """
    buffer.push StringUtil.formatStr tem, @type, StringUtil.upperBegin(@name), @name

  getValue: ()->
    if not @value
      ""
    else if @type is 'String' then " = \"#{@value}\"" else " = #{@value}"

  getComment: ()->
    if not @comment then "" else " // #{@comment}"

  toString: ->
    buffer = []
    @toSource buffer
    buffer[0]
