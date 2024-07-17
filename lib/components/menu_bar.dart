import 'package:flutter/material.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:google_fonts/google_fonts.dart';

class ZoomMenuBar extends StatelessWidget {
  const ZoomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    var zoom = ZoomVideoSdk();
    // ignore: non_constant_identifier_names
    var SDK_URL = 'https://marketplace.zoom.us';
    //final SDK_URL = Uri.parse('https://google.com');

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Video SDK playground',
              style: GoogleFonts.varela(
                  textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              )),
            ),
          ),
          ListTile(
            leading: const ImageIcon(
              AssetImage("assets/icons/question-ballon@2x.png"),
            ),
            title: const Text(
              'Zoom Video SDK',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            onTap: () async => {
              zoom.openBrowser(SDK_URL),
            },
          ),
          ListTile(
            leading: const Icon(Icons.spatial_audio),
            title: const Text(
              'Audio Test',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 16,
                        child: SizedBox(
                          height: 350,
                          child: Column(
                            children: [
                              ListView(
                                shrinkWrap: true,
                                children: [
                                  ListTile(
                                    title: const Text('Start Mic Test'),
                                    onTap: () async {
                                      var micResult = await zoom.testAudioHelper
                                          .startMicTest();
                                      debugPrint("Start Mic Test: $micResult");
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Stop Mic Test'),
                                    onTap: () async {
                                      var micResult = await zoom.testAudioHelper
                                          .stopMicTest();
                                      debugPrint("Stop Mic Test: $micResult");
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Play Mic Test'),
                                    onTap: () async {
                                      var micResult = await zoom.testAudioHelper
                                          .playMicTest();
                                      debugPrint("Play Mic Test: $micResult");
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Start Speaker Test'),
                                    onTap: () async {
                                      var micResult = await zoom.testAudioHelper
                                          .startSpeakerTest();
                                      debugPrint(
                                          "Start Speaker Test: $micResult");
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Stop Speaker Test'),
                                    onTap: () async {
                                      var micResult = await zoom.testAudioHelper
                                          .stopSpeakerTest();
                                      debugPrint(
                                          "Stop Speaker Test: $micResult");
                                    },
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); //close Dialog
                                },
                                child: const Text('Close'),
                              )
                            ],
                          ),
                        ));
                  });
            },
          ),
        ],
      ),
    );
  }
}
