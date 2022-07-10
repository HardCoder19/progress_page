import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form.dart';

class FinalFile {
  FinalFile(PlatformFile? file, File? image) {
    if (file != null) {
      this.name1 = file.name;
      this.bytes1 = Uri.dataFromBytes(file.bytes!);
      this.path1 = file.path;
    } else if (image != null) {
      this.name1 = image.path.split('/').last;
      this.bytes1 = image.uri;
      this.path1 = image.path;
    }
  }
  String name1 = '';
  late final Uri bytes1;
  late final path1;
}
