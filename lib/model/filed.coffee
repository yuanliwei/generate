StringUtil = require '../string-util-s'

module.exports = class Filed

  annotations: []
  modifier:'private'
  type: 'String'
  constructor: (type, @name, @value, @comment) ->
    @type = type || @type

  toSource: (buffer) ->
    if @value and @comment # private String name = "value"; // this is comment
      tem = '{0} {1} {2} = "{3}"; // {4}'
      buffer.push StringUtil.formatStr tem, @modifier, @type, @name, @value, @comment
    else if @value and not @comment # private String name = "value";
      tem = '{0} {1} {2} = "{3}";' if @type is 'String'
      tem = '{0} {1} {2} = {3};' if @type isnt 'String'
      buffer.push StringUtil.formatStr tem, @modifier, @type, @name, @value
    else if not @value and @comment # private String name; // this is comment
      tem = '{0} {1} {2}; // {3}'
      buffer.push StringUtil.formatStr tem, @modifier, @type, @name, @comment
    else # private String name;
      tem = '{0} {1} {2};'
      buffer.push StringUtil.formatStr tem, @modifier, @type, @name
