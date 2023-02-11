import 'package:flutter/material.dart';

/// Modal is the fullscreen window displayed behind the tooltip.
/// It's used to focus the user attention to the tooltip.
class Modal extends StatelessWidget {
  ///[visible] to show or hide the modal
  final bool visible;

  ///[color] to set a custom color, default color is black
  final Color color;

  ///[opacity] to set custom opacity, default opacity is 0.6
  final double opacity;

  ///[onTap] onTap void call back function when user clicks outside the tooltip
  final void Function()? onTap;

  /// [Modal] is the fullscreen window displayed behind the tooltip.
  const Modal({
    required this.onTap,
    this.visible = true,
    this.color = Colors.black,
    this.opacity = 0.6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (visible) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          color: color.withOpacity(opacity),
        ),
      );
    } else {
      return Container();
    }
  }
}
