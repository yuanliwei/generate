url         = require 'url'
querystring = require 'querystring'
GenerateView = require './generate-view'
{CompositeDisposable} = require 'atom'

util = require './util'
Java = require './java'
java = new Java()
StringUtil = require './string-util'
stringUtil = new StringUtil()

module.exports = Generate =
  generateView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @generateView = new GenerateView(state.generateViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @generateView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @pkgDisposables = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'generate:toggle': => @toggle()
      'generate:ascii_art': => @ascii_art()
      'generate:java_model': => @gen java.showHello
      'generate:java_format': => stringUtil.format "asFhdYin",1,3,4
      'generate:display': => @display()

    @pkgDisposables.add atom.workspace.addOpener (uriToOpen) ->
      {protocol, pathname} = url.parse uriToOpen
      pathname = querystring.unescape(pathname) if pathname

      return unless protocol is 'generate:'

      sourceEditorId = pathname.substr(1)
      sourceEditor   = util.getTextEditorById sourceEditorId

      return unless sourceEditor?

      util.buildCoffeeCompileEditor sourceEditor


  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pkgDisposables.dispose()
    @generateView.destroy()

  serialize: ->
    generateViewState: @generateView.serialize()

  toggle: ->
    console.log 'Generate was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  ascii_art: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      figlet = require 'figlet'
      font = "o8"
      figlet selection,{font:font},(error,art) ->
        if error
          console.error error
        else
          editor.insertText "\n#{art}\n"

  display: ->
    editor     = atom.workspace.getActiveTextEditor()
    activePane = atom.workspace.getActivePane()
    return unless editor?

    @open "generate://editor/#{editor.id}"
    .then (previewEditor) ->
      # compiled = util.compileOrStack editor
      compiled1 = "util.compileOrStack editorutil.compileOrStack editorutil.compileOrStack editor"
      previewEditor.setText compiled1
      activePane.activate()

  # Similar to atom.workspace.open
  # @param {string} A string containing a URI
  # @return {Promise.<TextEditor>}
  open: (uri) ->
    uri = atom.project.resolvePath uri
    pane = atom.workspace.paneForURI(uri)
    pane ?= atom.workspace.getActivePane().findOrCreateRightmostSibling()
    atom.workspace.openURIInPane(uri, pane)

  gen: (method) ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      editor.insertText method(selection)

    # if (editor?)
    #   selections = editor.getSelections()
    #   sel.insertText(t(sel.getText()), { "select": true}) for sel in selections
      # method selection,(error,art) ->
      #   if error
      #     console.error error
      #   else
      #     editor.insertText "\n#{art}\n"
