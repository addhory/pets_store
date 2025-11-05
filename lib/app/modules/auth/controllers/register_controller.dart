import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/data/models/user_model.dart';
import 'package:pets_store/app/data/repositories/user_repository.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  final UserRepository _userRepository;

  RegisterController(this._userRepository);

  UserModel? createdUser;

  void register() {
    // Validate all fields via Form
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    final username = usernameController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    // Additional cross-field validation safety (also covered in Form)
    if (password != confirm) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    _userRepository
        .register(
          UserModel(
            id: 99, // temporary id
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: phone,
            userStatus: 2, // regular user
          ),
        )
        .then((user) {
          isLoading.value = false;
          createdUser = user;
          Get.back();
          Get.snackbar('Success', 'User registered: ${createdUser!.username}');
          // Wait for the frame to complete
          // Ensure current controller cleanup completes
        })
        .catchError((error) {
          isLoading.value = false;
          Get.snackbar('Error', error.toString());
        });
  }

  @override
  void onClose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
