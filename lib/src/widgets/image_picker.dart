import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

///[ImageSelector] to pick files or media, supports all platforms
class ImageSelector {
  ///[onImagePicked] callback function for image picker
  final Function(String) onImagePicked;

  ///[ImageSelector] image selector widget to set images to editor
  ImageSelector({required this.onImagePicked});

  final FileType _pickingType = FileType.image;

  ///[pickFiles] to pick the files
  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: _pickingType, withData: true);

      if (result != null) {
        PlatformFile file = result.files.first;
        Uint8List? bytes = file.bytes;
        if (bytes != null) {
          String base64String = base64Encode(bytes);
          onImagePicked('data:image/${file.extension};base64,$base64String');
        }
      }
    } on PlatformException catch (e) {
      debugPrint('Unsupported operation $e');
    } catch (e) {
      debugPrint('File Picker ${e.toString()}');
    }
  }
}

///[OnPickImageCallback] typedef for onPickImageCallback
typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
