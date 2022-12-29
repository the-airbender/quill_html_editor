library el_tooltip;

import 'package:flutter/material.dart';

import 'src/arrow.dart';
import 'src/bubble.dart';
import 'src/element_box.dart';
import 'src/enum/el_tooltip_position.dart';
import 'src/modal.dart';
import 'src/position_manager.dart';
import 'src/tooltip_elements_display.dart';

export 'src/enum/el_tooltip_position.dart';

/// Widget that displays a tooltip
/// It takes a widget as the trigger and a widget as the content
class ElTooltip extends StatefulWidget {
  /// [content] Widget that appears inside the tooltip.
  final Widget content;

  /// [child] Widget that will trigger the tooltip to appear.
  final Widget child;

  /// [color] Background color of the tooltip and the arrow.
  final Color color;

  /// [distance] Space between the tooltip and the trigger.
  final double distance;

  /// [padding] Space inside the tooltip - around the content.
  final double padding;

  /// [position] Desired tooltip position in relationship to the trigger.
  /// The default value it topCenter.
  final ElTooltipPosition position;

  /// [radius] Border radius around the tooltip.
  final double radius;

  /// [showModal] Shows a dark layer behind the tooltip.
  final bool showModal;

  /// [timeout] Number of seconds until the tooltip disappears automatically
  /// The default value is 0 (zero) which means it never disappears.
  final int timeout;

  ///[enable] to enable to disable the onpressed function of child
  final bool enable;

  /// [error] showing the error message while the disabled
  final String error;

  /// [onTap] callback when tooltip is tapped
  final GestureTapCallback onTap;

  /// [ElTooltip] tooltip widget to show overlay
  const ElTooltip({
    required this.content,
    required this.child,
    required this.onTap,
    this.color = Colors.white,
    this.distance = 10.0,
    this.padding = 2.0,
    this.position = ElTooltipPosition.topCenter,
    this.radius = 8.0,
    this.showModal = true,
    this.timeout = 0,
    this.enable = true,
    this.error = '',
    super.key,
  });
  @override
  State<ElTooltip> createState() => ElTooltipState();
}

/// _ElTooltipState extends ElTooltip class
class ElTooltipState extends State<ElTooltip> with WidgetsBindingObserver {
  final GlobalKey _widgetKey = GlobalKey();
  OverlayEntry? _overlayEntryHidden;
  OverlayEntry? _overlayEntry;
  ElementBox get _screenSize => _getScreenSize();
  ElementBox get _triggerBox => _getTriggerSize();
  ElementBox _overlayBox = ElementBox(h: 0.0, w: 0.0);
  final ElementBox _arrowBox = ElementBox(h: 10.0, w: 16.0);

  /// Init state and trigger the hidden overlay to measure its size
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadHiddenOverlay(context));
    WidgetsBinding.instance.addObserver(this);
  }

  /// Dispode the observer
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Automatically hide the overlay when the screen dimension changes
  /// or when the user scrolls. This is done to avoid displacement.
  @override
  void didChangeMetrics() {
    /// hideOverlay();
  }

  /// Measures the hidden tooltip after it's loaded with _loadHiddenOverlay(_)
  void _getHiddenOverlaySize(context) {
    if (mounted && _widgetKey.currentContext != null) {
      RenderBox box =
          _widgetKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        _overlayBox = ElementBox(
          w: box.size.width,
          h: box.size.height,
        );
        _overlayEntryHidden?.remove();
      });
    }
  }

  /// Loads the tooltip without opacity to measure the rendered size
  void _loadHiddenOverlay(_) {
    OverlayState? overlayStateHidden = Overlay.of(context);
    _overlayEntryHidden = OverlayEntry(
      builder: (context) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _getHiddenOverlaySize(context));
        return Opacity(
          opacity: 0,
          child: Center(
            child: Bubble(
              key: _widgetKey,
              triggerBox: _triggerBox,
              padding: widget.padding,
              child: widget.content,
            ),
          ),
        );
      },
    );
    overlayStateHidden?.insert(_overlayEntryHidden!);
  }

  /// Measures the size of the trigger widget
  ElementBox _getTriggerSize() {
    if (mounted) {
      final renderBox = context.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      return ElementBox(
        w: renderBox.size.width,
        h: renderBox.size.height,
        x: offset.dx,
        y: offset.dy,
      );
    }
    return ElementBox(w: 0, h: 0);
  }

  /// Measures the size of the screen to calculate possible overflow
  ElementBox _getScreenSize() {
    return ElementBox(
      w: MediaQuery.of(context).size.width,
      h: MediaQuery.of(context).size.height,
    );
  }

  /// Loads the tooltip into view
  void _showOverlay(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);

    /// By calling [PositionManager.load()] we get returned the position
    /// of the tooltip, the arrow and the trigger.
    ToolTipElementsDisplay toolTipElementsDisplay = PositionManager(
      arrowBox: _arrowBox,
      overlayBox: _overlayBox,
      triggerBox: _triggerBox,
      screenSize: _screenSize,
      distance: widget.distance,
      radius: widget.radius,
    ).load(preferredPosition: widget.position);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Modal(
              color: Colors.black87,
              opacity: 0.7,
              visible: widget.showModal,
              onTap: () {
                hideOverlay();
              },
            ),
            Positioned(
              top: toolTipElementsDisplay.bubble.y,
              left: toolTipElementsDisplay.bubble.x,
              child: Bubble(
                triggerBox: _triggerBox,
                padding: widget.padding,
                radius: toolTipElementsDisplay.radius,
                color: widget.color,
                child: widget.content,
              ),
            ),
            Positioned(
              top: toolTipElementsDisplay.arrow.y,
              left: toolTipElementsDisplay.arrow.x,
              child: Arrow(
                color: widget.color,
                position: toolTipElementsDisplay.position,
                width: _arrowBox.w,
                height: _arrowBox.h,
              ),
            ),
            Positioned(
              top: _triggerBox.y,
              left: _triggerBox.x,
              child: GestureDetector(
                onTap: () {
                  _overlayEntry != null ? hideOverlay() : _showOverlay(context);
                },
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );

    overlayState?.insert(_overlayEntry!);

    // Add timeout for the tooltip to disapear after a few seconds
    if (widget.timeout > 0) {
      await Future.delayed(Duration(seconds: widget.timeout))
          .whenComplete(() => hideOverlay());
    }
  }

  /// Method to hide the tooltip
  void hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.child,
    );
  }

  /// [showOverlayOnTap] a function to show the overlay on tap
  void showOverlayOnTap() {
    if (widget.enable) {
      _overlayEntry != null ? hideOverlay() : _showOverlay(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(widget.error)));
    }
  }
}
