GenerateView = require './generate-view'
{CompositeDisposable} = require 'atom'

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
    @subscriptions.add atom.commands.add 'atom-workspace', 'generate:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'generate:alert1': => @alert1()

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


  alert1: ->
    alert "asdfdfdf"
