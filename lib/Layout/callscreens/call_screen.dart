import 'dart:async';

import 'package:agent_demo/Helper/call_methods.dart';
import 'package:agent_demo/Models/call.dart';
import 'package:agent_demo/Shared/Components/constant.dart';
import 'package:agent_demo/configs/agora_configs.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  const CallScreen({
    required this.call,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();
  int remoteUID = 0;
  bool localUserJoined = false;
  late RtcEngine rtcEngine;
  // UserProvider userProvider;
  StreamSubscription? callStreamSubscription;

  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    // await _initAgoraRtcEngine();
    await initAgora();
    // _addAgoraEventHandlers();
    // await AgoraRtcEngine.enableWebSdkInteroperability(true);
    // await AgoraRtcEngine.setParameters(
    //     '''{"che.video.lowBitRateStreamParameter":{"width":320,"height":180,"frameRate":15,"bitRate":140}}''');
    // await AgoraRtcEngine.joinChannel(null, widget.call.channelId, null, 0);
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods
          // .callStream(uid: userProvider.getUser.uid)
          .callStream(uid: '123')
          .listen((DocumentSnapshot ds) {
        // defining the logic
        if (ds.data == null) {
          // snapshot is null which means that call is hanged and documents are deleted
          Navigator.pop(context);
        }
      });
    });
  }

  /// Create agora sdk instance and initialize
  // Future<void> _initAgoraRtcEngine() async {
  //   await AgoraRtcEngine.create(APP_ID);
  //   await AgoraRtcEngine.enableVideo();
  // }

  // /// Add agora event handlers
  // void _addAgoraEventHandlers() {
  //   AgoraRtcEngine.onError = (dynamic code) {
  //     setState(() {
  //       final info = 'onError: $code';
  //       _infoStrings.add(info);
  //     });
  //   };

  //   AgoraRtcEngine.onJoinChannelSuccess = (
  //     String channel,
  //     int uid,
  //     int elapsed,
  //   ) {
  //     setState(() {
  //       final info = 'onJoinChannel: $channel, uid: $uid';
  //       _infoStrings.add(info);
  //     });
  //   };

  //   AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
  //     setState(() {
  //       final info = 'onUserJoined: $uid';
  //       _infoStrings.add(info);
  //       _users.add(uid);
  //     });
  //   };

  //   AgoraRtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
  //     setState(() {
  //       final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
  //       _infoStrings.add(info);
  //     });
  //   };

  //   AgoraRtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
  //     setState(() {
  //       final info = 'onRejoinChannelSuccess: $string';
  //       _infoStrings.add(info);
  //     });
  //   };

  //   AgoraRtcEngine.onUserOffline = (int a, int b) {
  //     callMethods.endCall(call: widget.call);
  //     setState(() {
  //       final info = 'onUserOffline: a: ${a.toString()}, b: ${b.toString()}';
  //       _infoStrings.add(info);
  //     });
  //   };

  //   AgoraRtcEngine.onRegisteredLocalUser = (String s, int i) {
  //     setState(() {
  //       final info = 'onRegisteredLocalUser: string: s, i: ${i.toString()}';
  //       _infoStrings.add(info);
  //     });
  //   };

  //   AgoraRtcEngine.onLeaveChannel = () {
  //     setState(() {
  //       _infoStrings.add('onLeaveChannel');
  //       _users.clear();
  //     });
  //   };

  //   AgoraRtcEngine.onConnectionLost = () {
  //     setState(() {
  //       final info = 'onConnectionLost';
  //       _infoStrings.add(info);
  //     });
  //   };

  //   AgoraRtcEngine.onUserOffline = (int uid, int reason) {
  //     // if call was picked

  //     setState(() {
  //       final info = 'userOffline: $uid';
  //       _infoStrings.add(info);
  //       _users.remove(uid);
  //     });
  //   };

  //   AgoraRtcEngine.onFirstRemoteVideoFrame = (
  //     int uid,
  //     int width,
  //     int height,
  //     int elapsed,
  //   ) {
  //     setState(() {
  //       final info = 'firstRemoteVideo: $uid ${width}x $height';
  //       _infoStrings.add(info);
  //     });
  //   };
  // }

  initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    rtcEngine = createAgoraRtcEngine();
    await rtcEngine.initialize(RtcEngineContext(appId: appId));
    rtcEngine.enableVideo();
    rtcEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            localUserJoined = true;
          });
          // update();
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            remoteUID = remoteUid;
          });
          // update();
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            remoteUID = 0;
          });
          // update();
          // Get.back();
        },
      ),
    );
    await rtcEngine.joinChannel(
        token: tempToken,
        channelId: channel,
        uid: 0,
        options: const ChannelMediaOptions());
  }

  /// Helper function to get list of native views
  // List<Widget> _getRenderViews() {
  //   final List<AgoraRenderWidget> list = [
  //     AgoraRenderWidget(0, local: true, preview: true),
  //   ];
  //   for (var uid in _users) {
  //     list.add(AgoraRenderWidget(uid));
  //   }
  //   return list;
  // }

  /// Video view wrapper
  // Widget _videoView(view) {
  //   return Expanded(child: Container(child: view));
  // }

  // /// Video view row wrapper
  // Widget _expandedVideoRow(List<Widget> views) {
  //   final wrappedViews = views.map<Widget>(_videoView).toList();
  //   return Expanded(
  //     child: Row(
  //       children: wrappedViews,
  //     ),
  //   );
  // }

  /// Video layout wrapper
  // Widget _viewRows() {
  //   final views = _getRenderViews();
  //   switch (views.length) {
  //     case 1:
  //       return Container(
  //           child: Column(
  //         children: <Widget>[_videoView(views[0])],
  //       ));
  //     case 2:
  //       return Container(
  //           child: Column(
  //         children: <Widget>[
  //           _expandedVideoRow([views[0]]),
  //           _expandedVideoRow([views[1]])
  //         ],
  //       ));
  //     case 3:
  //       return Container(
  //           child: Column(
  //         children: <Widget>[
  //           _expandedVideoRow(views.sublist(0, 2)),
  //           _expandedVideoRow(views.sublist(2, 3))
  //         ],
  //       ));
  //     case 4:
  //       return Container(
  //           child: Column(
  //         children: <Widget>[
  //           _expandedVideoRow(views.sublist(0, 2)),
  //           _expandedVideoRow(views.sublist(2, 4))
  //         ],
  //       ));
  //     default:
  //   }
  //   return Container();
  // }

  /// Info panel to show logs
  // Widget _panel() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     alignment: Alignment.bottomCenter,
  //     child: FractionallySizedBox(
  //       heightFactor: 0.5,
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 48),
  //         child: ListView.builder(
  //           reverse: true,
  //           itemCount: _infoStrings.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             if (_infoStrings.isEmpty) {
  //               return null;
  //             }
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 3,
  //                 horizontal: 10,
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Flexible(
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         vertical: 2,
  //                         horizontal: 5,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.yellowAccent,
  //                         borderRadius: BorderRadius.circular(5),
  //                       ),
  //                       child: Text(
  //                         _infoStrings[index],
  //                         style: const TextStyle(color: Colors.blueGrey),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _onToggleMute() {
  //   setState(() {
  //     muted = !muted;
  //   });
  //   AgoraRtcEngine.muteLocalAudioStream(muted);
  // }

  // void _onSwitchCamera() {
  //   AgoraRtcEngine.switchCamera();
  // }

  /// Toolbar layout
  // Widget _toolbar() {
  //   return Container(
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         RawMaterialButton(
  //           onPressed: _onToggleMute,
  //           shape: const CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: muted ? Colors.blueAccent : Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //           child: Icon(
  //             muted ? Icons.mic : Icons.mic_off,
  //             color: muted ? Colors.white : Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () => callMethods.endCall(
  //             call: widget.call,
  //           ),
  //           shape: const CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.redAccent,
  //           padding: const EdgeInsets.all(15.0),
  //           child: const Icon(
  //             Icons.call_end,
  //             color: Colors.white,
  //             size: 35.0,
  //           ),
  //         ),
  //         RawMaterialButton(
  //           onPressed: _onSwitchCamera,
  //           shape: const CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //           child: const Icon(
  //             Icons.switch_camera,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    rtcEngine.leaveChannel();

    rtcEngine.disableVideo();
    callStreamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: remoteUID != 0
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: rtcEngine,
                        canvas: VideoCanvas(uid: remoteUID),
                        connection: RtcConnection(channelId: channel),
                      ),
                    )
                  : const Text(
                      'Calling......',
                      textAlign: TextAlign.center,
                    ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: rtcEngine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () {
                  // Get.back();
                  callMethods.endCall(
                    call: widget.call,
                  );
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
