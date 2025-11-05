import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/data/repositories/user_repository.dart';
import 'package:pets_store/app/data/services/storage_services.dart';
import 'package:pets_store/app/routes/app_routes.dart';

class LoginController extends GetxController {
  var loginUsernameController = TextEditingController();
  var loginPasswordController = TextEditingController();
  final isLoading = false.obs;
  final UserRepository _userRepository;

  LoginController(this._userRepository);

  void login() async {
    final username = loginUsernameController.text.trim();
    final password = loginPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username and password are required');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _userRepository.login(username, password);
      if (response.statusCode == 200) {
        // get profile
        final profile = await _userRepository.getUserByUsername(username);
        // isLoading.value = false;
        // Save token to storage
        Get.find<StorageService>().write('token', '$username token');
        // Save profile to storage
        Get.find<StorageService>().write('profile', profile.toJson());
        Get.snackbar('Success', 'Logged in as ${profile.username}');
        Get.offAllNamed(Routes.home);
      } else {
        isLoading.value = false;
        Get.snackbar('Error', 'Login failed');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Login failed');
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.register);
  }
}
