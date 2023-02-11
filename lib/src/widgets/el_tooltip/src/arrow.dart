import 'package:flutter/material.dart';
import 'enum/el_tooltip_position.dart';
import 'paint/corner.dart';
import 'paint/triangle.dart';

/// Loads the arrow from the paint code and applies the correct transformations
/// color, rotation and mirroring
class Arrow extends StatelessWidget {
  ///color, to set color of the arrow
  final Color color;

  ///position, to set the position of the arrow
  final ElTooltipPosition position;

  ///width, to set the width of the arrow
  final double width;

  ///width, to set the height of the arrow
  final double height;

  /// Loads the arrow from the paint code and applies the correct transformations
  /// color, rotation and mirroring
  const Arrow({
    required this.color,
    required this.position,
    this.width = 16.0,
    this.height = 10.0,
    super.key,
  });

  /// Returns either the center triangle or the corner triangle
  CustomPainter? _getElement(bool isArrow) {
    return isArrow ? Triangle(color: color) : Corner(color: color);
  }

  /// Applies the transformation to the triangle
  Widget _getTriangle() {
    double scaleX = 1;
    double scaleY = 1;
    bool isArrow = false;
    int quarterTurns = 0;

    switch (position) {
      case ElTooltipPosition.topStart:
        break;
      case ElTooltipPosition.topCenter:
        quarterTurns = 0;
        isArrow = true;
        break;
      case ElTooltipPosition.topEnd:
        scaleX = -1;
        break;
      case ElTooltipPosition.bottomStart:
        scaleY = -1;
        break;
      case ElTooltipPosition.bottomCenter:
        quarterTurns = 2;
        isArrow = true;
        break;
      case ElTooltipPosition.bottomEnd:
        scaleX = -1;
        scaleY = -1;
        break;
      case ElTooltipPosition.leftStart:
        scaleY = -1;
        quarterTurns = 3;
        break;
      case ElTooltipPosition.leftCenter:
        quarterTurns = 3;
        isArrow = true;
        break;
      case ElTooltipPosition.leftEnd:
        quarterTurns = 3;
        break;
      case ElTooltipPosition.rightStart:
        quarterTurns = 1;
        break;
      case ElTooltipPosition.rightCenter:
        quarterTurns = 1;
        isArrow = true;
        break;
      case ElTooltipPosition.rightEnd:
        quarterTurns = 1;
        scaleY = -1;
        break;
    }

    return Transform.scale(
      scaleX: scaleX,
      scaleY: scaleY,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: CustomPaint(
          size: Size(width, height),
          painter: _getElement(isArrow),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getTriangle();
  }
}
