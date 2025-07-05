import '../../../../core/utils/resource.dart';

abstract class FileManagementRepository {
  Future<Resource<String>> uploadImage(Uri uri, String folder, String fileName);
}