import 'package:get/get.dart';
import 'package:pets_store/app/data/providers/user_api_provider.dart';
import 'package:pets_store/app/data/repositories/user_repository.dart';
import 'package:pets_store/app/modules/auth/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure provider is available
    if (!Get.isRegistered<UserApiProvider>()) {
      Get.put<UserApiProvider>(UserApiProvider(), permanent: true);
    }

    // Repository
    Get.lazyPut<UserRepository>(
      () => UserRepository(Get.find<UserApiProvider>()),
    );

    // Controller
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<UserRepository>()),
    );
  }
}
