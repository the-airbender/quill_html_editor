![Pub Version](https://img.shields.io/pub/v/quill_html_editor) ![GitHub](https://img.shields.io/github/license/the-airbender/quill_html_editor) ![Pub Points](https://img.shields.io/pub/points/quill_html_editor) ![Pub Popularity](https://img.shields.io/pub/popularity/quill_html_editor)



# Quill Html Editor

Quill Html Editor is a powerful HTML rich text editor designed for Android, iOS, and Web platforms. It leverages the capabilities of the QuillJs library, an open-source WYSIWYG editor, to provide a feature-rich editing experience for modern web applications.

## Features

- Highly customizable **Editor** and **Toolbar** widgets.
- Supports the `Delta` format, allowing you to set and retrieve content using `setDelta` and `getDelta` methods.
- Enables seamless copy-pasting of rich text from other files or webpages.
- The detached Toolbar can be placed anywhere on the page to suit your requirements.
- Provides the flexibility to add custom buttons to the toolbar.
- Supports embedding of images, videos, and insertion of tables.
- Allows setting and retrieving text in both HTML and Delta formats.
- Supports integration with **Google Fonts** for a wide range of font options.

## Demo

To experience the capabilities of the Quill Html Editor, you can visit our [Demo Page](https://the-airbender.github.io/). Explore the editor's functionalities and see how it can enhance your web editing experience.

## Screenshots

<img
style="display: block;  margin-left: auto;  margin-right: auto;"
width="600" alt="1" src="https://i.imgur.com/3PrFsZU.png">

<img  style="display: block;  margin-left: auto;  margin-right: auto;" width="600" alt="1" src="https://i.imgur.com/4FOw7Ap.png">

<p>
<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <a href="https://i.imgur.com/eNUzhgj.gif">
                    <img src="https://i.imgur.com/eNUzhgj.gif" width="300"/>
                </a>
            </td>            
            <td style="text-align: center">
                <a href="https://i.imgur.com/0DVAOec.gif">
                    <img src="https://i.imgur.com/0DVAOec.gif" width="300"/>
                </a>
            </td>
        </tr>
    </table>
</div> </p>


## Documentation
See the API documentation for details on the following topics:

- [Getting started](https://github.com/the-airbender/quill_html_editor/tree/main/doc/get-started.md)
- [Quill Html Editor Usage](https://github.com/the-airbender/quill_html_editor/tree/main/doc/quill-html-editor-setup.md)
- [Quill Controller Usage](https://github.com/the-airbender/quill_html_editor/tree/main/doc/quill-editor-controller-setup.md)
- [ToolBar Usage](https://github.com/the-airbender/quill_html_editor/tree/main/doc/toolbar-setup.md)



## Usage

Define a **QuillEditorController** to access the editor methods, pass the controller to **QuillHtmlEditor** Widget
```dart
  final QuillEditorController controller = QuillEditorController();
```
```dart
     QuillHtmlEditor(
text: "<h1>Hello</h1>This is a quill html editor example 😊",
hintText: 'Hint text goes here',
controller: controller,
isEnabled: true,
minHeight: 300,
textStyle: _editorTextStyle,
hintTextStyle: _hintTextStyle,
hintTextAlign: TextAlign.start,
padding: const EdgeInsets.only(left: 10, top: 5),
hintTextPadding: EdgeInsets.zero,
backgroundColor: _backgroundColor,
onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
onTextChanged: (text) => debugPrint('widget text change $text'),
onEditorCreated: () => debugPrint('Editor has been loaded'),
onEditorResized: (height) =>
debugPrint('Editor resized $height'),
onSelectionChanged: (sel) =>
debugPrint('${sel.index},${sel.length}'),
loadingBuilder: (context) {
return const Center(
child: CircularProgressIndicator(
strokeWidth: 0.4,
));
},
),
```

Define **ToolBar** widget and pass the same **controller** created for **QuillHtmlEditor**
```dart
   ToolBar(
toolBarColor: Colors.cyan.shade50,
activeIconColor: Colors.green,
padding: const EdgeInsets.all(8),
iconSize: 20,
controller: controller,
customButtons: [
InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),
],
)
```

## ToolBar Scroll Configuration

The `ToolBar.scroll` widget allows you to display the toolbar buttons in a single row or column, based on the specified `direction` parameter. By default, the `direction` is set to `Axis.horizontal`, which arranges the buttons in a single row.

To change the direction and display the buttons in a single column, you can provide the `direction` parameter as `Axis.vertical`. Here's an example:

```dart
ToolBar.scroll(
toolBarColor: _toolbarColor,
controller: controller,
direction: Axis.vertical,
),
```

In the above example, the `ToolBar.scroll` widget is used to display the toolbar buttons in a vertical arrangement.

## Customizing Toolbar Buttons

The `ToolBar` widget allows you to customize the buttons that are displayed in the toolbar. By default, if the `toolBarConfig` parameter is not provided, all the toolbar buttons will be shown.

If you want to show only specific buttons, you can pass a list of `ToolBarStyle` types to the `toolBarConfig` parameter. For example:

```dart
final customToolBarList = [
  ToolBarStyle.bold,
  ToolBarStyle.italic,
  ToolBarStyle.align,
  ToolBarStyle.color,
];

ToolBar(
controller: controller,
toolBarConfig: customToolBarList,
),
```

In the above example, only the "Bold," "Italic," "Align," and "Color" buttons will be displayed in the toolbar.

Additionally, you can add custom buttons to the toolbar by providing a list of custom widgets to the `customButtons` parameter. Here's an example:

```dart
final customButtons = [
  InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
  InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),
];

ToolBar(
controller: controller,
customButtons: customButtons,
),
```

In the above example, custom buttons with heart and add circle icons are added to the toolbar.

Feel free to customize the toolbar configuration and add custom buttons according to your requirements to enhance the editing experience with the Quill Html Editor.



## Custom Fonts in Quill Html Editor

You can pass custom fonts to the text style in the `quill_html_editor` package by following these steps:

Define your custom font family in your Flutter project. You can use Google Fonts. Let's assume you want to use the 'Roboto' font family.

```dart

final _editorTextStyle = const TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.normal,
  fontFamily: 'Roboto',
);

```
By following these steps, you can pass custom font styles to the text within the QuillHtmlEditor widget. The fontFamily property of the TextStyle allows you to specify the desired font family, such as 'Roboto' in this example.




##### To get the html string from editor
```dart
  String? htmlText = await controller.getText();
```
##### To set the html string to editor
```dart
 await controller.setText(text);
```

##### To get the text in delta format
```dart
 await controller.getDelta();
```

##### To set the text in delta format
```dart
 controller.setDelta(deltaMap);
```

##### To insert the html string to editor
```dart
/// index is optional
/// If the index is not passed, the text will be inserted at the cursor position
await controller.insertText(text, index: 10);  
```
##### To clear the editor
```dart
  controller.clear();
```

##### To enable editor
```dart
  controller.enableEditor(true);
```

##### To disable editor
```dart
  controller.enableEditor(false);
```

### Todo

-  **CustomStyleButton** - Let the user add own icons to toolbar styles
-  **Custom Color** - Let the user add more Colors to the Color Picker
-  **Custom FontSize** - Let the user add custom font sizes, instead of just Small, Normal, Large & Huge
-  **AsyncImagePickerButton** -  To share picked file to user, to upload it asynchronously and inserts the returned link into the editor
-  More examples for each available apis

------------

### MIT License

Copyright (c) 2022 Pavan Kumar Nagulavancha

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
