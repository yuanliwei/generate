{$, $$$, View, TextEditorView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
buildTextEditor = require './build-text-editor'

Config = require '../config'
config = Config.config

module.exports =
class FindView extends View
  @content: (model, {findBuffer, replaceBuffer}) ->
    packageNameEditor = buildTextEditor
      mini: true
      tabLength: 2
      softTabs: true
      softWrapped: false
      buffer: findBuffer
      placeholderText: 'package name'
    classNameEditor = buildTextEditor
      mini: true
      tabLength: 2
      softTabs: true
      softWrapped: false
      buffer: findBuffer
      placeholderText: 'class name'
    @div tabIndex: -1, class: 'generate-input-panel', =>
      @header class: 'header', =>
        @span outlet: 'descriptionLabel', class: 'header-item description', 'Input class name'
        @span class: 'header-item options-label pull-right', =>
          @span 'Close pane'
          @span outlet: 'optionsLabel', class: 'options'

      @section class: 'input-block find-container', =>
        @div class: 'input-block-item editor-container', =>
          @subview 'packageNameEditor', new TextEditorView(editor: packageNameEditor)
          @div class: 'find-meta-container', =>
            @span outlet: 'resultCounter', class: 'text-subtle result-counter', ''

        @div class: 'btn-group', =>
          @button outlet: 'nextButton', class: 'btn', 'Close'

      @section class: 'input-block find-container', =>
        @div class: 'input-block-item editor-container', =>
          @subview 'classNameEditor', new TextEditorView(editor: classNameEditor)
          @div class: 'find-meta-container', =>
            @span outlet: 'resultCounter', class: 'text-subtle result-counter', ''

  initialize: (@model, {@findHistoryCycler, @replaceHistoryCycler}) ->
    @subscriptions = new CompositeDisposable
    @handleEvents()
    @packageNameEditor.setText config.gen_java.packageName if config.gen_java.packageName?
    @classNameEditor.setText config.gen_java.className if config.gen_java.className?

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

    @on 'focus', => @classNameEditor.focus()

    @packageNameEditor.on 'blur', => @saveConfig()
    @classNameEditor.on 'blur', => @saveConfig()

    @find('button').on 'click', =>
      workspaceElement = atom.views.getView(atom.workspace)
      workspaceElement.focus()
      @panel?.hide()

  saveConfig: ->
    packageName = @packageNameEditor.getText()
    className = @classNameEditor.getText()
    config.gen_java.packageName = packageName
    config.gen_java.className = className
    Config.saveConfig()
