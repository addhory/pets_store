import 'package:get/get.dart';
import 'package:pets_store/app/core/utils/constants.dart';
import 'package:pets_store/app/data/models/pet_model.dart';

enum PetStatus { available, pending, sold }

class PetApiProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    baseUrl = '${AppConstants.apiBaseUrl}/pet';
  }

  Future<PetModel> getPetById(int id) async {
    final response = await get('/$id');
    if (response.statusCode == 200) {
      return PetModel.fromJson(response.body);
    } else {
      throw Exception('Failed to get pet by id');
    }
  }

  // find by tags
  //  'http://localhost:8080/api/v3/pet/findByTags?tags=test&tags=test1' \
  Future<List<PetModel>> findByTags(List<String> tags) async {
    if (tags.isEmpty) {
      return [];
    }

    final response = await get('/findByTags', query: {'tags': tags});
    if (response.statusCode == 200) {
      return (response.body as List).map((e) => PetModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to find pet by tags');
    }
  }

  // find by status
  // status option -> available, pending, sold
  Future<List<PetModel>> findByStatus(PetStatus status) async {
    final response = await get('/findByStatus?status=${status.name}');
    if (response.statusCode == 200) {
      return (response.body as List).map((e) => PetModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to find pet by status');
    }
  }
}
