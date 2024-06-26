import 'package:cache_image/screens/upload_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../bloc/image_bloc.dart';
import '../bloc/image_event.dart';
import '../bloc/image_state.dart';
import '../models/image_model.dart';

class ShowImageListScreen extends StatefulWidget {
  const ShowImageListScreen({super.key});

  @override
  State<ShowImageListScreen> createState() => _ShowImageListScreenState();
}

class _ShowImageListScreenState extends State<ShowImageListScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<ImageBloc>().add(FetchImagesEvent());
    _preloadImages();
  }

  void _preloadImages() {
    context.read<ImageBloc>().stream.listen((state) {
      if (state is ImageLoadedState || state is ImageUploadedState) {
        final List<ImageModel> images =
        state is ImageLoadedState ? state.images : (state as ImageUploadedState).images;
        for (final image in images) {
          precacheImage(CachedNetworkImageProvider(image.url), context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final images = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImageUploadScreen()),
          );
          if (images != null) {
            context.read<ImageBloc>().add(UploadImagesEvent(images));
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(0.5),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state is ImageLoadedState || state is ImageUploadedState) {
            final List<ImageModel> images =
            state is ImageLoadedState ? state.images : (state as ImageUploadedState).images;

            return PhotoViewGallery(
              backgroundDecoration: const BoxDecoration(
                color: Colors.white,
              ),
              scrollDirection: Axis.vertical,
              wantKeepAlive: true,
              pageOptions: images
                  .asMap()
                  .map((index, image) {
                final pageOption = PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(image.url),
                  minScale: PhotoViewComputedScale.covered,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
                return MapEntry(
                  index,
                  index == 0
                      ? PhotoViewGalleryPageOptions.customChild(
                    child: Container(
                      padding: const EdgeInsets.only(top: 85),
                      child: Image(
                        image: CachedNetworkImageProvider(image.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                    minScale: PhotoViewComputedScale.covered,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  )
                      : pageOption,

                );
              })
                  .values
                  .toList(),
              allowImplicitScrolling: true,
              pageSnapping: true,
              gaplessPlayback: true,
              pageController: _pageController,
              onPageChanged: (index) {},
            );
          } else if (state is ImageErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
