### Quill Html Editor - Setup & Usage

To get started with the editor setup, please refer the [Getting Started]


`QuillHtmlEditor` widget requires a `controller`, please refer to the [QuillEditorController] for more details on how to use the controller methods.

#### Quill Editor Parameters


| Parameter             | Type                        | Default  | Description                                                             |
|:----------------------|:----------------------------|:----------|:------------------------------------------------------------------------|
| `text`   	            | `String`                    |  `null` | To set initial text to the editor on created                            |
| `controller`          | `QuillEditorController`     | `required`   | To access all the methods of editor and toolbar                         |
| `minHeight`           | `double`                    | `required`   | To set min height of the editor                                         |
| `isEnabled`           | `bool`                      | `false`    | To enable/disable the editor                                            |
| `hintText`            | `String`                    | `null`   | To set hint text to the editor                                          |
| `hintTextStyle `      | `TextStyle`                 | `null`    | To define textStyle to hint text  (FontStyle is not available yet)      |
| `textStyle`           | `TextStyle`                 | `null`   | To define default text style to editor (FontStyle is not available yet) |
| `backgroundColor`     | `Color`                     | `null`    | To set Background Color to the editor                                   |
| `padding`             | `EdgeInsets`                | `EdgeInsets.zero`    | To set Padding to the editor                                            |
| `hintTextPadding `    | `EdgeInsets`                | `EdgeInsets.zero`    | To set Padding to hint text                                             
| `hintTextAlign`       | `TextAlign`                 | `TextAlign.start` | To set the Hint text alignment                                          |
| `onFocusChanged`      | `Function(bool)?`           | `null` | **Callback** that returns `true/false` when editor focus is changed     |
| `onTextChanged `      | `Function(String)?`         | `null` | **Callback** that returns `text` when editor text is changed            |
| `onEditorCreated `    | `VoidCallBack`              | `null` | **Callback** that triggers on Editor loaded                             |
| `onSelectionChanged ` | `Function(SelectionModel)?` | `null` | **Callback** that returns selected index and length                     |

Quill Editor, supports copy pasting the formatted text from other sources, you can also use some keyboard shortcuts to format the text (bold, italic, underline)etc.


For a complete sample, see the [Getting started sample][] in the example directory.

[Getting started sample]: https://github.com/the-airbender/quill_html_editor/blob/main/example/lib/main.dart

[QuillEditorController]: https://github.com/the-airbender/quill_html_editor/tree/main/doc/quill-editor-controller-setup.md

[Getting Started]: https://github.com/the-airbender/quill_html_editor/tree/main/doc/get-started.md

