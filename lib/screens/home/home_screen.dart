import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/shared/constants/navigation/navigation.dart';
import 'package:chat_app/shared/constants/navigation/screen_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: StreamBuilder<QuerySnapshot>(
          stream: UserService.instance.getUserList(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
                itemCount: snapshot.data?.docs.length ?? 0,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(snapshot.data?.docs[index]['name']),
                      Text(snapshot.data?.docs[index]['email']),
                      ElevatedButton(
                          onPressed: () => Navigation.pushNamed('/chat_main',
                              arguments: ChatMainScreenArgs(
                                  id: snapshot.data?.docs[index]['userId'])),
                          child: const Text('Chat'))
                    ],
                  );
                });
          }),
      floatingActionButton:
          FloatingActionButton(onPressed: () => Navigation.pushNamed('/chat')),
    );
  }
}
