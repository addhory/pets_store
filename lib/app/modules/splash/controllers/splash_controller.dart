import 'package:get/get.dart';
import 'package:pets_store/app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('SplashController onInit called');
  }

  @override
  void onReady() {
    super.onReady();
    print('SplashController onReady called');
    _navigateToLogin();
  }

  void _navigateToLogin() {
    print('Starting navigation timer...');
    Future.delayed(const Duration(seconds: 2), () {
      print('Navigating to login...');
      Get.offAllNamed(Routes.login);
    });
  }
}
