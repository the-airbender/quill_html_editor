import 'package:flutter/material.dart';
import 'package:quill_html_editor/src/utils/hex_color.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/webviewx_plus.dart';

///[ColorPicker] a widget to pick colors from a color grid
class ColorPicker extends StatelessWidget {
  ///[ColorPicker] constructor of a widget to pick colors from a color grid
  const ColorPicker({super.key, required this.onColorPicked});

  /// [onColorPicked] callback when a color is picked
  final Function(String) onColorPicked;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 120,
        height: 120,
        color: Colors.white,
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: _colorList.length,
            padding: const EdgeInsets.all(2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (context, index) {
              return WebViewAware(
                child: GestureDetector(
                    onTap: () {
                      onColorPicked(_colorList[index]);
                    },
                    child: _colorPaletteItem(_colorList[index])),
              );
            }));
  }

  Widget _colorPaletteItem(String hexColor) {
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

///// custom color list feature will coming in future release
const List<String> _colorList = [
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
