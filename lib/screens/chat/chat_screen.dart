import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  onTap: () => Get.toNamed(AppRoutes.createGroupView),
                  value: 'Create group',
                  child: const Text('Create group'))
            ];
          })
        ],
      ),
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
                    (id) => id != chatController.auth.currentUser?.uid,
                    orElse: () => '',
                  );

                  if (otherUserId != null &&
                      otherUserId.isNotEmpty &&
                      !chatUsers!.isGroup!) {
                    Get.toNamed(
                      AppRoutes.chatMainView,
                      arguments: {
                        'otherUserId': otherUserId,
                        'isGroup': false,
                        'name': chatUsers.userModel?.name
                      },
                    )?.then((val) => setState(() {}));
                  } else {
                    Get.toNamed(
                      AppRoutes.chatMainView,
                      arguments: {
                        'groupId': chatUsers?.chatId,
                        'isGroup': true,
                        'groupName': chatUsers?.groupName,
                        'participants': chatUsers?.participants
                      },
                    )?.then((val) => setState(() {}));
                  }
                },
                leading: const CircleAvatar(radius: 25),
                title: Text(
                  chatUsers?.isGroup == true
                      ? (chatUsers?.groupName ?? 'Unnamed Group')
                      : (chatUsers?.userModel?.name ?? 'Unknown User'),
                ),
                subtitle: Text(
                  (chatUsers?.lastMessage?.isNotEmpty ?? false)
                      ? (chatUsers?.lastMessage ?? '')
                      : chatUsers?.isGroup == true
                          ? ''
                          : 'Voice',
                  maxLines: 1,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (chatUsers?.lastMessageTime != null)
                      Text(
                        DateFormat('hh:mm a').format(
                          chatUsers!.lastMessageTime!.toDate(),
                        ),
                      ),
                    if ((chatUsers?.unreadCount ?? 0) > 0)
                      CircleAvatar(
                        radius: 12,
                        child: FittedBox(
                          child: Text(
                            (chatUsers?.unreadCount ?? 0).toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),

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
