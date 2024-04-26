import 'package:cache_image/repository/image_repository.dart';
import 'package:cache_image/screens/show_images.dart';
import 'package:cache_image/service/cache.dart';
import 'package:cache_image/service/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/image_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Upload',
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ImageRepository>(
            create: (context) => ImageRepository(
              firestoreService: FirestoreService(),
              cacheService: CacheService(),
            ),
          ),
        ],
        child: BlocProvider(
          create: (context) => ImageBloc(
            imageRepository: context.read<ImageRepository>(),
          ),
          child: const ShowImageListScreen(),
        ),
      ),
    );
  }
}