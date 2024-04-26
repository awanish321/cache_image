import 'package:equatable/equatable.dart';
import '../models/image_model.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoadingState extends ImageState {}

class ImageLoadedState extends ImageState {
  final List<ImageModel> images;

  const ImageLoadedState({required this.images});

  @override
  List<Object> get props => [images];
}

class ImageUploadingState extends ImageState {}

class ImageUploadedState extends ImageState {
  final List<ImageModel> images;

  const ImageUploadedState({required this.images});

  @override
  List<Object> get props => [images];
}

class ImageErrorState extends ImageState {
  final String error;

  const ImageErrorState({required this.error});

  @override
  List<Object> get props => [error];
}