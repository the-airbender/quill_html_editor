import 'package:flutter/material.dart';
import 'package:quill_html_editor/src/utils/hex_color.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker(
      {super.key, required this.onColorPicked, required this.showPicker});
  final Function(String) onColorPicked;
  final bool showPicker;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 120,
        height: 120,
        color: Colors.white,
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: colorList.length,
            padding: const EdgeInsets.all(2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (context, index) {
              return WebViewAware(
                child: GestureDetector(
                    onTap: () {
                      onColorPicked(colorList[index]);
                    },
                    child: colorPalette(colorList[index])),
              );
            }));
  }

  Widget colorPalette(String hexColor) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: HexColor.fromHex(hexColor), border: Border.all(width: 0.3)),
        width: 40,
        height: 40,
      ),
    );
  }
}

const List<String> colorList = [
  '#000000',
  '#FFFFFF',
  '#F44336',
  '#E91E63',
  '#9C27B0',
  '#673AB7',
  '#3F51B5',
  '#2196F3',
  '#03A9F4',
  '#00BCD4',
  '#009688',
  '#4CAF50',
  '#8BC34A',
  '#CDDC39',
  '#FFEB3B',
  '#FFC107',
  '#FF9800',
  '#FF5722',
  '#795548'
];
