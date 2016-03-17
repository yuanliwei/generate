{$, $$$, View, TextEditorView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
buildTextEditor = require './build-text-editor'

Config = require '../config'

config = Config.Ini

# config.scope = 'local'
# config.database.database = 'use_another_database'
# config.paths.default.tmpdir = '/tmp'
# config.paths.default.array.push('fourth value')

# fs.writeFileSync('./config_modified.ini', ini.stringify(config, { section: 'section' }))


module.exports =
class FindView extends View
  @content: (model, {findBuffer, replaceBuffer}) ->
    findEditor = buildTextEditor
      mini: true
      tabLength: 2
      softTabs: true
      softWrapped: false
      buffer: findBuffer
      placeholderText: 'class name'
    console.dir @
    @div tabIndex: -1, class: 'generate-input-panel', =>
      @header class: 'header', =>
        @span outlet: 'descriptionLabel', class: 'header-item description', 'Input class name'
        @span class: 'header-item options-label pull-right', =>
          @span 'Close pane'
          @span outlet: 'optionsLabel', class: 'options'

      @section class: 'input-block find-container', =>
        @div class: 'input-block-item editor-container', =>
          @subview 'findEditor', new TextEditorView(editor: findEditor)
          @div class: 'find-meta-container', =>
            @span outlet: 'resultCounter', class: 'text-subtle result-counter', ''

        @div class: 'btn-group', =>
          @button outlet: 'nextButton', class: 'btn', 'Close'

  initialize: (@model, {@findHistoryCycler, @replaceHistoryCycler}) ->
    @subscriptions = new CompositeDisposable

    @handleEvents()

  destroy: ->
    @subscriptions?.dispose()
    @tooltipSubscriptions?.dispose()

  setPanel: (@panel) ->
    # @subscriptions.add @panel.onDidChangeVisible (visible) =>
    #   if visible then @didShow() else @didHide()

  handleEvents: ->
    @subscriptions.add atom.commands.add @element,
      'core:close': => @panel?.hide()
      'core:cancel': => @panel?.hide()

    @on 'focus', => @findEditor.focus()

    @findEditor.on 'blur', =>
      className = @findEditor.getText()
      config.gen_java = {}
      config.gen_java.className = className
      Config.saveIni()

    @find('button').on 'click', =>
      workspaceElement = atom.views.getView(atom.workspace)
      workspaceElement.focus()
      @panel?.hide()
