import 'package:dio/dio.dart';
import 'package:nodelabs_case/core/service/logger_service.dart';
import '../models/movie_model.dart';

class MoviesRemoteDataSource {
  final Dio dio;

  MoviesRemoteDataSource(this.dio);

  Future<List<MovieModel>> fetchMovies({
    int page = 1,
    required String token,
  }) async {
    final response = await dio.get(
      'https://caseapi.servicelabs.tech/movie/list?page=$page',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    LoggerService().i("API RESPONSE DATA: ${response.data}");
    final data = response.data['data'];
    if (data == null || data['movies'] == null) {
      return [];
    }

    final moviesJson = data['movies'] as List;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<void> toggleFavorite(String movieId, {required String token}) async {
    if (token.isEmpty) {
      throw Exception("Token bulunamadı, lütfen tekrar giriş yapın.");
    }

    final url = 'https://caseapi.servicelabs.tech/movie/favorite/$movieId';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      rethrow;
    }
  }
}
