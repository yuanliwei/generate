{TextEditor}  = require 'atom'

module.exports =
class CoffeeCompileEditor extends TextEditor
  constructor: ({@sourceEditor}) ->
    super

    # set editor grammar to correct language
    # grammar = atom.grammars.selectGrammar pluginManager.getCompiledScopeByEditor(@sourceEditor)
    # @setGrammar grammar

    # 设置文件格式
    grammars = atom.grammars.getGrammars()
    grammar = grammars[0]
    grammars.forEach (gram) ->
      grammar = gram if gram.name is "Java"
    @setGrammar grammar


    # HACK: Override TextBuffer saveAs function
    @buffer.saveAs = ->

    # 设置编辑器文本
    # @setText text

  getTitle: -> "Generate #{@sourceEditor?.getTitle() or ''}".trim()
  getURI:   -> "generate://editor/#{@sourceEditor.id}"
