class PetModel {
  final int id;
  final String name;
  final Category category;
  final List<String> photoUrls;
  final List<Tag> tags;
  final String status;

  PetModel({
    required this.id,
    required this.name,
    required this.category,
    required this.photoUrls,
    required this.tags,
    required this.status,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      name: json['name'] as String,
      category: Category.fromJson(
        (json['category'] ?? {}) as Map<String, dynamic>,
      ),
      photoUrls: (json['photoUrls'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toJson(),
      'photoUrls': photoUrls,
      'tags': tags.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      name: (json['name'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Tag {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      name: (json['name'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
