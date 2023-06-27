import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quill_html_editor/src/constants/image_constants.dart';
import 'package:quill_html_editor/src/utils/hex_color.dart';
import 'package:quill_html_editor/src/widgets/color_picker.dart';
import 'package:quill_html_editor/src/widgets/image_picker.dart';
import 'package:quill_html_editor/src/widgets/table_picker.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/webviewx_plus.dart';

import 'widgets/edit_table_drop_down.dart';
import 'widgets/el_tooltip/el_tooltip.dart';
import 'widgets/input_url_widget.dart';

///[ToolBar] widget to show the quill toolbar
class ToolBar extends StatefulWidget {
  ///[toolBarConfig] optional list which takes the toolbar button types,
  /// by default, toolbar will show all the buttons,
  /// we can show required buttons by passing them in the list
  final List<ToolBarStyle>? toolBarConfig;

  ///[controller] to access the editor and toolbar methods
  final QuillEditorController controller;

  ///[customButtons] to add custom buttons in the toolbar
  final List<Widget>? customButtons;

  ///[iconSize] to define the toolbar icon size
  final double? iconSize;

  ///[iconColor] to define the toolbar icon color
  final Color? iconColor;

  ///[toolBarColor] to define the toolbar icon color
  final Color? toolBarColor;

  ///[activeIconColor] to define the active toolbar icon color
  final Color? activeIconColor;

  /// [padding] The amount of space by which to inset the toolbar style widgets.
  final EdgeInsetsGeometry? padding;

  /// The direction to use as the main axis.
  ///
  /// For example, if [direction] is [Axis.horizontal], the default, the
  /// children are placed adjacent to one another in a horizontal run until the
  /// available horizontal space is consumed, at which point a subsequent
  /// children are placed in a new run vertically adjacent to the previous run.
  final Axis direction;

  /// How the children within a run should be placed in the main axis.
  ///
  /// For example, if [alignment] is [WrapAlignment.center], the children in
  /// each run are grouped together in the center of their run in the main axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [runAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  ///  * [crossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment alignment;

  /// How much space to place between children in a run in the main axis.
  ///
  /// For example, if [spacing] is 10.0, the children will be spaced at least
  /// 10.0 logical pixels apart in the main axis.
  ///
  /// If there is additional free space in a run (e.g., because the wrap has a
  /// minimum size that is not filled or because some runs are longer than
  /// others), the additional free space will be allocated according to the
  /// [alignment].
  ///
  /// Defaults to 0.0.
  final double spacing;

  /// How the runs themselves should be placed in the cross axis.
  ///
  /// For example, if [runAlignment] is [WrapAlignment.center], the runs are
  /// grouped together in the center of the overall [Wrap] in the cross axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [alignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [crossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment runAlignment;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [runSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// If there is additional free space in the overall [Wrap] (e.g., because
  /// the wrap has a minimum size that is not filled), the additional free space
  /// will be allocated according to the [runAlignment].
  ///
  /// Defaults to 0.0.
  final double runSpacing;

