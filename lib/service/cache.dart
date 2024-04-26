import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class CacheService {
  static const key = 'cachedImages';

  Future<List<ImageModel>> getImages() async {
    final cacheManager = CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 1),
        maxNrOfCacheObjects: 100,
      ),
    );

    final fileInfo = await cacheManager.getFileFromCache(key);
    if (fileInfo == null) {
      return [];
    }

    final file = fileInfo.file;
    final jsonString = await file.readAsString();
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => ImageModel.fromJson(json)).toList();
  }

  Future<void> cacheImages(List<ImageModel> images) async {
    final cacheManager = CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 1),
        maxNrOfCacheObjects: 100,
      ),
    );

    final jsonList = images.map((image) => image.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$key');
    await file.writeAsString(jsonString);

    for (final image in images) {
      final cacheFile = await cacheManager.getImageFileFromUrl(image.url);
      await cacheManager.putFile(image.id, cacheFile.readAsBytesSync());
    }
  }
}

extension on CacheManager {
  Future<File> getImageFileFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(path);
    await file.writeAsBytes(bytes);

    return file;
  }
}