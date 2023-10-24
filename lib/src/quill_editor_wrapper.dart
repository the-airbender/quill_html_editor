import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quill_html_editor/src/utils/hex_color.dart';
import 'package:quill_html_editor/src/utils/string_util.dart';
import 'package:quill_html_editor/src/widgets/edit_table_drop_down.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/webviewx_plus.dart';

/// A typedef representing a loading builder function.
///
/// A [LoadingBuilder] is a function that takes a [BuildContext] as an argument
/// and returns a [Widget]. It is typically used in conjunction with asynchronous
/// operations or data fetching, allowing you to display a loading indicator or
/// any other UI element during the loading process.
typedef LoadingBuilder = Widget Function(BuildContext context);

///[QuillHtmlEditor] widget to display the quill editor,
class QuillHtmlEditor extends StatefulWidget {
  ///[QuillHtmlEditor] widget to display the quill editor,
  ///pass the controller to access the editor methods
  QuillHtmlEditor({
    this.text,
    required this.controller,
    required this.minHeight,
    this.isEnabled = true,
    this.onTextChanged,
    this.backgroundColor = Colors.white,
    this.hintText = 'Start typing something amazing',
    this.onFocusChanged,
    this.onEditorCreated,
    this.onSelectionChanged,
    this.padding = EdgeInsets.zero,
    this.hintTextPadding = EdgeInsets.zero,
    this.hintTextAlign = TextAlign.start,
    this.onEditorResized,
    this.onEditingComplete,
    this.ensureVisible = false,
    this.loadingBuilder,
    this.inputAction = InputAction.newline,
    this.autoFocus = false,
    this.textStyle = const TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: 20.0,
      color: Colors.black87,
      fontWeight: FontWeight.normal,
    ),
    this.hintTextStyle = const TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: 20.0,
      color: Colors.black87,
      fontWeight: FontWeight.normal,
    ),
  }) : super(key: controller._editorKey);

  /// [text] to set initial text to the editor, please use text
  /// We can also use the setText method for the same
  final String? text;

  /// [minHeight] to define the minimum height of the editor
  final double minHeight;

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

  /// [onEditingComplete] callback function that triggers on editing completed
  final Function(String)? onEditingComplete;

  ///[backgroundColor] to set the background color of the editor
  final Color backgroundColor;

  ///[onFocusChanged] method returns a boolean value, if the editor has focus,
  ///it will return true; if not, will return false
  final Function(bool)? onFocusChanged;

  ///[onSelectionChanged] method returns SelectionModel, which has index and
  ///length of the selected text
  final Function(SelectionModel)? onSelectionChanged;

  ///[onEditorResized] method returns height of the widget on resize,
  final Function(double)? onEditorResized;

  ///[onEditorCreated] a callback method triggered once the editor is created
  ///it will be called only once after editor is loaded completely
  final VoidCallback? onEditorCreated;

  ///[textStyle] optional style for the default editor text,
  ///while all fields in the style are not mapped;Some basic fields like,
  ///fontStyle, fontSize, color,fontWeight can be applied
  ///font family support is not available yet
  final TextStyle? textStyle;

  ///[padding] optional style to set padding to the editor's text,
  /// default padding will be EdgeInsets.zero
  final EdgeInsets? padding;

  ///[hintTextStyle] optional style for the hint text styepe,
  ///while all fields in the style are not mapped;Some basic fields like,
  ///fontStyle, fontSize, color,fontWeight can be applied
  ///font family support is not available yet
  final TextStyle? hintTextStyle;

  ///[hintTextAlign] optional style to align the editor's hint text
  /// default value is hintTextAlign.start
  final TextAlign? hintTextAlign;

  ///[hintTextPadding] optional style to set padding to the editor's text,
  /// default padding will be EdgeInsets.zero
  final EdgeInsets? hintTextPadding;

  /// [ensureVisible] by default it will be set to false, set it to true to
  /// make sure the focus area of the editor is visible.
  /// Note:  Please make sure to wrap the editor with SingleChildScrollView, to make the
  /// editor scrollable.
  final bool? ensureVisible;

  /// A builder function that provides a widget to display while the data is loading.
  ///
  /// The [loadingBuilder] is responsible for creating a widget that represents the
  /// loading state of the custom widget. It is called when the data is being fetched
  /// or processed, allowing you to display a loading indicator or any other UI element
  /// that indicates the ongoing operation.
  final LoadingBuilder? loadingBuilder;

  /// Represents an optional input action within a specific context.
  ///
  /// An instance of this class holds an optional [InputAction] value, which can be either
  /// [InputAction.newline] indicating a line break or [InputAction.send] indicating
  /// that the input content should be sent or submitted.
  final InputAction? inputAction;

  /// [autoFocus] Whether the widget should automatically request focus when it is inserted
  /// into the widget tree. If set to `true`, the widget will request focus
  /// immediately after being built and inserted into the tree. If set to `false`,
  /// it will not request focus automatically.
  ///
  /// The default value is `false`
  /// **Note** due to limitations of flutter webview at the moment, focus doesn't launch the keyboard in mobile, however, it will set the cursor at the end on focus.
  final bool? autoFocus;

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

  late double _currentHeight;
  bool _hasFocus = false;
  String _quillJsScript = '';
  late Future _loadScripts;
  late String _fontFamily;
  late String _encodedStyle;
  bool _editorLoaded = false;
  @override
  initState() {
    _loadScripts = rootBundle.loadString(
        'packages/quill_html_editor/assets/scripts/quill_2.0.0_4_min.js');
    _fontFamily = widget.textStyle?.fontFamily ?? 'Roboto';
    _encodedStyle = Uri.encodeFull(_fontFamily);
    isEnabled = widget.isEnabled;
    _currentHeight = widget.minHeight;

    super.initState();
  }

  @override
  void dispose() {
    _webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadScripts,
        builder: (context, snap) {
          if (snap.hasData) {
            _quillJsScript = snap.data!;
          }
          if (snap.connectionState == ConnectionState.done) {
            return LayoutBuilder(builder: (context, constraints) {
              _initialContent = _getQuillPage(width: constraints.maxWidth);
              return _buildEditorView(
                  context: context, width: constraints.maxWidth);
            });
          }

          if (widget.loadingBuilder != null) {
            return widget.loadingBuilder!(context);
          } else {
            return SizedBox(
              height: widget.minHeight,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 0.3,
                ),
              ),
            );
          }
        });
  }

  Widget _buildEditorView(
      {required BuildContext context, required double width}) {
    _initialContent = _getQuillPage(width: width);
    return Stack(
      children: [
        WebViewX(
          key: ValueKey(widget.controller.toolBarKey.hashCode.toString()),
          initialContent: _initialContent,
          initialSourceType: SourceType.html,
          height: _currentHeight,
          onPageStarted: (s) {
            _editorLoaded = false;
          },
          ignoreAllGestures: false,
          width: width,
          onWebViewCreated: (controller) => _webviewController = controller,
          onPageFinished: (src) {
            Future.delayed(const Duration(milliseconds: 100)).then((value) {
              _editorLoaded = true;
              debugPrint('_editorLoaded $_editorLoaded');
              if (mounted) {
                setState(() {});
              }
              widget.controller.enableEditor(isEnabled);
              if (widget.text != null) {
                _setHtmlTextToEditor(htmlText: widget.text!);
              }
              if (widget.autoFocus == true) {
                widget.controller.focus();
              }
              if (widget.onEditorCreated != null) {
                widget.onEditorCreated!();
              }
              widget.controller._editorLoadedController?.add('');
            });
          },
          dartCallBacks: {
            DartCallback(
                name: 'EditorResizeCallback',
                callBack: (height) {
                  if (_currentHeight == double.tryParse(height.toString())) {
                    return;
                  }
                  try {
                    _currentHeight =
                        double.tryParse(height.toString()) ?? widget.minHeight;
                  } catch (e) {
                    _currentHeight = widget.minHeight;
                  } finally {
                    if (mounted) {
                      setState(() => _currentHeight);
                    }
                    if (widget.onEditorResized != null) {
                      widget.onEditorResized!(_currentHeight);
                    }
                  }
                }),
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
                  var tempText = "";
                  if (tempText == map) {
                    return;
                  } else {
                    tempText = map;
                  }
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
                }),
            DartCallback(
                name: 'FocusChanged',
                callBack: (map) {
                  _hasFocus = map?.toString() == 'true';
                  if (widget.onFocusChanged != null) {
                    widget.onFocusChanged!(_hasFocus);
                  }

                  /// scrolls to the end of the text area, to keep the focus visible
                  if (widget.ensureVisible == true && _hasFocus) {
                    Scrollable.of(context).position.ensureVisible(
                        context.findRenderObject()!,
                        duration: const Duration(milliseconds: 300),
                        alignmentPolicy:
                            ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
                        curve: Curves.fastLinearToSlowEaseIn);
                  }
                }),
            DartCallback(
                name: 'OnEditingCompleted',
                callBack: (map) {
                  var tempText = "";
                  if (tempText == map) {
                    return;
                  } else {
                    tempText = map;
                  }
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
                      if (widget.onEditingComplete != null) {
                        widget.onEditingComplete!(finalText);
                      }
                      widget.controller._changeController!.add(finalText);
                    }
                  } catch (e) {
                    if (!kReleaseMode) {
                      debugPrint(e.toString());
                    }
                  }
                }),
            DartCallback(
                name: 'OnSelectionChanged',
                callBack: (selection) {
                  try {
                    if (widget.onSelectionChanged != null) {
                      if (!_hasFocus) {
                        if (widget.onFocusChanged != null) {
                          _hasFocus = true;
                          widget.onFocusChanged!(_hasFocus);
                        }
                      }
                      widget.onSelectionChanged!(selection != null
                          ? SelectionModel.fromJson(jsonDecode(selection))
                          : SelectionModel(index: 0, length: 0));
                    }
                  } catch (e) {
                    if (!kReleaseMode) {
                      debugPrint(e.toString());
                    }
                  }
                }),

            /// callback to notify once editor is completely loaded
            DartCallback(
                name: 'EditorLoaded',
                callBack: (map) {
                  _editorLoaded = true;
                  if (mounted) {
                    setState(() {});
                  }
                }),
          },
          webSpecificParams: const WebSpecificParams(
            printDebugInfo: false,
          ),
          mobileSpecificParams: const MobileSpecificParams(
            androidEnableHybridComposition: true,
          ),
        ),
        Visibility(
            visible: !_editorLoaded,
            child: widget.loadingBuilder != null
                ? widget.loadingBuilder!(context)
                : SizedBox(
                    height: widget.minHeight,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                      ),
                    ),
                  ))
      ],
    );
  }

  /// a private method to get the Html text from the editor
  Future<String> _getHtmlFromEditor() async {
    return await _webviewController.callJsMethod("getHtmlText", []);
  }

  /// a private method to get the Plain text from the editor
  Future<String> _getPlainTextFromEditor() async {
    return await _webviewController.callJsMethod("getPlainText", []);
  }

  /// a private method to get the delta  from the editor
  Future<String> _getDeltaFromEditor() async {
    return await _webviewController.callJsMethod("getDelta", []);
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
    return await _webviewController.callJsMethod("setHtmlText", [htmlText]);
  }

  /// a private method to set the Delta  text to the editor
  Future _setDeltaToEditor({required Map<dynamic, dynamic> deltaMap}) async {
    return await _webviewController
        .callJsMethod("setDeltaContent", [jsonEncode(deltaMap)]);
  }

  /// a private method to request focus to the editor
  Future _requestFocus() async {
    return await _webviewController.callJsMethod("requestFocus", []);
  }

  /// a private method to un focus the editor
  Future _unFocus() async {
    return await _webviewController.callJsMethod("unFocus", []);
  }

  /// a private method to insert the Html text to the editor
  Future _insertHtmlTextToEditor({required String htmlText, int? index}) async {
    return await _webviewController
        .callJsMethod("insertHtmlText", [htmlText, index]);
  }

  /// a private method to embed the video to the editor
  Future _embedVideo({required String videoUrl}) async {
    return await _webviewController.callJsMethod("embedVideo", [videoUrl]);
  }

  /// a private method to embed the image to the editor
  Future _embedImage({required String imgSrc}) async {
    return await _webviewController.callJsMethod("embedImage", [imgSrc]);
  }

  /// a private method to enable/disable the editor
  Future _enableTextEditor({required bool isEnabled}) async {
    return await _webviewController.callJsMethod("enableEditor", [isEnabled]);
  }

  /// a private method to enable/disable the editor
  Future _setFormat({required String format, required dynamic value}) async {
    try {
      return await _webviewController
          .callJsMethod("setFormat", [format, value]);
    } catch (e) {
      _printWrapper(false, e.toString());
    }
  }

  /// a private method to insert table by row and column to the editor
  Future _insertTableToEditor({required int row, required int column}) async {
    return await _webviewController.callJsMethod("insertTable", [row, column]);
  }

  /// a private method to add remove or delete table in the editor
  Future _modifyTable(EditTableEnum type) async {
    return await _webviewController
        .callJsMethod("modifyTable", [describeEnum(type)]);
  }

  /// a private method to replace selection text in the editor
  Future _replaceText(
    String replaceText,
  ) async {
    return await _webviewController
        .callJsMethod("replaceSelection", [replaceText]);
  }

  /// a private method to get the selected text from editor
  Future _getSelectedText() async {
    return await _webviewController.callJsMethod("getSelectedText", []);
  }

  /// a private method to get the selected html text from editor
  Future _getSelectedHtmlText() async {
    return await _webviewController.callJsMethod("getSelectionHtml", []);
  }

  /// a private method to undo the history
  Future _undo() async {
    return await _webviewController.callJsMethod("undo", []);
  }

  /// a private method to redo the history
  Future _redo() async {
    return await _webviewController.callJsMethod("redo", []);
  }

  /// a private method to clear the history stack
  Future _clearHistory() async {
    return await _webviewController.callJsMethod("clearHistory", []);
  }

  /// This method generated the html code that is required to render the quill js editor
  /// We are rendering this html page with the help of webviewx and using the callbacks to call the quill js apis
  String _getQuillPage({required double width}) {
    return '''
   <!DOCTYPE html>
        <html>
        <head>
        <link href="https://fonts.googleapis.com/css?family=$_encodedStyle:400,400i,700,700i" rel="stylesheet">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">    
        
       <!-- Include the Quill library --> 
        <script>
        $_quillJsScript
        </script>
        <style>
        /*!
       * Quill Editor v2.0.0-dev.3
       * https://quilljs.com/
       * Copyright (c) 2014, Jason Chen
       * Copyright (c) 2013, salesforce.com
       */.ql-container{box-sizing:border-box;font-family:Helvetica,Arial,sans-serif;font-size:13px;height:100%;margin:0;position:relative}.ql-container.ql-disabled .ql-tooltip{visibility:hidden}.ql-container:not(.ql-disabled) li[data-list=checked]>.ql-ui,.ql-container:not(.ql-disabled) li[data-list=unchecked]>.ql-ui{cursor:pointer}.ql-clipboard{left:-100000px;height:1px;overflow-y:hidden;position:absolute;top:50%}.ql-clipboard p{margin:0;padding:0}.ql-editor{box-sizing:border-box;counter-reset:list-0;line-height:1.42;height:100%;outline:0;overflow-y:auto;padding:12px 15px;tab-size:4;-moz-tab-size:4;text-align:left;white-space:pre-wrap;word-wrap:break-word}.ql-editor>*{cursor:text}.ql-editor blockquote,.ql-editor h1,.ql-editor h2,.ql-editor h3,.ql-editor h4,.ql-editor h5,.ql-editor h6,.ql-editor ol,.ql-editor p,.ql-editor pre{margin:0;padding:0}.ql-editor h1,.ql-editor h2,.ql-editor h3,.ql-editor h4,.ql-editor h5,.ql-editor h6,.ql-editor p{counter-reset:list-0 list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor table{border-collapse:collapse}.ql-editor td{border:1px solid #000;padding:2px 5px}.ql-editor ol{padding-left:1.5em}.ql-editor li{list-style-type:none;padding-left:1.5em;position:relative}.ql-editor li>.ql-ui:before{display:inline-block;margin-left:-1.5em;margin-right:.3em;text-align:right;white-space:nowrap;width:1.2em}.ql-editor li[data-list=checked]>.ql-ui,.ql-editor li[data-list=unchecked]>.ql-ui{color:#777}.ql-editor li[data-list=bullet]>.ql-ui:before{content:'\\2022'}.ql-editor li[data-list=checked]>.ql-ui:before{content:'\\2611'}.ql-editor li[data-list=unchecked]>.ql-ui:before{content:'\\2610'}.ql-editor li[data-list=ordered]{counter-reset:list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9;counter-increment:list-0}.ql-editor li[data-list=ordered]>.ql-ui:before{content:counter(list-0,decimal) '. '}.ql-editor li[data-list=ordered].ql-indent-1{counter-increment:list-1}.ql-editor li[data-list=ordered].ql-indent-1>.ql-ui:before{content:counter(list-1,lower-alpha) '. '}.ql-editor li[data-list=ordered].ql-indent-1{counter-reset:list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-2{counter-increment:list-2}.ql-editor li[data-list=ordered].ql-indent-2>.ql-ui:before{content:counter(list-2,lower-roman) '. '}.ql-editor li[data-list=ordered].ql-indent-2{counter-reset:list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-3{counter-increment:list-3}.ql-editor li[data-list=ordered].ql-indent-3>.ql-ui:before{content:counter(list-3,decimal) '. '}.ql-editor li[data-list=ordered].ql-indent-3{counter-reset:list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-4{counter-increment:list-4}.ql-editor li[data-list=ordered].ql-indent-4>.ql-ui:before{content:counter(list-4,lower-alpha) '. '}.ql-editor li[data-list=ordered].ql-indent-4{counter-reset:list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-5{counter-increment:list-5}.ql-editor li[data-list=ordered].ql-indent-5>.ql-ui:before{content:counter(list-5,lower-roman) '. '}.ql-editor li[data-list=ordered].ql-indent-5{counter-reset:list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-6{counter-increment:list-6}.ql-editor li[data-list=ordered].ql-indent-6>.ql-ui:before{content:counter(list-6,decimal) '. '}.ql-editor li[data-list=ordered].ql-indent-6{counter-reset:list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-7{counter-increment:list-7}.ql-editor li[data-list=ordered].ql-indent-7>.ql-ui:before{content:counter(list-7,lower-alpha) '. '}.ql-editor li[data-list=ordered].ql-indent-7{counter-reset:list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-8{counter-increment:list-8}.ql-editor li[data-list=ordered].ql-indent-8>.ql-ui:before{content:counter(list-8,lower-roman) '. '}.ql-editor li[data-list=ordered].ql-indent-8{counter-reset:list-9}.ql-editor li[data-list=ordered].ql-indent-9{counter-increment:list-9}.ql-editor li[data-list=ordered].ql-indent-9>.ql-ui:before{content:counter(list-9,decimal) '. '}.ql-editor .ql-indent-1:not(.ql-direction-rtl){padding-left:3em}.ql-editor li.ql-indent-1:not(.ql-direction-rtl){padding-left:4.5em}.ql-editor .ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:3em}.ql-editor li.ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:4.5em}.ql-editor .ql-indent-2:not(.ql-direction-rtl){padding-left:6em}.ql-editor li.ql-indent-2:not(.ql-direction-rtl){padding-left:7.5em}.ql-editor .ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:6em}.ql-editor li.ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:7.5em}.ql-editor .ql-indent-3:not(.ql-direction-rtl){padding-left:9em}.ql-editor li.ql-indent-3:not(.ql-direction-rtl){padding-left:10.5em}.ql-editor .ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:9em}.ql-editor li.ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:10.5em}.ql-editor .ql-indent-4:not(.ql-direction-rtl){padding-left:12em}.ql-editor li.ql-indent-4:not(.ql-direction-rtl){padding-left:13.5em}.ql-editor .ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:12em}.ql-editor li.ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:13.5em}.ql-editor .ql-indent-5:not(.ql-direction-rtl){padding-left:15em}.ql-editor li.ql-indent-5:not(.ql-direction-rtl){padding-left:16.5em}.ql-editor .ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:15em}.ql-editor li.ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:16.5em}.ql-editor .ql-indent-6:not(.ql-direction-rtl){padding-left:18em}.ql-editor li.ql-indent-6:not(.ql-direction-rtl){padding-left:19.5em}.ql-editor .ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:18em}.ql-editor li.ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:19.5em}.ql-editor .ql-indent-7:not(.ql-direction-rtl){padding-left:21em}.ql-editor li.ql-indent-7:not(.ql-direction-rtl){padding-left:22.5em}.ql-editor .ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:21em}.ql-editor li.ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:22.5em}.ql-editor .ql-indent-8:not(.ql-direction-rtl){padding-left:24em}.ql-editor li.ql-indent-8:not(.ql-direction-rtl){padding-left:25.5em}.ql-editor .ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:24em}.ql-editor li.ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:25.5em}.ql-editor .ql-indent-9:not(.ql-direction-rtl){padding-left:27em}.ql-editor li.ql-indent-9:not(.ql-direction-rtl){padding-left:28.5em}.ql-editor .ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:27em}.ql-editor li.ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:28.5em}.ql-editor li.ql-direction-rtl{padding-right:1.5em}.ql-editor li.ql-direction-rtl>.ql-ui:before{margin-left:.3em;margin-right:-1.5em;text-align:left}.ql-editor table{table-layout:fixed;width:100%}.ql-editor table td{outline:0}.ql-editor .ql-code-block-container{font-family:monospace}.ql-editor .ql-video{display:block;max-width:100%}.ql-editor .ql-video.ql-align-center{margin:0 auto}.ql-editor .ql-video.ql-align-right{margin:0 0 0 auto}.ql-editor .ql-bg-black{background-color:#000}.ql-editor .ql-bg-red{background-color:#e60000}.ql-editor .ql-bg-orange{background-color:#f90}.ql-editor .ql-bg-yellow{background-color:#ff0}.ql-editor .ql-bg-green{background-color:#008a00}.ql-editor .ql-bg-blue{background-color:#06c}.ql-editor .ql-bg-purple{background-color:#93f}.ql-editor .ql-color-white{color:#fff}.ql-editor .ql-color-red{color:#e60000}.ql-editor .ql-color-orange{color:#f90}.ql-editor .ql-color-yellow{color:#ff0}.ql-editor .ql-color-green{color:#008a00}.ql-editor .ql-color-blue{color:#06c}.ql-editor .ql-color-purple{color:#93f}.ql-editor .ql-font-serif{font-family:Georgia,Times New Roman,serif}.ql-editor .ql-font-monospace{font-family:Monaco,Courier New,monospace}.ql-editor .ql-size-small{font-size:.75em}.ql-editor .ql-size-large{font-size:1.5em}.ql-editor .ql-size-huge{font-size:2.5em}.ql-editor .ql-direction-rtl{direction:rtl;text-align:inherit}.ql-editor .ql-align-center{text-align:center}.ql-editor .ql-align-justify{text-align:justify}.ql-editor .ql-align-right{text-align:right}.ql-editor .ql-ui{position:absolute}.ql-editor.ql-blank::before{color:rgba(0,0,0,.6);content:attr(data-placeholder);font-style:italic;left:15px;pointer-events:none;position:absolute;right:15px}.ql-snow .ql-toolbar:after,.ql-snow.ql-toolbar:after{clear:both;content:'';display:table}.ql-snow .ql-toolbar button,.ql-snow.ql-toolbar button{background:0 0;border:none;cursor:pointer;display:inline-block;float:left;height:24px;padding:3px 5px;width:28px}.ql-snow .ql-toolbar button svg,.ql-snow.ql-toolbar button svg{float:left;height:100%}.ql-snow .ql-toolbar button:active:hover,.ql-snow.ql-toolbar button:active:hover{outline:0}.ql-snow .ql-toolbar input.ql-image[type=file],.ql-snow.ql-toolbar input.ql-image[type=file]{display:none}.ql-snow .ql-toolbar .ql-picker-item.ql-selected,.ql-snow .ql-toolbar .ql-picker-item:hover,.ql-snow .ql-toolbar .ql-picker-label.ql-active,.ql-snow .ql-toolbar .ql-picker-label:hover,.ql-snow .ql-toolbar button.ql-active,.ql-snow .ql-toolbar button:focus,.ql-snow .ql-toolbar button:hover,.ql-snow.ql-toolbar .ql-picker-item.ql-selected,.ql-snow.ql-toolbar .ql-picker-item:hover,.ql-snow.ql-toolbar .ql-picker-label.ql-active,.ql-snow.ql-toolbar .ql-picker-label:hover,.ql-snow.ql-toolbar button.ql-active,.ql-snow.ql-toolbar button:focus,.ql-snow.ql-toolbar button:hover{color:#06c}.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-fill,.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-stroke.ql-fill,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-fill,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-stroke.ql-fill,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-fill,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-stroke.ql-fill,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-fill,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-stroke.ql-fill,.ql-snow .ql-toolbar button.ql-active .ql-fill,.ql-snow .ql-toolbar button.ql-active .ql-stroke.ql-fill,.ql-snow .ql-toolbar button:focus .ql-fill,.ql-snow .ql-toolbar button:focus .ql-stroke.ql-fill,.ql-snow .ql-toolbar button:hover .ql-fill,.ql-snow .ql-toolbar button:hover .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-fill,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-fill,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-fill,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-fill,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-stroke.ql-fill,.ql-snow.ql-toolbar button.ql-active .ql-fill,.ql-snow.ql-toolbar button.ql-active .ql-stroke.ql-fill,.ql-snow.ql-toolbar button:focus .ql-fill,.ql-snow.ql-toolbar button:focus .ql-stroke.ql-fill,.ql-snow.ql-toolbar button:hover .ql-fill,.ql-snow.ql-toolbar button:hover .ql-stroke.ql-fill{fill:#06c}.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-stroke,.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-stroke-miter,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-stroke,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-stroke-miter,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-stroke,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-stroke-miter,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-stroke,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-stroke-miter,.ql-snow .ql-toolbar button.ql-active .ql-stroke,.ql-snow .ql-toolbar button.ql-active .ql-stroke-miter,.ql-snow .ql-toolbar button:focus .ql-stroke,.ql-snow .ql-toolbar button:focus .ql-stroke-miter,.ql-snow .ql-toolbar button:hover .ql-stroke,.ql-snow .ql-toolbar button:hover .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-stroke,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-stroke,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-stroke,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-stroke,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-stroke-miter,.ql-snow.ql-toolbar button.ql-active .ql-stroke,.ql-snow.ql-toolbar button.ql-active .ql-stroke-miter,.ql-snow.ql-toolbar button:focus .ql-stroke,.ql-snow.ql-toolbar button:focus .ql-stroke-miter,.ql-snow.ql-toolbar button:hover .ql-stroke,.ql-snow.ql-toolbar button:hover .ql-stroke-miter{stroke:#06c}@media (pointer:coarse){.ql-snow .ql-toolbar button:hover:not(.ql-active),.ql-snow.ql-toolbar button:hover:not(.ql-active){color:#444}.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-fill,.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-stroke.ql-fill,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-fill,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-stroke.ql-fill{fill:#444}.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-stroke,.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-stroke-miter,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-stroke,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-stroke-miter{stroke:#444}}.ql-snow{box-sizing:border-box}.ql-snow *{box-sizing:border-box}.ql-snow .ql-hidden{display:none}.ql-snow .ql-out-bottom,.ql-snow .ql-out-top{visibility:hidden}.ql-snow .ql-tooltip{position:absolute;transform:translateY(10px)}.ql-snow .ql-tooltip a{cursor:pointer;text-decoration:none}.ql-snow .ql-tooltip.ql-flip{transform:translateY(-10px)}.ql-snow .ql-formats{display:inline-block;vertical-align:middle}.ql-snow .ql-formats:after{clear:both;content:'';display:table}.ql-snow .ql-stroke{fill:none;stroke:#444;stroke-linecap:round;stroke-linejoin:round;stroke-width:2}.ql-snow .ql-stroke-miter{fill:none;stroke:#444;stroke-miterlimit:10;stroke-width:2}.ql-snow .ql-fill,.ql-snow .ql-stroke.ql-fill{fill:#444}.ql-snow .ql-empty{fill:none}.ql-snow .ql-even{fill-rule:evenodd}.ql-snow .ql-stroke.ql-thin,.ql-snow .ql-thin{stroke-width:1}.ql-snow .ql-transparent{opacity:.4}.ql-snow .ql-direction svg:last-child{display:none}.ql-snow .ql-direction.ql-active svg:last-child{display:inline}.ql-snow .ql-direction.ql-active svg:first-child{display:none}.ql-snow .ql-editor h1{font-size:2em}.ql-snow .ql-editor h2{font-size:1.5em}.ql-snow .ql-editor h3{font-size:1.17em}.ql-snow .ql-editor h4{font-size:1em}.ql-snow .ql-editor h5{font-size:.83em}.ql-snow .ql-editor h6{font-size:.67em}.ql-snow .ql-editor a{text-decoration:underline}.ql-snow .ql-editor blockquote{border-left:4px solid #ccc;margin-bottom:5px;margin-top:5px;padding-left:16px}.ql-snow .ql-editor .ql-code-block-container,.ql-snow .ql-editor code{background-color:#f0f0f0;border-radius:3px}.ql-snow .ql-editor .ql-code-block-container{margin-bottom:5px;margin-top:5px;padding:5px 10px}.ql-snow .ql-editor code{font-size:85%;padding:2px 4px}.ql-snow .ql-editor .ql-code-block-container{background-color:#23241f;color:#f8f8f2;overflow:visible}.ql-snow .ql-editor img{max-width:100%}.ql-snow .ql-picker{color:#444;display:inline-block;float:left;font-size:14px;font-weight:500;height:24px;position:relative;vertical-align:middle}.ql-snow .ql-picker-label{cursor:pointer;display:inline-block;height:100%;padding-left:8px;padding-right:2px;position:relative;width:100%}.ql-snow .ql-picker-label::before{display:inline-block;line-height:22px}.ql-snow .ql-picker-options{background-color:#fff;display:none;min-width:100%;padding:4px 8px;position:absolute;white-space:nowrap}.ql-snow .ql-picker-options .ql-picker-item{cursor:pointer;display:block;padding-bottom:5px;padding-top:5px}.ql-snow .ql-picker.ql-expanded .ql-picker-label{color:#ccc;z-index:2}.ql-snow .ql-picker.ql-expanded .ql-picker-label .ql-fill{fill:#ccc}.ql-snow .ql-picker.ql-expanded .ql-picker-label .ql-stroke{stroke:#ccc}.ql-snow .ql-picker.ql-expanded .ql-picker-options{display:block;margin-top:-1px;top:100%;z-index:1}.ql-snow .ql-color-picker,.ql-snow .ql-icon-picker{width:28px}.ql-snow .ql-color-picker .ql-picker-label,.ql-snow .ql-icon-picker .ql-picker-label{padding:2px 4px}.ql-snow .ql-color-picker .ql-picker-label svg,.ql-snow .ql-icon-picker .ql-picker-label svg{right:4px}.ql-snow .ql-icon-picker .ql-picker-options{padding:4px 0}.ql-snow .ql-icon-picker .ql-picker-item{height:24px;width:24px;padding:2px 4px}.ql-snow .ql-color-picker .ql-picker-options{padding:3px 5px;width:152px}.ql-snow .ql-color-picker .ql-picker-item{border:1px solid transparent;float:left;height:16px;margin:2px;padding:0;width:16px}.ql-snow .ql-picker:not(.ql-color-picker):not(.ql-icon-picker) svg{position:absolute;margin-top:-9px;right:0;top:50%;width:18px}.ql-snow .ql-picker.ql-font .ql-picker-item[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-font .ql-picker-label[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-header .ql-picker-item[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-size .ql-picker-item[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-label]:not([data-label=''])::before{content:attr(data-label)}.ql-snow .ql-picker.ql-header{width:98px}.ql-snow .ql-picker.ql-header .ql-picker-item::before,.ql-snow .ql-picker.ql-header .ql-picker-label::before{content:'Normal'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before{content:'Heading 1'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before{content:'Heading 2'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before{content:'Heading 3'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before{content:'Heading 4'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before{content:'Heading 5'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before{content:'Heading 6'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before{font-size:2em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before{font-size:1.5em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before{font-size:1.17em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before{font-size:1em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before{font-size:.83em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before{font-size:.67em}.ql-snow .ql-picker.ql-font{width:108px}.ql-snow .ql-picker.ql-font .ql-picker-item::before,.ql-snow .ql-picker.ql-font .ql-picker-label::before{content:'Sans Serif'}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=serif]::before,.ql-snow .ql-picker.ql-font .ql-picker-label[data-value=serif]::before{content:'Serif'}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=monospace]::before,.ql-snow .ql-picker.ql-font .ql-picker-label[data-value=monospace]::before{content:'Monospace'}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=serif]::before{font-family:Georgia,Times New Roman,serif}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=monospace]::before{font-family:Monaco,Courier New,monospace}.ql-snow .ql-picker.ql-size{width:98px}.ql-snow .ql-picker.ql-size .ql-picker-item::before,.ql-snow .ql-picker.ql-size .ql-picker-label::before{content:'Normal'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=small]::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=small]::before{content:'Small'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=large]::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=large]::before{content:'Large'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=huge]::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=huge]::before{content:'Huge'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=small]::before{font-size:10px}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=large]::before{font-size:18px}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=huge]::before{font-size:32px}.ql-snow .ql-color-picker.ql-background .ql-picker-item{background-color:#fff}.ql-snow .ql-color-picker.ql-color .ql-picker-item{background-color:#000}.ql-code-block-container{position:relative}.ql-code-block-container .ql-ui{right:5px;top:5px}.ql-toolbar.ql-snow{border:1px solid #ccc;box-sizing:border-box;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;padding:8px}.ql-toolbar.ql-snow .ql-formats{margin-right:15px}.ql-toolbar.ql-snow .ql-picker-label{border:1px solid transparent}.ql-toolbar.ql-snow .ql-picker-options{border:1px solid transparent;box-shadow:rgba(0,0,0,.2) 0 2px 8px}.ql-toolbar.ql-snow .ql-picker.ql-expanded .ql-picker-label{border-color:#ccc}.ql-toolbar.ql-snow .ql-picker.ql-expanded .ql-picker-options{border-color:#ccc}.ql-toolbar.ql-snow .ql-color-picker .ql-picker-item.ql-selected,.ql-toolbar.ql-snow .ql-color-picker .ql-picker-item:hover{border-color:#000}.ql-toolbar.ql-snow+.ql-container.ql-snow{border-top:0}.ql-snow .ql-tooltip{background-color:#fff;border:1px solid #ccc;box-shadow:0 0 5px #ddd;color:#444;padding:5px 12px;white-space:nowrap}.ql-snow .ql-tooltip::before{content:"Visit URL:";line-height:26px;margin-right:8px}.ql-snow .ql-tooltip input[type=text]{display:none;border:1px solid #ccc;font-size:13px;height:26px;margin:0;padding:3px 5px;width:170px}.ql-snow .ql-tooltip a.ql-preview{display:inline-block;max-width:200px;overflow-x:hidden;text-overflow:ellipsis;vertical-align:top}.ql-snow .ql-tooltip a.ql-action::after{border-right:1px solid #ccc;content:'Edit';margin-left:16px;padding-right:8px}.ql-snow .ql-tooltip a.ql-remove::before{content:'Remove';margin-left:8px}.ql-snow .ql-tooltip a{line-height:26px}.ql-snow .ql-tooltip.ql-editing a.ql-preview,.ql-snow .ql-tooltip.ql-editing a.ql-remove{display:none}.ql-snow .ql-tooltip.ql-editing input[type=text]{display:inline-block}.ql-snow .ql-tooltip.ql-editing a.ql-action::after{border-right:0;content:'Save';padding-right:0}.ql-snow .ql-tooltip[data-mode=link]::before{content:"Enter link:"}.ql-snow .ql-tooltip[data-mode=formula]::before{content:"Enter formula:"}.ql-snow .ql-tooltip[data-mode=video]::before{content:"Enter video:"}.ql-snow a{color:#06c}.ql-container.ql-snow{border:1px solid #ccc}
        
        body, html{
         font-family: "$_fontFamily", sans-serif !important;
        -webkit-user-select: text !important;
        margin:0px !important;
        background-color:${widget.backgroundColor.toRGBA()};
        color: ${widget.backgroundColor.toRGBA()};
        }
        .ql-font-roboto {
           font-family: '$_fontFamily', sans-serif;
          }
        .ql-editor.ql-blank::before{
         font-family: "$_fontFamily", sans-serif !important;
        -webkit-user-select: text !important;
          padding-left:${widget.hintTextPadding?.left ?? '0'}px !important;
          padding-right:${widget.hintTextPadding?.right ?? '0'}px !important;
          padding-top:${widget.hintTextPadding?.top ?? '0'}px !important;
          padding-bottom:${widget.hintTextPadding?.bottom ?? '0'}px !important;
          position: center;
          left:0px;
          text-align: ${StringUtil.getCssTextAlign(widget.hintTextAlign)};
          font-size: ${widget.hintTextStyle?.fontSize ?? '14'}px;
          color:${(widget.hintTextStyle?.color ?? Colors.black).toRGBA()};
          background-color:${widget.backgroundColor.toRGBA()};
          font-style: ${StringUtil.getCssFontStyle(widget.hintTextStyle?.fontStyle)};
          font-weight: ${StringUtil.getCssFontWeight(widget.hintTextStyle?.fontWeight)};
          
        }
        .ql-container.ql-snow{
         font-family: "$_fontFamily", sans-serif !important;
        -webkit-user-select: text !important;
          white-space:nowrap !important;
          margin-top:0px !important;
          margin-bottom:0px !important;
          margin:0px !important;
          width:100%;
          border:none;
          font-style: ${StringUtil.getCssFontStyle(widget.textStyle?.fontStyle)};
          font-size: ${widget.textStyle?.fontSize ?? '14'}px;
          color:${(widget.textStyle!.color ?? Colors.black).toRGBA()};
          background-color:${widget.backgroundColor.toRGBA()};
          font-weight: ${StringUtil.getCssFontWeight(widget.textStyle?.fontWeight)};
          padding-left:${widget.padding?.left ?? '0'}px;
          padding-right:${widget.padding?.right ?? '0'}px;
          padding-top:${widget.padding?.top ?? '0'}px;
          padding-bottom:${widget.padding?.bottom ?? '0'}px;
          min-height:100%;
        
          contenteditable: true !important;
          data-gramm: false !important;
         
        }
        .ql-editor { 
         font-family: "$_fontFamily", sans-serif !important;
          -webkit-user-select: text !important;
          padding-left:${widget.padding?.left ?? '0'}px !important;
          padding-right:${widget.padding?.right ?? '0'}px !important;
          padding-top:${widget.padding?.top ?? '0'}px !important;
          padding-bottom:${widget.padding?.bottom ?? '0'}px !important;
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
        
        .ql-editor.ql-blank:focus::before {
          content: '';
          }
        #toolbar-container{
         display:none;
        }     
        #scrolling-container {  
        overflow-y: scroll  !important;
          min-height: ${widget.minHeight}px !important;
          -webkit-user-select: text !important;
           scrollbar-width: none !important; 
         } 
         #scroll-container::-webkit-scrollbar {
            display: none !important; /* For Chrome, Safari, and Opera */
          }
         ::-webkit-scrollbar {
          width: 0;  /* Remove scrollbar space */
          background: transparent;  /* Optional: just make scrollbar invisible */
          } 
        </style>
   
        </head>
        <body>
         <script>
           const resizeObserver = new ResizeObserver(entries =>{
            ///console.log("Offset height has changed:", (entries[0].target.clientHeight).toString())
                if($kIsWeb) {
                  EditorResizeCallback((entries[0].target.clientHeight).toString());
                } else {
                  EditorResizeCallback.postMessage((entries[0].target.clientHeight).toString());
                }            
            })
            resizeObserver.observe(document.body)
          </script>
         <script>
          let isTextSelectionInProgress = false;

          // Event handler for text selection start
          function handleTextSelectionStart() {
              isTextSelectionInProgress = true;
             // console.log("Text selection started.");
          }
  
          // Event handler for text selection end
          function handleTextSelectionEnd() {
              isTextSelectionInProgress = false;
             // console.log("Text selection ended.");
          }
  
          // Check if text is being selected while dragging the mouse
          function handleMouseMove(event) {
              if (isTextSelectionInProgress) {
                  // Do something when the text is being selected (dragging the mouse while text is selected)
                  window.getSelection();
              }
          }
  
          // Attach event listeners
          document.addEventListener("mousedown", handleTextSelectionStart);
          document.addEventListener("mouseup", handleTextSelectionEnd);
          document.addEventListener("mousemove", handleMouseMove);
         
         </script> 
        <!-- Create the toolbar container -->
        <div id="scrolling-container">
        <div id="toolbar-container"></div>
        
        <!-- Create the editor container -->
        <div style="position:relative;margin-top:0em;">
        <div id="editorcontainer" style= "min-height:${widget.minHeight}px;margin-top:0em;">
        <div id="editor" style="min-height:${widget.minHeight}px; width:100%;"></div>
        </div>
        </div> 
        </div>
      
        <!-- Initialize Quill editor -->
        <script>
      
            let fullWindowHeight = window.innerHeight;
            let keyboardIsProbablyOpen = false;
            window.addEventListener("resize", function() {
              if(window.innerHeight == fullWindowHeight) {
                keyboardIsProbablyOpen = false;
              } else if(window.innerHeight < fullWindowHeight * 0.9) {
                keyboardIsProbablyOpen = true;
              }
            });
            
            function resizeElementHeight(element, ratio) {
              var height = 0;
              var body = window.document.body;
              if(window.innerHeight) {
                height = window.innerHeight;
              } else if(body.parentElement.clientHeight) {
                height = body.parentElement.clientHeight;
              } else if(body && body.clientHeight) {
                height = body.clientHeight;
              }
              let isIOS = /iPad|iPhone|iPod/.test(navigator.platform) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)
              if(isIOS) {
                element.style.height = ((height / ratio - element.offsetTop) + "px");
              } else {
                element.style.height = ((height - element.offsetTop) + "px");
              }  
            }
            
            
          function replaceSelection(replaceText) {
              try{
              var range = quilleditor.getSelection(true);
                    if (range) {
                      if (range.length == 0) {
                       // console.log('User cursor is at index', range.index);
                      } else {
                       quilleditor.deleteText(range.index, range.length);
                       quilleditor.insertText(range.index, replaceText);
                      
                      /// replace text with format will be coming in future release
                      /// quilleditor.insertText(range.index, replaceText, JSON.parse(format));
                      }
                    } else {
                     // console.log('User cursor is not in editor');
                    }
                }
                 catch(e) {
                    console.log('replaceSelection', e);
                 } 
            }
            // Retrieve the Quill editor container element by its ID
            var quillContainer = document.getElementById('scrolling-container');
            
            // Add the focusout event listener to the Quill editor container
            quillContainer.addEventListener('focusout', function() {
                 if($kIsWeb) {
                FocusChanged(false);
              } else {
                FocusChanged.postMessage(false);
              }
            });
            
             quillContainer.addEventListener('focusin', () => {
               if($kIsWeb) {
                FocusChanged(true);
              } else {
                FocusChanged.postMessage(true);
              }
             })
             quillContainer.addEventListener('click', function() {
              quilleditor.focus(); // Set focus on the Quill editor
              });
             
             /*quilleditor.root.addEventListener("blur", function() {
               if($kIsWeb) {
                FocusChanged(false);
                } else {
                var focus  = quilleditor.hasFocus();
                  FocusChanged.postMessage(isQuillFocused());
                }
            });
            
            quilleditor.root.addEventListener("focus", function() {
               if($kIsWeb) {
                FocusChanged(true);
              } else {
              var focus  = quilleditor.hasFocus();
                FocusChanged.postMessage(isQuillFocused());
              }
            });*/
            
            function isQuillFocused() {
                // Retrieve the Quill editor container element by its ID
                var quillContainer = document.getElementById('scrolling-container');
              
                // Check if the Quill editor container or any of its descendants have focus
                return quillContainer.contains(document.activeElement);
              }
            
            function getSelectedText() {
            let text = '';
              try{
                var range = quilleditor.getSelection(true);
                    if (range) {
                      if (range.length == 0) {
                       // console.log('User cursor is at index', range.index);
                      } else {
                         text = quilleditor.getText(range.index, range.length);
                      }
                    } else {
                    //  console.log('User cursor is not in editor');
                    }
                }
                 catch(e) {
                    console.log('getSelectedText', e);
                  } 
                return text;  
            }
              
         
            function applyGoogleKeyboardWorkaround(editor) {
              try {
              
                let isIOS = /iPad|iPhone|iPod/.test(navigator.platform) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)

                if($kIsWeb || isIOS){
                  return;
                }
                if(editor.applyGoogleKeyboardWorkaround) {
                  return
                }
                editor.applyGoogleKeyboardWorkaround = true
                editor.on('editor-change', function(eventName, ...args) {
                  
                    // args[0] will be delta
                    var ops = args[0]['ops']
                    if(ops === null) {
                      return
                    }
                    var oldSelection = editor.getSelection(true)
                    var oldPos = oldSelection.index
                    var oldSelectionLength = oldSelection.length
                    if( ops[0]["retain"] === undefined || !ops[1] || !ops[1]["insert"] || !ops[1]["insert"] || ops[1]["list"] === "bullet" || ops[1]["list"] === "ordered" || ops[1]["insert"] != "\\n" || oldSelectionLength > 0) {
                      return
                    }
                 
                    setTimeout(function() {
                      var newPos = editor.getSelection(true).index
                      if(newPos === oldPos) {
                      console.log('newPos oldPos');
                        editor.setSelection(editor.getSelection(true).index + 1, 0)
                      }
                    }, 30);
                    //onRangeChanged();
                 
                });
              } catch(e) {
                console.log('applyGoogleKeyboardWorkaround', e);
              } 
            }
            
            /// observer to listen to the editor div changes 
            // select the target node
            var target = document.querySelector('#editor');
            
            // create an observer instance
            var tempText = "";
            var observer = new MutationObserver(function(mutations) {
                 var text = quilleditor.root.innerHTML; 
                 if(text != tempText){
                      tempText = text;
                     if($kIsWeb) {
                      OnTextChanged(text);
                    } else {
                      OnTextChanged.postMessage(text);
                    }
                     onRangeChanged(); 
                     quilleditor.focus();
                 }
            });

            // configuration of the observer:
            var config = { attributes: true, childList: true, characterData: true, subtree: true };

            // pass in the target node, as well as the observer options
            observer.observe(target, config);
    
           // stops the listener
           //// observer.disconnect();
          
        
           //// to accept all link formats 
           var Link = Quill.import('formats/link');
              Link.sanitize = function(url) {
                // modify url if desired
                return url;
              }
             Quill.register(Link, true);
           
            /// quill custom font import
            var FontStyle = Quill.import('attributors/class/font');
            Quill.register(FontStyle, true);
            
            const Inline = Quill.import('blots/inline');
            class RequirementBlot extends Inline {}
            RequirementBlot.blotName = 'requirement';
            RequirementBlot.tagName = 'requirement';
            Quill.register(RequirementBlot);
            
            class ResponsibilityBlot extends Inline {}
            ResponsibilityBlot.blotName = 'responsibility';
            ResponsibilityBlot.tagName = 'responsibility';
            Quill.register(ResponsibilityBlot);
            
             ///// quill shift enter key binding      
              var bindings = {
                  linebreak: {
                      key: 13,
                      shiftKey: true,
                      handler: function(range) {
                          this.quill.insertEmbed(range.index, 'breaker', true, Quill.sources.USER);
                          this.quill.setSelection(range.index + 1, Quill.sources.SILENT);
                          return false;
                      }
                  },
                  enter: {
                      key: 'Enter',
                      handler: () => {
                         if($kIsWeb) {
                          OnEditingCompleted(quilleditor.root.innerHTML);
                          } else {
                          OnEditingCompleted.postMessage(quilleditor.root.innerHTML);
                          }
                      }
                  }
              };
              
              let Embed = Quill.import('blots/embed');
              
              class Breaker extends Embed {
                  static tagName = 'br';
                  static blotName = 'breaker';
              }
              Quill.register(Breaker);

            var quilleditor = new Quill('#editor', {
              modules: {
                toolbar: '#toolbar-container',
                table: true,
                 keyboard:  ${widget.inputAction == InputAction.send ? '{bindings: bindings}' : '{}'},
                history: {
                  delay: 2000,
                  maxStack: 500,
                  userOnly: false
                }
              },
              theme: 'snow',
             scrollingContainer: '#scrolling-container', 
              placeholder: '${widget.hintText ?? "Description"}',
              clipboard: {
                matchVisual: true
              }
            });
            
          
            const table = quilleditor.getModule('table');
            quilleditor.enable($isEnabled);
        
           applyGoogleKeyboardWorkaround(quilleditor);
            
            let editorLoaded = false;
            quilleditor.on('editor-change', function(eventName, ...args) {
      
             if (!editorLoaded) {
                if($kIsWeb) {
                    EditorLoaded(true);
                } else {
                    EditorLoaded.postMessage(true);
                }
                  editorLoaded = true;
                }
             
            });
            
            quilleditor.on('selection-change', function(range, oldRange, source)  {
             /// console.log('selection changed');
              onRangeChanged();
              if($kIsWeb){
              OnSelectionChanged(getSelectionRange());
              }else{
              OnSelectionChanged.postMessage(getSelectionRange());
              }     
              
            });
                  
            function onRangeChanged() { 
              try {
                var range = quilleditor.getSelection(true);
                if(range != null) {
                  if(range.length == 0) {
                    var format = quilleditor.getFormat();
                    formatParser(format);
                  } else {
                    var format = quilleditor.getFormat(range.index, range.length);
                    formatParser(format);
                  }
                } else {
                 // console.log('Cursor not in the editor');
                }
              } catch(e) {
              ///  console.log(e);
              }
            }
            
             function redo(){
              quilleditor.history.redo();
              return '';
             }
             
             function undo(){
              quilleditor.history.undo();
              return '';
             }
             function clearHistory(){
               quilleditor.history.clear();
               return '';
             }
            
            
            function formatParser(format) {
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
              formatMap['size'] = format['size'];
              formatMap['header'] = format['header'];
              formatMap['color'] = format['color'];
              formatMap['font'] = format['font'];
              formatMap['align'] = format['align'];
              formatMap['list'] = format['list'];
              formatMap['image'] = format['image'];
              formatMap['video'] = format['video'];
              formatMap['clean'] = format['clean'];
              formatMap['link'] = format['link'];
              if($kIsWeb) {
                UpdateFormat(JSON.stringify(formatMap));
              } else {
                UpdateFormat.postMessage(JSON.stringify(formatMap));
              }
            }
     
           
            function getHtmlText() {
              return quilleditor.root.innerHTML;
            }
 
            function getPlainText() {
              var text = "";
              try{
                 text =  toPlaintext(quilleditor.getContents());
              }catch(e){
                 text = "";
              }
              return text; 
            }
            
            function toPlaintext(delta) {
              return delta.reduce(function (text, op) {
                if (!op.insert) throw new TypeError('only `insert` operations can be transformed!');
                if (typeof op.insert !== 'string') return text + ' ';
                return text + op.insert;
              }, '');
            };
            
            function getSelection() {
            try{
              var range = quilleditor.getSelection(true);
              if(range) {
                return range.length;
              }
                }catch(e){
                console.log('getSelection', e);
              }
              return -1;
            }
            
            function getSelectionHtml() {
              var selection = quilleditor.getSelection(true);
              if(selection){
              var selectedContent = quilleditor.getContents(selection.index, selection.length);
              var tempContainer = document.createElement('div')
              var tempQuill = new Quill(tempContainer);
              tempQuill.setContents(selectedContent);
              return tempContainer.querySelector('.ql-editor').innerHTML;
              }
              return '';
            }
            
            function getSelectionRange() {
              var range = quilleditor.getSelection(true);
              if(range) {
                var rangeMap = {};
                rangeMap['length'] = range.length;
                rangeMap['index'] = range.index;
                return JSON.stringify(rangeMap);
              }
              return {};
            }
            
            function setSelection(index, length) {
            try{
              setTimeout(() => quilleditor.setSelection(index, length), 1);
              }catch(e){
                console.log('setSelection', e);
              }
              return '';
            }
            
            function setHtmlText(htmlString) {
            try{
               quilleditor.enable(false);
               quilleditor.clipboard.dangerouslyPasteHTML(htmlString);   
            }catch(e){
               console.log('setHtmlText', e);
            }
             setTimeout(() =>   quilleditor.enable($isEnabled), 10);  
              return '';
            }
            
          
            function setDeltaContent(deltaMap) {   
              try{
                  quilleditor.enable(false);
                  const obj = JSON.parse(deltaMap);
                  quilleditor.setContents(obj);
                }catch(e){
                  console.log('setDeltaContent', e);
                }
               setTimeout(() =>   quilleditor.enable($isEnabled), 10);  
              return '';
            }
            
            function getDelta() {
              return JSON.stringify(quilleditor.getContents()); 
            }

            function requestFocus() {
              try{
              var htmlString = quilleditor.root.innerHTML;
               setTimeout(() => {
                    quilleditor.setSelection(htmlString.length + 1, htmlString.length + 1);
                    quilleditor.focus();
               }, 600);
              }catch(e){
                console.log('requestFocus',e);
              }
            
              return '';
            }
            
            function unFocus() {
              quilleditor.root.blur()
              return '';
            }
  
            function insertTable(row,column) {
              table.insertTable(row, column);
              return '';
            }
            
            function modifyTable(type) {
                if(type =="insertRowAbove"){
                 table.insertRowAbove();
                }else if(type == "insertRowBelow"){
                  table.insertRowBelow();
                }else if(type == "insertColumnLeft"){
                  table.insertColumnLeft();
                }else if(type == "insertColumnRight"){
                  table.insertColumnRight();
                }else if(type == "deleteRow"){
                  table.deleteRow();
                }else if(type == "deleteColumn"){
                  table.deleteColumn();
                }else if(type == "deleteTable"){
                  table.deleteTable();
                }
              return '';
            }
            
            function insertHtmlText(htmlString, index) {
              if(index == null) {
                var range = quilleditor.getSelection(true);
                if(range) {
                  quilleditor.clipboard.dangerouslyPasteHTML(range.index, htmlString);
                }
              } else {
                quilleditor.clipboard.dangerouslyPasteHTML(index, htmlString);
              }
              return '';
            }
            
            function embedVideo(videoUrl) {
              var range = quilleditor.getSelection(true);
              if(range) {
                quilleditor.insertEmbed(range.index, 'video', videoUrl);
              }
              return '';
            }
            
            function embedImage(img) {
              var range = quilleditor.getSelection(true);
              if(range) {
                quilleditor.insertEmbed(range.index, 'image', img);
              }
              return '';
            }
            
            function enableEditor(isEnabled) {
              quilleditor.enable(isEnabled);
              return '';
            }
            
            function setFormat(format, value) {
            try{
              if(format == 'clean') {
                var range = quilleditor.getSelection(true);
                if(range) {
                  if(range.length == 0) {
                    quilleditor.removeFormat(range.index, quilleditor.root.innerHTML.length);
                  } else {
                    quilleditor.removeFormat(range.index, range.length);
                  }
                } else {
                  quilleditor.format('clean');
                }
              } else {
                
                quilleditor.format(format, value);
              }
            }catch(e){
            console.log('setFormat',e);
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
  StreamController<String>? _editorLoadedController;

  ///[isEnable] to enable/disable editor
  bool isEnable = true;

  /// A controller for the Quill editor.
  ///
  /// The [QuillEditorController] class provides control over the Quill editor by managing its state
  /// and providing methods to interact with the editor's content and toolbar.
  ///
  QuillEditorController() {
    _editorKey =
        GlobalKey<QuillHtmlEditorState>(debugLabel: _getRandomString(15));
    _toolBarKey = GlobalKey<ToolBarState>(debugLabel: _getRandomString(15));
    _changeController = StreamController<String>();
    _editorLoadedController = StreamController<String>();
  }

  /// to access toolbar key from toolbar widget
  GlobalKey<ToolBarState>? get toolBarKey => _toolBarKey;

  /// [getText] method is used to get the html string from the editor
  /// To avoid getting empty html tags, we are validating the html string
  /// if it doesn't contain any text, the method will return empty string instead of empty html tag
  Future<String> getText() async {
    try {
      String? text = await _editorKey?.currentState?._getHtmlFromEditor();
      if (text == '<p><br></p>') {
        return text!.replaceAll('<p><br></p>', '');
      }
      return text ?? '';
    } catch (e) {
      return "";
    }
  }

  /// Retrieves the plain text content from the editor.
  ///
  /// The [getPlainText] method is used to extract the plain text content from the editor
  /// as a [String]. This can be useful when you need to retrieve the editor's content
  /// without any formatting or HTML tags.
  ///
  Future<String> getPlainText() async {
    try {
      String? text = await _editorKey?.currentState?._getPlainTextFromEditor();
      if (text == null) {
        return "";
      } else {
        return text;
      }
    } catch (e) {
      return "";
    }
  }

  /// Sets the HTML text content in the editor.
  ///
  /// The [setText] method is used to set the HTML text content in the editor,
  /// overriding any existing text with the new content.
  Future setText(String text) async {
    return await _editorKey?.currentState?._setHtmlTextToEditor(htmlText: text);
  }

  /// Sets the Delta object in the editor.
  ///
  /// The [setDelta] method is used to set the Delta object in the editor,
  /// overriding any existing text with the new content.
  Future setDelta(Map delta) async {
    return await _editorKey?.currentState?._setDeltaToEditor(deltaMap: delta);
  }

  /// Retrieves the Delta map from the editor.
  ///
  /// The [getDelta] method is used to retrieve the Delta map from the editor
  /// as a [Map]. The Delta map represents the content and formatting of the editor.
  ///
  Future<Map> getDelta() async {
    var text = await _editorKey?.currentState?._getDeltaFromEditor();
    return jsonDecode(text.toString());
  }

  /// Requests focus for the editor.
  ///
  /// The [focus] method is used to request focus for the editor,
  /// bringing it into the active input state.
  ///
  Future focus() async {
    return await _editorKey?.currentState?._requestFocus();
  }

  /// Inserts a table into the editor.
  ///
  /// The [insertTable] method is used to insert a table into the editor
  /// with the specified number of rows and columns.
  ///
  Future insertTable(int row, int column) async {
    return await _editorKey?.currentState
        ?._insertTableToEditor(row: row, column: column);
  }

  /// Modifies an existing table in the editor.
  ///
  /// The [modifyTable] method is used to add or remove rows or columns of an existing table in the editor.
  ///
  Future modifyTable(EditTableEnum type) async {
    return await _editorKey?.currentState?._modifyTable(type);
  }

  /// Inserts HTML text into the editor.
  ///
  /// The [insertText] method is used to insert HTML text into the editor.
  /// If the [index] parameter is not specified, the text will be inserted at the current cursor position.
  ///
  Future insertText(String text, {int? index}) async {
    return await _editorKey?.currentState
        ?._insertHtmlTextToEditor(htmlText: text, index: index);
  }

  /// Replaces the selected text in the editor.
  ///
  /// The [replaceText] method is used to replace the currently selected text in the editor
  /// with the specified HTML text.
  ///
  /// custom format for replaced text will come in future release
  Future replaceText(String text) async {
    return await _editorKey?.currentState?._replaceText(text);
  }

  /// [getSelectedText] method to get the selected text from editor
  Future getSelectedText() async {
    return await _editorKey?.currentState?._getSelectedText();
  }

  /// [getSelectedHtmlText] method to get the selected html text from editor
  Future getSelectedHtmlText() async {
    return await _editorKey?.currentState?._getSelectedHtmlText();
  }

  /// [embedVideo] method is used to embed url of video to the editor
  Future embedVideo(String url) async {
    String? link = StringUtil.sanitizeVideoUrl(url);
    if (link == null) {
      return;
    }
    return await _editorKey?.currentState?._embedVideo(videoUrl: link);
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

  @Deprecated(
      'Please use onFocusChanged method in the QuillHtmlEditor widget for focus')

  /// [hasFocus]checks if the editor has focus, returns the selection string length
  Future<int> hasFocus() async {
    return (await _editorKey?.currentState?._getSelectionCount()) ?? 0;
  }

  /// [getSelectionRange] to get the text selection range from editor
  Future<SelectionModel> getSelectionRange() async {
    var selection = await _editorKey?.currentState?._getSelectionRange();
    return selection != null
        ? SelectionModel.fromJson(jsonDecode(selection))
        : SelectionModel(index: 0, length: 0);
  }

  /// [setSelectionRange] to select the text in the editor by index
  Future setSelectionRange(int index, int length) async {
    return await _editorKey?.currentState?._setSelectionRange(index, length);
  }

  ///  [clear] method is used to clear the editor
  void clear() async {
    await _editorKey?.currentState?._setHtmlTextToEditor(htmlText: '');
  }

  /// [requestFocus] method is to request focus of the editor
  void requestFocus() async {
    await _editorKey?.currentState?._requestFocus();
  }

  ///  [unFocus] method is to un focus the editor
  void unFocus() async {
    await _editorKey?.currentState?._unFocus();
  }

  ///[setFormat]  sets the format to editor either by selection or by cursor position
  void setFormat({required String format, required dynamic value}) async {
    _editorKey?.currentState?._setFormat(format: format, value: value);
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

  /// Callback function triggered when the editor is completely loaded.
  ///
  /// The [onEditorLoaded] callback function is called when the Quill editor is fully loaded and ready for user interaction.
  /// It provides an opportunity to perform actions or initialize any additional functionality once the editor is loaded.
  ///
  void onEditorLoaded(VoidCallback callback) {
    try {
      if (_editorLoadedController != null &&
          _editorLoadedController?.hasListener == false) {
        _editorLoadedController?.stream.listen((event) {
          callback();
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
    _editorLoadedController?.close();
  }

  /// it is a regex method to remove the tags and replace them with empty space
  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  ///  [undo] method to undo the changes in editor
  void undo() async {
    await _editorKey?.currentState?._undo();
  }

  ///  [redo] method to redo the changes in editor
  void redo() async {
    await _editorKey?.currentState?._redo();
  }

  ///  [clearHistory] method to clear the history stack of editor
  void clearHistory() async {
    await _editorKey?.currentState?._clearHistory();
  }
}

///[SelectionModel] a model class for selection range
class SelectionModel {
  /// [index] index of the cursor
  int? index;

  ///[length] length of the selected value
  int? length;

  ///[SelectionModel] a model class constructor for selection range
  SelectionModel({this.index, this.length});

  ///[SelectionModel.fromJson] extension method to get selection model from json
  SelectionModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    length = json['length'];
  }
}

void _printWrapper(bool showPrint, String text) {
  if (showPrint) {
    debugPrint(text);
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