  /// How the children within a run should be aligned relative to each other in
  /// the cross axis.
  ///
  /// For example, if this is set to [WrapCrossAlignment.end], and the
  /// [direction] is [Axis.horizontal], then the children within each
  /// run will have their bottom edges aligned to the bottom edge of the run.
  ///
  /// Defaults to [WrapCrossAlignment.start].
  ///
  /// See also:
  ///
  ///  * [alignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [runAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  final dynamic crossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If the [direction] is [Axis.horizontal], this controls order in which the
  /// children are positioned (left-to-right or right-to-left), and the meaning
  /// of the [alignment] property's [WrapAlignment.start] and
  /// [WrapAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and either the
  /// [alignment] is either [WrapAlignment.start] or [WrapAlignment.end], or
  /// there's more than one child, then the [textDirection] (or the ambient
  /// [Directionality]) must not be null.
  ///
  /// If the [direction] is [Axis.vertical], this controls the order in which
  /// runs are positioned, the meaning of the [runAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [crossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and either the
  /// [runAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [crossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [textDirection] (or the ambient [Directionality]) must not be null.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// If the [direction] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [alignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and either the [alignment]
  /// is either [WrapAlignment.start] or [WrapAlignment.end], or there's
  /// more than one child, then the [verticalDirection] must not be null.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// runs are positioned, the meaning of the [runAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [crossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and either the
  /// [runAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [crossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [verticalDirection] must not be null.
  final VerticalDirection verticalDirection;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  /// How the children should be placed along the main axis.
  ///
  /// For example, [MainAxisAlignment.start], the default, places the children
  /// at the start (i.e., the left for a [Row] or the top for a [Column]) of the
  /// main axis.
  final MainAxisAlignment? mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  ///
  /// After allocating space to children, there might be some remaining free
  /// space. This value controls whether to maximize or minimize the amount of
  /// free space, subject to the incoming layout constraints.
  ///
  /// If some children have a non-zero flex factors (and none have a fit of
  /// [FlexFit.loose]), they will expand to consume all the available space and
  /// there will be no remaining free space to maximize or minimize, making this
  /// value irrelevant to the final layout.
  final MainAxisSize? mainAxisSize;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If [textDirection] is [TextDirection.rtl], then the direction in which
  /// text flows starts from right to left. Otherwise, if [textDirection] is
  /// [TextDirection.ltr], then the direction in which text flows starts from
  /// left to right.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// the children are positioned (left-to-right or right-to-left), and the
  /// meaning of the [mainAxisAlignment] property's [MainAxisAlignment.start] and
  /// [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and either the
  /// [mainAxisAlignment] is either [MainAxisAlignment.start] or
  /// [MainAxisAlignment.end], or there's more than one child, then the
  /// [textDirection] (or the ambient [`Directionality]) must not be null.
  ///
  /// If the [direction] is [Axis.vertical], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// Defaults to [VerticalDirection.down].
  ///
  /// If the [direction] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [mainAxisAlignment]
  /// property's [MainAxisAlignment.start] and [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and either the [mainAxisAlignment]
  /// is either [MainAxisAlignment.start] or [MainAxisAlignment.end], or there's
  /// more than one child, then the [verticalDirection] must not be null.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If aligning items according to their baseline, which baseline to use.
  ///
  /// This must be set if using baseline alignment. There is no default because there is no
  /// way for the framework to know the correct baseline _a priori_.
  final TextBaseline? textBaseline;

  final bool? _isScrollable;

  ///[ToolBar] widget to show the quill
  /// The toolbar items will be auto aligned based on the screen's width or height
  /// The behaviour of the widget's alignment is similar to [Wrap] widget

  ToolBar({
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.toolBarConfig,
    required this.controller,
    this.customButtons,
    this.padding,
    this.iconSize = 25,
    this.iconColor = Colors.black,
    this.activeIconColor = Colors.blue,
    this.toolBarColor = Colors.white,
    this.mainAxisSize,
  })  : assert(crossAxisAlignment is WrapCrossAlignment,
            "Please pass WrapCrossAlignment, instead of CrossAxisAlignment"),
        mainAxisAlignment = MainAxisAlignment.start,
        textBaseline = TextBaseline.alphabetic,
        _isScrollable = false,
        super(
          key: controller.toolBarKey,
        );

  ///[ToolBar.scroll] shows the widget in a single row/column
  ///Please define the [direction], to make it a row or a column
  ///the direction defaults to [Axis.horizontal]

  ToolBar.scroll({
    this.direction = Axis.horizontal,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.toolBarConfig,
    required this.controller,
    this.customButtons,
    this.padding,
    this.iconSize = 25,
    this.iconColor = Colors.black,
    this.activeIconColor = Colors.blue,
    this.toolBarColor = Colors.white,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.textBaseline = TextBaseline.alphabetic,
  })  : assert(crossAxisAlignment is CrossAxisAlignment,
            "Please pass CrossAxisAlignment, instead of WrapCrossAlignment"),
        spacing = 0.0,
        runSpacing = 0.0,
        alignment = WrapAlignment.start,
        runAlignment = WrapAlignment.start,
        _isScrollable = true,
        super(
          key: controller.toolBarKey,
        );
  @override
  State<ToolBar> createState() => ToolBarState();
}

///[ToolBarState] state object to access the apis of toolbar
class ToolBarState extends State<ToolBar> {
  List<ToolBarItem> _toolbarList = [];
  Map<String, dynamic> _formatMap = {};
  late GlobalKey<ElTooltipState> _fontBgColorKey;
  late GlobalKey<ElTooltipState> _fontColorKey;
  late GlobalKey<ElTooltipState> _tablePickerKey;
  EdgeInsetsGeometry _buttonPadding = const EdgeInsets.all(6);

