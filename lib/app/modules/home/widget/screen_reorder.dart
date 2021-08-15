// import 'package:flutter/material.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file/open_file.dart';
// import 'package:quiver/async.dart';

// class ScreenRecorder extends StatefulWidget {
//   const ScreenRecorder({Key? key}) : super(key: key);

//   @override
//   _ScreenRecorderState createState() => _ScreenRecorderState();
// }

// class _ScreenRecorderState extends State<ScreenRecorder> {
//   bool recording = false;
//   int _time = 0;

//   requestPermissions() async {
//     // await PermissionHandler().requestPermissions([
//     //   PermissionGroup.storage,
//     //   PermissionGroup.photos,
//     //   PermissionGroup.microphone,
//     // ]);
//   }
//   @override
//   void initState() {
//     requestPermissions();
//     startTimer();
//     super.initState();
//   }

//   void startTimer() {
//     CountdownTimer countDownTimer = new CountdownTimer(
//       new Duration(seconds: 1000),
//       new Duration(seconds: 1),
//     );

//     var sub = countDownTimer.listen(null);
//     sub.onData((duration) {
//       setState(() => _time++);
//     });

//     sub.onDone(() {
//       sub.cancel();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Screen Recording'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text('Time: $_time\n'),
//           !recording
//               ? Center(
//                   child: RaisedButton(
//                     child: Text("Record Screen"),
//                     onPressed: () => startScreenRecord(false),
//                   ),
//                 )
//               : Container(),
//           !recording
//               ? Center(
//                   child: RaisedButton(
//                     child: Text("Record Screen & audio"),
//                     onPressed: () => startScreenRecord(true),
//                   ),
//                 )
//               : Center(
//                   child: RaisedButton(
//                     child: Text("Stop Record"),
//                     onPressed: () => stopScreenRecord(),
//                   ),
//                 )
//         ],
//       ),
//     );
//   }

//   startScreenRecord(bool audio) async {
//     bool start = false;
//     await Future.delayed(const Duration(milliseconds: 1000));

//     if (audio) {
//       start = await FlutterScreenRecording.startRecordScreenAndAudio(
//           "Title" + _time.toString(),
//           titleNotification: "dsffad",
//           messageNotification: "sdffd");
//     } else {
//       start = await FlutterScreenRecording.startRecordScreen("Title",
//           titleNotification: "dsffad", messageNotification: "sdffd");
//     }

//     if (start) {
//       setState(() => recording = !recording);
//     }

//     return start;
//   }

//   stopScreenRecord() async {
//     String path = await FlutterScreenRecording.stopRecordScreen;
//     setState(() {
//       recording = !recording;
//     });
//     print("Opening video");
//     print(path);
//     OpenFile.open(path);
//   }
// }
