import 'package:chat_app/exceptions/app_exceptions.dart';
import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/utilities/pops.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ChatService chatService = ChatService();

  void sendMessage(
      {required String otherUserId,
      required String senderName,
      required String message,
      List<String>? participants,
      List<String>? deletedFor,
      String? mediaUrl,
      String? groupName,
      String type = "text",
      bool isGroup = false}) {
    try {
      chatService.sendMessage(
          otherUserId: otherUserId,
          senderName: senderName,
          message: message,
          participants: participants,
          deletedFor: deletedFor,
          mediaUrl: mediaUrl,
          groupName: groupName,
          type: type,
          isGroup: isGroup);
    } catch (e) {
      if (e is AppException) {
        Pops.showError(e.toString());
      } else {
        Pops.showError('Something went wrong');
      }
    }
  }

  Stream<List<ChatModel>> getMessages(String otherUserId) {
    return chatService.getMessages(otherUserId).handleError((error) {
      if (error is AppException) {
        Pops.showError(error.message);
      } else {
        Pops.showError('Something went wrong');
      }
    });
  }

  Stream<List<ChatModel>> getChatUsers() {
    return chatService.getChatUsers().handleError((error) {
      if (error is AppException) {
        Pops.showError(error.message);
      } else {
        Pops.showError('Something went wrong');
      }
    });
  }

  void markMessagesAsRead(String otherUserId) {
    chatService.markMessagesAsRead(otherUserId);
  }
}
