import 'package:flutter/material.dart';

class IntroImageList extends StatefulWidget {
  const IntroImageList({super.key});

  @override
  State<IntroImageList> createState() => _IntroImageListState();
}

class _IntroImageListState extends State<IntroImageList> {
  final PageController pageController = PageController(viewportFraction: 0.75);

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        padEnds: true,
        controller: pageController,
        itemCount: 7,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // ignore: unused_local_variable
          bool active = index == currentPage;
          return Opacity(
            opacity: currentPage == index ? 1.0 : 0.5,
            child: Image.asset(
              'assets/images/intro-image${index + 1}.png',
              height: 100.0,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      int position = pageController.page!.round();
      if (currentPage != position) {
        {
          setState(() {
            currentPage = position;
          });
        }
      }
    });
  }
}
