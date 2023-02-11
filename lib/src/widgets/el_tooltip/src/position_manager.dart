import 'package:flutter/material.dart';
import 'element_box.dart';
import 'enum/el_tooltip_position.dart';
import 'tooltip_elements_display.dart';

/// Calculates the position of the tooltip and the arrow on the screen
/// Verifies if the desired position fits the screen.
/// If it doesn't the position changes automatically.
class PositionManager {
  /// [arrowBox] width, height, position x and y of the arrow.
  final ElementBox arrowBox;

  /// [triggerBox] width, height, position x and y of the trigger.
  final ElementBox triggerBox;

  /// [overlayBox] width, height, position x and y of the overlay.
  final ElementBox overlayBox;

  /// [screenSize] width and height of the current screen.
  final ElementBox screenSize;

  /// [distance] between the tooltip and the trigger button.
  final double distance;

  /// [radius] border radius amount of the tooltip.
  final double radius;

  /// [PositionManager] Calculates the position of the tooltip and the arrow on the screen
  /// Verifies if the desired position fits the screen.
  /// If it doesn't the position changes automatically.
  const PositionManager({
    required this.arrowBox,
    required this.triggerBox,
    required this.overlayBox,
    required this.screenSize,
    this.distance = 0.0,
    this.radius = 0.0,
  });

