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
  editor.deleteToBeginningOfLine()
  content = builder.join('\n')
  editor.insertText content

exports.get_url_show_url_config = ->
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?
  selectionText = editor.getSelectedText()
  editor.insertNewlineBelow()
  editor.deleteToBeginningOfLine()
  url = selectionText
  urlConfig = indexUrl.getUrlConfig(url)
  cfg = JSON.stringify urlConfig
  jsBeautify = require('js-beautify').js_beautify
  cfg_text = jsBeautify(cfg, { })
  editor.insertText cfg_text
