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
    chatController.markMessagesAsRead(otherUserId ?? '',
        isGroup: Get.arguments['isGroup'] ?? false);
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
        isGroup: Get.arguments['isGroup'],
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
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 35, left: 12),
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back)),
              const CircleAvatar(radius: 25),
              const SizedBox(width: 2),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Get.arguments['name'] ?? ''),
                  if (Get.arguments['otherUserId'] != null)
                    StreamBuilder(
                        stream: userController
                            .getOtherUserData(Get.arguments['otherUserId']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          }
                          final data = snapshot.data;
                          final lastSeen =
                              DateTimeHelper.formatLastSeen(data?.lastSeen);
                          return Text(lastSeen,
                              style: const TextStyle(fontSize: 10));
                        }),
                ],
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: chatController.getMessages(otherUserId ?? '',
              isGroup: Get.arguments['isGroup'] ?? false),
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
                        child: Dismissible(
                          key: Key(chat.id!),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await chatController.deleteMsg(
                                otherUserId!, chat.id!,
                                isGroup: Get.arguments['isGroup']);
                          },
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
                                              style: const TextStyle(
                                                  fontSize: 10)),
                                        ),
                                      ],
                                    ),
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
                                color: chat.readBy!.length ==
                                        chat.participants!.length
                                    ? Colors.blue
                                    : Colors.black,
                                size: 15,
                              ),
                            ))
                    ],
                  );
                });
          }),
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
}
