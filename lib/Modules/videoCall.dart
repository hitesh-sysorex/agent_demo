import 'package:agent_demo/Shared/Network/Models/videoCallViewModel.dart';
import 'package:agent_demo/Shared/Widgets/localUserVideo.dart';
import 'package:agent_demo/Shared/Widgets/remoteUserVideo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoCall extends GetWidget<VideoCallViewModel> {
  const VideoCall({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoCallViewModel>(
      init: VideoCallViewModel(),
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            const Center(
              child: RemoteUserVideo(),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: const SizedBox(
                    height: 200,
                    width: 200,
                    child: LocalUserVideo(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
