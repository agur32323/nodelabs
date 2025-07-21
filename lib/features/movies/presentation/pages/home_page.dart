import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs_case/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:nodelabs_case/features/movies/presentation/pages/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

String securePosterUrl(String url) {
  return url.startsWith('http://')
      ? url.replaceFirst('http://', 'https://')
      : url;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [MovieExplorePage(), ProfilePage()];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Anasayfa", 0),
            _buildNavButton(Icons.person, "Profil", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.white,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.red : Colors.white, size: 22),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieExplorePage extends StatefulWidget {
  const MovieExplorePage({super.key});

  @override
  State<MovieExplorePage> createState() => _MovieExplorePageState();
}

class _MovieExplorePageState extends State<MovieExplorePage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(FetchMovies());

    _pageController.addListener(() {
      final bloc = context.read<MoviesBloc>();
      final state = bloc.state;
      if (state is MoviesLoaded) {
        if (_pageController.page != null &&
            _pageController.page!.round() >= state.movies.length - 1) {
          bloc.add(FetchMovies());
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        color: Colors.red,
        backgroundColor: Colors.black,
        onRefresh: () async {
          context.read<MoviesBloc>().add(FetchMovies(refresh: true));
        },
        child: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
            if (state is MoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            } else if (state is MoviesLoaded) {
              if (state.movies.isEmpty) {
                return const Center(
                  child: Text(
                    "Hiç film bulunamadı.",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  final posterUrl = movie.poster.isNotEmpty
                      ? securePosterUrl(movie.poster)
                      : 'https://via.placeholder.com/400x600.png?text=No+Image';

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          child: const Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.transparent,
                              Colors.black.withOpacity(0.9),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Year: ${movie.year}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(
                                  movie.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: movie.isFavorite
                                      ? Colors.red
                                      : Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  context.read<MoviesBloc>().add(
                                    ToggleFavorite(movie.id),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (state is MoviesError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
