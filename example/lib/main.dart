import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
  ];

  final _toolbarColor = Colors.greenAccent.shade100;
  final _backgroundColor = Colors.transparent;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal);
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
    /// please do not forget to dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ToolBar(
              toolBarColor: _toolbarColor,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: _toolbarIconColor,
              activeIconColor: Colors.purple.shade300,
              controller: controller,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              customButtons: [
                InkWell(
                    onTap: () => unFocusEditor(),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.black,
                    )),
                InkWell(
                    onTap: () async {
                      var selectedText = await controller.getSelectedText();
                      debugPrint('selectedText $selectedText');
                      var selectedHtmlText =
                          await controller.getSelectedHtmlText();
                      debugPrint('selectedHtmlText $selectedHtmlText');
                    },
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    )),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              child: QuillHtmlEditor(
                text: "<h1>Hello</h1>This is a quill html editor example 😊",
                hintText: 'Hint text goes here',
                controller: controller,
                isEnabled: true,
                minHeight: 300,
                textStyle: _editorTextStyle,
                hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 0, top: 0),
                hintTextPadding: EdgeInsets.zero,
                backgroundColor: _backgroundColor,
                onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () => debugPrint('Editor has been loaded'),
                onEditorResized: (height) =>
                    debugPrint('Editor resized $height'),
                onSelectionChanged: (sel) =>
                    debugPrint('index ${sel.index}, range ${sel.length}'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Visibility(
          visible: true,
          child: Container(
            width: double.maxFinite,
            color: _toolbarColor,
            child: Wrap(
              children: [
                textButton(
                    text: 'Set Text',
                    onPressed: () {
                      setHtmlText("This text is set by the setText method");
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
                      insertNetworkImage('https://i.imgur.com/0DVAOec.gif');
                    }),
                textButton(
                    text: 'Insert Index',
                    onPressed: () {
                      insertHtmlText(
                          "This text is set by the insertText method",
                          index: 10);
                    }),
                textButton(
                    text: 'Undo',
                    onPressed: () {
                      controller.undo();
                    }),
                textButton(
                    text: 'Redo',
                    onPressed: () {
                      controller.redo();
                    }),
                textButton(
                    text: 'Clear History',
                    onPressed: () {
                      controller.clearHistory();
                    }),
                textButton(
                    text: 'Clear Editor',
                    onPressed: () {
                      controller.clear();
                    }),
              ],
            ),
          ),
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

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();
}
