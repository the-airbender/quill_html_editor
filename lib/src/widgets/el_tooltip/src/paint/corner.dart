import 'package:flutter/widgets.dart';

/// Design of the corner triangle that appears attached to the tooltip
class Corner extends CustomPainter {
  /// [color] of the arrow.
  final Color color;

  /// Design of the corner triangle that appears attached to the tooltip
  const Corner({this.color = const Color(0xff000000)});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();
    paint.color = color;
    path = Path();
    path.lineTo(0, size.height * 0.69);
    path.cubicTo(0, size.height * 0.95, size.width * 0.18, size.height * 1.09,
        size.width * 0.31, size.height * 0.93);
    path.cubicTo(
        size.width * 0.31, size.height * 0.93, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, size.height * 0.69, 0, size.height * 0.69);
    path.cubicTo(
        0, size.height * 0.69, 0, size.height * 0.69, 0, size.height * 0.69);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
