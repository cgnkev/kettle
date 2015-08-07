define (require, exports, module) ->
#  ProjectManager = brackets.getModule 'project/ProjectManager'
  ExtensionUtils = brackets.getModule 'utils/ExtensionUtils'
  NodeDomain = brackets.getModule 'utils/NodeDomain'
#  AppInit = brackets.getModule 'utils/AppInit'
#  FileSystem = brackets.getModule 'filesystem/FileSystem'
#  FileUtils = brackets.getModule 'file/FileUtils'
  CodeInspection = brackets.getModule 'language/CodeInspection'
  DocumentManager = brackets.getModule 'document/DocumentManager'
  EditorManager = brackets.getModule 'editor/EditorManager'
  StatusBar = brackets.getModule 'widgets/StatusBar'
  DefaultDialogs = brackets.getModule 'widgets/DefaultDialogs'
  Dialogs = brackets.getModule 'widgets/Dialogs'
  statusBar = $ '<div>K</div>'
  statusBar.css "color", "#76ff03"
  statusBar.css "font-size", "14px"
  statusBar.css "font-family", "Comic Sans MS, Verdana"
  # Dialog message
  message = "Kettle Status Indicator"
  StatusBar.addIndicator "nelsonkam-kettle", statusBar, true, "", "Kettle"
  statusBar.on "click", (event) ->
    Dialogs.showModalDialog DefaultDialogs.DIALOG_ID_INFO, "Kettle", message
#  loadProjectConfig = (callback) ->
#    projectPath = ProjectManager.getProjectRoot().fullPath
#    file = FileSystem.getFileForPath "#{projectPath}.brackets.json"
#    FileUtils.readAsText file
#      .then callback, ->
#        file = FileSystem.getFileForPath "#{projectPath}compile.json"
#        FileUtils.readAsText file
#          .then callback, -> callback()
#  loadOptions = (documentPath) ->
#    projectPath = ProjectManager.getProjectRoot().fullPath
#    deferred = $.Deferred()
#    loadProjectConfig (text) ->
#      defaults = kettle: [documentPath]
#      deferred.resolve defaults unless text?
#      try
#        options = JSON.parse text
#      catch err
#      if not err? and options.kettle instanceof Array
#        for file, i in options.kettle
#          options.kettle[i] = projectPath + file
#      options = $.extend {}, defaults, options
#      deferred.resolve options
#    deferred
#  compile = (compiler, options) ->
#    tasks = []
#    for file in options.kettle
#      tasks.push compiler.compile file, options
#    $.when.apply $, tasks
#  convertError = (error) ->
#    if typeof error is 'string'
#      return pos: {}, message: error
#    switch error.code
#      when 'EACCES', 'ENOENT'
#        pos: {}, message: "Cannot open file '#{error.path}'"
#      else
#        currentFilename =
#          EditorManager.getCurrentFullEditor().document.file.name
#        if error.filename isnt currentFilename
#          pos: {}
#          message: "Error in file '#{error.filename}' on
#          line #{error.line}: #{error.message}"
#          type: error.type
#        pos:
#          line: error.line - 1
#          ch: error.index
#        message: error.message
#        type: error.type
  # Compiles coffeescript document using CoffeeCompiler module
  # @param [String] content document's content
  # @param [String] document document's path
  compileCoffee = (content, documentPath) ->
    coffeeCompiler = new NodeDomain 'CoffeeCompiler',
      ExtensionUtils.getModulePath module, 'node/CoffeeCompiler.js'
    updateStatusOnError = (err) ->
      console.log "kettle - #{err}"
      if err?
        statusBar.css "color", "#d50000"
        message = "Couldn't compile. Your file contains errors."
        StatusBar.updateIndicator "nelsonkam-kettle", true, "", message
    coffeeCompiler.exec 'compile', documentPath
      .done (result) ->
        statusBar.css "color", "#76ff03"
        message = "File compiled successfully."
        StatusBar.updateIndicator "nelsonkam-kettle", true, "", message
      .fail updateStatusOnError

  DocumentManager.on 'documentSaved', (event, document) ->
    isCoffeeScript = false
    for mode in ['coffeescript', 'coffeescriptimproved']
      if document.language.getId() is mode
        isCoffeeScript = true
        break
    currentDocument = EditorManager.getCurrentFullEditor().document
    if currentDocument is document and isCoffeeScript
      try
        compileCoffee document.getText(), document.file.fullPath
      catch err
        console.log err.stack