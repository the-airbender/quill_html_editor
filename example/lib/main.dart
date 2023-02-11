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

  final _toolbarColor = Color(int.parse('FF30363C', radix: 16));
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ToolBar(
              toolBarColor: _toolbarColor,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: Colors.white70,
              activeIconColor: Colors.orange.shade300,
              controller: controller,
              customButtons: [
                InkWell(
                    onTap: () async {},
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white70,
                    )),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.white70,
                    )),
              ],
            ),
            Expanded(
              child: QuillHtmlEditor(
                text:
                    "<h1>Hello</h1>This is a quill html editor example text. :-)",
                hintText: 'Hint text goes here',
                controller: controller,
                height: MediaQuery.of(context).size.height,
                onTextChanged: (text) => debugPrint('widget text change $text'),
                defaultFontSize: 18,
                defaultFontColor: Colors.white70,
                isEnabled: true,
                backgroundColor: Color(int.parse('FF424242', radix: 16)),
              ),
            ),
            Container(
              color: Color(int.parse('FF424242', radix: 16)).withOpacity(0.8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: _toolbarColor,
                        child: const Text(
                          'Set Text',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onPressed: () {
                          setHtmlText("This text is set by the setText method");
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: _toolbarColor,
                        child: const Text(
                          'Insert Text',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onPressed: () {
                          insertHtmlText(
                              "This text is set by the insertText method");
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: _toolbarColor,
                        child: const Text(
                          'Insert Index',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onPressed: () {
                          insertHtmlText(
                              "This text is set by the insertText method",
                              index: 10);
                        }),
                  ),
                ],
              ),
            )
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
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);
}
