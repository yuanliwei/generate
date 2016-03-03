module.exports = class Filed

  annotations: []
  modifier:'private'
  type: 'String'
  constructor: (type, @name, @value, @comment) ->
    @type = type || @type

  toSource: (buffer) ->
    buffer.push "#{@modifier} "
    buffer.push "#{@type} "
    buffer.push "#{@name} "
    if @value
      buffer.push "= "
      buffer.push "#{@value};"
    else buffer.push ";"
    if @comment
      buffer.push " // "
      buffer.push "#{@comment} "
