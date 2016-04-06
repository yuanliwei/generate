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

exports.escape_native2ascii = ->
  transfromSel native2ascii

exports.escape_ascii2native = ->
  transfromSel ascii2native

exports.json_string2json = ->
  transfromSel string2json

exports.json_json2string = ->
  transfromSel json2string

string2json = (text) ->
  text.replace /\\(.)/g, (match, char) ->
    char

json2string = (text) ->
  body = {"body": "#{text}" }
  JSON.stringify body.body

encodeBase64 = (text) ->
  new Buffer(text).toString("base64")

decodeBase64 = (text) ->
  if /^[A-Za-z0-9+/=]+$/.test(text)
    new Buffer(text, "base64").toString("utf8")
  else
    #console.debug("Ignoring text as it contains illegal characers", text)
    text

ascii2native = (ascii) ->
  words = ascii.split '\\u'
  native1 = words[0]
  for code, i in words when i isnt 0
    native1 += String.fromCharCode parseInt "0x#{code.substr 0,4}"
    native1 += code.substr(4,code.length) if code.length > 4
  native1

native2ascii = (native_) ->
  chars = native_.split ''
  ascii = ''
  for char, i in chars
    code = Number chars[i].charCodeAt 0
    if code > 127
      charAscii = code.toString 16
      charAscii = new String('0000').substr(charAscii.length,4)+charAscii;
      ascii += '\\u'+charAscii
    else
      ascii += chars[i]
  ascii

transfromSel = (t) ->
  # This assumes the active pane item is an editor
  editor = atom.workspace.getActiveTextEditor()
  return unless editor?

  selections = editor.getSelections()
  sel.insertText(t(sel.getText()), { "select": true}) for sel in selections
