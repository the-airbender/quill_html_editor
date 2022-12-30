import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

///[QuillHtmlEditor] widget to show the quill editor,
class QuillHtmlEditor extends StatefulWidget {
  ///[QuillHtmlEditor] widget to show the quill editor,
  ///pass the controller to access the editor methods
  QuillHtmlEditor(
      {this.text,
      required this.controller,
      required this.height,
      this.isEnabled = true,
      this.onTextChanged,
      this.hintText = 'Description'})
      : super(key: controller._editorKey);

  /// [text] to set initial text to the editor, please use text
  /// We can also use the setText method for the same
  final String? text;

  /// [height] to define the height of the editor
  final double height;

  /// [hintText] is a placeholder, by default, the hint will be 'Description'
  /// We can override the placeholder text by passing hintText to the editor
  final String? hintText;

  /// [isEnabled] as the name suggests, is used to enable or disable the editor
  /// When it is set to false, the user cannot edit or type in the editor
  final bool isEnabled;

  /// [controller] to access all the methods of editor and toolbar
  final QuillEditorController controller;

  /// [onTextChanged] callback function that triggers on text changed
  final Function(String)? onTextChanged;

  @override
  QuillHtmlEditorState createState() => QuillHtmlEditorState();
}

///[QuillHtmlEditorState] editor state class to render the editor
class QuillHtmlEditorState extends State<QuillHtmlEditor> {
  /// it is the controller used to access the functions of quill js library
  late WebViewXController _webviewController;

  /// this variable is used to set the html code that renders the quill js library
  String _initialContent = "";

  /// [isEnabled] as the name suggests, is used to enable or disable the editor
  /// When it is set to false, the user cannot edit or type in the editor
  bool isEnabled = true;

  @override
  void initState() {
    isEnabled = widget.isEnabled;
    super.initState();
  }

