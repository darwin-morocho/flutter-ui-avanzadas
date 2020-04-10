import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Extras {
  static String getTime(int time) {
    final duration = Duration(seconds: time);
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  static Future<File> pickImage(
      {bool fromCamera = false, withCompress = false}) async {
    final file = await ImagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    if (withCompress && file != null) {
      return await compressImage(file);
    }
    return file;
  }

  // get image dimensions by file
  static Future<ui.Image> getImageInfo(File file) {
    final image = Image.file(file);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, _) {
      completer.complete(info.image);
    }));

    return completer.future;
  }

  static Future<File> compressImage(File file) async {
    final size = file.lengthSync() / 1000; // in kbs
    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';

    final maxSize = 500; // maximun size 500kb
    if (size <= maxSize) return file;
    //caculate quality
    final quality = 100 / (size / maxSize);

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: quality.toInt());

    print(
        "original size: ${(size / 1000).toStringAsFixed(1)} mb, new size: ${(compressedFile.lengthSync() / 1000 / 1000).toStringAsFixed(1)} mb");

    return compressedFile;
  }

  static StorageUploadTask uploadFile(File file) {
    // file.path.

    final ext = path.extension(file.path);

    final StorageReference storageReference = FirebaseStorage()
        .ref()
        .child("/images/${DateTime.now().millisecondsSinceEpoch}.$ext");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    return uploadTask;
  }
}
