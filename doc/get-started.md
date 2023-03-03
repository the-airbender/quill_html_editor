To get started, follow the [package installation
instructions](https://pub.dev/packages/quill_html_editor/install) and add QuillHtmlEditor to your app:

For more customization, the **QuillHtmlEditor** and **ToolBar** are completely detached. We can define both widgets separately as shown below.



#### `QuillHtmlEditor` with required parameters

```dart
import 'package:quill_html_editor/quill_html_editor.dart';

// Editor widget with required parameters
   QuillHtmlEditor(
     controller: controller,
     height: MediaQuery.of(context).size.height,
   );

```

#### `QuillHtmlEditor` with all available parameters

```dart
import 'package:quill_html_editor/quill_html_editor.dart';

// With all available parameters
   QuillHtmlEditor(
     text: "Hello 😊",
     hintText: 'Hint text goes here',
     controller: controller, //required
     isEnabled: true,
     height: 400,
     textStyle: _editorTextStyle,
     hintTextStyle: _hintTextStyle,
     hintTextAlign: TextAlign.start,
     padding: const EdgeInsets.only(left: 10, top: 5),
     hintTextPadding: EdgeInsets.zero,
     backgroundColor: _backgroundColor,
     onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
     onTextChanged: (text) => debugPrint('widget text change $text'),
     onEditorCreated: () => debugPrint('Editor has been loaded'),),
     onSelectionChanged: (sel) =>
               debugPrint('index ${sel.index}, range ${sel.length}'),
  );
```


#### `ToolBar` widget with required parameters


```dart
import 'package:quill_html_editor/quill_html_editor.dart';
// With required parameters
  ToolBar(
    controller: controller
  );
```

#### `ToolBar` widget with all available parameters


```dart
import 'package:quill_html_editor/quill_html_editor.dart';
// With required parameters
 ToolBar(
  controller: controller,
  toolBarColor: _toolbarColor,
  padding: const EdgeInsets.all(8),
  iconSize: 25,
  iconColor: _toolbarIconColor,
  activeIconColor: Colors.purple.shade300,
  toolBarConfig: [ToolBarStyle.bold],
  customButtons: [
    InkWell( 
     child: const Icon( Icons.favorite),
     onTap: (){},),
   ],
  );
```

For a complete sample, see the [Getting started sample][] in the example directory.
For more on how to configure [QuillHtmlEditor] and [Toolbar].

[Getting started sample]: https://github.com/the-airbender/quill_html_editor/blob/main/example/lib/main.dart
[QuillHtmlEditor]: https://github.com/the-airbender/quill_html_editor/tree/main/doc/quill-html-editor-setup.md
[Toolbar]: https://github.com/the-airbender/quill_html_editor/tree/main/doc/toolbar-setup.md