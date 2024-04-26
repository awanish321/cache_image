import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class FetchImagesEvent extends ImageEvent {
  @override
  List<Object?> get props => [];
}

class UploadImagesEvent extends ImageEvent {
  final List<File> images;

  const UploadImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}