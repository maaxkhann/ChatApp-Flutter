import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/shared/constants/navigation/navigation.dart';
import 'package:chat_app/shared/constants/navigation/screen_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Provider{
//   getUser({Function(State)? callback})async{
//     if(state==state.comple){
//       callback(State.Success);
//     }else{
//       callback(State.Failiure);

//     }
//   }
// }
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  // hello()  {
  //   ref.read().getUsers(callback: (f) {
  //     if(f==State.Success){

  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: UserService.instance
            .getChatUsers(FirebaseAuth.instance.currentUser!.uid),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (ctx, index) {
              final time = snapshot.data?[index]['time']?.toDate() != null
                  ? DateFormat.yMd()
                      .format(snapshot.data?[index]['time'].toDate())
                  : '';

              return ListTile(
                onTap: () async {
                  final otherUserId = snapshot.data?[index]['otherId'] ?? '';
                  Navigation.pushNamed('/chat_main',
                      arguments: ChatMainScreenArgs(id: otherUserId));
                  //     Get.to(() => ChatMainScreen(id: otherUserId));
                },
                leading: const CircleAvatar(radius: 25),
                title: Text(snapshot.data?[index]['user']['name'] ?? ''),
                subtitle: Text(snapshot.data?[index]['lastMessage'] ?? ''),
                trailing: Column(
                  children: [
                    Text(time),
                    snapshot.data?[index]['unreadCount'] != null &&
                            snapshot.data?[index]['unreadCount'] > 0
                        ? CircleAvatar(
                            radius: 12,
                            child: Text(
                                '${snapshot.data?[index]['unreadCount'] ?? ''}'),
                          )
                        : const SizedBox(),
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
