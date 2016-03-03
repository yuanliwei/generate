StringUtil = require '../string-util-s'

exports.modifiers = modifiers = {
    0x01:'private'
    0x02:'public'
    0x04:'protect'
    0x08:'final'
    0x10:'static'
    'private' : 0x01
    'public' : 0x02
    'protect' : 0x04
    'final' : 0x08
    'static' : 0x10
  }

module.exports = class Filed

  annotations: []

  ###
  0x01:private
  0x02:public
  0x04:protect
  0x08:final
  0x10:static
  ###
  modifier: modifiers.private
  type: 'String'
  constructor: (type, @name, @value, @comment) ->
    @type = type || @type

  ###
  private String name = "value"; // this is comment
  ###
  fromSource: (source) ->
    source = source.trim()

    # parse comment
    i = source.indexOf('//')
    if i > 3
      @comment = source.substr(i+2).trim() if i > 3
      source = source.substr(0, i).trim();

    # parse value
    i = source.indexOf('=')
    if i > 3
      strs = source.split '='
      @value = strs[1].replace /[\\"|\s|;]/g,''
      source = strs[0].trim();
    source = source.replace(';','').trim()

    # parse modifier type name
    @modifier = 0
    thiz = @
    items = source.split /\s+/g
    items.forEach (item) ->
      if item of modifiers
        value = modifiers[item]
        thiz.modifier += value
      else if not thiz.type
        thiz.type = item
      else
        thiz.name = item
    thiz

  ###
  private String name = "value"; // this is comment
  private String name = "value";
  private String name; // this is comment
  private String name;
  ###
  toSource: (buffer) ->
    tem = '{0} {1} {2}{3};{4}'
    buffer.push StringUtil.formatStr tem, @getModifier(), @type, @name, @getValue(), @getComment()

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

  getModifier: () ->
    modifier = ''
    for key of modifiers
      modifier += modifiers[key] if(parseInt(key) & @modifier > 0)
    modifier

  toString: ->
    buffer = []
    @toSource buffer
    buffer[0]