  @override
  void dispose() {
    _webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double screenHeight = widget.height;
      _initialContent =
          _getQuillPage(height: screenHeight, width: constraints.maxWidth);

      return Center(
        child: _buildEditorView(
            context: context,
            height: screenHeight,
            width: constraints.maxWidth),
      );
    });
  }

  Widget _buildEditorView(
      {required BuildContext context,
      required double height,
      required double width}) {
    _initialContent = _getQuillPage(height: height, width: width);

    return WebViewX(
      key: ValueKey(widget.key.hashCode.toString()),
      initialContent: _initialContent,
      initialSourceType: SourceType.html,
      height: height,
      ignoreAllGestures: false,
      width: width - 5,
      onWebViewCreated: (controller) => _webviewController = controller,
      onPageStarted: (src) {},
      onPageFinished: (src) {
        widget.controller.enableEditor(isEnabled);
        if (widget.text != null) {
          _setHtmlTextToEditor(htmlText: widget.text!);
        }
      },
      dartCallBacks: {
        DartCallback(
            name: 'UpdateFormat',
            callBack: (map) {
              try {
                if (widget.controller._toolBarKey != null) {
                  widget.controller._toolBarKey!.currentState
                      ?.updateToolBarFormat(jsonDecode(map));
                }
              } catch (e) {
                if (!kReleaseMode) {
                  debugPrint(e.toString());
                }
              }
            }),
        DartCallback(
            name: 'OnTextChanged',
            callBack: (map) {
              try {
                if (widget.controller._changeController != null) {
                  String finalText = "";
                  String parsedText =
                      QuillEditorController._stripHtmlIfNeeded(map);
                  if (parsedText.trim() == "") {
                    finalText = "";
                  } else {
                    finalText = map;
                  }
                  if (widget.onTextChanged != null) {
                    widget.onTextChanged!(finalText);
                  }
                  widget.controller._changeController!.add(finalText);
                }
              } catch (e) {
                if (!kReleaseMode) {
                  debugPrint(e.toString());
                }
              }
            })
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: false,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
    );
  }

  /// a private method to get the Html text from the editor
  Future<String> _getHtmlFromEditor() async {
    return await _webviewController.callJsMethod("getHtmlText", []);
  }

  /// a private method to check if editor has focus
  Future<int> _getSelectionCount() async {
    return await _webviewController.callJsMethod("getSelection", []);
  }

  /// a private method to check if editor has focus
  Future<dynamic> _getSelectionRange() async {
    return await _webviewController.callJsMethod("getSelectionRange", []);
  }

  /// a private method to check if editor has focus
  Future<dynamic> _setSelectionRange(int index, int length) async {
    return await _webviewController
        .callJsMethod("setSelection", [index, length]);
  }

  /// a private method to set the Html text to the editor
  Future _setHtmlTextToEditor({required String htmlText}) async {
    await _webviewController.callJsMethod("setHtmlText", [htmlText]);
  }

  /// a private method to embed the video to the editor
  Future _embedVideo({required String videoUrl}) async {
    await _webviewController.callJsMethod("embedVideo", [videoUrl]);
  }

// a private method to embed the image to the editor
  Future _embedImage({required String imgSrc}) async {
    await _webviewController.callJsMethod("embedImage", [imgSrc]);
  }

  /// a private method to enable/disable the editor
  Future _enableTextEditor({required bool isEnabled}) async {
    await _webviewController.callJsMethod("enableEditor", [isEnabled]);
  }

  /// a private method to enable/disable the editor
  Future _setFormat({required String format, required dynamic value}) async {
    await _webviewController.callJsMethod("setFormat", [format, value]);
  }

  /// This method generated the html code that is required to render the quill js editor
  /// We are rendering this html page with the help of webviewx and using the callbacks to call the quill js apis
  String _getQuillPage({required double height, required double width}) {
    double finalHeight = width < 350
        ? height - 110
        : width < 600
            ? height - 85
            : height - 65;

    return '''
 <!DOCTYPE html>
      <html>
      <head>
      <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
      <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet" />
      <style>
      .ql-container.ql-snow {
      margin-top:0px;
      width:100%;
      border:none;
      height: ${finalHeight.toInt() - 43}px;
      min-height:100%;
      }
      .ql-toolbar { 
        position: absolute; 
        top: 0;
        left:0;
        right:0
      }
      .ql-tooltip{
     display:none; 
      }
      
      #toolbar-container{
      display:none;
      }     
      </style>
      </head>
      <body>
      
      
      <!-- Create the toolbar container -->
      
      <div id="toolbar-container">
      
      <span class="ql-formats">
      <button class="ql-bold"></button>
      <button class="ql-italic"></button>
      <button class="ql-underline"></button>
      <button class="ql-strike"></button>
      <button class="ql-blockquote"></button>
      <select class="ql-size"></select>
      <button class="ql-direction" value="rtl"></button>
      <button class="ql-direction" value="ltr"></button>
     
      
      <select class="ql-color"></select>
      <select class="ql-background"></select>
      
      <button class="ql-header" value="1"></button>
      <button class="ql-header" value="2"></button>
      
      <button class="ql-list" value="ordered"></button>
      <button class="ql-list" value="bullet"></button>
      <select class="ql-align"></select>
      <button class="ql-indent" value="-1"></button>
      <button class="ql-indent" value="+1"></button>
      <button class="ql-link"></button>
      <button class="ql-image"></button>
      <button class="ql-video"></button>
      
      <button class="ql-clean"></button>
      </span>
      </div>
      
      <!-- Create the editor container -->
      <div style="position:relative;margin-top:0em;">
      <div id="editorcontainer" style="height:${finalHeight.toInt()}px; min-height:100%; overflow-y:auto;margin-top:0em;">
      <div id="editor" style="min-height:100%; height:${finalHeight.toInt() - 43}px;  width:100%;"></div>
      </div>
      </div>
      <!-- Include the Quill library -->
      <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
      
      <!-- Initialize Quill editor -->
      <script>
      
      
      let fullWindowHeight = window.innerHeight;
      let keyboardIsProbablyOpen = false;
      
      window.addEventListener("resize", function() {
      
      resizeElementHeight(document.getElementById("editorcontainer"),1);
      resizeElementHeight(document.getElementById("editor"),1);
      if(window.innerHeight == fullWindowHeight) {
      keyboardIsProbablyOpen = false;
      
      } else if(window.innerHeight < fullWindowHeight*0.9) {
      
      keyboardIsProbablyOpen = true;
      }
      });
      
      
      function resizeElementHeight(element, ratio) {
      var height = 0;
      var body = window.document.body;
      if (window.innerHeight) {
      height = window.innerHeight;
      } else if (body.parentElement.clientHeight) {
      height = body.parentElement.clientHeight;
      } else if (body && body.clientHeight) {
      height = body.clientHeight;
      }
        let isIOS = /iPad|iPhone|iPod/.test(navigator.platform)
        || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)
        if(isIOS){
        element.style.height = ((height/ratio - element.offsetTop) + "px");
        }else{
        element.style.height = ((height - element.offsetTop-60) + "px");
        }
      
      }
      
      function applyGoogleKeyboardWorkaround(editor) {
      
      try {
      
      if (editor.applyGoogleKeyboardWorkaround) {
          return
      }
      editor.applyGoogleKeyboardWorkaround = true
      editor.on('editor-change', function (eventName, ...args) {
          if (eventName === 'text-change') {
            // args[0] will be delta
            var ops = args[0]['ops']
            if(ops===null){
            return
            }
            var oldSelection = editor.getSelection()
            var oldPos = oldSelection.index
            var oldSelectionLength = oldSelection.length
            if (ops[0]["retain"] === undefined || !ops[1] || !ops[1]["insert"] || !ops[1]["insert"] ||ops[1]["list"] === "bullet"|| ops[1]["list"] === "ordered"  || ops[1]["insert"] !=  "\\n" || oldSelectionLength > 0) {
              return
            }
          
            setTimeout(function () {
              var newPos = editor.getSelection().index
              if (newPos === oldPos) {
                editor.setSelection(editor.getSelection().index + 1, 0)
              }
            }, 30);
            //onRangeChanged();
          } 
        });
      } catch (e) {
        console.log(e);
       }
      }
      
      const Inline = Quill.import('blots/inline');
      class RequirementBlot extends Inline {}
      RequirementBlot.blotName = 'requirement';
      RequirementBlot.tagName = 'requirement';
      Quill.register(RequirementBlot);
      
      class ResponsibilityBlot extends Inline {}
      ResponsibilityBlot.blotName = 'responsibility';
      ResponsibilityBlot.tagName = 'responsibility';
      Quill.register(ResponsibilityBlot);
      
      var quilleditor = new Quill('#editor', {
        modules: { toolbar: '#toolbar-container' },
        theme: 'snow',
        placeholder: '${widget.hintText ?? "Description"}',
        clipboard: {
            matchVisual: false
        }
      });
      
      quilleditor.enable($isEnabled);
      
      quilleditor.root.addEventListener("blur",function (){
      resizeElementHeight(document.getElementById("editorcontainer"),1);
      resizeElementHeight(document.getElementById("editor"),1);                     
      });
        
       quilleditor.on('selection-change', function(eventName, ...args) {
             /// console.log('selection changed');
               onRangeChanged(); 
          });
          
      quilleditor.on('text-change', function(eventName, ...args) {
              console.log('text changed');
             onRangeChanged(); 
             OnTextChanged(quilleditor.root.innerHTML);
          });
      
     function onRangeChanged(){
           var range = quilleditor.getSelection();
           var format = quilleditor.getFormat();
           
              if (range) {
                  if (range.length == 0) {
                    var format = quilleditor.getFormat();
                     formatParser(format);
                 } else {
                    var format = quilleditor.getFormat(range.index,range.length);
                     formatParser(format);
                 }
              } else {
                  console.log('Cursor not in the editor');
              }
     } 
      
      
      function formatParser(format){
      var formatMap = {};
        formatMap['bold'] = format['bold'];
        formatMap['italic'] = format['italic'];
        formatMap['underline'] = format['underline'];
        formatMap['strike'] = format['strike'];
        formatMap['blockqoute'] = format['blockqoute'];
        formatMap['background'] = format['background'];
        formatMap['code-block'] = format['code-block'];
        formatMap['indent'] = format['indent'];
        formatMap['direction'] = format['direction'];
        formatMap['size'] =   format['size'];
        formatMap['header'] = format['header'];
        formatMap['color'] = format['color'];
        formatMap['font'] = format['font'];
        formatMap['align'] = format['align'];
        formatMap['list'] = format['list'];
        formatMap['image'] = format['image'];
        formatMap['video'] = format['video'];
        formatMap['clean'] = format['clean'];
        formatMap['link'] = format['link'];
  
        if($kIsWeb){
        UpdateFormat(JSON.stringify(formatMap));
        }else{
        UpdateFormat.postMessage(JSON.stringify(formatMap));
        }  
      }
        
      quilleditor.root.addEventListener("focus",function (){  
      // onRangeChanged(); 
      resizeElementHeight(document.getElementById("editorcontainer"),2);
      resizeElementHeight(document.getElementById("editor"),2);       
      
      });
      applyGoogleKeyboardWorkaround(quilleditor);
      
     function getHtmlText()
      {
        return quilleditor.root.innerHTML;
      }
      
     function getSelection()
      {
       var range = quilleditor.getSelection();
       if(range){
         return range.length;
       }
        return -1;
      }
      
   function getSelectionRange()
      {
       var range = quilleditor.getSelection();
      if(range){
         var rangeMap = {};
         rangeMap['length'] = range.length;
         rangeMap['index'] = range.index;
         return  JSON.stringify(rangeMap);   
      }
      return {};    
      }
   
   
    function setSelection (index, length) 
      {
      setTimeout(() => quilleditor.setSelection(index, length), 1);
      return '';
      } 
   
      function setHtmlText(htmlString) 
      {
        const delta = quilleditor.clipboard.convert(htmlString);
        quilleditor.setContents(delta, 'silent');
        return '';
      } 
      
      function embedVideo(videlUrl) 
      {  
        var range = quilleditor.getSelection();
        if(range){
          quilleditor.insertEmbed(range.index, 'video', videlUrl);
        }
      return '' ;
      } 
      
      function embedImage(img) 
      {  
        var range = quilleditor.getSelection();
        if(range){
          quilleditor.insertEmbed(range.index, 'image', img);
        }
        return '';
      } 
      
      
     function enableEditor(isEnabled) 
      {
        quilleditor.enable(isEnabled);
         return '';
      } 
      
      function setFormat(format,value){     
      if(format == 'clean'){
        var range = quilleditor.getSelection();
          if (range) {
            if (range.length == 0) {
             quilleditor.removeFormat(range.index,quilleditor.root.innerHTML.length);
            
            } else {
              quilleditor.removeFormat(range.index,range.length);
            }
          } else {
             quilleditor.format('clean');
          }
      }else{
      quilleditor.format(format,value);
      }
      return '';
       
      }
      </script>
      </body>
      </html>
     ''';
  }
}

