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
