import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  List<File> _images = [];
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _imagePicker.pickMultiImage();
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
    }

  Future<void> _uploadImages() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final List<String> downloadUrls = [];

      for (File image in _images) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');
        UploadTask uploadTask = storageReference.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      debugPrint('Image upload successful! Download URLs: $downloadUrls');
    } catch (e) {
      debugPrint('Image upload failed: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
      Navigator.pop(context, _images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Images'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final image = _images[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(image, fit: BoxFit.contain),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _pickImages,
            child: const Text('Pick Images'),
          ),
          ElevatedButton(
            onPressed: _images.isNotEmpty ? _uploadImages : null,
            child: _isUploading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Text('Upload'),
          ),
        ],
      ),
    );
  }
}