///[QuillEditorController] controller constructor to generate editor, toolbar state keys
class QuillEditorController {
  GlobalKey<QuillHtmlEditorState>? _editorKey;
  GlobalKey<ToolBarState>? _toolBarKey;
  StreamController<String>? _changeController;

  ///[isEnable] to enable/ disable editor
  bool isEnable = true;

  ///[QuillEditorController] controller constructor to generate editor, toolbar state keys
  QuillEditorController() {
    _editorKey = GlobalKey<QuillHtmlEditorState>();
    _toolBarKey = GlobalKey<ToolBarState>();
    _changeController = StreamController<String>();
  }

  /// to access toolbar key from toolbar widget
  GlobalKey<ToolBarState>? get toolBarKey => _toolBarKey;

  /// [getText] method is used to get the html string from the editor
  /// To avoid getting empty html tags, we are validating the html string
  /// if it doesn't contain any text, the method will return empty string instead of empty html tag
  Future<String> getText() async {
    try {
      String? text = await _editorKey?.currentState?._getHtmlFromEditor();
      String parsedText = _stripHtmlIfNeeded(text!);
      if (parsedText.trim() == "") {
        return "";
      } else {
        return text;
      }
    } catch (e) {
      return "";
    }
  }

  /// [setText] method is used to set the html text to the editor
  /// it will override the existing text in the editor with the new one
  Future setText(String text) async {
    return await _editorKey?.currentState?._setHtmlTextToEditor(htmlText: text);
  }

