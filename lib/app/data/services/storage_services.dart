import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  @override
  void onInit() {
    _box = GetStorage();
    super.onInit();
  }

  // Generic read
  T? read<T>(String key) => _box.read<T>(key);

  // Generic write
  Future<void> write(String key, dynamic value) async => _box.write(key, value);

  // Remove
  Future<void> remove(String key) async => _box.remove(key);

  // Clear all
  Future<void> clearAll() async => _box.erase();

  // Check if key exists
  bool hasData(String key) => _box.hasData(key);

  // Listen to key changes
  void listenKey(String key, Function(dynamic) callback) {
    _box.listenKey(key, callback);
  }

  // check profile and token
  bool hasProfileAndToken() => hasData('profile') && hasData('token');
}
