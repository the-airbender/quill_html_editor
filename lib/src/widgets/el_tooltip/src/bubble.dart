import 'package:flutter/material.dart';
import 'element_box.dart';

/// Bubble serves as the tooltip container
class Bubble extends StatefulWidget {
  /// [color] sets color to the bubble widget
  final Color color;

  /// [padding] sets padding to the bubble widget
  final double padding;

  /// [maxWidth] defines width constraints to the bubble widget
  final double maxWidth;

  /// [triggerBox] defines the offset position to bubble widget
  final ElementBox triggerBox;

  /// [radius] defines the radius of bubble widget
  final BorderRadiusGeometry? radius;

  /// [child] to pass the child widget
  final Widget child;

  /// [Bubble] serves as the tooltip container
  const Bubble({
    this.color = Colors.white,
    this.padding = 10.0,
    this.radius = const BorderRadius.all(Radius.circular(0)),
    required this.child,
    required this.triggerBox,
    this.maxWidth = 300.0,
    super.key,
  });

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: 1.0,
        child: Container(
          constraints: BoxConstraints(maxWidth: widget.maxWidth),
          decoration: BoxDecoration(
            borderRadius: widget.radius,
            color: widget.color,
          ),
          padding: EdgeInsets.all(widget.padding),
          child: widget.child,
        ),
      ),
    );
  }
}
