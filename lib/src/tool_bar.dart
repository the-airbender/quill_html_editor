import 'dart:core';

import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quill_html_editor/src/utils/hex_color.dart';
import 'package:quill_html_editor/src/widgets/color_picker.dart';
import 'package:quill_html_editor/src/widgets/image_picker.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

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

  ///[ToolBar] widget to show the quill toolbar
  ToolBar({
    this.toolBarConfig,
    required this.controller,
    this.customButtons,
    this.padding,
  }) : super(
          key: controller.toolBarKey,
        );

  /// [padding] The amount of space by which to inset the toolbar style widgets.
  final EdgeInsetsGeometry? padding;

  @override
  State<ToolBar> createState() => ToolBarState();
}

class ToolBarState extends State<ToolBar> {
  List<ToolBarItem> _toolbarList = [];
  Map<String, dynamic> _formatMap = {};
  final GlobalKey<ElTooltipState> _fontBgColorKey =
      GlobalKey<ElTooltipState>(debugLabel: 'fontBgColorKey');
  final GlobalKey<ElTooltipState> _fontColorKey =
      GlobalKey<ElTooltipState>(debugLabel: 'fontColorKey');
  EdgeInsetsGeometry _buttonPadding = const EdgeInsets.all(6);

  @override
  void initState() {
    if (widget.padding != null) {
      _buttonPadding = widget.padding!;
    }
    if (widget.toolBarConfig == null) {
      for (var style in ToolBarStyle.values) {
        _toolbarList.add(ToolBarItem(
          style: style,
          isActive: false,
          padding: _buttonPadding,
        ));
      }
    } else {
      for (var style in widget.toolBarConfig!) {
        _toolbarList.add(ToolBarItem(
            style: style, isActive: false, padding: _buttonPadding));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _generateToolBar(context),
    );
  }

  ///[updateToolBarFormat] method to update the toolbar state in sync with editor formats
  void updateToolBarFormat(Map<String, dynamic> formatMap) {
    _formatMap = formatMap;

    for (var toolbarItem in _toolbarList) {
      switch (toolbarItem.style) {
        case ToolBarStyle.bold:
          toolbarItem.isActive = formatMap['bold'] == true;
          break;
        case ToolBarStyle.italic:
          toolbarItem.isActive = formatMap['italic'] == true;
          break;
        case ToolBarStyle.underline:
          toolbarItem.isActive = formatMap['underline'] == true;
          break;
        case ToolBarStyle.strike:
          toolbarItem.isActive = formatMap['strike'] == true;
          break;
        case ToolBarStyle.blockQuote:
          toolbarItem.isActive = formatMap['blockquote'] == true;
          break;
        case ToolBarStyle.codeBlock:
          toolbarItem.isActive = formatMap['code-block'] == true;
          break;
        case ToolBarStyle.indentMinus:
          toolbarItem.isActive = formatMap['indent'] != null;
          break;
        case ToolBarStyle.indentAdd:
          toolbarItem.isActive = formatMap['indent'] != null;
          break;
        case ToolBarStyle.directionRtl:
          toolbarItem.isActive = formatMap['direction'] == 'rtl';
          break;
        case ToolBarStyle.directionLtr:
          toolbarItem.isActive = formatMap['direction'] != 'rtl';
          break;
        case ToolBarStyle.size:
          toolbarItem.isActive = formatMap['size'] != null;
          break;
        case ToolBarStyle.headerOne:
          toolbarItem.isActive = formatMap['header'] == 1;
          break;
        case ToolBarStyle.headerTwo:
          toolbarItem.isActive = formatMap['header'] == 2;
          break;
        case ToolBarStyle.color:
          toolbarItem.isActive = formatMap['color'] != null;
          if (formatMap['color'] != null) {
            _formatMap['color'] = formatMap['color'];
          }
          break;
        case ToolBarStyle.align:
          formatMap['align'] ??= '';
          toolbarItem.isActive = formatMap['align'] != null;
          break;
        case ToolBarStyle.listOrdered:
          toolbarItem.isActive = formatMap['list'] == 'ordered';
          break;
        case ToolBarStyle.listBullet:
          toolbarItem.isActive = formatMap['list'] == 'bullet';
          break;
        case ToolBarStyle.image:
          toolbarItem.isActive = formatMap['image'] != null;
          break;
        case ToolBarStyle.video:
          toolbarItem.isActive = formatMap['video'] != null;
          break;
        case ToolBarStyle.clean:
          toolbarItem.isActive = formatMap['clean'] != null;
          break;
        case ToolBarStyle.background:
          toolbarItem.isActive = formatMap['background'] != null;
          if (formatMap['background'] != null) {
            _formatMap['background'] = formatMap['background'];
          }
          break;
        case ToolBarStyle.link:
          _formatMap['link'] = formatMap['link'];
          break;
      }
    }
    setState(() {});
  }

  List<Widget> _generateToolBar(BuildContext context) {
    List<Widget> tempToolBarList = [];

    for (int i = 0; i < _toolbarList.length; i++) {
      final toolbarItem = _toolbarList[i];
      if (toolbarItem.style == ToolBarStyle.size) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: _fontSizeDD(),
        ));
      } else if (toolbarItem.style == ToolBarStyle.align) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: _alignDD(),
        ));
      } else if (toolbarItem.style == ToolBarStyle.color) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: _getFontColorWidget(i),
        ));
      } else if (toolbarItem.style == ToolBarStyle.video) {
        tempToolBarList.add(Padding(
          padding: _buttonPadding,
          child: InputUrlWidget(
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
          child: _getFontBackgndColorWidget(i),
        ));
      } else {
        tempToolBarList.add(ToolBarItem(
          padding: _buttonPadding,
          style: toolbarItem.style,
          isActive: toolbarItem.isActive,
          onTap: () async {
            if (toolbarItem.style == ToolBarStyle.image) {
              await ImageSelector(onImagePicked: (value) {
                _formatMap['image'] = value;
                widget.controller.embedImage(value);
              }).pickFiles();
            } else if (toolbarItem.style == ToolBarStyle.clean) {
              List<ToolBarItem> tempList = [];
              for (var value in _toolbarList) {
                value.isActive = false;
                tempList.add(value);
              }
              _toolbarList = tempList;
            } else if (toolbarItem.style == ToolBarStyle.headerOne) {
              for (var element in _toolbarList) {
                if (element.style == ToolBarStyle.headerTwo) {
                  element.isActive = false;
                }
              }
              toolbarItem.isActive = !toolbarItem.isActive;
            } else if (toolbarItem.style == ToolBarStyle.headerTwo) {
              for (var element in _toolbarList) {
                if (element.style == ToolBarStyle.headerOne) {
                  element.isActive = false;
                }
              }
              toolbarItem.isActive = !toolbarItem.isActive;
            } else {
              toolbarItem.isActive = !toolbarItem.isActive;
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
    }
  }

  Widget _fontSizeDD() {
    return FittedBox(
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          padding: EdgeInsets.zero,
          child: DropdownButton(
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
              style: const TextStyle(
                fontSize: 12,
              ),
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
                      ? Colors.blue
                      : Colors.black87,
                  fontWeight: FontWeight.bold)),
        ));
  }

  Widget _fontSelectionTextItem({
    required String type,
  }) {
    return SizedBox(
      width: 55,
      child: Text(type,
          style: TextStyle(
              fontSize: 14,
              color:
                  type.toLowerCase() != 'normal' ? Colors.blue : Colors.black87,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _alignDD() {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButton<String>(
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
        color: _formatMap['align'] == type ? Colors.blue : Colors.black,
      )),
    );
  }

  Widget _getFontColorWidget(int i) {
    return ElTooltip(
      onTap: () {
        if (_fontColorKey.currentState != null) {
          _fontColorKey.currentState!.showOverlayOnTap();
        }
      },
      position: ElTooltipPosition.bottomEnd,
      key: _fontColorKey,
      content: ColorPicker(
        onColorPicked: (color) {
          _formatMap['color'] = color;
          _toolbarList[i].isActive = true;
          widget.controller
              .setFormat(format: 'color', value: _formatMap['color']);
          setState(() {});
          if (_fontColorKey.currentState != null) {
            _fontColorKey.currentState!.hideOverlay();
          }
        },
      ),
      child: SizedBox(
        width: 25,
        height: 25,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A',
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      _formatMap['color'] != null ? Colors.blue : Colors.black,
                  fontSize: 14),
            ),
            Container(
              color: _formatMap['color'] != null
                  ? HexColor.fromHex(_formatMap['color'])
                  : Colors.black,
              height: 3,
              width: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFontBackgndColorWidget(int i) {
    return ElTooltip(
      position: ElTooltipPosition.bottomEnd,
      onTap: () {
        if (_fontBgColorKey.currentState != null) {
          _fontBgColorKey.currentState!.showOverlayOnTap();
        }
      },
      key: _fontBgColorKey,
      content: ColorPicker(
        onColorPicked: (color) {
          _formatMap['background'] = color;
          _toolbarList[i].isActive = true;
          widget.controller
              .setFormat(format: 'background', value: _formatMap['background']);
          setState(() {});
          if (_fontBgColorKey.currentState != null) {
            _fontBgColorKey.currentState!.hideOverlay();
          }
        },
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 0.1),
          color: _formatMap['background'] != null
              ? HexColor.fromHex(_formatMap['background'])
              : Colors.white,
        ),
        height: 22,
        width: 22,
        child: Text(
          'A',
          maxLines: 1,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _formatMap['background'] != null
                  ? Colors.white
                  : Colors.black,
              fontSize: 16),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ToolBarItem extends StatelessWidget {
  ///[style] to set the toolbar buttons by styles
  final ToolBarStyle style;

  ///[isActive] to highlight the toolbar buttons when active
  bool isActive;

  ///[onTap] callback to set format on tap
  final GestureTapCallback? onTap;

  /// The amount of space by which to inset the child.
  EdgeInsetsGeometry padding;

  ///[ToolBarItem] toolbaritem widget to show buttons based on style
  ToolBarItem({
    super.key,
    required this.style,
    required this.isActive,
    required this.padding,
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
        isActive = false;
        return _getIconWidget(Icons.format_indent_increase_sharp);
      case ToolBarStyle.indentMinus:
        isActive = false;
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
        return _getTextToolBarStyle('H1');
      case ToolBarStyle.headerTwo:
        return _getTextToolBarStyle('H2');
      case ToolBarStyle.background:
        return _getIconWidget(Icons.font_download_sharp);
      case ToolBarStyle.image:
        return _getIconWidget(Icons.image);
      case ToolBarStyle.link:
      case ToolBarStyle.video:
      case ToolBarStyle.size:
        return const SizedBox();
    }
  }

  Icon _getIconWidget(IconData iconData) => Icon(
        iconData,
        color: isActive ? Colors.blue : Colors.black87,
        size: 22,
      );

  Widget _getTextToolBarStyle(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      child: FittedBox(
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.blue : Colors.black87,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}

///[ToolBarConfig] class to configure, toggle toolbar styles
class ToolBarConfig {
  bool bold;
  bool italic;
  bool underline;
  bool strike;
  bool blockQuote;
  bool codeBlock;
  bool indentAdd;
  bool indentMinus;
  bool directionRtl;
  bool directLtr;
  bool size;
  bool header;
  bool color;
  bool font;
  bool align;
  bool clean;
  bool listOrdered;
  bool listBullet;
  bool link;
  bool image;
  bool video;

  ///[ToolBarConfig] to enable or disable the toolbar styles
  ToolBarConfig(
      {this.bold = false,
      this.italic = false,
      this.underline = false,
      this.strike = false,
      this.blockQuote = false,
      this.codeBlock = false,
      this.indentAdd = false,
      this.indentMinus = false,
      this.directionRtl = false,
      this.directLtr = false,
      this.size = false,
      this.header = false,
      this.color = false,
      this.font = false,
      this.align = false,
      this.clean = false,
      this.listOrdered = false,
      this.listBullet = false,
      this.image = false,
      this.video = false,
      this.link = false});
}

///[ToolBarStyle] an enum with multiple toolbar styles, to define required toolbar styles in custom config
enum ToolBarStyle {
  bold,
  italic,
  underline,
  strike,
  blockQuote,
  codeBlock,
  indentMinus,
  indentAdd,
  directionRtl,
  directionLtr,
  headerOne,
  headerTwo,
  color,
  background,
  align,
  listOrdered,
  listBullet,
  size,
  link,
  image,
  video,
  clean,

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
