import 'package:themoviedb/feature/home/domain/entity/genre_entity.dart';

class GenreModels {
  final int id;
  final String name;

  GenreModels({required this.id, required this.name});

  factory GenreModels.fromJson(Map<String, dynamic> json) {
    return GenreModels(id: json["id"], name: json["name"]);
  }
  Map<String, dynamic> toJson() => {"id": id, "name": name};

  GenreEntity toEntity() {
    return GenreEntity(id: id, name: name);
  }
}
