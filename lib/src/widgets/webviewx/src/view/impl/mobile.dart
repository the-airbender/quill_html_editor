import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/controller/impl/mobile.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/controller/interface.dart'
    as ctrl_interface;
import 'package:quill_html_editor/src/widgets/webviewx/src/utils/utils.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/view/interface.dart'
    as view_interface;
import 'package:webview_flutter/webview_flutter.dart' as wf;
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as wf_android;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart'
    as wf_pi;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    as wf_wk;

/// Mobile implementation
class WebViewX extends StatefulWidget implements view_interface.WebViewX {
  /// Initial content
  @override
  final String initialContent;

  /// Initial source type. Must match [initialContent]'s type.
  ///
  /// Example:
  /// If you set [initialContent] to '<p>hi</p>', then you should
  /// also set the [initialSourceType] accordingly, that is [SourceType.html].
  @override
  final SourceType initialSourceType;

  /// User-agent
  /// On web, this is only used when using [SourceType.urlBypass]
  @override
  final String? userAgent;

  /// Widget width
  @override
  final double width;

  /// Widget height
  @override
  final double height;

  /// Callback which returns a reference to the [WebViewXController]
  /// being created.
  @override
  final Function(ctrl_interface.WebViewXController controller)?
      onWebViewCreated;

  /// A set of [EmbeddedJsContent].
  ///
  /// You can define JS functions, which will be embedded into
  /// the HTML source (won't do anything on URL) and you can later call them
  /// using the controller.
  ///
  /// For more info, see [EmbeddedJsContent].
  @override
  final Set<EmbeddedJsContent> jsContent;

  /// A set of [DartCallback].
  ///
  /// You can define Dart functions, which can be called from the JS side.
  ///
  /// For more info, see [DartCallback].
  @override
  final Set<DartCallback> dartCallBacks;

  /// Boolean value to specify if should ignore all gestures that touch the webview.
  ///
  /// You can change this later from the controller.
  @override
  final bool ignoreAllGestures;

  /// Boolean value to specify if Javascript execution should be allowed inside the webview
  @override
  final JavascriptMode javascriptMode;

  /// This defines if media content(audio - video) should
  /// auto play when entering the page.
  @override
  final AutoMediaPlaybackPolicy initialMediaPlaybackPolicy;

  /// Callback for when the page starts loading.
  @override
  final void Function(String src)? onPageStarted;

  /// Callback for when the page has finished loading (i.e. is shown on screen).
  @override
  final void Function(String src)? onPageFinished;

  /// Callback to decide whether to allow navigation to the incoming url
  @override
  final NavigationDelegate? navigationDelegate;

  /// Callback for when something goes wrong in while page or resources load.
  @override
  final void Function(WebResourceError error)? onWebResourceError;

  /// Parameters specific to the web version.
  /// This may eventually be merged with [mobileSpecificParams],
  /// if all features become cross platform.
  @override
  final WebSpecificParams webSpecificParams;

  /// Parameters specific to the mobile version.
  /// This may eventually be merged with [webSpecificParams],
  /// if all features become cross platform.
  @override
  final MobileSpecificParams mobileSpecificParams;

  /// Constructor
  const WebViewX({
    Key? key,
    this.initialContent = 'about:blank',
    this.initialSourceType = SourceType.url,
    this.userAgent,
    required this.width,
    required this.height,
    this.onWebViewCreated,
    this.jsContent = const {},
    this.dartCallBacks = const {},
    this.ignoreAllGestures = false,
    this.javascriptMode = JavascriptMode.unrestricted,
    this.initialMediaPlaybackPolicy =
        AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
    this.onPageStarted,
    this.onPageFinished,
    this.navigationDelegate,
    this.onWebResourceError,
    this.webSpecificParams = const WebSpecificParams(),
    this.mobileSpecificParams = const MobileSpecificParams(),
  }) : super(key: key);

  @override
  State<WebViewX> createState() => _WebViewXState();
}

