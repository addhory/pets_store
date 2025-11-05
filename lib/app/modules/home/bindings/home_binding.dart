import 'package:get/get.dart';
import 'package:pets_store/app/modules/home/controllers/home_controller.dart';
import 'package:pets_store/app/data/providers/pet_api_provider.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure PetApiProvider is available for HomeController
    if (!Get.isRegistered<PetApiProvider>()) {
      Get.put<PetApiProvider>(PetApiProvider(), permanent: true);
    }

    Get.lazyPut<HomeController>(() => HomeController(Get.find<PetApiProvider>()));
  }
}
