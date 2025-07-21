part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovies extends MoviesEvent {
  final bool refresh;
  FetchMovies({this.refresh = false});
}

class ToggleFavorite extends MoviesEvent {
  final String movieId;

  ToggleFavorite(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
