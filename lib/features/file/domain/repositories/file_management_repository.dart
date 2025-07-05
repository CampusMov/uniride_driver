import '../../../../core/utils/resource.dart';

abstract class FileManagementRepository {
  Future<Resource<String>> uploadImage(String filePath, String folder, String fileName);
}