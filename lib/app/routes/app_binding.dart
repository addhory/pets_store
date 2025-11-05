import 'package:get/get.dart';
import 'package:pets_store/app/data/services/storage_services.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);
  }
}
