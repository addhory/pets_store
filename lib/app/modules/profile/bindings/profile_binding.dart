import 'package:get/get.dart';
import 'package:pets_store/app/data/providers/user_api_provider.dart';
import 'package:pets_store/app/data/repositories/user_repository.dart';
import 'package:pets_store/app/data/services/storage_services.dart';
import 'package:pets_store/app/modules/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure shared services/providers
    if (!Get.isRegistered<UserApiProvider>()) {
      Get.put<UserApiProvider>(UserApiProvider(), permanent: true);
    }
    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(StorageService(), permanent: true);
    }

    Get.lazyPut<UserRepository>(() => UserRepository(Get.find<UserApiProvider>()));
    Get.lazyPut<ProfileController>(() => ProfileController(
          Get.find<UserRepository>(),
          Get.find<StorageService>(),
        ));
  }
}