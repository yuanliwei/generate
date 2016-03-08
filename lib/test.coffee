cp = atom.packages.getLoadedPackage('generate').getMainModulePath()
basePath = cp.substr 0,(cp.lastIndexOf('generate.coffee') - 1)
console.log basePath
# StringUtil = require "#{basePath}/string-util-s"

################################################################
http = require 'http' 
http.get("http://cnodejs.org/", (res) ->
    size = 0
    chunks = []
    res.on 'data', (chunk) ->
        size += chunk.length
        chunks.push chunk
    res.on 'end', ->
        data = Buffer.concat chunks, size
        console.log data.toString()
  ).on 'error', (e) ->
    console.log "Got error: #{e.message}"
