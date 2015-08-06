define (require, exports, module) ->
  ProjectManager = brackets.getModule 'project/ProjectManager'
  ExtensionUtils = brackets.getModule 'utils/ExtensionUtils'
  NodeConnection = brackets.getModule 'utils/NodeConnection'
  AppInit = brackets.getModule 'utils/AppInit'
  FileSystem = brackets.getModule 'filesystem/FileSystem'
  FileUtils = brackets.getModule 'file/FileUtils'
  CodeInspection = brackets.getModule 'language/CodeInspection'
  DocumentManager = brackets.getModule 'document/DocumentManager'
  EditorManager = brackets.getModule 'editor/EditorManager'
  
  connectToNodeModule = (moduleName) ->
    connection = new NodeConnection()
    connection.connect true
      .pipe ->
        path = ExtensionUtils.getModulePath module, "node/#{moduleName}"
        return connection.loadDomains [path], true
      .pipe ->
        return connection.domains[moduleName]
  loadProjectConfig = (callback) ->
    projectPath = ProjectManager.getProjectRoot().fullPath
    file = FileSystem.getFileForPath "#{projectPath}.brackets.json"
    FileUtils.readAsText file
      .then callback, ->
        file = FileSystem.getFileForPath "#{projectPath}compile.json"
        FileUtils.readAsText file
          .then callback, -> callback()
  loadOptions = (documentPath) ->
    projectPath = ProjectManager.getProjectRoot().fullPath
    deferred = $.Deferred()
    loadProjectConfig (text) ->
      defaults = kettle: [documentPath]
      deferred.resolve defaults unless text?
      try
        options = JSON.parse text
      catch err
      if not err? and options.kettle instanceof Array
        for file, i in options.kettle
          options.kettle[i] = projectPath + file
      options = $.extend {}, defaults, options
      deferred.resolve options
    deferred
  compile = (compiler, options) ->
    tasks = []
    for file in options.kettle
      tasks.push compiler.compile file, options
    $.when.apply $, tasks
  convertError = (error) ->
    if typeof error is 'string'
      return pos: {}, message: error
    switch error.code
      when 'EACCES', 'ENOENT'
        pos: {}, message: "Cannot open file '#{error.path}'"
      else
        if error.filename isnt EditorManager.getCurrentFullEditor().document.file.name
          pos: {} 
          message: "Error in file '#{error.filename}' on line #{error.line}: #{error.message}"
          type: error.type
        pos:
          line: error.line - 1
          ch: error.index
        message: error.message
        type: error.type
  compileCoffee = (content, documentPath) ->
    deferred = new $.Deferred()
    connection = connectToNodeModule 'CoffeeCompiler'
    options = loadOptions documentPath
    $.when connection, options
      .then ((compiler, options) ->
        compile compiler, options
          .then (-> deferred.resolve()),
            (error) ->
              deferred.resolve errors: [convertError error]),
        (error) ->
          deferred.resolve errors: [error]
    return deferred.promise()
  
  DocumentManager.on 'documentSaved', (event, document) ->
    isCoffeeScript = false
    for mode in ['coffeescript', 'coffeescriptimproved']
      if document.language.getId() is mode
        isCoffeeScript = true
        break
    if EditorManager.getCurrentFullEditor().document is document and isCoffeeScript
      try
        compileCoffee document.getText(), document.file.fullPath
      catch err
        console.log err.stack