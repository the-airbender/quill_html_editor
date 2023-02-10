import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
class TablePicker extends StatefulWidget {
  const TablePicker(
      {super.key, this.rowCount = 5, required this.onTablePicked});
  final Function(int row, int column) onTablePicked;
  @override
  TablePickerState createState() {
    return TablePickerState();
  }

  final int? rowCount;
}

class TablePickerState extends State<TablePicker> {
  final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  final Set<CellBox> _trackTaped = <CellBox>{};
  int selectedRow = 0;
  int selectedColumn = 0;
  @override
  initState() {
    super.initState();
  }

  _detectTapedItem(PointerEvent event) {
    _clearSelection();
    final RenderBox box =
        key.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is CellBox && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
        }
      }
    }
  }

  _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
      List<int> tempList = selectedIndexes.toList();
      tempList.sort((a, b) => a - b);
      selectedRow = tempList.last ~/ widget.rowCount!;
      selectedColumn = tempList.last % widget.rowCount!;
      print(tempList);
      print("Column $selectedColumn");
      print("Row $selectedRow");
      int count = 0;
      selectedIndexes.clear();
      for (int i = 0; i < widget.rowCount!; i++) {
        for (int j = 0; j < widget.rowCount!; j++) {
          if (i <= selectedRow && j <= selectedColumn) {
            selectedIndexes.add(count);
          }
          count++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _detectTapedItem,
      onPointerMove: _detectTapedItem,
      onPointerUp: _onSelectionDone,
      child: GridView.builder(
        key: key,
        itemCount: widget.rowCount! * widget.rowCount!,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.rowCount!,
          childAspectRatio: 1.0,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
        ),
        itemBuilder: (context, index) {
          return WebViewAware(
            child: CellSelectionWidget(
              index: index,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: selectedIndexes.contains(index)
                        ? Colors.lightBlue.shade50
                        : Colors.transparent,
                    border: Border.all(
                      width: selectedIndexes.contains(index) ? 2 : 1,
                      color: selectedIndexes.contains(index)
                          ? Colors.lightBlue.shade100
                          : Colors.black26,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  void _clearSelection() {
    _trackTaped.clear();
    setState(() {
      selectedIndexes.clear();
    });
  }

  void _onSelectionDone(PointerUpEvent event) {
    widget.onTablePicked(selectedRow+1, selectedColumn+1);
  }
}

class CellSelectionWidget extends SingleChildRenderObjectWidget {
  final int index;

  CellSelectionWidget({required Widget child, required this.index, Key? key})
      : super(child: child, key: key);

  @override
  CellBox createRenderObject(BuildContext context) {
    return CellBox(index);
  }

  @override
  void updateRenderObject(BuildContext context, CellBox renderObject) {
    renderObject.index = index;
  }
}

class CellBox extends RenderProxyBox {
  int index;
  CellBox(this.index);
}
