fs = require 'fs'
ini = require 'ini'

Config = {
    basePath: "C:\\Users\\up366pc1.hxtt-pc1\\.atom\\packages\\generate\\"
    runOneSpec: true
  }


configPath =( ->
  g_basePath = "#{Config.basePath}config/"
  fs.mkdir g_basePath if not fs.existsSync g_basePath
  "#{g_basePath}config.ini")

config =( ->
  fs.writeFileSync(configPath, '') if not fs.existsSync configPath
  ini.parse(fs.readFileSync(configPath, 'utf-8')))

saveConfig = ->
  fs.writeFileSync(configPath, ini.stringify(config, { section: 'section' }))

exports.Config = Config
exports.Ini = config
exports.saveIni = saveConfig
