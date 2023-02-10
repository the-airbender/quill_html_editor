import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///[controller] create a QuillEditorController to access the editor methods
  final QuillEditorController controller = QuillEditorController();

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
  ];

  @override
  void initState() {
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(250), // Set this height
          child: SafeArea(
            child: ToolBar(
              toolBarColor: Colors.cyan.shade50,
              padding: const EdgeInsets.all(8),
              iconSize: 20,
              activeIconColor: Colors.green,
              controller: controller,
              customButtons: [
                InkWell(
                    onTap: () async {},
                    child: const Icon(
                      Icons.favorite,
                    )),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.add_circle,
                    )),
              ],
            ),
          )),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(width: 1500,
                child: QuillHtmlEditor(
                  text: '''<b>Hello</b> world. This is a <b>test</b>''' '',
                  hintText: 'Hint text goes here',
                  controller: controller,
                  height: MediaQuery.of(context).size.height,
                  onTextChanged: (text) => debugPrint('widget text change $text'),
                  defaultFontSize: 14,
                  defaultFontColor: Colors.black45,
                  isEnabled: true,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            TextButton(
                onPressed: () async {

                  setHtmlText('1343234rf2');
                },
                child: const Text('Insert')),
          ],
        ),
      ),
    );
  }

  /// to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText.toString());
  }

  /// to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  /// to set the html text to editor
  void insertHtmlText(String text) async {
    await controller.insertText(text, index: 10);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);
}
