import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

class ImageSelector {
  ///[onImagePicked] callback function for image picker
  final Function(String) onImagePicked;

  ///[ImageSelector] image selector widget to set images to editor
  ImageSelector({required this.onImagePicked});
  late List<PlatformFile>? _paths;
  late String? _extension;
  final FileType _pickingType = FileType.image;

  ///[pickFiles] to pick the files
  Future<void> pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) =>
            debugPrint(status.toString()),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
      print(_paths);
      if (_paths != null && _paths!.isNotEmpty) {
        Uint8List? bytes;
        if (kIsWeb) {
          bytes = _paths!.single.bytes;
        } else {
          if (_paths!.single.path != null) {
            bytes = await File(_paths!.single.path!).readAsBytes();
          }
        }
        if (bytes != null) {
          String base64String = base64Encode(bytes);
          onImagePicked(
              'data:image/${_paths!.single.extension};base64,$base64String');
        }
      }
    } on PlatformException catch (e) {
      debugPrint('Unsupported operation $e');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _resetState() {
    _paths = null;
  }
}

///[OnPickImageCallback] typedef for onPickImageCallback
typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
