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
| `direction`    | `Axis`    | `Axis.horizontal`    | The direction to use as the main axis   |
| `alignment`    | `WrapAlignment`    | `WrapAlignment.start`    | How the children within a run should be placed in the main axis   |
| `spacing`    | `double`    | `0.0`    | How much space to place between children in a run in the main axis   |
| `runAlignment`   | `WrapAlignment`    | `WrapAlignment.start`    | How the runs themselves should be placed in the cross axis   |
| `runSpacing`   | `double`    | `0.0`    | How much space to place between the runs themselves in the cross axis    |
| `crossAxisAlignment`   | `WrapAlignment`    | `WrapAlignment.start`    | How the children within a run should be aligned relative to each other in the cross axis.   |
| `textDirection`   | `TextDirection`    | `null`   | Determines the order to lay children out horizontally and how to interpret `start` and `end` in the horizontal direction. |
| `verticalDirection`   | `VerticalDirection`    | `VerticalDirection.down`   | Determines the order to lay children out vertically and how to interpret `start` and `end` in the vertical direction. |
| `clipBehavior`    | `Clip`    | `Clip.none`    | Controls how the contents of the dialog are clipped (or not) to the given shape.   |



For a complete sample, see the [Getting started sample][] in the example directory.

[Getting started sample]: https://github.com/the-airbender/quill_html_editor/blob/main/example/lib/main.dart


[QuillEditorController]: https://github.com/the-airbender/quill_html_editor/tree/main/doc/quill-editor-controller-setup.md


[Getting Started]: https://github.com/the-airbender/quill_html_editor/tree/main/doc/get-started.md

