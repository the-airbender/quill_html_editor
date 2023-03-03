import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/src/utils/hex_color.dart';

///[FormatConfig] to create a format map for insertText
class FormatConfig {
  ///[bold] sets bold format
  bool? bold;

  /// [italic] sets italic format
  bool? italic;

  /// [underline] sets underline to text
  bool? underline;

  /// [strike] makes the selected text strikethrough
  bool? strike;

  /// [blockQuote] converts text to quote
  bool? blockQuote;

  /// [codeBlock] makes selected text code block
  bool? codeBlock;

  /// [indentMinus] decreases the indent by given value
  bool? indentMinus;

  /// [indentAdd] increases the indent by given value
  bool? indentAdd;

  /// [directionRtl] sets the direction of text from Right to Left
  bool? directionRtl;

  /// [directionLtr] sets the direction of text from Left to Right
  bool? directionLtr;

  /// [headerType] enum to set the text H1,H2
  HeaderType? headerType;

  /// [color] sets font color
  Color? color;

  /// [background] sets background color to text
  Color? background;

  /// [align] adds alignment to text, left, right, center, justify
  AlignType? align;

  /// [fontSize] sets fontSize of the text
  double? fontSize;

  ///FormatConfig constructor to set the required styles
  FormatConfig({
    this.bold,
    this.color,
    this.italic,
    this.underline,
    this.strike,
    this.background,
    this.headerType,
    this.directionRtl,
    this.blockQuote,
    this.align,
    this.codeBlock,
    this.directionLtr,
    this.indentAdd,
    this.indentMinus,
    this.fontSize,
  });

  /// will add the following formats in future release
  /// link, font,image, video, orderedList, bulletList

  Map<String, dynamic> toMap() {
    return {
      if (bold != null) 'bold': bold ?? false,
      if (italic != null) 'italic': italic ?? false,
      if (underline != null) 'underline': underline ?? false,
      if (strike != null) 'strike': strike ?? false,
      if (blockQuote != null) 'blockqoute': blockQuote ?? false,
      if (codeBlock != null) 'code-block': codeBlock ?? false,
      if (indentAdd != null || indentMinus != null)
        'indent': indentAdd == true
            ? '+1'
            : indentMinus == true
                ? '-1'
                : '',
      if (directionRtl != null || directionLtr != null)
        'direction': directionRtl == true
            ? 'rtl'
            : directionLtr == true
                ? 'ltr'
                : '',

      'fontSize': fontSize ?? 14,
      if (headerType != null)
        'header': headerType == null
            ? 4
            : headerType?.index == 0
                ? 1
                : 2,
      if (color != null) 'color': color?.toHex(),
      if (background != null) 'background': background?.toHex(),
      if (align != null) 'align': describeEnum(align ?? AlignType.left),

      /// 'list':, 'image':, 'video':, 'clean':, 'link':, 'size': size,
    };
  }
}

///[AlignType] to define the alignment of the text
enum AlignType {
  /// to align left,
  left,

  /// to align center,
  center,

  /// to align right,
  right,

  /// to align justify,
  justify
}

///[HeaderType] to define the header to editor
enum HeaderType {
  /// to set the H1 header,
  headerOne,

  /// to set the H2 header,
  headerTwo
}
