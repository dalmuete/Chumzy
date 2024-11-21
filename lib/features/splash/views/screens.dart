import 'package:chumzy/features/auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreens extends StatefulWidget {
  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/graphics_background.png',
              fit: BoxFit.cover, // Ensures the image covers the whole screen
            ),
          ),
          PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            children: [
              IntroScreen(
                title: "Meet Chumzy AI",
                imagePath: "assets/images/graphics_ai.png",
                description:
                    "Your smart study buddy for organizing, learning, and staying productive.",
                titleColor: Colors.black,
                descriptionColor: Colors.grey.shade800,
              ),
              IntroScreen(
                title: "Organize & Learn",
                imagePath: "assets/images/graphics_sort.png",
                description: "Categorize your study materials with ease.",
                titleColor: Colors.black,
                descriptionColor: Colors.grey.shade800,
              ),
              GetStartedScreen(),
            ],
          ),
          Positioned(
            bottom: 20,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Color(0xffFDC000),
                dotColor: const Color.fromARGB(255, 218, 218, 218),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class IntroScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color titleColor;
  final Color descriptionColor;

  IntroScreen({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.titleColor,
    required this.descriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 110),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Image.asset(
            imagePath,
            height: 350,
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              color: descriptionColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 110),
          Text(
            "Get Started",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Image.asset(
            "assets/images/graphics_simple.png",
            width: 400,
          ),
          SizedBox(height: 16),
          Text(
            "Join us in simplifying your study journey!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffFDC000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 120, vertical: 20),
            ),
            child: Text(
              "Get Started",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
