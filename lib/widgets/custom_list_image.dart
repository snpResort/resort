import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:resort/widgets/loading_widget.dart';

class CustomListImage extends StatefulWidget {
  int currentIndex;
  List<String> imagePaths;
  CustomListImage({Key? key,required this.currentIndex, required this.imagePaths }) : super(key: key);

  @override
  _CustomListImageState createState() => _CustomListImageState();
}

class _CustomListImageState extends State<CustomListImage> {
  late int _currentIndex;
  late PageController _pageController;
  @override
  void initState() {

    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildPhotoViewGallery(),
          _buildIndicator(),
          Positioned(
            top: 10.0,
            left: 20.0,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Icon(CupertinoIcons.back),
                ),
              )
            ),
          )
        ],
      ),
    );
  }

  PhotoViewGallery _buildPhotoViewGallery() {
    List<String> imagePaths =  widget.imagePaths;
    return PhotoViewGallery.builder(
      itemCount: imagePaths.length,
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(
              imagePaths[index],
          ),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      },
      enableRotation: true,
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: _pageController,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          child: LoadingWidget(),
        ),
      ),
      onPageChanged: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      // backgroundDecoration: BoxDecoration(color: Colors.red),
      // scrollDirection: Axis.vertical,
    );
  }
  Widget _buildIndicator() {
    List<String> imagePaths =  widget.imagePaths;
    return Positioned(
      bottom: 80.0,
      left: 0.0,
      right: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imagePaths
            .map<Widget>(( imagePath) => _buildDot(imagePath))
            .toList(),
      ),
    );
  }
  Widget _buildDot(String imagePath) {
    List<String> imagePaths =  widget.imagePaths;
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == imagePaths.indexWhere((element) => element == imagePath)
            ? Colors.white
            : Colors.grey.shade700,
      ),
    );
  }
}