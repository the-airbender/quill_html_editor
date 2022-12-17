import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import '../../quill_html_editor.dart';
import '../constants/image_constants.dart';
import '../utils/hex_color.dart';
import '../utils/url_validator.dart';
import 'el_tooltip/el_tooltip.dart';

///[InputUrlWidget] class to show widget that capture video/hyperlink urls
class InputUrlWidget extends StatefulWidget {
  ///[onSubmit] callback when user submits the url input
  final Function(String) onSubmit;

  ///[UrlInputType] for input types video, hyperlink
  final UrlInputType type;

  ///[controller] editor controller to access internal apis
  final QuillEditorController controller;

  ///[isActive] to highlight icon on selection
  final bool isActive;

  ///[InputUrlWidget] constructor of input url widget to capture, video/hyperlink urls
  const InputUrlWidget(
      {super.key,
      required this.onSubmit,
      required this.type,
      required this.controller,
      required this.isActive});
  @override
  State<StatefulWidget> createState() {
    return _InputUrlWidgetState();
  }
}

class _InputUrlWidgetState extends State<InputUrlWidget> {
  /// declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  /// declare a variable to keep track of the input text
  String _inputValue = '';

  ///[_toolTipKey] key to access tooltip methods
  final GlobalKey<ElTooltipState> _toolTipKey = GlobalKey<ElTooltipState>();

  ///[selection] selected text length to perform validations
  int selection = -1;
  @override
  void initState() {
    super.initState();
  }

  getSelection() async {
    selection = await widget.controller.hasFocus();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetByPlatform(context);
  }

  Widget getWidgetByPlatform(BuildContext context) {
    if (kIsWeb) {
      return ElTooltip(
        key: _toolTipKey,
        content: WebViewAware(
          child: Form(
            key: _formKey,
            child: Container(
                width: 350,
                height: 60,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex('#E7F0FE'),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            onChanged: (v) {
                              setState(() => _inputValue = v);
                            },
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Can\'t be empty';
                              } else if (!hasValidUrl(text)) {
                                return 'Enter valid URL';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 5),
                                errorBorder: InputBorder.none,
                                hintText: ' Type URL',
                                alignLabelWithHint: true,
                                hintStyle: TextStyle(fontSize: 10),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSubmit(_inputValue);
                          _toolTipKey.currentState!.hideOverlay();
                        }
                      },
                      icon: const Icon(
                        Icons.check_rounded,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        _toolTipKey.currentState!.hideOverlay();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                )),
          ),
        ),
        child: getIcon(widget.type),
      );
    } else {
      return InkWell(
        onTap: () async {
          int onDoneLastClicked = 0;
          int onCloseLastClicked = 0;
          var range = await widget.controller.getSelectionRange();
          var decodeMap = {};
          if (kIsWeb) {
            decodeMap = range;
          } else {
            decodeMap = jsonDecode(range);
          }

          showBottomSheet(
              context: context,
              builder: (context) {
                return WebViewAware(
                  child: Form(
                    key: _formKey,
                    child: Container(
                        // width: 350,
                        height: 60,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            // Text(getTitle(widget.type)),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HexColor.fromHex('#E7F0FE'),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    onChanged: (v) {
                                      setState(() => _inputValue = v);
                                    },
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Can\'t be empty';
                                      } else if (!hasValidUrl(text)) {
                                        return 'Enter valid URL';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        errorBorder: InputBorder.none,
                                        hintText: ' Type URL',
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(fontSize: 10),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final now =
                                    DateTime.now().millisecondsSinceEpoch;
                                if (now - onDoneLastClicked < 500) {
                                  return;
                                }
                                onDoneLastClicked = now;
                                if (_formKey.currentState!.validate()) {
                                  widget.controller.setSelectionRange(
                                      decodeMap['index'], decodeMap['length']);
                                  Future.delayed(
                                          const Duration(milliseconds: 10))
                                      .then((value) {
                                    widget.onSubmit(_inputValue);
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.check_rounded,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              onPressed: () {
                                final now =
                                    DateTime.now().millisecondsSinceEpoch;
                                if (now - onCloseLastClicked < 500) {
                                  return;
                                }
                                onCloseLastClicked = now;
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        )),
                  ),
                );
              });
        },
        child: getIcon(widget.type),
      );
    }
  }

  Widget getIcon(UrlInputType type) {
    switch (type) {
      case UrlInputType.video:
        return SizedBox(
            height: 18,
            width: 18,
            child: Image.asset(ImageConstant.kiCameraRollPng));
      case UrlInputType.hyperlink:
        return Icon(
          Icons.link,
          color: widget.isActive ? Colors.blue : Colors.black,
        );
    }
  }

  String getTitle(UrlInputType type) {
    switch (type) {
      case UrlInputType.video:
        return 'Enter Video';
      case UrlInputType.hyperlink:
        return 'Enter Url';
    }
  }
}

///[UrlInputType] enum for input types
enum UrlInputType {
  ///[video] type for embedding video url to editor
  video,

  ///[hyperlink] type for embedding hyperlink to selection in editor
  hyperlink
}
