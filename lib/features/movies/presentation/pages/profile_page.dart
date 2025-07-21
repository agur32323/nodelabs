import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nodelabs_case/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nodelabs_case/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:nodelabs_case/features/movies/data/models/movie_model.dart';
import 'package:nodelabs_case/features/movies/presentation/pages/LimitedOfferPage.dart';
import 'package:nodelabs_case/features/movies/presentation/pages/uploadPhoto_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userPhoto = "";
  bool isNetworkPhoto = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPhoto();
  }

  Future<void> _loadSavedPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhoto = prefs.getString('profile_photo');
    final savedIsNetwork = prefs.getBool('profile_photo_is_network') ?? false;

    setState(() {
      userPhoto = savedPhoto ?? "";
      isNetworkPhoto = savedIsNetwork;
      _isLoading = false;
    });
  }

  Future<void> _updateUserPhoto(String path, {bool isNetwork = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_photo', path);
    await prefs.setBool('profile_photo_is_network', isNetwork);

    setState(() {
      userPhoto = path;
      isNetworkPhoto = isNetwork;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    final authState = context.watch<AuthBloc>().state;
    final moviesState = context.watch<MoviesBloc>().state;

    String userName = "Kullanıcı";
    String userEmail = "";

    if (authState is AuthSuccess) {
      userName = authState.response.name.isNotEmpty
          ? authState.response.name
          : "Kullanıcı";
      userEmail = authState.response.email;
    }

    List<MovieModel> favoriteMovies = [];
    if (moviesState is MoviesLoaded) {
      favoriteMovies = moviesState.movies
          .where((movie) => movie.isFavorite)
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profil Detayı",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showLimitedOfferPopup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: const Text("Sınırlı Teklif"),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildProfileImage(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UploadPhotoPage(),
                        ),
                      );

                      if (result != null && result is String && mounted) {
                        await _updateUserPhoto(result, isNetwork: false);
                      } else {
                        final randomId =
                            DateTime.now().millisecondsSinceEpoch % 70;
                        final randomAvatarUrl =
                            "https://i.pravatar.cc/150?img=$randomId";
                        await _updateUserPhoto(
                          randomAvatarUrl,
                          isNetwork: true,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Fotoğraf Ekle"),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Beğendiğim Filmler",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: favoriteMovies.isEmpty
                    ? Center(
                        child: Lottie.asset(
                          'ios/assets/lottie/loading.json',
                          width: 200,
                          height: 200,
                          repeat: true,
                        ),
                      )
                    : GridView.builder(
                        itemCount: favoriteMovies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                        itemBuilder: (context, index) {
                          final movie = favoriteMovies[index];
                          return _buildMovieCard(movie.title, movie.poster);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (userPhoto.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: isNetworkPhoto
            ? NetworkImage(userPhoto)
            : FileImage(File(userPhoto)) as ImageProvider,
      );
    } else {
      return const CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
      );
    }
  }

  Widget _buildMovieCard(String title, String imageUrl) {
    final secureUrl = imageUrl.startsWith('http://')
        ? imageUrl.replaceFirst('http://', 'https://')
        : imageUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            secureUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
