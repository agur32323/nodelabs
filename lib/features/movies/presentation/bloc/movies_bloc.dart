import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nodelabs_case/core/service/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/movie_model.dart';
import '../../data/datasources/movies_remote_data_source.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRemoteDataSource dataSource;
  int currentPage = 1;
  bool isFetching = false;

  MoviesBloc(this.dataSource) : super(MoviesInitial()) {
    on<FetchMovies>((event, emit) async {
      if (isFetching) return;
      isFetching = true;

      try {
        if (event.refresh) {
          currentPage = 1;
          emit(MoviesLoading());
        }

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token') ?? "";

        if (token.isEmpty) {
          emit(MoviesError("Token bulunamadı, lütfen tekrar giriş yapın."));
          isFetching = false;
          return;
        }

        final movies = await dataSource.fetchMovies(
          page: currentPage,
          token: token,
        );

        if (movies.isEmpty) {
          emit(MoviesLoaded([]));
          isFetching = false;
          return;
        }

        currentPage++;

        if (state is MoviesLoaded && !event.refresh) {
          final oldMovies = (state as MoviesLoaded).movies;
          emit(MoviesLoaded([...oldMovies, ...movies]));
        } else {
          emit(MoviesLoaded(movies));
        }
      } catch (e) {
        if (e is DioException) {
          LoggerService().d("MOVIE ERROR: ${e.response?.data}");
          emit(
            MoviesError(e.response?.data.toString() ?? e.message ?? 'Error'),
          );
        } else {
          emit(MoviesError(e.toString()));
        }
      }

      isFetching = false;
    });

    on<ToggleFavorite>((event, emit) async {
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;

        final updatedMovies = currentState.movies.map((movie) {
          if (movie.id == event.movieId) {
            return movie.copyWith(isFavorite: !movie.isFavorite);
          }
          return movie;
        }).toList();

        emit(MoviesLoaded(updatedMovies));

        try {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token') ?? "";
          if (token.isEmpty) {
            emit(MoviesError("Token bulunamadı, lütfen tekrar giriş yapın."));
            return;
          }

          await dataSource.toggleFavorite(event.movieId, token: token);
        } catch (e) {
          if (e is DioException) {
            emit(
              MoviesError(e.response?.data.toString() ?? e.message ?? 'Error'),
            );
          } else {
            emit(MoviesError(e.toString()));
          }
        }
      }
    });
  }
}
