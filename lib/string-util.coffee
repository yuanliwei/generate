module.exports ->
  upperBegin = (item) ->
    item.replace /(\w)/,(match) ->
      match.toUpperCase()

  lowerBegin = (item) ->
    item.replace /(\w)/,(match) ->
      match.toLowerCase()


  formatJavaType = (item) ->
    switch item
      when 'char' then 'String'
      when 'string' then 'String'
      when 'datetime' then 'String'
      when 'text' then 'String'
      when 'int' then 'int'
      when 'decimal' then 'double'
      when 'float' then 'float'
      when 'double' then 'double'
      else 'ERROR TYPE'

  formatDbType = (item) ->
    switch item
      when 'String' then 'TEXT'
      when 'int' then 'INTEGER'
      when 'float' then 'DOUBLE'
      else 'ERROR TYPE'

  formatJavaVarName = (item) ->
    lowerBegin item.replace /(_\w)/g, (match) ->
      match[1].toUpperCase()

  formatJSONVarName = (item) ->
    item.replace /([A-Z])/g, (match) ->
      match.toLowerCase() + '_'

  
  console.log "hello"
