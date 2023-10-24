/// ElementBox class is used to represent an element's offset information.

class ElementBox {
  /// The width of the element.
  final double w;

  /// The height of the element.
  final double h;

  /// The X-coordinate of the element's position.
  final double x;

  /// The Y-coordinate of the element's position.
  final double y;

  /// Creates an ElementBox to hold the offset information.
  ///
  /// The [w] parameter represents the width of the element.
  /// The [h] parameter represents the height of the element.
  /// The optional [x] parameter sets the X-coordinate of the element's position. Default is 0.0.
  /// The optional [y] parameter sets the Y-coordinate of the element's position. Default is 0.0.
  const ElementBox({
    required this.w,
    required this.h,
    this.x = 0.0,
    this.y = 0.0,
  });
}
