///ElementBox to hold the offset information

class ElementBox {
  final double w;
  final double h;
  final double x;
  final double y;

  ///ElementBox constructor to hold the offset information
  const ElementBox({
    required this.w,
    required this.h,
    this.x = 0.0,
    this.y = 0.0,
  });
}
