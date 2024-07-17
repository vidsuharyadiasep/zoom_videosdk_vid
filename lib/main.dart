import 'package:flutter/material.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';

import 'package:zoom_videosdk_vid/screen/intro_screen.dart';
import 'package:zoom_videosdk_vid/screen/join_screen.dart';
import 'package:zoom_videosdk_vid/screen/call_screen.dart';

class ZoomVideoSDKVCube extends StatelessWidget {
  const ZoomVideoSDKVCube({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var zoom = ZoomVideoSdk();
    InitConfig initConfig = InitConfig(domain: "zoom.us", enableLog: false);

    zoom.initSdk(initConfig);
    return const SafeArea(
      child: IntroScreen(),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'VCube Zoom Video SDK',
      home: const SafeArea(
        child: ZoomVideoSDKVCube()
      ),
      routes: {
        "Intro": (context) => const IntroScreen(),
        "Join": (context) => const JoinScreen(),
        "Call": (context) => const CallScreen(),
        
      },
    ),
  );
}

