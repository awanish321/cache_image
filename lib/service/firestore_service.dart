import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../models/image_model.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<ImageModel>> fetchImages() async {
    final snapshot = await _firestore.collection("IMAGES").get();
    return snapshot.docs.map((doc) => ImageModel.fromJson(doc.data())).toList();
  }

  // Future<List<ImageModel>> uploadImages(List<File> images) async {
  //   final uploadedImages = <ImageModel>[];
  //
  //   for (final image in images) {
  //     final imageId = _firestore.collection("IMAGES").doc().id;
  //     final imageRef = _storage.ref().child('images/$imageId');
  //     await imageRef.putFile(image);
  //     final imageUrl = await imageRef.getDownloadURL();
  //
  //     final imageModel = ImageModel(id: imageId, url: imageUrl);
  //     uploadedImages.add(imageModel);
  //
  //     await _firestore.collection("IMAGES").doc(imageId).set(imageModel.toJson());
  //   }
  //
  //   return uploadedImages;
  // }

  Future<List<ImageModel>> uploadImages(List<File> images) async {
    final uploadedImages = <ImageModel>[];

    for (final image in images) {
      final imageId = _firestore.collection("IMAGES").doc().id;
      final imageRef = _storage.ref().child('images/$imageId');

      try {
        // Set a timeout for the upload operation
        final metadata = SettableMetadata(contentType: 'image/jpeg', cacheControl: 'max-age=3600');
        final uploadTask = imageRef.putFile(image, metadata);

        // You can adjust the timeout duration as needed
        final snapshot = await uploadTask.whenComplete(() {}).timeout(const Duration(days: 20));

        final imageUrl = await snapshot.ref.getDownloadURL();
        final imageModel = ImageModel(id: imageId, url: imageUrl);
        uploadedImages.add(imageModel);

        await _firestore.collection("IMAGES").doc(imageId).set(imageModel.toJson());
      } catch (e) {
        if (e is FirebaseException && e.code == 'canceled') {
          // Handle the upload cancellation error
          debugPrint('Upload cancelled for image: $imageId');
        } else {
          // Handle other errors
          debugPrint('Error uploading image: $imageId, $e');
        }
      }
    }

    return uploadedImages;
  }

}