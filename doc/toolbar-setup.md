### ToolBar - Setup & Usage

To get started with the editor and toolbar setup, please refer the [Getting Started]


`ToolBar` widget requires a `controller`, please refer to the [QuillEditorController] for more details on how to use the controller methods.

ToolBar widget is optional and is completely isolated from the Editor widget, which allows users to easily place the ToolBar anywhere inside the page. Please refer to the examples to understand it better.

#### ToolBar Parameters


| Parameter  | Type  | Default  | Description |
|:----------|:----------|:----------|:----------|
| `toolBarConfig`   	| `List<ToolBarStyle>?`   |  `null` | Optional list which takes the toolbar button types, by default, toolbar will show all the buttons, we can show required buttons by passing them in the list.   |
| `controller`    |  `QuillEditorController`   | `required`   | To access all the methods of editor and toolbar    |
| `customButtons`    | `List<Widget>?`    | `null`   | To add custom buttons in the toolbar  |
| `iconSize`   | `double`    | `25`    | To define the toolbar icon size    |
| `iconColor`   | `Color?`    | `Colors.black`   | To define the toolbar icon color    |
| `toolBarColor`    | `Color?`    | `Colors.white`    | To define the toolbar background color  |
| `activeIconColor`    | `Color?`   | `Colors.blue`   | To define the active toolbar icon color |
| `backgroundColor`    | `Color?`    | `null`    | To set Background Color to the editor   |
| `padding`    | `EdgeInsets`   | `EdgeInsets.zero`    | To set Padding to the toolbar style widgets    |



For a complete sample, see the [Getting started sample][] in the example directory.

[Getting started sample]: https://github.com/the-airbender/quill_html_editor/blob/main/example/lib/main.dart

[Getting Started]: https://pub.dev/documentation/quill_html_editor/latest/topics/Get%20started-topic.html

[QuillEditorController]: https://pub.dev/documentation/quill_html_editor/latest/topics/QuillEditorController-topic.html
