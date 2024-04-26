// import 'dart:async';
// import 'package:bloc/bloc.dart';
//
// import '../repository/image_repository.dart';
// import 'image_event.dart';
// import 'image_state.dart';
//
// class ImageBloc extends Bloc<ImageEvent, ImageState> {
//   final ImageRepository _imageRepository;
//
//   ImageBloc({required ImageRepository imageRepository})
//       : _imageRepository = imageRepository,
//         super(ImageInitial());
//
//   Stream<ImageState> mapEventToState(ImageEvent event) async* {
//     if (event is FetchImagesEvent) {
//       emit(ImageLoadingState());
//       try {
//         final images = await _imageRepository.fetchImages();
//         emit(ImageLoadedState(images: images));
//       } catch (e) {
//         emit(ImageErrorState(error: e.toString()));
//       }
//     } else if (event is UploadImagesEvent) {
//       emit(ImageUploadingState());
//       try {
//         await _imageRepository.uploadImages(event.images);
//         final images = await _imageRepository.fetchImages();
//         emit(ImageUploadedState(images: images));
//       } catch (e) {
//         emit(ImageErrorState(error: e.toString()));
//       }
//     }
//   }
// }




import 'package:bloc/bloc.dart';

import '../repository/image_repository.dart';
import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _imageRepository;

  ImageBloc({required ImageRepository imageRepository})
      : _imageRepository = imageRepository,
        super(ImageInitial()) {
    on<FetchImagesEvent>(_onFetchImagesEvent);
    on<UploadImagesEvent>(_onUploadImagesEvent);
  }

  Future<void> _onFetchImagesEvent(
      FetchImagesEvent event,
      Emitter<ImageState> emit,
      ) async {
    emit(ImageLoadingState());
    try {
      final images = await _imageRepository.fetchImages();
      emit(ImageLoadedState(images: images));
    } catch (e) {
      emit(ImageErrorState(error: e.toString()));
    }
  }

  Future<void> _onUploadImagesEvent(
      UploadImagesEvent event,
      Emitter<ImageState> emit,
      ) async {
    emit(ImageUploadingState());
    try {
      await _imageRepository.uploadImages(event.images);
      final images = await _imageRepository.fetchImages();
      emit(ImageUploadedState(images: images));
    } catch (e) {
      emit(ImageErrorState(error: e.toString()));
    }
  }
}