import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: library_prefixes
import 'package:flutter_zoom_videosdk/flutter_zoom_view.dart' as FlutterZoomView;
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';

// ignore: constant_identifier_names
const SHOW_TALKING_ICON_DURATION = 2000;



class VideoView extends FlutterZoomView.ZoomView  {

  const VideoView({
    super.key,
    required super.user,
    required super.sharing,
    required super.preview,
    required super.focused,
    required super.hasMultiCamera,
    required super.isPiPView,
    required super.multiCameraIndex,
    required super.videoAspect,
    required super.fullScreen,
    required super.resolution,
  });

  @override
  Widget build(BuildContext context) {
    var isVideoOn = useState(false);
    var isTalking = useState(false);
    var isMuted = useState(false);
    // ignore: deprecated_member_use
    var isMounted = useIsMounted();
    var zoom = ZoomVideoSdk();
    var isSharing = useState(false);
    user?.audioStatus?.isMuted().then((muted) => isMuted.value = muted);

    useEffect(() {
      updateVideoStatus() {
        if (user == null) return;
        Future<void>.microtask(() async {
          if (isMounted()) {
            isVideoOn.value = (await user!.videoStatus!.isOn());
            isSharing.value = sharing;
          }
        });
      }

      // ignore: unused_element
      resetAudioStatus() {
        isTalking.value = false;
        isMuted.value = false;
      }

      // ignore: unused_element
      updateAudioStatus() async {
        if (!isMounted()) return;
        var talking = await user?.audioStatus?.isTalking();
        var muted = await user?.audioStatus?.isMuted();
        isMuted.value = muted!;
        isTalking.value = talking!;
        if (talking) {
          Timer(
              const Duration(milliseconds: SHOW_TALKING_ICON_DURATION),
              () {
                    if (isMounted())
                      {
                        isTalking.value = false;
                      }
                  });
        }
      }

      updateVideoStatus();
      return null;
    }, [zoom, user]);

    // ignore: unused_local_variable
    ImageIcon audioStatusIcon;
    if (isTalking.value) {
      audioStatusIcon = const ImageIcon(
        AssetImage("assets/icons/talking@2x.png"),
      );
    } else if (isMuted.value) {
      audioStatusIcon = const ImageIcon(
        AssetImage("assets/icons/muted@2x.png"),
      );
    }
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams.putIfAbsent("userId", () => preview? "" : user!.userId);
    creationParams.putIfAbsent("sharing", () => sharing);
    creationParams.putIfAbsent("preview", () => preview);
    creationParams.putIfAbsent("focused", () => focused);
    creationParams.putIfAbsent("hasMultiCamera", () => hasMultiCamera);
    creationParams.putIfAbsent("isPiPView", () => isPiPView);
    if (videoAspect.isEmpty) {
      creationParams.putIfAbsent("videoAspect", () => VideoAspect.PanAndScan);
    } else {
      creationParams.putIfAbsent("videoAspect", () => videoAspect);
    }
    creationParams.putIfAbsent("fullScreen", () => fullScreen);
    if (resolution.isNotEmpty) {
      creationParams.putIfAbsent("videoAspect", () => videoAspect);
    }

    String viewParamStr = "sharing:$sharing, isPiPView:$isPiPView";

    if (fullScreen) {
      if (sharing || isVideoOn.value || isPiPView || preview) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: FlutterZoomView.View(key: Key(viewParamStr), creationParams: creationParams),
        );
      } else if (isVideoOn.value) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: FlutterZoomView.View(key: Key(sharing.toString()), creationParams: creationParams),
        );
      } else {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 0),
          child: Container(
              alignment: Alignment.center,
              child: const Image(
                image: AssetImage("assets/icons/default-avatar.png"),
              )),
        );
      }
    } else {
      if (isVideoOn.value || sharing || preview) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 110,
          width: 110,
          child: Stack(
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: const Color(0xff232323),
                  border: Border.all(
                    color: const Color(0xff666666),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                alignment: Alignment.center,
                child: FlutterZoomView.View(key: Key(sharing.toString()), creationParams: creationParams),
              ),
              Container(
                height: 110,
                width: 110,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 20,
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  user!.userName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                // height: 110,
                // width: 110,
                child: Image(
                  height: 12,
                  width: 12,
                  image: isMuted.value
                      ? const AssetImage("assets/icons/muted@2x.png")
                      : const AssetImage("assets/icons/talking@2x.png"),
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 110,
          width: 110,
          child: Stack(
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: const Color(0xff232323),
                  border: Border.all(
                    color: const Color(0xff666666),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    child: const Image(
                      height: 60,
                      width: 60,
                      image: AssetImage("assets/icons/default-avatar.png"),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 20,
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  user!.userName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                child: Image(
                  height: 12,
                  width: 12,
                  image: isMuted.value
                      ? const AssetImage("assets/icons/muted@2x.png")
                      : const AssetImage("assets/icons/talking@2x.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      }
    }
  }

}