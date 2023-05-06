import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/webviewx_plus.dart';

///[TablePicker] a widget to interactively selected the number of rows and columns to insert in editor
class TablePicker extends StatefulWidget {
  ///[TablePicker] a widget to interactively selected the number of rows and columns to insert in editor
  const TablePicker(
      {super.key,
      this.rowCount = 6,
      required this.onTablePicked,
      this.width = 200});

  ///[onTablePicked] a callback function that returns the selected row and column index
  final Function(int row, int column) onTablePicked;

  ///[rowCount] to define the table row*column matrix
  final int? rowCount;

  ///[width] to set the min width of the table picker
  final double? width;

  @override
  State<TablePicker> createState() => _TablePickerState();
}

class _TablePickerState extends State<TablePicker> {
  final Set<int> _selectedIndexes = <int>{};
  final Set<_CellBox> _trackTaped = <_CellBox>{};
  int _selectedRow = 0;
  int _selectedColumn = 0;
  final _cellKey = GlobalKey();
  @override
  initState() {
    super.initState();
  }

  _detectTapedItem(PointerEvent event) {
    _clearSelection();
    final RenderBox box =
        _cellKey.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _CellBox && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
        }
      }
    }
  }

  _selectIndex(int index) {
    setState(() {
      _selectedIndexes.add(index);
      List<int> tempList = _selectedIndexes.toList();
      tempList.sort((a, b) => a - b);
      _selectedColumn = tempList.last ~/ widget.rowCount!;
      _selectedRow = tempList.last % widget.rowCount!;
      int count = 0;
      _selectedIndexes.clear();
      for (int i = 0; i < widget.rowCount!; i++) {
        for (int j = 0; j < widget.rowCount!; j++) {
          if (i <= _selectedColumn && j <= _selectedRow) {
            _selectedIndexes.add(count);
          }
          count++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebViewAware(
      child: Listener(
        onPointerDown: _detectTapedItem,
        onPointerMove: _detectTapedItem,
        onPointerUp: _onSelectionDone,
        child: GridView.builder(
          key: _cellKey,
          shrinkWrap: true,
          itemCount: widget.rowCount! * widget.rowCount!,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1, crossAxisCount: widget.rowCount!),
          itemBuilder: (context, index) {
            return _CellSelectionWidget(
              index: index,
              child: Container(
                // width: widget.width! / widget.rowCount!,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: _selectedIndexes.contains(index)
                        ? Colors.lightBlue.shade50
                        : Colors.transparent,
                    border: Border.all(
                      width: _selectedIndexes.contains(index) ? 2 : 1,
                      color: _selectedIndexes.contains(index)
                          ? Colors.lightBlue.shade100
                          : Colors.black45,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  void _clearSelection() {
    _trackTaped.clear();
    setState(() {
      _selectedIndexes.clear();
    });
  }

  void _onSelectionDone(PointerUpEvent event) {
    widget.onTablePicked(_selectedRow + 1, _selectedColumn + 1);
  }
}

class _CellSelectionWidget extends SingleChildRenderObjectWidget {
  final int index;

  const _CellSelectionWidget(
      {required Widget child, required this.index, Key? key})
      : super(child: child, key: key);

  @override
  _CellBox createRenderObject(BuildContext context) {
    return _CellBox(index);
  }

  @override
  void updateRenderObject(BuildContext context, _CellBox renderObject) {
    renderObject.index = index;
  }
}

class _CellBox extends RenderProxyBox {
  int index;

  _CellBox(this.index);
}
