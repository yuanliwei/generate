GenerateView = require './generate-view'
{CompositeDisposable} = require 'atom'

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

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'generate:toggle': => @toggle()
      'generate:ascii_art': => @ascii_art()
      'generate:java_model': => @gen java.showHello
      'generate:java_format': => stringUtil.format "asFhdYin",1,3,4


  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
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
