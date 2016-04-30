url         = require 'url'
querystring = require 'querystring'
GenerateView = require './generate-view'
SearchView = require './view/search-view'

JavaConfigView = require './view/java-config-view'

{CompositeDisposable} = require 'atom'

util = require './utils/util'
CoffeeCompileEditor = require './custom-pane/coffee-compile-editor'

StringUtil = require './utils/string-util'
GenMV = require './gen-code/gen-m-v'
GetUrl = require './get-url/get-url-m-v'
Escape = require './escape/escape-m-v'

module.exports = Generate =
  generateView: null
  searchView: null
  modalPanel: null
  searchPanel: null
  subscriptions: null

  activate: (state) ->
    @generateView = new GenerateView(state.generateViewState)
    @searchView = new SearchView(state.generateViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @generateView.getElement(), visible: false)
    @searchPanel = atom.workspace.addModalPanel(item: @searchView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @pkgDisposables = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'generate:toggle': => @toggle()
      'generate:ascii_art': => @ascii_art()
      # 'generate:java_model': => @gen console.log "hello...."
      'generate:display': => @display()
      'generate:template-search': => @toggleSearch()
      'generate:template-for-gen-java': => @toggleSearch()
      'generate:template-find-view': => @createJavaConfigView()
      'generate:template-store-gen-java': => @display()
      'generate:gen-menu-command': => @genInNewPane GenMV.gen_menu_command

      'generate:escape-url-encode': => Escape.escape_url_encode()
      'generate:escape-url-decode': => Escape.escape_url_decode()
      'generate:escape-Base64-encode': => Escape.escape_Base64_encode()
      'generate:escape-Base64-decode': => Escape.escape_Base64_decode()
      'generate:escape-Html-encode': => Escape.escape_Html_encode()
      'generate:escape-Html-decode': => Escape.escape_Html_decode()
      'generate:escape-native2ascii': => Escape.escape_native2ascii()
      'generate:escape-ascii2native': => Escape.escape_ascii2native()
      'generate:json-string2json': => Escape.json_string2json()
      'generate:json-json2string': => Escape.json_json2string()

      'generate:json-java': => @genInNewPane GenMV.json_java
      'generate:json-java-url': => @genInNewPane GenMV.json_java_url
      'generate:json-java-db-xutils': => @genInNewPane GenMV.json_java_db_xutils
      'generate:json-java-db-ormlite': => @genInNewPane GenMV.json_java_db_ormlite
      'generate:fileds-java': => @genInNewPane GenMV.fileds_java
      'generate:fileds-java-db-xutils': => @genInNewPane GenMV.fileds_java_db_xutils
      'generate:fileds-java-ormlite': => @genInNewPane GenMV.fileds_java_ormlite
      'generate:gen-style-xml': => @genInNewPane GenMV.gen_style_xml

      'generate:get-url-listurl': => GetUrl.get_url_listurl()
      'generate:get-url-show-url-config': => GetUrl.get_url_show_url_config()
      'generate:get-url-save-config': => GetUrl.get_url_save_config()
      'generate:get-url-insert-url': => GetUrl.get_url_insert_url()
      'generate:get-url-request-config': => GetUrl.get_url_request_config()
      'generate:get-url-request-url': => GetUrl.get_url_request_url()
      'generate:get-url-request-har': => GetUrl.get_url_request_har()
      'generate:get-url-store-cookies': => GetUrl.get_url_store_cookies()

      # 'generate:json-java': => @genInNewPane GenMV.json_java

    @pkgDisposables.add atom.workspace.addOpener (uriToOpen) ->
      {protocol, pathname} = url.parse uriToOpen
      pathname = querystring.unescape(pathname) if pathname

      return unless protocol is 'generate:'

      sourceEditorId = pathname.substr(1)
      sourceEditor   = util.getTextEditorById sourceEditorId

      return unless sourceEditor?

      return new CoffeeCompileEditor {sourceEditor}
      # util.buildCoffeeCompileEditor sourceEditor


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

  toggleSearch: ->
    console.log 'SearchView was toggled!'

    if @searchPanel.isVisible()
      @searchPanel.hide()
    else
      @searchPanel.show()

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
      compiled = "util.compileOrStack editorutil.compileOrStack editorutil.compileOrStack editor"
      previewEditor.setText compiled
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

  genInNewPane: (method) ->
    editor     = atom.workspace.getActiveTextEditor()
    activePane = atom.workspace.getActivePane()
    return unless editor?

    @open "generate://editor/#{editor.id}"
    .then (previewEditor) ->
      selection = editor.getSelectedText()
      selection = editor.getText() if selection.length < 1
      compiled = ''
      try
        compiled = method selection
      catch error
        console.dir error
        compiled = error.stack
      previewEditor.setText compiled
      activePane.activate()

  createJavaConfigView: ->
    @findPanel?show().
    return if @javaConfigView?
    options = {}
    @javaConfigView = new JavaConfigView(@findModel, options)
    @findPanel = atom.workspace.addBottomPanel(item: @javaConfigView, visible: true, className: 'tool-panel panel-bottom')
    @javaConfigView.setPanel(@findPanel)
