import 'package:agent_demo/Shared/Components/constant.dart';
import 'package:agent_demo/Shared/Network/Models/videoCallViewModel.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

class RemoteUserVideo extends GetWidget<VideoCallViewModel> {
  const RemoteUserVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoCallViewModel>(
        init: VideoCallViewModel(),
        builder: (controller) => controller.remoteUID != 0
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.rtcEngine,
                  canvas: VideoCanvas(uid: controller.remoteUID),
                  connection: RtcConnection(channelId: channel),
                ),
              )
            : const Text(
                'Calling......',
                textAlign: TextAlign.center,
              ));
  }
}
