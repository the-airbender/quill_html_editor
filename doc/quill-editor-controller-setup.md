### Quill Editor Controller - Setup & Usage

To get started with the editor setup, please refer the [Getting Started]


To understand the usage of `QuillHtmlEditor` widget, please refer to [QuillHtmlEditor]

We need to pass `QuillEditorController` to both Editor and the Toolbar to bind the widgets with the controller methods.

### Quill Controller Methods

As shown in the getting started sample, please define a `QuillEditorController`

```dart 
  final QuillEditorController controller = QuillEditorController();
```


#### `getText`


Method is used to get the html string from the editor. To avoid getting empty html tags, we are validating the html string; if it doesn't contain any text, the method will return empty string instead.
```dart 
   String? htmlText = await controller.getText();
```

#### `setText`

Method is used to set the html text to the editor. It will override the existing text in the editor with the new one
```dart 
   await controller.setText(text);
```

#### `insertText `

Method is used to insert the html text to the editor, if the index is not passed, it will insert the text at cursor position.
```dart 
   await controller.insertText(text,index:10); //index is optional
```

#### `replaceText `

Method is used to replace the selected text in the editor, custom format for replaced text is not available yet, will be added in future release.

```dart 
   await controller.replaceText(text);
```

#### `getSelectedText`

Method to get the selected text from editor in plain text

```dart 
   await controller.getSelectedText();
```

#### `getSelectedHtmlText`

Method to get the selected text from editor in html format

```dart 
   await controller.getSelectedHtmlText();
```

#### `focus`

Method is used to request focus of the editor
```dart 
   controller.focus();
```
**Note**: Due to limitations of the Webview, the editor focus doesn't launch the Soft Keyboard at the moment.


#### `unFocus`

Method is used to remove focus of the editor. This method, will also dismiss the keyboard.
```dart 
   controller.unFocus();
```


#### `undo`

Method to undo the entered text
```dart 
    controller.undo();
```

#### `redo`

Method to redo the entered text
```dart 
    controller.redo();
```

#### `clearHistory`

Method to clear the editor history stack
```dart 
    controller.clearHistory();
```



#### `onTextChanged`
Can be used to listen to the text changes, as defined below
```dart
   controller.onTextChanged((text) {
debugPrint('listening to $text');
});
```


#### `onEditorLoaded`
/// The [onEditorLoaded] callback function is called when the Quill editor is fully loaded and ready for user interaction.
```dart
   controller.onEditorLoaded(() {
    debugPrint('Editor Loaded :)');
   });
```

#### `getSelectionRange`

To get the text selection range from editor. It returns a `SelectionModel` object which has the `index` and `length` of the selection.

```dart 
  var selectionModel =  controller.getSelectionRange();
```


#### `setSelectionRange`

To select the text in the editor by index and legnth

```dart 
   await controller.setSelectionRange(index,length);
```



#### `clear`

Clears the editor text.

```dart 
   controller.clear();
```


#### `embedImage`

Method is used to insert image to the editor, we can set the network image url to embed the network link, please refer the example.

```dart 
     await controller.embedImage(url); //network image url
   ```
We can also set the base64 String of an image using this method, which will be handled by the image picker in the `ToolBar` widget.
```dart 
   var data = 'data:image/${file.extension};base64,$base64String';

   await controller.embedImage(data);
   ```


#### `embedVideo`

Method is used to embed url of video to the editor, it recognises the inserted url and sanitize to make it embeddable url.

Eg: Converts **youtube** video to embed video, same for **vimeo**
```dart 
     await controller.embedVideo(url); //video url
   ```
More info about this methods at [Getting started sample]


#### `enableEditor`

Method is used to enable/ disable the editor. We can also enable or disable the editor directly by passing `isEnabled` to the `QuillHtmlEditor` widget.
```dart 
     await controller.enableEditor(bool); 
```



#### `setDetla`

Method is used to set delta to the editor, it will override the existing text in the editor with the new one.
Please pass the data in Map format.
```dart 
     controller.setDelta(map);
```

#### `getDelta`

Method is used to get delta from editor, it will return the delta in Map format
```dart 
   var deltaMap =  await controller.getDelta();
```

### Table Methods


#### `insertTable`

Method is used to insert table by row and column to the editor

```dart 
   controller.insertTable(int row, int column);
```

#### `modifyTable`

Method is used to add/remove, rows or columns of the table. This method takes `EditTableEnum` enum type to modify the table accordingly.

```dart 
 await controller.modifyTable(editTableEnum);
```

```dart 
   enum EditTableEnum {
      insertRowAbove,
      insertRowBelow,
      insertColumnLeft,
      insertColumnRight,
      deleteRow,
      deleteColumn,
      deleteTable
   }
```


#### `dispose`

Method to dispose the controller

```dart 
   controller.dispose();
```


For a complete sample, see the [Getting started sample][] in the example directory.

[Getting started sample]: https://github.com/the-airbender/quill_html_editor/blob/main/example/lib/main.dart

[Getting Started]: https://github.com/the-airbender/quill_html_editor/tree/main/doc/get-started.md

[QuillHtmlEditor]:  https://github.com/the-airbender/quill_html_editor/tree/main/doc/quill-html-editor-setup.md
