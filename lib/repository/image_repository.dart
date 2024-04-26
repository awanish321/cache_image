import 'dart:io';
import '../models/image_model.dart';
import '../service/cache.dart';
import '../service/firestore_service.dart';

class ImageRepository {
  final FirestoreService _firestoreService;
  final CacheService _cacheService;

  ImageRepository({
    required FirestoreService firestoreService,
    required CacheService cacheService,
  })  : _firestoreService = firestoreService,
        _cacheService = cacheService;

  Future<List<ImageModel>> fetchImages() async {
    final cachedImages = await _cacheService.getImages();
    if (cachedImages.isNotEmpty) {
      return cachedImages;
    }

    final images = await _firestoreService.fetchImages();
    _cacheService.cacheImages(images);
    return images;
  }

  Future<void> uploadImages(List<File> images) async {
    final uploadedImages = await _firestoreService.uploadImages(images);
    _cacheService.cacheImages(uploadedImages);
  }
}