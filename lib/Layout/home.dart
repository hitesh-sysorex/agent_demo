import 'package:agent_demo/Modules/videoCall.dart';
import 'package:agent_demo/Utils/call_utilities.dart';
import 'package:agent_demo/Utils/permissions.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:agent_demo/Shared/Network/Models/HomePageViewModel.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends GetWidget<HomePageViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomePageViewModel>(
        init: HomePageViewModel(),
        builder: (controller) => Container(
          child: Column(
            children: [
              const ListTile(
                leading: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                title: Text('Hitesh'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.video_call),
                    onPressed: () {
                      Get.to(() => const VideoCall());
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () async {
                        // await [Permission.microphone, Permission.camera]
                        //         .request();
                        CallUtils.dial(
                          from: controller.sender,
                          to: controller.receiver,
                          context: context,
                        );
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
