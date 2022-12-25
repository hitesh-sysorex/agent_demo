import 'package:agent_demo/Helper/call_methods.dart';
import 'package:agent_demo/Layout/callscreens/pickup/pickup_screen.dart';
import 'package:agent_demo/Models/call.dart';
import 'package:agent_demo/Modules/videoCall.dart';
import 'package:agent_demo/Utils/call_utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:agent_demo/Shared/Network/Models/HomePageViewModel.dart';

class Home extends GetWidget<HomePageViewModel> {
  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: callMethods.callStream(uid: '123'),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            Call call =
                Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

            if (!call.hasDialled!) {
              return PickupScreen(call: call);
            }
          }

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
        });
  }
}
