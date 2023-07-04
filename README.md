![Pub Version](https://img.shields.io/pub/v/quill_html_editor) ![GitHub](https://img.shields.io/github/license/the-airbender/quill_html_editor) ![Pub Points](https://img.shields.io/pub/points/quill_html_editor)
# quill_html_editor

Quill Html Editor is a HTML rich text editor for Android, iOS, and Web, it is built with the powerful QuillJs library, an open source WYSIWYG editor for the modern web.


## Features
- Highly customizable **Editor** and **Toolbar** widgets
- Supports `Delta` format, can pass delta with `setDelta`and get with `getDelta` methods.
- Supports copy pasting the RichText from other files or webpages
- Because the Toolbar is completely detached from editor, it can be placed anywhere in the page, as per the requirement
- We can also add custom buttons to the toolbar
- Supports Embedding **Images**, **Videos**, Inserting **Tables**
- Set or get text in html/delta formats
- Supports **Google fonts**

## Quill Html Editor Demo
Please go to [Demo Page](https://the-airbender.github.io/) to try out the Quill Editor on Web


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
        debugPrint('${sel.index},${sel.length}')
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
`ToolBar.scroll` shows the widget in a single row/column based on the `direction`. The default value is [Axis.horizontal]


```dart
   ToolBar.scroll(
	toolBarColor: _toolbarColor,
	controller: controller,
	direction: Axis.vertical,
   ),

```

**Note**: *toolBarConfig*, if not passed to **ToolBar**, it will show all the Toolbar Buttons. To show only required buttons, please specify the types in the list as show below.
```dart
    final customToolBarList = [
  ToolBarStyle.bold,
  ToolBarStyle.italic,
  ToolBarStyle.align,
  ToolBarStyle.color,
];

ToolBar(
controller: controller,
toolBarConfig: customToolBarList
),
```

We can also add custom buttons to our **ToolBar** as shown below
```dart
    final customButtons =  [
  InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
  InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),
];

ToolBar(
controller: controller,
customButtons:customButtons
),
```

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
-  **Custom FontStyles** -  Let the user choose the supported font styles of the editor
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
