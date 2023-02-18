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
}