  @override
  void initState() {
    _fontBgColorKey = GlobalKey<ElTooltipState>(
        debugLabel: 'fontBgColorKey${widget.controller.hashCode.toString()}');
    _fontColorKey = GlobalKey<ElTooltipState>(
        debugLabel: 'fontColorKey${widget.controller.hashCode.toString()}');
    _tablePickerKey = GlobalKey<ElTooltipState>(
        debugLabel: '_tablePickerKey${widget.controller.hashCode.toString()}');

    if (widget.padding != null) {
      _buttonPadding = widget.padding!;
    }
    if (widget.toolBarConfig == null || widget.toolBarConfig!.isEmpty) {
      for (var style in ToolBarStyle.values) {
        _toolbarList.add(ToolBarItem(
          activeIconColor: widget.activeIconColor!,
          iconColor: widget.iconColor!,
          iconSize: widget.iconSize!,
          style: style,
          isActive: false,
          padding: _buttonPadding,
        ));
      }
    } else {
      for (var style in widget.toolBarConfig!) {
        _toolbarList.add(ToolBarItem(
            activeIconColor: widget.activeIconColor!,
            iconColor: widget.iconColor!,
            iconSize: widget.iconSize!,
            style: style,
            isActive: false,
            padding: _buttonPadding));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isScrollable!) {
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: widget.toolBarColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: widget.direction,
          child: Flex(
            direction: widget.direction,
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: widget.textDirection,
            verticalDirection: widget.verticalDirection,
            clipBehavior: widget.clipBehavior,
            children: _generateToolBar(context),
          ),
        ),
      );
    }
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: widget.toolBarColor,
      ),
      child: Wrap(
        direction: widget.direction,
        alignment: widget.alignment,
        spacing: widget.spacing,
        runAlignment: widget.runAlignment,
        runSpacing: widget.runSpacing,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        clipBehavior: widget.clipBehavior,
        children: _generateToolBar(context),
      ),
    );
  }

  ///[updateToolBarFormat] method to update the toolbar state in sync with editor formats
  void updateToolBarFormat(Map<String, dynamic> formatMap) {
    _formatMap = formatMap;
    for (int i = 0; i < _toolbarList.length; i++) {
      switch (_toolbarList[i].style) {
        case ToolBarStyle.bold:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['bold'] == true);
          break;
        case ToolBarStyle.italic:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['italic'] == true);
          break;
        case ToolBarStyle.underline:
          _toolbarList[i] = _toolbarList[i]
              .copyWith(isActive: formatMap['underline'] == true);
          break;
        case ToolBarStyle.strike:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['strike'] == true);
          break;
        case ToolBarStyle.blockQuote:
          _toolbarList[i] = _toolbarList[i]
              .copyWith(isActive: formatMap['blockquote'] == true);
          break;
        case ToolBarStyle.codeBlock:
          _toolbarList[i] = _toolbarList[i]
              .copyWith(isActive: formatMap['code-block'] == true);
          break;
        case ToolBarStyle.indentMinus:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['indent'] != null);
          break;
        case ToolBarStyle.indentAdd:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['indent'] != null);
          break;
        case ToolBarStyle.directionRtl:
          _toolbarList[i] = _toolbarList[i]
              .copyWith(isActive: formatMap['direction'] == 'rtl');
          break;
        case ToolBarStyle.directionLtr:
          _toolbarList[i] = _toolbarList[i]
              .copyWith(isActive: formatMap['direction'] != 'rtl');
          break;
        case ToolBarStyle.size:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['size'] != null);
          break;
        case ToolBarStyle.headerOne:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['header'] == 1);
          break;
        case ToolBarStyle.headerTwo:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['header'] == 2);
          break;
        case ToolBarStyle.color:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['color'] != null);
          try {
            if (formatMap['color'] != null) {
              if (formatMap['color'].runtimeType.toString() ==
                  'List<dynamic>') {
                _formatMap['color'] = formatMap['color'][0];
              } else {
                _formatMap['color'] = formatMap['color'];
              }
            }
          } catch (e) {
            if (!kReleaseMode) {
              debugPrint(e.toString());
            }
          }
          break;
        case ToolBarStyle.align:
          formatMap['align'] ??= '';
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['align'] != null);
          break;
        case ToolBarStyle.listOrdered:
          _toolbarList[i] = _toolbarList[i]
              .copyWith(isActive: formatMap['list'] == 'ordered');
          break;
        case ToolBarStyle.listBullet:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['list'] == 'bullet');
          break;
        case ToolBarStyle.image:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['image'] != null);
          break;
        case ToolBarStyle.video:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['video'] != null);
          break;
        case ToolBarStyle.clean:
          _toolbarList[i] =
              _toolbarList[i].copyWith(isActive: formatMap['clean'] != null);
          break;
        case ToolBarStyle.background:
          _toolbarList[i] = _toolbarList[i]
              .copyWith(isActive: formatMap['background'] != null);
          try {
            if (formatMap['background'] != null) {
              if (formatMap['background'].runtimeType.toString() ==
                  'List<dynamic>') {
                _formatMap['background'] = formatMap['background'][0];
              } else {
                _formatMap['background'] = formatMap['background'];
              }
            }
          } catch (e) {
            if (!kReleaseMode) {
              debugPrint(e.toString());
            }
          }
          break;
        case ToolBarStyle.link:
          _formatMap['link'] = formatMap['link'];
          break;
        case ToolBarStyle.undo:
        case ToolBarStyle.redo:
        case ToolBarStyle.editTable:
        case ToolBarStyle.addTable:
        case ToolBarStyle.clearHistory:
        case ToolBarStyle.separator:
          break;
      }
    }
    setState(() {});
  }

  List<Widget> _generateToolBar(BuildContext context) {
    List<Widget> tempToolBarList = [];

    for (int i = 0; i < _toolbarList.length; i++) {
      var toolbarItem = _toolbarList[i];
      if (toolbarItem.style == ToolBarStyle.size) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: _fontSizeDD(),
        ));
      } else if (toolbarItem.style == ToolBarStyle.align) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: SizedBox(
              width: widget.iconSize,
              height: widget.iconSize,
              child: _alignDD()),
        ));
      } else if (toolbarItem.style == ToolBarStyle.color) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: SizedBox(
              width: widget.iconSize,
              height: widget.iconSize,
              child: _getFontColorWidget(i)),
        ));
      } else if (toolbarItem.style == ToolBarStyle.video) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: InputUrlWidget(
            iconWidget: SizedBox(
              width: widget.iconSize! - 2,
              height: widget.iconSize! - 2,
              child: Image.asset(
                ImageConstant.kiCameraRollPng,
                color: widget.iconColor,
              ),
            ),
            isActive: _formatMap['video'] != null,
            controller: widget.controller,
            type: UrlInputType.video,
            onSubmit: (v) {
              widget.controller.embedVideo(v);
            },
          ),
        ));
      } else if (toolbarItem.style == ToolBarStyle.link) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: InputUrlWidget(
            iconWidget: Icon(
              Icons.link,
              color: widget.iconColor,
              size: widget.iconSize,
            ),
            isActive: _formatMap['link'] != null,
            controller: widget.controller,
            type: UrlInputType.hyperlink,
            onSubmit: (v) {
              widget.controller.setFormat(format: 'link', value: v);
            },
          ),
        ));
      } else if (toolbarItem.style == ToolBarStyle.background) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: SizedBox(
              width: widget.iconSize,
              height: widget.iconSize,
              child: _getFontBackgroundColorWidget(i)),
        ));
      } else if (toolbarItem.style == ToolBarStyle.addTable) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: SizedBox(
              width: widget.iconSize,
              height: widget.iconSize,
              child: _getTablePickerWidget(i, context)),
        ));
      } else if (toolbarItem.style == ToolBarStyle.editTable) {
        tempToolBarList.add(EditTableDropDown(
          padding: _buttonPadding,
          iconColor: widget.iconColor!,
          iconSize: widget.iconSize!,
          dropDownColor: widget.toolBarColor!,
          onOptionSelected: (type) => widget.controller.modifyTable(type),
        ));
      } else if (toolbarItem.style == ToolBarStyle.separator) {
        if (widget.direction == Axis.horizontal) {
          tempToolBarList.add(Padding(
            padding: _buttonPadding,
            child: Container(
              height: widget.iconSize,
              width: 0.8,
              color: widget.iconColor,
            ),
          ));
        } else {
          tempToolBarList.add(Padding(
            padding: _buttonPadding,
            child: Container(
              width: widget.iconSize,
              height: 0.8,
              color: widget.iconColor,
            ),
          ));
        }
      } else {
        tempToolBarList.add(ToolBarItem(
          activeIconColor: widget.activeIconColor!,
          iconColor: widget.iconColor!,
          iconSize: widget.iconSize!,
          padding: _buttonPadding,
          style: toolbarItem.style,
          isActive: toolbarItem.isActive,
          onTap: () async {
            if (toolbarItem.style == ToolBarStyle.clearHistory) {
              widget.controller.clearHistory();
            } else if (toolbarItem.style == ToolBarStyle.undo) {
              widget.controller.undo();
            } else if (toolbarItem.style == ToolBarStyle.redo) {
              widget.controller.redo();
            } else if (toolbarItem.style == ToolBarStyle.image) {
              await ImageSelector(onImagePicked: (value) {
                _formatMap['image'] = value;
                widget.controller.embedImage(value);
              }).pickFiles();
            } else if (toolbarItem.style == ToolBarStyle.clean) {
              List<ToolBarItem> tempList = [];
              for (var value in _toolbarList) {
                value = value.copyWith(isActive: false);
                tempList.add(value);
              }
              _toolbarList = tempList;
            } else if (toolbarItem.style == ToolBarStyle.headerOne) {
              for (var element in _toolbarList) {
                if (element.style == ToolBarStyle.headerTwo) {
                  element = element.copyWith(isActive: false);
                }
              }
              toolbarItem =
                  toolbarItem.copyWith(isActive: !toolbarItem.isActive);
            } else if (toolbarItem.style == ToolBarStyle.headerTwo) {
              for (var element in _toolbarList) {
                if (element.style == ToolBarStyle.headerOne) {
                  element = element.copyWith(isActive: false);
                }
              }
              toolbarItem =
                  toolbarItem.copyWith(isActive: !toolbarItem.isActive);
            } else {
              toolbarItem =
                  toolbarItem.copyWith(isActive: !toolbarItem.isActive);
            }
            Map<String, dynamic> getFormat =
                _getFormatByStyle(toolbarItem.style, toolbarItem.isActive);
            widget.controller.setFormat(
                format: getFormat['format'], value: getFormat['value']);

            if (_formatMap['direction'] == 'rtl') {
              widget.controller.setFormat(format: 'align', value: 'right');
            }
            setState(() {});
          },
        ));
      }
    }
    if (widget.customButtons != null && widget.customButtons!.isNotEmpty) {
      for (var element in widget.customButtons!) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: element,
        ));
      }
    }
    return tempToolBarList;
  }

  Map<String, dynamic> _getFormatByStyle(ToolBarStyle style, bool isActive) {
    switch (style) {
      case ToolBarStyle.bold:
        return {'format': 'bold', 'value': isActive};
      case ToolBarStyle.italic:
        return {'format': 'italic', 'value': isActive};
      case ToolBarStyle.underline:
        return {'format': 'underline', 'value': isActive};
      case ToolBarStyle.strike:
        return {'format': 'strike', 'value': isActive};
      case ToolBarStyle.blockQuote:
        return {'format': 'blockquote', 'value': isActive};
      case ToolBarStyle.codeBlock:
        return {'format': 'code-block', 'value': isActive};
      case ToolBarStyle.indentAdd:
        return {'format': 'indent', 'value': '+1'};
      case ToolBarStyle.indentMinus:
        return {'format': 'indent', 'value': '-1'};
      case ToolBarStyle.directionRtl:
        return {'format': 'direction', 'value': 'rtl'};
      case ToolBarStyle.directionLtr:
        return {'format': 'direction', 'value': ''};
      case ToolBarStyle.size:
        return {'format': 'size', 'value': 'small'};
      case ToolBarStyle.color:
        return {'format': 'color', 'value': 'red'};
      case ToolBarStyle.align:
        return {'format': 'align', 'value': 'right'};
      case ToolBarStyle.listOrdered:
        return {'format': 'list', 'value': isActive ? 'ordered' : ''};
      case ToolBarStyle.listBullet:
        return {'format': 'list', 'value': isActive ? 'bullet' : ''};
      case ToolBarStyle.image:
        return {'format': 'image', 'value': ''};
      case ToolBarStyle.video:
        return {'format': 'video', 'value': ''};
      case ToolBarStyle.clean:
        return {'format': 'clean', 'value': ''};
      case ToolBarStyle.headerOne:
        return {'format': 'header', 'value': isActive ? 1 : 4};
      case ToolBarStyle.headerTwo:
        return {'format': 'header', 'value': isActive ? 2 : 4};
      case ToolBarStyle.background:
        return {'format': 'background', 'value': 'red'};
      case ToolBarStyle.link:
        return {'format': 'link', 'value': ''};
      case ToolBarStyle.undo:
      case ToolBarStyle.redo:
      case ToolBarStyle.clearHistory:
      case ToolBarStyle.editTable:
      case ToolBarStyle.addTable:
      case ToolBarStyle.separator:
        return {'format': 'undo', 'value': ''};
    }
  }

  Widget _fontSizeDD() {
    return FittedBox(
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          padding: EdgeInsets.zero,
          child: DropdownButton(
              dropdownColor: widget.toolBarColor,
              alignment: Alignment.centerLeft,
              selectedItemBuilder: (context) {
                return [
                  _fontSelectionTextItem(type: 'Small'),
                  _fontSelectionTextItem(type: 'Normal'),
                  _fontSelectionTextItem(type: 'Large'),
                  _fontSelectionTextItem(type: 'Huge'),
                ];
              },
              isDense: true,
              value: _formatMap['size'] ?? 'normal',
              style: TextStyle(fontSize: 12, color: widget.iconColor!),
              items: [
                _fontSizeItem(type: 'Small', fontSize: 8),
                _fontSizeItem(type: 'Normal', fontSize: 12),
                _fontSizeItem(type: 'Large', fontSize: 16),
                _fontSizeItem(type: 'Huge', fontSize: 20),
              ],
              onChanged: (value) {
                _formatMap['size'] = value;
                widget.controller.setFormat(
                    format: 'size', value: value == 'normal' ? '' : value);
                setState(() {});
              }),
        ),
      ),
    );
  }

  DropdownMenuItem _fontSizeItem(
      {required String type, required double fontSize}) {
    return DropdownMenuItem(
        value: type.toLowerCase(),
        child: WebViewAware(
          child: Text(type,
              style: TextStyle(
                  fontSize: fontSize,
                  color: _formatMap['size'] == type.toLowerCase()
                      ? widget.activeIconColor
                      : widget.iconColor!,
                  fontWeight: FontWeight.bold)),
        ));
  }

  Widget _fontSelectionTextItem({
    required String type,
  }) {
    return SizedBox(
      child: Text(type,
          style: TextStyle(
              fontSize: 14,
              color: type.toLowerCase() != 'normal'
                  ? widget.activeIconColor
                  : widget.iconColor!,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _alignDD() {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        padding: EdgeInsets.zero,
        child: DropdownButton<String>(
            dropdownColor: widget.toolBarColor,
            icon: const SizedBox(
              width: 0,
            ),
            focusColor: Colors.transparent,
            alignment: Alignment.bottomCenter,
            isDense: true,
            value: (_formatMap['align'] == '' || _formatMap['align'] == null)
                ? 'left'
                : _formatMap['align'],
            items: [
              _getAlignDDItem('left'),
              _getAlignDDItem('center'),
              _getAlignDDItem('right'),
              _getAlignDDItem('justify'),
            ],
            onChanged: (value) {
              _formatMap['align'] = value == 'left' ? '' : value;
              widget.controller
                  .setFormat(format: 'align', value: _formatMap['align']);
              setState(() {});
            }),
      ),
    );
  }

  DropdownMenuItem<String> _getAlignDDItem(String type) {
    IconData icon = Icons.format_align_left;
    if (type == 'center') {
      icon = Icons.format_align_center;
    } else if (type == 'right') {
      icon = Icons.format_align_right;
    } else if (type == 'justify') {
      icon = Icons.format_align_justify;
    }
    return DropdownMenuItem<String>(
      value: type,
      child: WebViewAware(
        child: Icon(
          icon,
          color: _formatMap['align'] == type
              ? widget.activeIconColor
              : widget.iconColor,
          size: widget.iconSize,
        ),
      ),
    );
  }

  Widget _getFontColorWidget(int i) {
    return ElTooltip(
      onTap: () {
        if (_fontColorKey.currentState != null) {
          _fontColorKey.currentState!.showOverlayOnTap();
        }
      },
      key: _fontColorKey,
      content: ColorPicker(
        onColorPicked: (color) {
          _formatMap['color'] = color;
          _toolbarList[i] = _toolbarList[i].copyWith(isActive: true);
          widget.controller
              .setFormat(format: 'color', value: _formatMap['color']);
          setState(() {});
          if (_fontColorKey.currentState != null) {
            _fontColorKey.currentState!.hideOverlay();
          }
        },
      ),
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: widget.iconSize,
          height: widget.iconSize,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'A',
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _formatMap['color'] != null
                          ? widget.activeIconColor
                          : widget.iconColor,
                      fontSize: widget.iconSize! - 5),
                ),
              ),
              Container(
                color: _formatMap['color'] != null
                    ? HexColor.fromHex(_formatMap['color'])
                    : Colors.black,
                height: 3,
                width: widget.iconSize! - 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFontBackgroundColorWidget(int i) {
    return ElTooltip(
      onTap: () {
        if (_fontBgColorKey.currentState != null) {
          _fontBgColorKey.currentState!.showOverlayOnTap();
        }
      },
      key: _fontBgColorKey,
      content: ColorPicker(
        onColorPicked: (color) {
          _formatMap['background'] = color;
          _toolbarList[i] = _toolbarList[i].copyWith(isActive: true);

          widget.controller
              .setFormat(format: 'background', value: _formatMap['background']);
          setState(() {});
          if (_fontBgColorKey.currentState != null) {
            _fontBgColorKey.currentState!.hideOverlay();
          }
        },
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 0.1),
            color: _formatMap['background'] != null
                ? HexColor.fromHex(_formatMap['background'])
                : Colors.transparent,
          ),
          height: widget.iconSize,
          width: widget.iconSize,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              'A',
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _formatMap['background'] != null
                      ? widget.activeIconColor
                      : widget.iconColor,
                  fontSize: widget.iconSize! - 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTablePickerWidget(int i, BuildContext context) {
    return ElTooltip(
      color: widget.toolBarColor!,
      distance: 0,
      onTap: () {
        if (MediaQuery.of(context).size.width < 480) {
          _showTablePickerDialog(context);
        } else {
          if (_tablePickerKey.currentState != null) {
            _tablePickerKey.currentState!.showOverlayOnTap();
          }
        }
      },
      key: _tablePickerKey,
      content: SizedBox(
        height: 200,
        child: TablePicker(
          onTablePicked: (int row, int column) {
            widget.controller.insertTable(row, column);
            if (_tablePickerKey.currentState != null) {
              _tablePickerKey.currentState!.hideOverlay();
            }
          },
        ),
      ),
      child: SizedBox(
        width: widget.iconSize,
        height: widget.iconSize,
        child: Image.asset(
          ImageConstant.kiInsertTablePng,
          color: widget.iconColor,
        ),
      ),
    );
  }

  void _showTablePickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            content: WebViewAware(
              child: Builder(
                builder: (context) {
                  return SizedBox(
                    width: 300,
                    height: 310,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            const Expanded(
                                child: Text(
                              'Select Rows x Columns',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                            IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close))
                          ],
                        ),
                        Expanded(
                          child: TablePicker(
                            rowCount: 8,
                            width: 300,
                            onTablePicked: (int row, int column) {
                              widget.controller.insertTable(row, column);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

///[ToolBarItem] toolbaritem widget to show buttons based on style
@immutable
class ToolBarItem extends StatelessWidget {
  ///[style] to set the toolbar buttons by styles
  final ToolBarStyle style;

  ///[isActive] to highlight the toolbar buttons when active
  final bool isActive;

  ///[onTap] callback to set format on tap
  final GestureTapCallback? onTap;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry padding;

  ///[iconSize] to define the toolbar icon size
  final double iconSize;

  ///[iconColor] to define the toolbar icon color
  final Color iconColor;

  ///[activeIconColor] to define the active toolbar icon color
  final Color? activeIconColor;

  ///[ToolBarItem] toolbaritem widget to show buttons based on style
  const ToolBarItem({
    super.key,
    required this.style,
    required this.isActive,
    required this.padding,
    required this.iconSize,
    required this.iconColor,
    required this.activeIconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: SizedBox(child: _getIconByStyle(style)),
      ),
    );
  }

  Widget _getIconByStyle(ToolBarStyle style) {
    switch (style) {
      case ToolBarStyle.bold:
        return _getIconWidget(Icons.format_bold_sharp);
      case ToolBarStyle.italic:
        return _getIconWidget(Icons.format_italic_sharp);
      case ToolBarStyle.underline:
        return _getIconWidget(Icons.format_underline_sharp);
      case ToolBarStyle.strike:
        return _getIconWidget(Icons.format_strikethrough_sharp);
      case ToolBarStyle.blockQuote:
        return _getIconWidget(Icons.format_quote_sharp);
      case ToolBarStyle.codeBlock:
        return _getIconWidget(Icons.code_sharp);
      case ToolBarStyle.indentAdd:
        //isActive = false;
        return _getIconWidget(Icons.format_indent_increase_sharp);
      case ToolBarStyle.indentMinus:
        //  isActive = false;
        return _getIconWidget(Icons.format_indent_decrease_sharp);
      case ToolBarStyle.directionRtl:
        return _getIconWidget(Icons.format_textdirection_r_to_l_sharp);
      case ToolBarStyle.directionLtr:
        return _getIconWidget(Icons.format_textdirection_l_to_r_sharp);
      case ToolBarStyle.color:
        return _getIconWidget(Icons.format_bold_sharp);
      case ToolBarStyle.align:
        return _getIconWidget(Icons.format_align_left_sharp);
      case ToolBarStyle.clean:
        return _getIconWidget(Icons.format_clear_sharp);
      case ToolBarStyle.listOrdered:
        return _getIconWidget(Icons.format_list_numbered_sharp);
      case ToolBarStyle.listBullet:
        return _getIconWidget(Icons.format_list_bulleted_sharp);
      case ToolBarStyle.headerOne:
        return _getAssetImageWidget(ImageConstant.kiHeaderOneDarkPng);
      case ToolBarStyle.headerTwo:
        return _getAssetImageWidget(ImageConstant.kiHeaderTwoDarkPng);
      case ToolBarStyle.background:
        return _getIconWidget(Icons.font_download_sharp);
      case ToolBarStyle.image:
        return _getIconWidget(Icons.image);
      case ToolBarStyle.undo:
        return _getIconWidget(Icons.undo_sharp);
      case ToolBarStyle.redo:
        return _getIconWidget(Icons.redo_sharp);
      case ToolBarStyle.clearHistory:
        return _getIconWidget(Icons.layers_clear_sharp);
      case ToolBarStyle.link:
      case ToolBarStyle.video:
      case ToolBarStyle.size:
      case ToolBarStyle.addTable:
      case ToolBarStyle.editTable:
      case ToolBarStyle.separator:
        return const SizedBox();
    }
  }

  Icon _getIconWidget(IconData iconData) => Icon(
        iconData,
        color: isActive ? activeIconColor : iconColor,
        size: iconSize,
      );

  Widget _getAssetImageWidget(String imagePath) => SizedBox(
        width: iconSize,
        height: iconSize,
        child: Image.asset(
          imagePath,
          color: isActive ? activeIconColor : iconColor,
        ),
      );

  ///toolbar item copyWith function
  ToolBarItem copyWith({
    bool? isActive,
  }) {
    return ToolBarItem(
        style: style,
        isActive: isActive ?? this.isActive,
        padding: padding,
        iconSize: iconSize,
        iconColor: iconColor,
        activeIconColor: activeIconColor);
  }
}

///[ToolBarStyle] an enum with multiple toolbar styles, to define required toolbar styles in custom config

enum ToolBarStyle {
  ///[bold] sets bold format
  bold,

  /// [italic] sets italic format

  italic,

  /// [underline] sets underline to text

  underline,

  /// [strike] makes the selected text strikethrough

  strike,

  /// [blockQuote] converts text to quote

  blockQuote,

  /// [codeBlock] makes selected text code block

  codeBlock,

  /// [indentMinus] decreases the indent by given value

  indentMinus,

  /// [indentAdd] increases the indent by given value

  indentAdd,

  /// [directionRtl] sets the direction of text from Right to Left

  directionRtl,

  /// [directionLtr] sets the direction of text from Left to Right

  directionLtr,

  /// [headerOne] makes the text H1

  headerOne,

  /// [headerTwo] makes the text H2

  headerTwo,

  /// [color] sets font color

  color,

  /// [background] sets background color to text

  background,

  /// [align] adds alignment to text, left, right, center, justify

  align,

  /// [listOrdered] adds numbered/alphabets list to the text

  listOrdered,

  /// [listBullet] makes text as bullet points

  listBullet,

  /// [size] sets fontSize of the text

  size,

  /// [link] sets hyperlink to selected text

  link,

  /// [image] embeds image to the editor

  image,

  /// [video] embeds Youtube, Vimeo or other network videos to editor

  video,

  /// [clean] clears all formats of editor, (for internal use case)
  clean,

  /// [undo] to undo the editor change
  undo,

  /// [redo] to undo the editor change
  redo,

  /// [clearHistory] to undo the editor change
  clearHistory,

  /// [addTable] to add table to the editor
  addTable,

  /// [editTable] to edit rows, columns or delete table
  editTable,

  ///[separator] to add divider between toolbar items
  separator

  ///font - later releases
}

/***
    ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
    ['blockquote', 'code-block'],

    [{ 'header': 1 }, { 'header': 2 }],               // custom button values
    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
    [{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript
    [{ 'indent': '-1'}, { 'indent': '+1' }],          // outdent/indent
    [{ 'direction': 'rtl' }],                         // text direction

    [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown
    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

    [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
    [{ 'font': [] }],
    [{ 'align': [] }],

    ['clean']
 ***/
