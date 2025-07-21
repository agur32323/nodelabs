class MovieModel {
  final String id;
  final String title;
  final String year;
  final String poster;
  final String? director;
  final bool isFavorite;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.poster,
    this.director,
    this.isFavorite = false,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id']?.toString() ?? '',
      title: json['Title']?.toString() ?? '',
      year: json['Year']?.toString() ?? '',
      poster: json['Poster']?.toString() ?? '',
      director: json['Director']?.toString(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Title': title,
      'Year': year,
      'Poster': poster,
      'Director': director,
      'isFavorite': isFavorite,
    };
  }

  MovieModel copyWith({
    String? id,
    String? title,
    String? year,
    String? poster,
    String? director,
    bool? isFavorite,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      poster: poster ?? this.poster,
      director: director ?? this.director,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'MovieModel(id: $id, title: $title, year: $year, poster: $poster, director: $director, isFavorite: $isFavorite)';
  }
}
