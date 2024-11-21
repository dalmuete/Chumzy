import 'package:chumzy/features/01-auth/views/login_screen.dart';
import 'package:chumzy/features/splash/views/screens.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChumzySplashScreen extends StatefulWidget {
  @override
  _ChumzySplashScreenState createState() => _ChumzySplashScreenState();
}

class _ChumzySplashScreenState extends State<ChumzySplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/chumzy_3s.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 3800), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => IntroScreens(),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE9AC),
      body: Center(
        child: _controller.value.isInitialized
            ? Container(
                width: double.infinity,
                height: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
