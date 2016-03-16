module.exports =
  ###
  @name getTextEditorById
  @param {String} id
  @returns {Editor|null}
  ###
  getTextEditorById: (id) ->
    for editor in atom.workspace.getTextEditors()
      return editor if editor.id?.toString() is id.toString()

    return null

  ###
  @name getSelectedCode
  @param {Editor} editor
  @returns {String} Selected text
  ###
  getSelectedCode: (editor) ->
    range = editor.getSelectedBufferRange()
    text  =
      if range.isEmpty()
        editor.getText()
      else
        editor.getTextInBufferRange range

    return text

  buildCoffeeCompileEditor: (sourceEditor) ->
    previewEditor = atom.workspace.buildTextEditor()

    previewEditor.disposables.add(
      sourceEditor.onDidSave =>
    )

    # set editor grammar to correct language
    # grammar = atom.grammars.selectGrammar pluginManager.getCompiledScopeByEditor(sourceEditor)
    grammars = atom.grammars.getGrammars()
    grammar = grammars[0]
    grammars.forEach (gram) ->
      grammar = gram if gram.name is "Java"
    previewEditor.setGrammar grammar

    # HACK: Override TextBuffer saveAs function
    previewEditor.getBuffer().saveAs = ->

    # HACK: Override getURI and getTitle
    previewEditor.getTitle = -> "Generate #{sourceEditor?.getTitle() or ''}".trim()
    previewEditor.getURI   = -> "generate://editor/#{sourceEditor.id}"

    # Should never prompt to save on preview editor
    previewEditor.shouldPromptToSave = -> false

    return previewEditor
