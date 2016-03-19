Entities = require('html-entities').AllHtmlEntities
entities = new Entities()

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

exports.escape_url_encode = ->
  transfromSel encodeURIComponent

exports.escape_url_decode = ->
  transfromSel decodeURIComponent

exports.escape_Base64_encode = ->
  transfromSel encodeBase64

exports.escape_Base64_decode = ->
  transfromSel decodeBase64

exports.escape_Html_encode = ->
  transfromSel entities.encodeNonUTF

exports.escape_Html_decode = ->
  transfromSel entities.decode

encodeBase64 = (text) ->
  new Buffer(text).toString("base64")

decodeBase64 = (text) ->
  if /^[A-Za-z0-9+/=]+$/.test(text)
    new Buffer(text, "base64").toString("utf8")
  else
    #console.debug("Ignoring text as it contains illegal characers", text)
    text

transfromSel = (t) ->
  # This assumes the active pane item is an editor
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?

  selections = editor.getSelections()
  sel.insertText(t(sel.getText()), { "select": true}) for sel in selections
