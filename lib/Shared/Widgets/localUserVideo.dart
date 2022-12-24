import 'package:agent_demo/Shared/Network/Models/videoCallViewModel.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class LocalUserVideo extends GetWidget<VideoCallViewModel> {
  const LocalUserVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoCallViewModel>(
        init: VideoCallViewModel(),
        builder: (controller) => AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: controller.rtcEngine,
                canvas: const VideoCanvas(uid: 0),
              ),
            ));
  }
}
