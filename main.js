(function() {
  define(function(require, exports, module) {
    var CodeInspection, DefaultDialogs, Dialogs, DocumentManager, EditorManager, ExtensionUtils, NodeDomain, StatusBar, compileCoffee, message, statusBar;
    ExtensionUtils = brackets.getModule('utils/ExtensionUtils');
    NodeDomain = brackets.getModule('utils/NodeDomain');
    CodeInspection = brackets.getModule('language/CodeInspection');
    DocumentManager = brackets.getModule('document/DocumentManager');
    EditorManager = brackets.getModule('editor/EditorManager');
    StatusBar = brackets.getModule('widgets/StatusBar');
    DefaultDialogs = brackets.getModule('widgets/DefaultDialogs');
    Dialogs = brackets.getModule('widgets/Dialogs');
    statusBar = $('<div>K</div>');
    statusBar.css("color", "#76ff03");
    statusBar.css("font-size", "14px");
    statusBar.css("font-family", "Comic Sans MS, Verdana");
    message = "Kettle Status Indicator";
    StatusBar.addIndicator("nelsonkam-kettle", statusBar, true, "", "Kettle");
    statusBar.on("click", function(event) {
      return Dialogs.showModalDialog(DefaultDialogs.DIALOG_ID_INFO, "Kettle", message);
    });
    compileCoffee = function(content, documentPath) {
      var coffeeCompiler, updateStatusOnError;
      coffeeCompiler = new NodeDomain('CoffeeCompiler', ExtensionUtils.getModulePath(module, 'node/CoffeeCompiler.js'));
      updateStatusOnError = function(err) {
        console.log("kettle - " + err);
        if (err != null) {
          statusBar.css("color", "#d50000");
          message = "Couldn't compile. Your file contains errors.";
          return StatusBar.updateIndicator("nelsonkam-kettle", true, "", message);
        }
      };
      return coffeeCompiler.exec('compile', documentPath).done(function(result) {
        statusBar.css("color", "#76ff03");
        message = "File compiled successfully.";
        return StatusBar.updateIndicator("nelsonkam-kettle", true, "", message);
      }).fail(updateStatusOnError);
    };
    return DocumentManager.on('documentSaved', function(event, document) {
      var currentDocument, err, i, isCoffeeScript, len, mode, ref;
      isCoffeeScript = false;
      ref = ['coffeescript', 'coffeescriptimproved'];
      for (i = 0, len = ref.length; i < len; i++) {
        mode = ref[i];
        if (document.language.getId() === mode) {
          isCoffeeScript = true;
          break;
        }
      }
      currentDocument = EditorManager.getCurrentFullEditor().document;
      if (currentDocument === document && isCoffeeScript) {
        try {
          return compileCoffee(document.getText(), document.file.fullPath);
        } catch (_error) {
          err = _error;
          return console.log(err.stack);
        }
      }
    });
  });

}).call(this);
