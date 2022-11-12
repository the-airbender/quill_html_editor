import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:webviewx/webviewx.dart';

class QuillHtmlViewer extends StatefulWidget {
  const QuillHtmlViewer(
      {super.key, this.text,
      required this.height,
      this.onTap,
      this.htmlKey,
      this.enableGestures = false,
      this.isSimpleHtml = false});
  final String? text;
  final double height;
  final bool? enableGestures;
  final GestureTapCallback? onTap;
  final Key? htmlKey;
  /// used for simple views or rendering multple html widgets in listview.
  final bool? isSimpleHtml;

  @override
  State<QuillHtmlViewer> createState() => _QuillHtmlViewerState();
}

class _QuillHtmlViewerState extends State<QuillHtmlViewer>
    with AutomaticKeepAliveClientMixin {
  late WebViewXController _webviewController;

  var _initialContent = "";
  StreamController<double> streamController = StreamController<double>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isSimpleHtml == true) {
      return HtmlWidget(widget.text ?? "");
    }
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
    return StreamBuilder<double>(
        initialData: 50,
        stream: streamController.stream,
        builder: (context, snapshot) {
          _initialContent = _getQuillPage(height: snapshot.data!, width: width);
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: WebViewX(
                      key: widget.htmlKey ??
                          ((widget.text != null && widget.text!.isNotEmpty)
                              ? ValueKey(widget.text!.length > 10
                                  ? widget.text!.substring(0, 7)
                                  : widget.text)
                              : UniqueKey()),
                      initialContent: _initialContent,
                      initialSourceType: SourceType.html,
                      height: snapshot.data!,
                      ignoreAllGestures: true,

                      ///!widget.enableGestures!,
                      width: width,
                      onWebViewCreated: (controller) =>
                          _webviewController = controller,
                      onPageStarted: (src) {},

                      onPageFinished: (src) async {
                        var temptext = widget.text!
                            .replaceAll('indent-6', 'indent-5')
                            .replaceAll('indent-7', 'indent-5')
                            .replaceAll('indent-8', 'indent-5')
                            .replaceAll('indent-9', 'indent-5')
                            .replaceAll("27em;", "0em;");
                        await _setHtmlTextToEditor(htmlText: temptext);
                        await Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          await _webviewController
                              .callJsMethod("getHeight", []).then((height) {
                            streamController.add(height);
                          });
                        });
                      },
                      webSpecificParams: const WebSpecificParams(
                        printDebugInfo: false,
                      ),
                      mobileSpecificParams: const MobileSpecificParams(
                        androidEnableHybridComposition: true,
                      ),
                      navigationDelegate: (navigation) {
                        return NavigationDecision.navigate;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      height: snapshot.data,
                      width: width,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future _setHtmlTextToEditor({required String htmlText}) async {
    await _webviewController.callJsMethod("setHtmlText", [htmlText]);
  }

  String _getQuillPage({required double height, required double width}) {
    return """<!DOCTYPE html>
<html>
   <head>
      <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
      <style>
         #editorcontainer .ql-editor {
         font-size: 14.5px;
         overflow-y: visible; 
         border:none;
         height:auto;
         }
         #editor{
         font-size: 14.5px;
         border:none;
         outline:none;
         padding:0px;
         margin:0px;
         width:100%;
         border-color: transparent;
         }
         
         .ql-editor li.ql-indent {
  margin-left: 5em !important;
}
.ql-editor li.ql-indent:not(.ql-direction-rtl) {
  margin-left: 5em !important;
}
body{
padding:0px;
margin:0px;
overflow: hidden;
}
         
      </style>
      <link href="https://cdn.quilljs.com/1.3.6/quill.core.css" rel="stylesheet"/>
      <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet" />
   </head>
   <body>
        <div id="editor">
          
            </div>
   </body>
   <script>
      
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
      theme: 'snow',
      "modules": {
      "toolbar": false
      },
      clipboard: {
            matchVisual: false
        }
      });
       quilleditor.enable(false);
    
      function getHeight(){
      // return quilleditor.getBounds(0,quilleditor.getLength())['height'];
       return document.getElementById('editor').clientHeight;
      }
      
      function setHtmlText(htmlString) 
      {
      quilleditor.container.firstChild.innerHTML = htmlString;
      quilleditor.enable(false); 
      }
   </script>
</html>""";
  }

  @override
  bool get wantKeepAlive => true;
}
