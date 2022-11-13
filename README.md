
# Quill Html Editor

HTML rich text editor for Android, iOS, and Web, using the QuillJS library. QuillJS is a free, open source WYSIWYG editor built for the modern web.


## 📸 Screenshots
![Example Output of Quill HTML Editor](https://github.com/the-airbender/quill_html_editor/blob/main/screenshots/editor.png?raw=true)
## Usage
```dart
/// define editorKey to access the editor functions
final  htmlKey =  GlobalKey<QuillHtmlEditorState>();

QuillHtmlEditor(
  editorKey: htmlKey,
  height: 600
)
```
#### To get the html string from editor
```dart
String? htmlText = await htmlKey.currentState?.getText();
```
#### To set the html string to editor
```dart
 await htmlKey.currentState?.setText(text);
```


#### To clear the editor
```dart
  htmlKey.currentState?.clear();
```


#### To enable editor
```dart
  htmlKey.currentState?.enableEditor();
```

#### To disable editor
```dart
  htmlKey.currentState?.disableEditor();

```

## Todo
- Customization of toolbar
- Support for Windows and Mac

## License


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

