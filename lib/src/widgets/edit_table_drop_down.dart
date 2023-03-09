import 'package:flutter/material.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/webviewx_plus.dart';

import '../constants/image_constants.dart';
import 'el_tooltip/el_tooltip.dart';

/// [EditTableDropDown] to edit the table, add remove columns rows etc.
class EditTableDropDown extends StatefulWidget {
  /// [EditTableDropDown] constructor to edit the table, add remove columns rows etc.
  const EditTableDropDown({
    Key? key,
    required this.dropDownColor,
    required this.iconColor,
    required this.iconSize,
    required this.padding,
    required this.onOptionSelected,
  }) : super(key: key);

  ///[dropDownColor] to define the dropdown background color
  final Color dropDownColor;

  ///[iconColor] to define the icon color
  final Color iconColor;

  ///[iconSize] to define the size of the icon
  final double iconSize;

  ///[padding] to define the padding of the dropdown
  final EdgeInsetsGeometry padding;

  ///[onOptionSelected] a callback function that returns the selected action from dropdown
  final Function(EditTableEnum type) onOptionSelected;

  @override
  State<EditTableDropDown> createState() => _EditTableDropDownState();
}

class _EditTableDropDownState extends State<EditTableDropDown> {
  final GlobalKey<ElTooltipState> _editTableETKey =
      GlobalKey<ElTooltipState>(debugLabel: 'fontBgColorKey');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        width: widget.iconSize,
        height: widget.iconSize,
        child: ElTooltip(
          color: widget.dropDownColor,
          distance: 0,
          position: ElTooltipPosition.bottomEnd,
          onTap: () {
            if (_editTableETKey.currentState != null) {
              _editTableETKey.currentState!.showOverlayOnTap();
            }
          },
          key: _editTableETKey,
          content: SizedBox(
            width: 180,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: EditTableEnum.values.length,
              itemBuilder: (context, i) {
                return _getEditTableItem(EditTableEnum.values.toList()[i]);
              },
            ),
          ),
          child: SizedBox(
            width: widget.iconSize,
            height: widget.iconSize,
            child: Image.asset(
              ImageConstant.kiEditTablePng,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getEditTableItem(EditTableEnum type) {
    String value = "";
    String imagePath = ImageConstant.kiInsertRowBelowPng;

    switch (type) {
      case EditTableEnum.insertRowAbove:
        value = "Insert Row Above";
        imagePath = ImageConstant.kiInsertTablePng;
        break;
      case EditTableEnum.insertRowBelow:
        value = "Insert Row Below";
        imagePath = ImageConstant.kiInsertRowBelowPng;
        break;
      case EditTableEnum.deleteRow:
        value = "Delete Row";
        imagePath = ImageConstant.kiDeleteRowPng;
        break;
      case EditTableEnum.deleteColumn:
        value = "Delete Column";
        imagePath = ImageConstant.kiDeleteColumnPng;
        break;
      case EditTableEnum.insertColumnLeft:
        value = "Insert Column Left";
        imagePath = ImageConstant.kiInsertColumnLeftPng;
        break;
      case EditTableEnum.insertColumnRight:
        value = "Insert Column Right";
        imagePath = ImageConstant.kiInsertColumnRightPng;
        break;
      case EditTableEnum.deleteTable:
        value = "Delete Table";
        imagePath = ImageConstant.kiDeleteTablePng;
        break;
    }

    return WebViewAware(
      child: Card(
        color: widget.dropDownColor,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    child: Image.asset(
                      imagePath,
                      color: widget.iconColor,
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: widget.iconColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            widget.onOptionSelected(type);
            if (_editTableETKey.currentState != null) {
              _editTableETKey.currentState!.hideOverlay();
            }
          },
        ),
      ),
    );
  }
}

///[EditTableEnum] enum options for edit table dropdown
enum EditTableEnum {
  /// to insert a row above the cursor in the table
  insertRowAbove,

  /// to insert a row below cursor in the table
  insertRowBelow,

  /// to insert a column left side of cursor in the  table
  insertColumnLeft,

  /// to insert a column right side of cursor in the  table
  insertColumnRight,

  /// to delete a row where the cursor is placed in the table
  deleteRow,

  /// to delete a column where the cursor is placed in the table
  deleteColumn,

  /// to delete the whole table where the cursor is currently in
  deleteTable
}
