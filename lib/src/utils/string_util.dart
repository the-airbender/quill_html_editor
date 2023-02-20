import 'dart:ui';

import 'package:flutter/foundation.dart';

///[StringUtil] utility class to convert objects/styles into string
class StringUtil {
  ///[getCssFontWeight] a utility method to convert the font weight
  ///into css style for the editor; default FontWeight will be normal
  static String getCssFontWeight(FontWeight? fontWeight) {
    return describeEnum(fontWeight ?? FontWeight.normal)
        .toString()
        .replaceAll('w', '');
  }

  ///[getCssFontStyle] a utility method to convert the font style
  ///into css style for the editor; default FontStyle will be normal
  static String getCssFontStyle(FontStyle? fontStyle) {
    return describeEnum(fontStyle ?? FontStyle.normal).toString();
  }

  ///[getCssTextAlign] a utility method to convert the text align
  ///into css style for the editor; default TextAlign will be start
  static String getCssTextAlign(TextAlign? textAlign) {
    return describeEnum(textAlign ?? TextAlign.start).toString();
  }

  ///[sanitizeVideoUrl] a utility method to convert the Youtube, Vimeo or Network urls to embed in editor
  static String? sanitizeVideoUrl(String url) {
    final uri = Uri.parse(url);
    if (uri.host.toLowerCase().contains('youtube')) {
      return getYoutubeEmbedLink(url);
    } else if (uri.host.toLowerCase().contains('vimeo')) {
      return getVimeoEmbedLink(url);
    } else {
      return url;
    }
  }

  ///[getYoutubeEmbedLink] a utility method to convert the Youtube urls to embed link
  static String? getYoutubeEmbedLink(String url) {
    if (!url.contains("http") && (url.length == 11)) return url;
    url.trim();
    String? youtubeId;
    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        youtubeId = match.group(1);
      }
    }
    if (youtubeId == null) {
      return null;
    }
    return 'https://www.youtube.com/embed/$youtubeId';
  }

  ///[getVimeoEmbedLink] a utility method to convert the Vimeo urls to embed link
  static String? getVimeoEmbedLink(String url) {
    final RegExp vimeoRegex = RegExp(
      r'(?:http|https)?:?\/?\/?(?:www\.)?(?:player\.)?vimeo\.com\/(?:channels\/(?:\w+\/)?|groups\/(?:[^\/]*)\/videos\/|video\/|)(\d+)(?:|\/\?)',
      caseSensitive: false,
      multiLine: false,
    );
    var vimeoId = vimeoRegex.firstMatch(url)?.group(1);
    if (vimeoId == null) {
      return null;
    }
    return 'https://player.vimeo.com/video/$vimeoId';
  }
}
