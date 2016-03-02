fileds = """
wer
sdf
asd
dfg
"""

upperBegin = (item) ->
  item.replace /(\w)/,(match) ->
    match.toUpperCase()

fileds.split(/\s/g).forEach (item) ->
  console.log upperBegin item

"ffff".toUpperCase()