  ToolTipElementsDisplay _topStart() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x + _half(triggerBox.w)).floorToDouble(),
        y: (triggerBox.y - distance - arrowBox.h).floorToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x + _half(triggerBox.w),
        y: triggerBox.y - overlayBox.h - distance - arrowBox.h,
      ),
      position: ElTooltipPosition.topStart,
      radius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.zero,
        bottomRight: Radius.circular(radius),
      ),
    );
  }

  ToolTipElementsDisplay _topCenter() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: arrowBox.w,
        h: arrowBox.h,
        x: (triggerBox.x + _half(triggerBox.w) - _half(arrowBox.w))
            .floorToDouble(),
        y: (triggerBox.y - distance - arrowBox.h).floorToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x + _half(triggerBox.w) - _half(overlayBox.w),
        y: triggerBox.y - overlayBox.h - distance - arrowBox.h,
      ),
      position: ElTooltipPosition.topCenter,
      radius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  ToolTipElementsDisplay _topEnd() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: arrowBox.w,
        h: arrowBox.h,
        x: (triggerBox.x + _half(triggerBox.w) - arrowBox.w).floorToDouble(),
        y: (triggerBox.y - distance - arrowBox.h).floorToDouble(),
      ),
      bubble: ElementBox(
        w: arrowBox.w,
        h: arrowBox.h,
        x: triggerBox.x - overlayBox.w + _half(triggerBox.w),
        y: triggerBox.y - overlayBox.h - distance - arrowBox.h,
      ),
      position: ElTooltipPosition.topEnd,
      radius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.zero,
      ),
    );
  }

  ToolTipElementsDisplay _bottomStart() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x + _half(triggerBox.w)).ceilToDouble(),
        y: (triggerBox.y + triggerBox.h + distance).ceilToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x + _half(triggerBox.w),
        y: triggerBox.y + triggerBox.h + distance + arrowBox.h,
      ),
      position: ElTooltipPosition.bottomStart,
      radius: BorderRadius.only(
        topLeft: Radius.zero,
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }

  ToolTipElementsDisplay _bottomCenter() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: arrowBox.w,
        h: arrowBox.h,
        x: (triggerBox.x + _half(triggerBox.w) - _half(arrowBox.w))
            .ceilToDouble(),
        y: (triggerBox.y + triggerBox.h + distance).ceilToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x + _half(triggerBox.w) - _half(overlayBox.w),
        y: triggerBox.y + triggerBox.h + distance + arrowBox.h,
      ),
      position: ElTooltipPosition.bottomCenter,
      radius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  ToolTipElementsDisplay _bottomEnd() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x + _half(triggerBox.w) - arrowBox.w),
        y: (triggerBox.y + triggerBox.h + distance).ceilToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x + _half(triggerBox.w) - overlayBox.w,
        y: triggerBox.y + triggerBox.h + distance + arrowBox.h,
      ),
      position: ElTooltipPosition.bottomEnd,
      radius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.zero,
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }

  ToolTipElementsDisplay _leftStart() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x - overlayBox.x - distance - arrowBox.h)
            .floorToDouble(),
        y: triggerBox.y + _half(triggerBox.h),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x - overlayBox.x - overlayBox.w - distance - arrowBox.h,
        y: triggerBox.y + _half(triggerBox.h),
      ),
      position: ElTooltipPosition.leftStart,
      radius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.zero,
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }

  ToolTipElementsDisplay _leftCenter() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x - overlayBox.x - distance - arrowBox.h)
            .floorToDouble(),
        y: (triggerBox.y + _half(triggerBox.h) - _half(arrowBox.w))
            .floorToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x - overlayBox.x - overlayBox.w - distance - arrowBox.h,
        y: triggerBox.y + _half(triggerBox.h) - _half(overlayBox.h),
      ),
      position: ElTooltipPosition.leftCenter,
      radius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  ToolTipElementsDisplay _leftEnd() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x - overlayBox.x - distance - arrowBox.h)
            .floorToDouble(),
        y: (triggerBox.y + _half(triggerBox.h) - arrowBox.w).floorToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x - overlayBox.x - overlayBox.w - distance - arrowBox.h,
        y: triggerBox.y + _half(triggerBox.h) - overlayBox.h,
      ),
      position: ElTooltipPosition.leftEnd,
      radius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.zero,
      ),
    );
  }

  ToolTipElementsDisplay _rightStart() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x + triggerBox.w + distance).floorToDouble(),
        y: (triggerBox.y + _half(triggerBox.h)).floorToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x + triggerBox.w + distance + arrowBox.h)
            .floorToDouble(),
        y: (triggerBox.y + _half(triggerBox.h)).floorToDouble(),
      ),
      position: ElTooltipPosition.rightStart,
      radius: BorderRadius.only(
        topLeft: Radius.zero,
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }

  ToolTipElementsDisplay _rightCenter() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x + triggerBox.w + distance).floorToDouble(),
        y: (triggerBox.y + _half(triggerBox.h) - _half(arrowBox.w))
            .floorToDouble(),
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x + triggerBox.w + distance + arrowBox.h,
        y: triggerBox.y + _half(triggerBox.h) - _half(overlayBox.h),
      ),
      position: ElTooltipPosition.rightCenter,
      radius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  ToolTipElementsDisplay _rightEnd() {
    return ToolTipElementsDisplay(
      arrow: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: (triggerBox.x + triggerBox.w + distance).floorToDouble(),
        y: triggerBox.y + _half(triggerBox.h) - arrowBox.w,
      ),
      bubble: ElementBox(
        w: overlayBox.w,
        h: overlayBox.h,
        x: triggerBox.x + triggerBox.w + distance + arrowBox.h,
        y: triggerBox.y + _half(triggerBox.h) - overlayBox.h,
      ),
      position: ElTooltipPosition.rightEnd,
      radius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.zero,
        bottomRight: Radius.circular(radius),
      ),
    );
  }

  double _half(double size) {
    return size * 0.5;
  }

  bool _fitsScreen(ToolTipElementsDisplay el) {
    if (el.bubble.x > 0 &&
        el.bubble.x + el.bubble.w < screenSize.w &&
        el.bubble.y > 0 &&
        el.bubble.y + el.bubble.h < screenSize.h) {
      return true;
    }
    return false;
  }

  /// Tests each possible position until it finds one that fits.
  ToolTipElementsDisplay _firstAvailablePosition() {
    List<ToolTipElementsDisplay Function()> positions = [
      _topCenter,
      _bottomCenter,
      _leftCenter,
      _rightCenter,
      _topStart,
      _topEnd,
      _leftStart,
      _rightStart,
      _leftEnd,
      _rightEnd,
      _bottomStart,
      _bottomEnd,
    ];
    for (var position in positions) {
      if (_fitsScreen(position())) return position();
    }
    return _topCenter();
  }

  /// Load the calculated tooltip position
  ToolTipElementsDisplay load({ElTooltipPosition? preferredPosition}) {
    ToolTipElementsDisplay elementPosition;

    switch (preferredPosition) {
      case ElTooltipPosition.topStart:
        elementPosition = _topStart();
        break;
      case ElTooltipPosition.topCenter:
        elementPosition = _topCenter();
        break;
      case ElTooltipPosition.topEnd:
        elementPosition = _topEnd();
        break;
      case ElTooltipPosition.bottomStart:
        elementPosition = _bottomStart();
        break;
      case ElTooltipPosition.bottomCenter:
        elementPosition = _bottomCenter();
        break;
      case ElTooltipPosition.bottomEnd:
        elementPosition = _bottomEnd();
        break;
      case ElTooltipPosition.leftStart:
        elementPosition = _leftStart();
        break;
      case ElTooltipPosition.leftCenter:
        elementPosition = _leftCenter();
        break;
      case ElTooltipPosition.leftEnd:
        elementPosition = _leftEnd();
        break;
      case ElTooltipPosition.rightStart:
        elementPosition = _rightStart();
        break;
      case ElTooltipPosition.rightCenter:
        elementPosition = _rightCenter();
        break;
      case ElTooltipPosition.rightEnd:
        elementPosition = _rightEnd();
        break;
      default:
        elementPosition = _topCenter();
        break;
    }

    return _fitsScreen(elementPosition)
        ? elementPosition
        : _firstAvailablePosition();
  }
}
