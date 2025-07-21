import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:nodelabs_case/core/service/logger_service.dart';
import 'package:nodelabs_case/core/service/navigation_service.dart';
import 'package:nodelabs_case/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:nodelabs_case/features/movies/presentation/bloc/movies_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/pages/splash_screen.dart';

void main() async {
  LoggerService().d("Debug testi başladı!");

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRemoteDataSource())),
        BlocProvider<MoviesBloc>(
          create: (_) => MoviesBloc(MoviesRemoteDataSource(Dio())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService().navigatorKey,
        home: const SplashScreen(),
      ),
    );
  }
}
