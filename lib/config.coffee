fs = require 'fs'
ini = require 'ini'
cfg = require '../config/config.json'

class Config

  constructor: ->
    @basePath = cfg.basePath
    @runOneSpec = cfg.runOneSpec
    @g_basePath = "#{@basePath}config/"
    mkdirp = require 'mkdirp'
    mkdirp.sync @g_basePath unless fs.existsSync @g_basePath
    @configPath = "#{@g_basePath}config.ini"
    fs.writeFileSync(@configPath, '') unless fs.existsSync @configPath
    @config = ini.parse(fs.readFileSync(@configPath, 'utf-8'))
    @config.gen_java = {} unless @config.gen_java?
    @config.get_url = {} unless @config.get_url?
  saveConfig: ->
    fs.writeFileSync(@configPath, ini.stringify(@config))

module.exports = new Config()
