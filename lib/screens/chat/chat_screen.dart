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
                      (id) => id != chatController.auth.currentUser?.uid);

                  Get.toNamed(AppRoutes.chatMainView,
                          arguments: {'otherUserId': otherUserId})
                      ?.then((val) => setState(() {}));
                },
                leading: const CircleAvatar(radius: 25),
                title: Text(chatUsers?.userModel?.name ?? ''),
                subtitle: Text(
                    chatUsers?.lastMessage != ''
                        ? chatUsers!.lastMessage!
                        : 'Voice',
                    maxLines: 1),
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
                            style: const TextStyle(fontSize: 10),
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
