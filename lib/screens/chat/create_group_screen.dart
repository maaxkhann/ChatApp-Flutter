import 'package:chat_app/components/custom_textfield.dart';
import 'package:chat_app/components/primary_button.dart';
import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final userController = Get.find<UserController>();
  final chatController = Get.find<ChatController>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                hintText: 'Group Name',
              ),
              StreamBuilder(
                  stream: userController.getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 150,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (!snapshot.hasData ||
                        (snapshot.data?.isEmpty ?? false)) {
                      return const Center(child: Text('No Users'));
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final user = snapshot.data?[index];

                            return Column(
                              children: [
                                Obx(() {
                                  final isSelected = userController
                                      .selectedUsers
                                      .contains(user!.userId);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        user.name!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Checkbox(
                                          visualDensity: VisualDensity.compact,
                                          value: isSelected,
                                          onChanged: (val) {
                                            if (val == true) {
                                              userController.selectedUsers
                                                  .add(user.userId!);
                                            } else {
                                              userController.selectedUsers
                                                  .remove(user.userId);
                                            }
                                          })
                                    ],
                                  );
                                })
                              ],
                            );
                          }),
                    );
                  })
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryButton(
              text: const Text('Create group'),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    userController.selectedUsers.isNotEmpty) {
                  chatController.createGroup(nameController.text.trim(),
                      userController.selectedUsers.toList());
                }
              }),
        ),
      ),
    );
  }
}
