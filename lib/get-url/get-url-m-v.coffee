config = require('../config').config
IndexUrl = require './index-url'
indexUrl = new IndexUrl()

exports.get_url_listurl = ->
  filter = { }
  urls = indexUrl.listUrls(filter)
  builder = []
  urls.forEach (item) ->
    builder.push "#{item.name}\n\t\t#{item.url}"
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?
  editor.insertNewlineBelow()
  # editor.deleteToBeginningOfLine()
  content = builder.join('\n')
  editor.insertText content

exports.get_url_show_url_config = ->
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?
  selectionText = editor.getSelectedText()
  editor.insertNewlineBelow()
  editor.deleteToBeginningOfLine()
  url = selectionText.trim()
  console.dir url
  if url.length is 0
    editor.insertText '\n'
    editor.insertText urlCfgTem
  else
    urlConfig = indexUrl.getUrlConfig(url)
    cfg = JSON.stringify urlConfig
    jsBeautify = require('js-beautify').js_beautify
    cfg_text = jsBeautify(cfg, { })
    editor.insertText cfg_text

exports.get_url_save_config = ->
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?
  selectionText = editor.getSelectedText()
  # editor.insertNewlineBelow()
  # editor.deleteToBeginningOfLine()
  cfgText = selectionText.trim()
  return if cfgText.length is 0

  urlConfig = JSON.parse(cfgText)
  indexUrl.saveUrlConfig(urlConfig)
  console.log "save over!"

exports.get_url_insert_url = ->
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?
  selectionText = editor.getSelectedText()
  # editor.insertNewlineBelow()
  # editor.deleteToBeginningOfLine()
  cfgText = selectionText
  cfgs = cfgText.trim().split /\s+/g
  return unless cfgs.length is 2
  urlObj = {name:cfgs[0], url: cfgs[1]}
  indexUrl.insertUrl(urlObj)

  console.log "insert over!"

urlCfgTem = """
            {
              "url": "http://www.baidu.com",
              "opts": {
                "method": "GET",
                "headers": {
                  "Accept": "text/html",
                  "Cache-Control": "no-cache"
                },
                "queryString": {
                  "name": "ylw",
                  "age": 123
                },
                "formData": {
                  "name": "ylw",
                  "age": 123456
                }
              }
            }
        """

exports.get_url_request_config = ->
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?
  selectionText = editor.getSelectedText()
  cfgText = selectionText.trim()
  return if cfgText.length is 0
  editor.moveToBottom()
  editor.insertNewlineBelow()
  editor.deleteToBeginningOfLine()

  try
    urlConfig = JSON.parse(cfgText)
    indexUrl.requestUrlConfig urlConfig, (error, response, body) ->
      editor.insertText error.stack if error
      json = JSON.stringify response.toJSON()
      jsBeautify = require('js-beautify').js_beautify
      body_text = jsBeautify(json, { })
      # console.dir response
      # body_text = body
      # body_text = response.toJSON()
      editor.insertText body_text
  catch error
    editor.insertText error.stack

exports.get_url_request_url = ->
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?
  selectionText = editor.getSelectedText()
  url = selectionText.trim()
  return if url.length is 0
  editor.moveToBottom()
  editor.insertNewlineBelow()
  editor.deleteToBeginningOfLine()
  try
    indexUrl.requestUrl url, (error, response, body) ->
      editor.insertText error.stack if error
      json = JSON.stringify response.toJSON()
      jsBeautify = require('js-beautify').js_beautify
      body_text = jsBeautify(json, { })
      editor.insertText body_text
  catch error
    editor.insertText error.stack