  /// [embedVideo] method is used to embed url of video to the editor
  Future embedVideo(String text) async {
    return await _editorKey?.currentState?._embedVideo(videoUrl: text);
  }

  /// [embedImage] method is used to insert image to the editor
  Future embedImage(String imgSrc) async {
    return await _editorKey?.currentState?._embedImage(imgSrc: imgSrc);
  }

  /// [enableEditor] method is used to enable/ disable the editor,
  /// while, we can enable or disable the editor directly by passing isEnabled to the widget,
  /// this is an additional function that can be used to do the same with the state key
  /// We can choose either of these ways to enable/disable
  void enableEditor(bool enable) async {
    isEnable = enable;
    await _editorKey?.currentState?._enableTextEditor(isEnabled: enable);
  }

  /// [hasFocus]checks if the editor has focus, returns the selection string length
  Future<int> hasFocus() async {
    return (await _editorKey?.currentState?._getSelectionCount()) ?? 0;
  }

  /// [getSelectionRange] to get the text selection range from editor
  Future<dynamic> getSelectionRange() async {
    return await _editorKey?.currentState?._getSelectionRange();
  }

  /// [setSelectionRange] to select the text in the editor by index
  Future<dynamic> setSelectionRange(int index, int length) async {
    return await _editorKey?.currentState?._setSelectionRange(index, length);
  }

  /// This [clear] method is used to clear the editor
  void clear() async {
    await _editorKey?.currentState?._setHtmlTextToEditor(htmlText: '');
  }

  ///[setFormat]  sets the format to editor either by selection or by cursor position
  void setFormat({required String format, required dynamic value}) async {
    _editorKey?.currentState?._setFormat(format: format, value: value);
  }

  /// it is a regex method to remove the tags and replace them with empty space
  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  ///[onTextChanged] method is used to listen to editor text changes
  void onTextChanged(Function(String) data) {
    try {
      if (_changeController != null &&
          _changeController?.hasListener == false) {
        _changeController?.stream.listen((event) {
          data(event);
        });
      }
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e.toString());
      }
    }

    return;
  }

  ///[dispose] dispose function to close the stream
  void dispose() {
    _changeController?.close();
  }
}