class _WebViewXState extends State<WebViewX> {
  late final wf.WebViewController originalWebViewController;
  late final WebViewXController webViewXController;

  late bool _ignoreAllGestures = widget.ignoreAllGestures;
  late final wf.WebViewWidget webViewWidget;
  @override
  void initState() {
    super.initState();

    originalWebViewController = _createOriginalController();
    _populateOriginalController();
    webViewXController = _createWebViewXController();

    widget.onWebViewCreated?.call(webViewXController);

    late final wf.PlatformWebViewWidgetCreationParams widgetParams;
    if (Platform.isAndroid) {
      widgetParams = wf_android.AndroidWebViewWidgetCreationParams(
        controller: originalWebViewController.platform,
        gestureRecognizers:
            widget.mobileSpecificParams.mobileGestureRecognizers ?? const {},
        displayWithHybridComposition:
            widget.mobileSpecificParams.androidEnableHybridComposition,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      widgetParams = wf_wk.WebKitWebViewWidgetCreationParams(
        controller: originalWebViewController.platform,
        gestureRecognizers:
            widget.mobileSpecificParams.mobileGestureRecognizers ?? const {},
      );
    }

    if (wf.WebViewPlatform.instance is wf_android.AndroidWebViewPlatform) {
      webViewWidget = wf.WebViewWidget.fromPlatformCreationParams(
        key: widget.key,
        params: widgetParams,
      );
    } else {
      webViewWidget = wf.WebViewWidget(
        controller: originalWebViewController,
        key: widget.key,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: IgnorePointer(
        ignoring: _ignoreAllGestures,
        child: webViewWidget,
      ),
    );
  }

  void _onWebResourceError(wf_pi.WebResourceError err) {
    String? domain;
    String? failingUrl;

    if (err is wf_wk.WebKitWebResourceError) {
      domain = err.domain;
    } else if (err is wf_android.AndroidWebResourceError) {
      failingUrl = err.url;
    }

    widget.onWebResourceError?.call(
      WebResourceError(
        description: err.description,
        errorCode: err.errorCode,
        domain: domain,
        errorType: WebResourceErrorType.values.singleWhere(
          (value) => value.toString() == err.errorType.toString(),
        ),
        failingUrl: failingUrl,
      ),
    );
  }

  FutureOr<wf.NavigationDecision> _onNavigationRequest(
    wf.NavigationRequest request,
  ) async {
    final navigationDelegate = widget.navigationDelegate;
    if (navigationDelegate == null) {
      webViewXController.value =
          webViewXController.value.copyWith(source: request.url);
      return wf.NavigationDecision.navigate;
    }

    final delegate = await navigationDelegate.call(
      NavigationRequest(
        content:
            NavigationContent(request.url, webViewXController.value.sourceType),
        isForMainFrame: request.isMainFrame,
      ),
    );

    switch (delegate) {
      case NavigationDecision.navigate:
        // When clicking on an URL, the sourceType stays the same.
        // That's because you cannot move from URL to HTML just by clicking.
        // Also we don't take URL_BYPASS into consideration because it has no effect here in mobile
        webViewXController.value = webViewXController.value.copyWith(
          source: request.url,
        );
        return wf.NavigationDecision.navigate;
      case NavigationDecision.prevent:
        return wf.NavigationDecision.prevent;
    }
  }

  // Returns initial data
  WebViewContent _initialContent() {
    return WebViewContent(
      source: widget.initialContent,
      sourceType: widget.initialSourceType,
    );
  }

  // Creates a wf.WebViewController
  wf.WebViewController _createOriginalController() {
    late final wf.PlatformWebViewControllerCreationParams params;
    if (wf.WebViewPlatform.instance is wf_wk.WebKitWebViewPlatform) {
      late final Set<wf_wk.PlaybackMediaTypes> mediaTypesRequiringUserAction;
      switch (widget.initialMediaPlaybackPolicy) {
        case AutoMediaPlaybackPolicy.alwaysAllow:
          mediaTypesRequiringUserAction = const <wf_wk.PlaybackMediaTypes>{};
          break;
        case AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes:
          mediaTypesRequiringUserAction =
              wf_wk.PlaybackMediaTypes.values.toSet();
          break;
      }
      params = wf_wk.WebKitWebViewControllerCreationParams(
        mediaTypesRequiringUserAction: mediaTypesRequiringUserAction,
      );
    } else {
      params = const wf.PlatformWebViewControllerCreationParams();
    }

    return wf.WebViewController.fromPlatformCreationParams(params);
  }

  // Sets the original controller's properties
  void _populateOriginalController() {
    final javaScriptMode = widget.javascriptMode == JavascriptMode.unrestricted
        ? wf.JavaScriptMode.unrestricted
        : wf.JavaScriptMode.disabled;
    originalWebViewController.setJavaScriptMode(javaScriptMode);
    originalWebViewController.setUserAgent(widget.userAgent);
    originalWebViewController.setNavigationDelegate(
      wf.NavigationDelegate(
        onNavigationRequest: _onNavigationRequest,
        onPageStarted: widget.onPageStarted,
        onPageFinished: widget.onPageFinished,
        onWebResourceError: _onWebResourceError,
      ),
    );
    for (final cb in widget.dartCallBacks) {
      originalWebViewController.addJavaScriptChannel(
        cb.name,
        onMessageReceived: (msg) => cb.callBack(msg.message),
      );
    }

    if (originalWebViewController.platform
        is wf_android.AndroidWebViewController) {
      wf_android.AndroidWebViewController.enableDebugging(
          widget.mobileSpecificParams.debuggingEnabled);
      (originalWebViewController.platform
              as wf_android.AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(
        widget.initialMediaPlaybackPolicy ==
            AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
      );
    } else if (originalWebViewController.platform
        is wf_wk.WebKitWebViewController) {
      (originalWebViewController.platform as wf_wk.WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(
        widget.mobileSpecificParams.gestureNavigationEnabled,
      );
    }

    _load(_initialContent());
  }

  // Creates a WebViewXController and adds the listener
  WebViewXController _createWebViewXController() {
    return WebViewXController(
      initialContent: widget.initialContent,
      initialSourceType: widget.initialSourceType,
      ignoreAllGestures: _ignoreAllGestures,
    )
      ..addListener(_handleChange)
      ..addIgnoreGesturesListener(_handleIgnoreGesturesChange)
      ..connector = originalWebViewController;
  }

  // Called when WebViewXController updates it's value
  void _handleChange() {
    _load(webViewXController.value);
  }

  Uint8List? _convertPostRequestBody(Object? body) {
    // no body
    if (body == null) {
      return null;
    }

    // already a Uint8List
    if (body is Uint8List) {
      return body;
    }

    // convert Map<String, dynamic> or List<dynamic> to JSON String
    if (body is Map || body is List) {
      body = json.encode(body);
    }

    // convert String to List<int>
    if (body is String) {
      body = utf8.encode(body);
    }

    // convert List<int> to Uint8List
    if (body is List<int>) {
      return Uint8List.fromList(body);
    }

    return null;
  }

  void _load(WebViewContent model) {
    switch (model.sourceType) {
      case SourceType.html:
        originalWebViewController.loadHtmlString(HtmlUtils.preprocessSource(
          model.source,
          jsContent: widget.jsContent,
        ));
        break;
      case SourceType.url:
      case SourceType.urlBypass:
        originalWebViewController.loadRequest(
          Uri.parse(model.source),
          headers: model.headers ?? {},
          body: _convertPostRequestBody(model.webPostRequestBody),
        );
        break;
    }
  }

  // Called when the ValueNotifier inside WebViewXController updates it's value
  void _handleIgnoreGesturesChange() {
    setState(() {
      _ignoreAllGestures = webViewXController.ignoresAllGestures;
    });
  }

  @override
  void dispose() {
    webViewXController.removeListener(_handleChange);
    webViewXController.removeIgnoreGesturesListener(
      _handleIgnoreGesturesChange,
    );
    super.dispose();
  }
}
