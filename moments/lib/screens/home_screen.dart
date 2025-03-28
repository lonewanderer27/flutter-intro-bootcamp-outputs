import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/providers/camera_provider.dart';
import 'package:moments/providers/places_provider.dart';
import 'package:moments/screens/new_place_screen.dart';
import 'package:moments/widgets/camera_viewfinder.dart';
import 'package:moments/widgets/place_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late Future<void> _placesFuture;
  late PageController pageController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
    pageController = PageController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritePlaces = ref.watch(placesProvider);
    List<Widget> slides = [
      ...(favoritePlaces.map((place) => PlaceItem(place: place)).toList()),
      // ...(dummyPlaces
      //     .map((place) => PlaceItem(
      //           dummyPlace: place,
      //         ))
      //     .toList()),
      CameraViewFinder()
    ];

    void handleCamPress() {
      // if we're on the slides then set the current page to the last
      if (_currentPageIndex < slides.length - 1) {
        pageController.animateToPage(slides.length - 1, duration: Durations.long2, curve: Curves.decelerate);
        return;
      }

      // otherwise trigger the camera
      ref.read(cameraProvider.notifier).takePicture().then((image) {
        if (image == null) return;
        var pickedImage = File(image.path);
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewPlaceScreen(pickedImage, pageController)));
      });
    }

    void handleGalleryPress() {
      ref.read(cameraProvider.notifier).selectFromGallery().then((image) {
        if (image == null) return;
        var pickedImage = File(image.path);
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewPlaceScreen(pickedImage, pageController)));
      });
    }

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _placesFuture,
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PageView(
                      controller: pageController,
                      onPageChanged: (page) {
                        setState(() {
                          debugPrint('current page: $page');
                          _currentPageIndex = page;
                        });
                      },
                      children: slides,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: Duration(milliseconds: 300),
                  scale: _currentPageIndex < slides.length - 1 && slides.isNotEmpty ? 1.0 : 0.0,
                  child: _currentPageIndex < slides.length - 1 && slides.isNotEmpty
                      ? Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                child: SmoothPageIndicator(controller: pageController, count: slides.length),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
                ElevatedButton(
                  onPressed: handleCamPress,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(
                    Icons.photo_camera,
                    size: 28,
                  ),
                ),
                AnimatedScale(
                  scale: _currentPageIndex == slides.length - 1 ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: _currentPageIndex == slides.length - 1
                      ? IconButton.outlined(onPressed: handleGalleryPress, icon: Icon(Icons.image))
                      : SizedBox.shrink(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
