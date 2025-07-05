import 'dart:developer';

import 'package:uniride_driver/features/file/domain/services/file_management_service.dart';

import '../../../../core/utils/resource.dart';
import '../../domain/repositories/file_management_repository.dart';

class FileManagementRepositoryImpl implements FileManagementRepository {
  final FileManagementService fileManagementService;

  FileManagementRepositoryImpl({required this.fileManagementService});

  @override
  Future<Resource<String>> uploadImage(Uri uri, String folder, String fileName) async {
    try {
      final result = await fileManagementService.uploadImage(uri, folder, fileName);
      log('TAG: FileManagementRepositoryImpl: Image uploaded successfully: $result');
      return Success(result);
    } catch (e) {
      log('TAG: FileManagementRepositoryImpl: Error uploading image: $e');
      return Failure(e.toString());
    }
  }
}