exports.upperBegin = (item) ->
    item.replace /(\w)/,(match) ->
      match.toUpperCase()

exports.lowerBegin = (item) ->
    item.replace /(\w)/,(match) ->
      match.toLowerCase()


exports.formatJavaType = (item) ->
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

exports.formatDbType = (item) ->
    switch item
      when 'String' then 'TEXT'
      when 'int' then 'INTEGER'
      when 'float' then 'DOUBLE'
      else 'ERROR TYPE'

exports.formatJavaVarName = (item) ->
    @lowerBegin item.replace /(_\w)/g, (match) ->
      match[1].toUpperCase()

exports.formatJSONVarName = (item) ->
    item.replace /([A-Z])/g, (match) ->
      match.toLowerCase() + '_'

exports.format = () ->
    args = arguments
    item = args[0]
    for arg, i in args when i isnt 0
      switch arg
        when 0 then item = @upperBegin item
        when 1 then item = @lowerBegin item
        when 2 then item = @formatJavaVarName item
        when 3 then item = @formatJSONVarName item
        when 4 then item = @formatJSONVarName item
        when 5 then item = @formatJavaType item
        when 6 then item = @formatDbType item
        else throw new Error("IllegalArgument for #{arg}")
          # body...
      # body...
    item
