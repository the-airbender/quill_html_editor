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

  final _toolbarColor = Colors.greenAccent.shade100;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black54, fontWeight: FontWeight.normal);
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.teal, fontWeight: FontWeight.normal);

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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black45,
        body: Column(
          children: [
            ToolBar(
              toolBarColor: _toolbarColor,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: _toolbarIconColor,
              activeIconColor: Colors.purple.shade300,
              controller: controller,
              customButtons: [
                InkWell(
                    onTap: () async {},
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.black,
                    )),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    )),
              ],
            ),
            Expanded(
              child: QuillHtmlEditor(
                text: "<h1>Hello</h1>This is a quill html editor example 😊",
                hintText: 'Hint text goes here',
                controller: controller,
                isEnabled: true,
                height: MediaQuery.of(context).size.height,
                textStyle: _editorTextStyle,
                hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, top: 5),
                hintTextPadding: EdgeInsets.zero,
                backgroundColor: _backgroundColor,
                onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () => debugPrint('Editor has been loaded'),
              ),
            ),
            Visibility(
              visible: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: _toolbarColor,
                  child: Row(
                    children: [
                      textButton(
                          text: 'Set Text',
                          onPressed: () {
                            setHtmlText(
                                "This text is set by the setText method");
                          }),
                      textButton(
                          text: 'Insert Video',
                          onPressed: () {
                            ////insert
                            insertVideoURL(
                                'https://www.youtube.com/watch?v=4AoFA19gbLo');
                            insertVideoURL('https://vimeo.com/440421754');
                            insertVideoURL(
                                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
                          }),
                      textButton(
                          text: 'Insert Image',
                          onPressed: () {
                            insertNetworkImage(
                                'https://i.imgur.com/0DVAOec.gif');
                          }),
                      textButton(
                          text: 'Insert Index',
                          onPressed: () {
                            insertHtmlText(
                                "This text is set by the insertText method",
                                index: 10);
                          }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText.toString());
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
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
