import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/router/app_routes.dart';
import 'package:chat_app/screens/chat/chat_main_screen.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/shared/constants/navigation/navigation.dart';
import 'package:chat_app/shared/constants/navigation/screen_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: chatController.getChatUsers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || (snapshot.data?.isEmpty ?? false)) {
            return const Text('No Data');
          }

          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (ctx, index) {
              final chatUsers = snapshot.data?[index];

              return ListTile(
                onTap: () async {
                  final otherUserId = chatUsers?.participants?.firstWhere(
                      (id) => id != chatController.auth.currentUser?.uid);

                  Get.toNamed(AppRoutes.chatMainView,
                          arguments: {'otherUserId': otherUserId})
                      ?.then((val) => setState(() {}));
                },
                leading: const CircleAvatar(radius: 25),
                title: Text(chatUsers?.userModel?.name ?? ''),
                subtitle: Text(chatUsers?.lastMessage ?? ''),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    chatUsers?.lastMessageTime != null
                        ? Text(
                            DateFormat('hh:mm a')
                                .format(chatUsers!.lastMessageTime!.toDate()),
                          )
                        : const SizedBox.shrink(),

                    if ((chatUsers?.unreadCount ?? 0) > 0)
                      CircleAvatar(
                        radius: 12,
                        child: FittedBox(
                          child: Text(
                            chatUsers!.unreadCount.toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      )
                    // snapshot.data?[index]['unreadCount'] != null &&
                    //         snapshot.data?[index]['unreadCount'] > 0
                    //     ? CircleAvatar(
                    //         radius: 12,
                    //         child: Text(
                    //             '${snapshot.data?[index]['unreadCount'] ?? ''}'),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
