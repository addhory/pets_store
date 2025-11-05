import 'package:get/get.dart';
import 'package:pets_store/app/data/models/user_model.dart';
import 'package:pets_store/app/data/providers/user_api_provider.dart';

class UserRepository {
  final UserApiProvider apiProvider;

  UserRepository(this.apiProvider);

  Future<UserModel> getUserByUsername(String username) async {
    return await apiProvider.getProfile(username);
  }

  Future<Response> login(String username, String password) async {
    return await apiProvider.login(username, password);
  }

  Future<UserModel> register(UserModel user) async {
    return await apiProvider.register(user);
  }

  Future<UserModel> updateProfile(UserModel user) async {
    return await apiProvider.updateProfile(user);
  }

  Future<Response> logout() async {
    return await apiProvider.logout();
  }
}
