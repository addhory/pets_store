import 'package:get/get.dart';
import 'package:pets_store/app/core/utils/constants.dart';
import 'package:pets_store/app/data/models/user_model.dart';

class UserApiProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    baseUrl = '${AppConstants.apiBaseUrl}/user';
  }

  Future<UserModel> register(UserModel user) async {
    final response = await post('/', user.toJson());
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<Response> login(String username, String password) async {
    final response = await get(
      '/login',
      query: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<Response> logout() async {
    final response = await get('/logout');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to logout user');
    }
  }

  Future<UserModel> getProfile(String username) async {
    final response = await get('/$username');
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  // update current user profile
  Future<UserModel> updateProfile(UserModel user) async {
    final response = await put('/${user.username}', user.toJson());
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw Exception('Failed to update user profile');
    }
  }
}
