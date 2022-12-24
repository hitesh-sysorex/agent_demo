import 'package:agent_demo/Shared/Components/constant.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallViewModel extends GetxController {
  int remoteUID = 0;
  bool localUserJoined = false;
  late RtcEngine rtcEngine;

  initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    rtcEngine = createAgoraRtcEngine();
    await rtcEngine.initialize(RtcEngineContext(appId: appId));
    rtcEngine.enableVideo();
    rtcEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          localUserJoined = true;
          update();
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("remote user $remoteUid joined");
          remoteUID = remoteUid;
          update();
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("remote user $remoteUid left channel");
          remoteUID = 0;
          update();
          Get.back();
        },
      ),
    );
    await rtcEngine.joinChannel(
        token: tempToken,
        channelId: channel,
        uid: 0,
        options: const ChannelMediaOptions());
  }

  @override
  void onInit() {
    super.onInit();
    initAgora();
  }

  @override
  void onClose() {
    super.onClose();
    rtcEngine.disableVideo();
  }
}
