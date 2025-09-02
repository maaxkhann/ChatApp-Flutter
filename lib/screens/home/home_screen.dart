import 'package:chat_app/controller/user_controller.dart';
import 'package:chat_app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.put(UserController());
//  final userModel = Get.put(UserController());
  @override
  void initState() {
    super.initState();
    userController.updatePresence(true).then((val) {
      userController.getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: StreamBuilder(
          stream: userController.getUsers(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Text('No data');
            }
            return ListView.separated(
                itemCount: snapshot.data?.length ?? 0,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final users = snapshot.data?[index];
                  return Column(
                    children: [
                      Text(users?.name ?? ''),
                      Text(users?.email ?? ''),
                      ElevatedButton(
                          onPressed: () => Get.toNamed(AppRoutes.chatMainView,
                              arguments: {'otherUserId': users?.userId}),
                          child: const Text('Chat'))
                    ],
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.chatView)),
    );
  }
}
