import 'package:get/get.dart';
import 'package:pets_store/app/data/providers/user_api_provider.dart';
import 'package:pets_store/app/data/repositories/user_repository.dart';
import 'package:pets_store/app/modules/auth/controllers/login_controller.dart';
import 'package:pets_store/app/modules/auth/controllers/register_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Global dependency (can be permanent)
    Get.put<UserApiProvider>(UserApiProvider(), permanent: true);

    // ✅ Shared repository for both login and register
    Get.lazyPut<UserRepository>(
      () => UserRepository(Get.find<UserApiProvider>()),
      fenix: true,
    );

    // ✅ Both controllers under one binding
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<UserRepository>()),
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find<UserRepository>()),
    );
  }
}
