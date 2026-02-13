import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../core/utils/logger_utils.dart';

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// ── Pick image from gallery or camera ──
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        return File(picked.path);
      }
      return null;
    } catch (e) {
      Log.e('Pick image error', e);
      return null;
    }
  }

  /// ── Compress image ──
  Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${const Uuid().v4()}${p.extension(file.path)}';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 75,
        minWidth: 800,
        minHeight: 800,
      );

      return result != null ? File(result.path) : file;
    } catch (e) {
      Log.e('Compress image error', e);
      return file;
    }
  }

  /// ── Upload image to Firebase Storage ──
  Future<String?> uploadImage(File file, String path) async {
    try {
      // Compress first
      final compressed = await compressImage(file);
      final uploadFile = compressed ?? file;

      final ref = _storage.ref().child(path).child(
            '${const Uuid().v4()}${p.extension(uploadFile.path)}',
          );

      final uploadTask = ref.putFile(uploadFile);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      Log.i('Image uploaded: $path');
      return url;
    } catch (e) {
      Log.e('Upload image error', e);
      return null;
    }
  }

  /// ── Delete image ──
  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      Log.i('Image deleted');
    } catch (e) {
      Log.e('Delete image error', e);
    }
  }
}
