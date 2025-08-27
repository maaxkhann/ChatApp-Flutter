import 'dart:io';

import 'package:chat_app/exceptions/app_exceptions.dart';
import 'package:chat_app/exceptions/firebase_exceptions.dart';
import 'package:chat_app/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String channelId(String currentId, String otherId) {
    List<String> ids = [currentId, otherId];
    ids.sort();
    return ids.join('_');
  }

  Future<void> sendMessage(
      {required String otherUserId,
      required String senderName,
      required String message,
      List<String>? participants,
      List<String>? deletedFor,
      String? mediaUrl,
      String? groupName,
      String type = "text",
      bool isGroup = false}) async {
    final chatId = channelId(auth.currentUser!.uid, otherUserId);
    try {
      DocumentReference msgRef = firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();
      final newMsg = ChatModel(
          id: msgRef.id,
          currentUserId: auth.currentUser!.uid,
          otherUserId: otherUserId,
          senderName: senderName,
          chatId: chatId,
          message: message,
          mediaUrl: mediaUrl,
          type: type,
          isGroup: isGroup,
          participants: participants,
          timestamp: Timestamp.now(),
          readBy: [auth.currentUser!.uid],
          deletedFor: deletedFor ?? []);
      await msgRef.set(newMsg.toMap());

      await firestore.collection('chats').doc(chatId).set({
        'participants': participants ?? [],
        'isGroup': isGroup,
        'groupName': groupName,
        'lastMessage': message,
        'timeStamp': FieldValue.serverTimestamp()
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      // Firestore-specific error
      throw handleFirestoreException(e);
    } on SocketException catch (e) {
      // Network issue
      throw handleNetworkException(e);
    } catch (e) {
      // Unexpected error
      throw UnknownException(e.toString());
    }
  }

  Stream<List<ChatModel>> getMessages(String otherUserId) {
    final chatId = channelId(auth.currentUser!.uid, otherUserId);

    try {
      return firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
                return ChatModel.fromMap(doc.data(), doc.id);
              }).toList());
    } on FirebaseException catch (e) {
      // Firestore-specific error
      throw handleFirestoreException(e);
    } on SocketException catch (e) {
      // Network issue
      throw handleNetworkException(e);
    } catch (e) {
      // Unexpected error
      throw UnknownException(e.toString());
    }
  }

  Stream<List<ChatModel>> getChatUsers() {
    //  final chatId = channelId(auth.currentUser!.uid, otherUserId);
    try {
      return firestore
          .collection('chats')
          // .doc(chatId)
          // .collection('messages')
          .where('participants', arrayContains: auth.currentUser!.uid)
          .snapshots()
          .asyncMap((snap) async {
        final chatModel = Future.wait(snap.docs.map((doc) async {
          final data = doc.data();
          final chatId = doc.id;

          final otherUserId = (data['participants'] as List<dynamic>)
              .firstWhere((id) => id != auth.currentUser!.uid);

          final userDoc =
              await firestore.collection('Users').doc(otherUserId).get();
          final messagesSnap = await firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .get();
          final unreadCount = messagesSnap.docs.where((msg) {
            final readBy = List<String>.from(msg.data()['readBy'] ?? []);
            return !readBy.contains(auth.currentUser!.uid);
          }).length;

          return ChatModel.fromMap(data, doc.id, userModel: userDoc.data())
              .copyWith(unreadCount: unreadCount);
        }));
        return chatModel;
      });
    } on FirebaseException catch (e) {
      // Firestore-specific error
      throw handleFirestoreException(e);
    } on SocketException catch (e) {
      // Network issue
      throw handleNetworkException(e);
    } catch (e) {
      // Unexpected error
      throw UnknownException(e.toString());
    }
  }

  void markMessagesAsRead(String otherUserId) async {
    final chatId = channelId(auth.currentUser!.uid, otherUserId);

    final chatRef = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();
    for (var doc in chatRef.docs) {
      List<String> readBy = List<String>.from(doc['readBy'] ?? []);
      if (!readBy.contains(auth.currentUser!.uid)) {
        await doc.reference.update({
          'readBy': FieldValue.arrayUnion([auth.currentUser!.uid])
        });
      }
    }
  }
}
