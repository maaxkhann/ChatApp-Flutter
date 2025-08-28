import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_app/components/custom_textfield.dart';
import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/controller/user_controller.dart';
import 'package:chat_app/screens/chat/widget/voice_message_widget.dart';
import 'package:chat_app/utilities/date_time_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ChatMainScreen extends StatefulWidget {
  // final String idd;
  const ChatMainScreen({super.key});

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  final chatController = Get.put(ChatController());
  final userController = Get.find<UserController>();
  final msgController = TextEditingController();
  String? otherUserId;
  String? recordedFilePath;
  final RecorderController recorderController = RecorderController();
  final PlayerController playerController = PlayerController();
  bool isRecording = false;
  String? audioPath;

  @override
  void initState() {
    super.initState();
    otherUserId = Get.arguments['otherUserId'] ?? Get.arguments['groupId'];
    chatController.markMessagesAsRead(otherUserId ?? '');
    recorderController.checkPermission();
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();
    super.dispose();
  }

  void startRecording() async {
    setState(() => isRecording = true);
    final dir = await getApplicationDocumentsDirectory();
    audioPath =
        "${dir.path}/recorded_${DateTime.now().millisecondsSinceEpoch}.m4a";

    await recorderController.record(path: audioPath!);
  }

  void stopRecording() async {
    setState(() => isRecording = false);
    await recorderController.stop();

    if (audioPath == null) return null;

    final file = File(audioPath!);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("voice_messages/${DateTime.now().millisecondsSinceEpoch}.m4a");

    await storageRef.putFile(file);
    final downloadUrl = await storageRef.getDownloadURL();

    if (audioPath != null) {
      chatController.sendMessage(
        otherUserId: otherUserId ?? '',
        senderName: userController.userModel.value?.name ?? '',
        message: '',
        mediaUrl: downloadUrl,
        participants: [chatController.auth.currentUser!.uid, otherUserId ?? ''],
        type: 'voice',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder(
          stream: chatController.getMessages(otherUserId ?? '',
              isGroup: Get.arguments['isGroup']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || (snapshot.data?.isEmpty ?? false)) {
              return const Center(child: Text('No Messages'));
            }
            return ListView.separated(
                itemCount: snapshot.data!.length,
                reverse: true,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final chat = snapshot.data![index];
                  final isMine = chatController.auth.currentUser!.uid ==
                      chat.currentUserId;
                  final date = (chat.timestamp)?.toDate();
                  String? dateLabel;
                  if (date != null) {
                    // Show label if first message (in reversed list) or day is different from previous message
                    if (index == snapshot.data!.length - 1 ||
                        (snapshot.data![index + 1].timestamp)?.toDate().day !=
                            date.day) {
                      dateLabel = DateTimeHelper.formatTimestamp(date);
                    }
                  }
                  return Column(
                    children: [
                      if (dateLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 6),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            dateLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      Align(
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IntrinsicWidth(
                            child: chat.type == 'voice'
                                ? VoiceMessageWidget(
                                    key: ValueKey(chat.id ??
                                        chat.timestamp), // 🔑 unique identity
                                    url: chat.mediaUrl ?? '',
                                    timeStamp: chat.timestamp!)
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        chat.message ?? '',
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.left,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            DateFormat('hh:mm a').format(
                                                chat.timestamp!.toDate()),
                                            style:
                                                const TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      if (isMine)
                        Align(
                            alignment: isMine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.check_circle_outline,
                                color: chat.participants?.length !=
                                        chat.readBy?.length
                                    ? Colors.black
                                    : Colors.blue,
                                size: 15,
                              ),
                            ))
                    ],
                  );
                });
          }),
      // appBar: AppBar(
      //   title: getOnlineStatus(),
      //   automaticallyImplyLeading: false,
      // ),
      // body: Padding(
      //     padding: const EdgeInsets.all(10),
      //     child: ListView.builder(

      //         //   reverse: true,
      //         shrinkWrap: true,
      //         itemCount: 10,
      //         itemBuilder: (context, index) {
      //           // print('index ${index == messageList.length}');
      //           // if (isLoading && index == messageList.length) {
      //           //   return const Center(child: CircularProgressIndicator());
      //           // }

      //           return Column(
      //             children: [
      //               Center(
      //                 child: Container(
      //                   margin: const EdgeInsets.symmetric(vertical: 10),
      //                   padding: const EdgeInsets.all(8),
      //                   decoration: BoxDecoration(
      //                     color: Colors.grey.shade300,
      //                     borderRadius: BorderRadius.circular(8),
      //                   ),
      //                   child: const Text(
      //                     '10:10',
      //                     style: TextStyle(fontSize: 12, color: Colors.grey),
      //                   ),
      //                 ),
      //               ),
      //               Align(
      //                 // alignment: data['senderId'] ==
      //                 //         FirebaseAuth.instance.currentUser!.uid
      //                 //     ? Alignment.bottomRight
      //                 //     : Alignment.bottomLeft,
      //                 child: Column(
      //                   children: [
      //                     // GestureDetector(
      //                     //   onTap: () async {

      //                     //   },
      //                     //   child: Container(
      //                     //     padding: const EdgeInsets.all(8),
      //                     //     margin: const EdgeInsets.all(8),
      //                     //     decoration: BoxDecoration(
      //                     //       borderRadius: BorderRadius.circular(8),
      //                     //       // color: data['senderId'] ==
      //                     //       //         FirebaseAuth
      //                     //       //             .instance.currentUser!.uid
      //                     //       //     ? Colors.green
      //                     //       //     : Colors.blue,
      //                     //     ),
      //                     //     child: (data['isVoiceMessage'] == true)
      //                     //         ? AudioFileWaveforms(
      //                     //             playerController: playerController,
      //                     //             size: const Size(100, 40.0),
      //                     //             playerWaveStyle:
      //                     //                 const PlayerWaveStyle(
      //                     //               fixedWaveColor: Colors.red,
      //                     //               liveWaveColor: Colors.white,
      //                     //               spacing: 6,
      //                     //             ),
      //                     //           )
      //                     //         : Text(data['message'] ?? ''),
      //                     //   ),
      //                     // ),
      //                     Row(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         Text(
      //                           'time',
      //                           style: const TextStyle(fontSize: 10),
      //                         ),
      //                         // if (data['senderId'] ==
      //                         //     FirebaseAuth.instance.currentUser!.uid)
      //                         Icon(
      //                           Icons.check_circle_outline,
      //                           // color: isSeen ? Colors.blue : Colors.grey,
      //                           size: 16,
      //                         ),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           );
      //         })),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: msgController,
                  hintText: 'Enter message',
                  textAlignVertical: TextAlignVertical.center,
                  suffixIcon: IconButton(
                      onPressed: () {
                        chatController.sendMessage(
                            otherUserId: otherUserId ?? '',
                            senderName:
                                userController.userModel.value?.name ?? '',
                            message: msgController.text.trim(),
                            isGroup: Get.arguments['isGroup'],
                            groupId: Get.arguments['groupId'],
                            groupName: Get.arguments['groupName'],
                            participants: Get.arguments['participants'] ??
                                [
                                  chatController.auth.currentUser!.uid,
                                  otherUserId ?? ''
                                ]);
                        msgController.clear();
                      },
                      icon: const Icon(Icons.send)),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (isRecording) {
                      stopRecording();
                    } else {
                      startRecording();
                    }
                  },
                  icon: Icon(isRecording ? Icons.stop : Icons.mic))
            ],
          ),
        ),
      ),
    );
  }

  // Widget getOnlineStatus() {
  //   return StreamBuilder(
  //       stream: FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(widget.params.id)
  //           .snapshots(),
  //       builder: (ctx, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const SizedBox();
  //         }
  //         String? lastSeen;
  //         bool isOnline = snapshot.data?['isOnline'];
  //         Timestamp time = snapshot.data?['timeStamp'];

  //         if (isOnline) {
  //           lastSeen = 'Online';
  //         } else {
  //           DateTime lastSeendt = time.toDate();
  //           DateTime now = DateTime.now();

  //           String formattedTime = DateFormat('HH:mm a').format(lastSeendt);
  //           if (now.difference(lastSeendt).inDays == 0) {
  //             lastSeen = 'Last seen today at $formattedTime';
  //           } else {
  //             String formattedDate = DateFormat('yMd').format(lastSeendt);
  //             lastSeen = 'Last seen $formattedDate at $formattedTime';
  //           }
  //         }
  //         return Text(
  //           lastSeen,
  //           style: const TextStyle(fontSize: 13),
  //         );
  //       });
  // }
}
