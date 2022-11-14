import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ///  create a key to access the the editor methods
  final GlobalKey<QuillHtmlEditorState> htmlKey =
      GlobalKey<QuillHtmlEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quill Html Editor'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          QuillHtmlEditor(
            editorKey: htmlKey,
            height: MediaQuery.of(context).size.height * 0.7,
            isEnabled:
                true, // to disable the editor set it to false (default value is true)
          ),
        ],
      ),
    );
  }

  /// to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await htmlKey.currentState?.getText();
    debugPrint(htmlText.toString());
  }

  /// to set the html text to editor
  void setHtmlText(String text) async {
    await htmlKey.currentState?.setText(text);
  }

  /// to clear the editor
  void clearEditor() => htmlKey.currentState?.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => htmlKey.currentState?.enableEditor(enable);
}
