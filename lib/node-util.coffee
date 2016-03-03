# 获取当前路径
path = process.cwd()
console.log path
# 修改当前路径
process.chdir(path)

fs = require 'fs'
fs.readFile 'start.js',(err, data) ->
  if err
    console.error err
  else
    console.log data.toString()

os = require "os"
console.log "uptime - #{os.uptime()/3600/24}"
