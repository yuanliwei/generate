{$, $$$, View, TextEditorView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
buildTextEditor = require './build-text-editor'

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
    @subscriptions.add @panel.onDidChangeVisible (visible) =>
      if visible then @didShow() else @didHide()

  didShow: ->
    atom.views.getView(atom.workspace).classList.add('find-visible')

  didHide: ->
    @hideAllTooltips()
    workspaceElement = atom.views.getView(atom.workspace)
    workspaceElement.focus()
    workspaceElement.classList.remove('find-visible')

  hideAllTooltips: ->
    @tooltipSubscriptions.dispose()
    @tooltipSubscriptions = null

  handleEvents: ->
    # @findEditor.getModel().onDidStopChanging => @liveSearch()

    @subscriptions.add atom.commands.add @findEditor.element,
      'core:confirm': => @confirm()

    @subscriptions.add atom.commands.add @element,
      'core:close': => @panel?.hide()
      'core:cancel': => @panel?.hide()

    @on 'focus', => @findEditor.focus()
    @find('button').on 'click', ->
      workspaceElement = atom.views.getView(atom.workspace)
      workspaceElement.focus()
