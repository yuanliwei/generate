module.exports ->
  upperBegin = (item) ->
    item.replace /(\w)/,(match) ->
      match.toUpperCase()
