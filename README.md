
## Quill Html Editor

HTML rich text editor for Android, iOS, and Web, using the QuillJS library. QuillJS is a free, open source WYSIWYG editor built for the modern web.

------------
### 📸 Screenshots

<p float="left">
  <img width="600" alt="1" src="https://i.imgur.com/c3n5IzE.png">
</p>
------------


### Usage

Define a **QuillEditorController** to access the editor methods, pass the controller to **QuillHtmlEditor** Widget
```dart
  final QuillEditorController controller = QuillEditorController();
```
```dart
   QuillHtmlEditor(
	   hintText: 'Hint text goes here',
	   controller: controller,
	   height: MediaQuery.of(context).size.height,
	   onTextChanged: (text) =>
	   debugPrint('widget text change $text'),
	   defaultFontSize: 18,
	   defaultFontColor: Colors.black45,
	   isEnabled: true,
	   backgroundColor: Colors.white,  
    )
```
**onTextChanged** can be used to listen to the text changes, as defined below
```dart
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
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
				InkWell(
				onTap: () async {}, child: const Icon(Icons.favorite)),
				InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),
			],
      )
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
        customButtons:customButtons ,
    ),
```

#### To get the html string from editor
```dart
String? htmlText = await controller.getText();
```
#### To set the html string to editor
```dart
 await controller.setText(text);
```
#### To clear the editor
```dart
 controller.clear();
```

#### To enable editor
```dart
  controller.enableEditor(true);
```

#### To disable editor
```dart
  controller.enableEditor(false);
```

### Todo

- Custom Font Styles
- Image button should support custom async upload over network and embed url
- Embed YouTube or video urls
- Replace selected Text
- Support for Windows and Mac

### Credits
[adrianflutur](https://github.com/adrianflutur/webviewx "adrianflutur") for webviewx package<br>
[Mahad61](https://github.com/Mahad61/webviewx_plus "Mahad61") for webviewx_plus package<br>
[miguelpruivo](https://github.com/miguelpruivo/flutter_file_picker "file_picker") for filepicker pacakge<br>
[marcelogil](https://github.com/marcelogil/el_tooltip "marcelogil") for eltooltip package, which we used in this package to create custom color picker<br>

------------

### MIT License


Copyright (c) 2022 Pavan Kumar

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

