import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniride_driver/features/file/domain/services/file_management_service.dart';

class FileManagementServiceImpl implements FileManagementService {
  @override
  Future<String> uploadImage(Uri uri, String folder, String fileName) async {
    final path = '$folder/$fileName';
    final file = File.fromUri(uri);
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      if (!await file.exists()) {
        throw Exception('File does not exist: ${uri.path}');
      }
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log('TAG: FileManagementDataSource: Error uploading file: $e');
      throw FileStorageException('Error uploading file to $folder/$fileName', e);
    }
  }

}

class FileStorageException implements Exception {
  final String message;
  final dynamic cause;

  const FileStorageException(this.message, [this.cause]);

  @override
  String toString() => 'FileStorageException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}