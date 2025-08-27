import 'dart:io';

import 'package:chat_app/exceptions/app_exceptions.dart';
import 'package:chat_app/exceptions/firebase_exceptions.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<UserModel>> getUsers() {
    try {
      return firestore.collection('Users').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
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

  Future<UserModel> getUserData() async {
    DocumentSnapshot userRef =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    return UserModel.fromMap(userRef.data() as Map<String, dynamic>);
  }
}

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:intl/intl.dart';

// class UserService {
//   static final UserService instance = UserService._internal();
//   UserService._internal();

//   FirebaseAuth auth = FirebaseAuth.instance;
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference userRef = FirebaseFirestore.instance.collection('users');

//   Future<void> sendVoiceMessage(
//       String filePath, String senderId, String otherId) async {
//     // Get a reference to Firebase Storage
//     FirebaseStorage storage = FirebaseStorage.instance;

//     // Create a unique path for the voice message
//     String fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
//     Reference storageRef = storage.ref().child('voice_messages/$fileName');

//     // Upload the audio file to Firebase Storage
//     File file = File(filePath);
//     await storageRef.putFile(file);

//     // Get the download URL of the uploaded file
//     String voiceUrl = await storageRef.getDownloadURL();
//     print('voiceUrl$voiceUrl');

//     // Now, save the voice message URL to Firestore like a regular message
//     List<String> ids = [senderId, otherId];
//     ids.sort();
//     String chatId = ids.join('_');

//     await firestore.collection('chats').doc(chatId).collection('messages').add({
//       'message': '', // No text message, just voice
//       'voiceUrl': voiceUrl, // Store the voice message URL
//       'time': FieldValue.serverTimestamp(),
//       'read': false,
//       'readBy': [senderId],
//       'senderId': senderId,
//       'isVoiceMessage': true // Add a flag to identify this as a voice message
//     });

//     // Update chat metadata for sender
//     await firestore
//         .collection('chatUsers')
//         .doc(senderId)
//         .collection('chatUsers')
//         .doc(chatId)
//         .set({
//       'lastMessage': 'Voice message',
//       'time': FieldValue.serverTimestamp(),
//       'otherId': otherId,
//       'unreadCount': 0
//     });

//     // Update chat metadata for receiver
//     await firestore
//         .collection('chatUsers')
//         .doc(otherId)
//         .collection('chatUsers')
//         .doc(chatId)
//         .set({
//       'lastMessage': 'Voice message',
//       'time': FieldValue.serverTimestamp(),
//       'otherId': senderId,
//       'unreadCount': FieldValue.increment(1)
//     }, SetOptions(merge: true));
//   }

//   void storeUserData(String name, String email) async {
//     await userRef.doc(auth.currentUser!.uid).set({
//       'name': name,
//       'email': email,
//       'isOnline': false,
//       'timeStamp': FieldValue.serverTimestamp(),
//       'userId': auth.currentUser!.uid
//     });
//   }

//   Stream<QuerySnapshot> getUserList() {
//     return userRef
//         .where('userId', isNotEqualTo: auth.currentUser!.uid)
//         .snapshots();
//   }

//   Future<void> sendMessage(
//       String message, String senderId, String otherId) async {
//     List<String> ids = [senderId, otherId];
//     ids.sort();
//     String chatId = ids.join('_');

//     // Add the message to Firestore
//     DocumentReference messageRef = await firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .add({
//       'message': message,
//       'time': FieldValue.serverTimestamp(),
//       'read': false,
//       'readBy': [senderId], // Initialize with the sender's ID
//       'senderId': senderId
//     });
//     await messageRef.update({'id': messageRef.id});

//     // Update chat metadata for sender
//     await firestore
//         .collection('chatUsers')
//         .doc(senderId)
//         .collection('chatUsers')
//         .doc(chatId)
//         .set({
//       'lastMessage': message,
//       'time': FieldValue.serverTimestamp(),
//       'otherId': otherId,
//       'unreadCount': 0
//     });

//     // Update chat metadata for receiver and increment unreadCount
//     await firestore
//         .collection('chatUsers')
//         .doc(otherId)
//         .collection('chatUsers')
//         .doc(chatId)
//         .set({
//       'lastMessage': message,
//       'time': FieldValue.serverTimestamp(),
//       'otherId': senderId,
//       'unreadCount':
//           FieldValue.increment(1) // Increment unread count for receiver
//     }, SetOptions(merge: true));
//   }

//   // Fetch chat users and include unread message count
//   Stream<List<Map<String, dynamic>>> getChatUsers(String currentUserId) {
//     return firestore
//         .collection('chatUsers')
//         .doc(currentUserId)
//         .collection('chatUsers')
//         .orderBy('time', descending: true)
//         .snapshots()
//         .asyncMap((snapshot) async {
//       List<Map<String, dynamic>> users = [];

//       for (var chat in snapshot.docs) {
//         Map<String, dynamic> data = chat.data();
//         // Fetch the other user's data (name, etc.)
//         final userSnapshot =
//             await firestore.collection('users').doc(chat['otherId']).get();
//         data['user'] = userSnapshot.data();
//         users.add(data);
//       }
//       return users;
//     });
//   }

//   Future<List<DocumentSnapshot>> getMessagesPaginated(
//       String currentUserId, String otherUserId,
//       {int limit = 20, DocumentSnapshot? lastDocument}) async {
//     List<String> ids = [currentUserId, otherUserId];
//     ids.sort();
//     String chatId = ids.join('_');

//     Query query = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('time', descending: true)
//         .limit(10);

//     if (lastDocument != null) {
//       query = query.startAfterDocument(lastDocument);
//     }
//     final QuerySnapshot snapshot = await query.get();

//     return snapshot.docs.toList();
//   }

//   Stream<QuerySnapshot> getMessages(
//       String currentUserId, String otherUserId) async* {
//     List<String> ids = [currentUserId, otherUserId];
//     ids.sort();
//     String chatId = ids.join('_');
//     yield* firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('time', descending: true)
//         .limit(1)
//         .snapshots();
//     //  .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//   }

//   // Mark all unread messages as read and reset unread count
//   Future<void> markMessagesAsRead(
//       String otherUserId, String currentUserId) async {
//     List<String> ids = [currentUserId, otherUserId];
//     ids.sort();
//     String chatId = ids.join('_');

//     // Get all unread messages sent by the other user
//     final unreadMessagesQuery = await firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .where('senderId', isEqualTo: otherUserId)
//         .where('read', isEqualTo: false)
//         //  .where('readBy', isNotEqualTo: currentUserId)
//         .get();

//     // Mark each unread message as read
//     for (var doc in unreadMessagesQuery.docs) {
//       await firestore
//           .collection('chats')
//           .doc(chatId)
//           .collection('messages')
//           .doc(doc.id)
//           .update({
//         'read': true,
//         'readBy':
//             FieldValue.arrayUnion([currentUserId]) // Add current user to readBy
//       });
//     }

//     // Reset unread count in chatUsers for the current user
//     await firestore
//         .collection('chatUsers')
//         .doc(currentUserId)
//         .collection('chatUsers')
//         .doc(chatId)
//         .update({'unreadCount': 0});
//   }

//   setUserOnline(String currentId) {
//     userRef
//         .doc(currentId)
//         .update({'isOnline': true, 'timeStamp': FieldValue.serverTimestamp()});
//   }

//   setUserOffline(String currentId) {
//     userRef
//         .doc(currentId)
//         .update({'isOnline': false, 'timeStamp': FieldValue.serverTimestamp()});
//   }

//   static String formatDateTime(DateTime? timeStamp) {
//     if (timeStamp == null) return '';
//     final dateTime = timeStamp;
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = DateTime(now.year, now.month, now.day - 1);
//     final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

//     if (messageDate == today) {
//       return 'Today';
//     } else if (messageDate == yesterday) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('dd/MM/yyyy').format(dateTime);
//     }
//   }
// }

// class Userr {
//   static final Userr ins = Userr._internal();
//   Userr._internal();
//   String? _id;
//   String? get id => _id;

//   setId(String id) {
//     _id = id;
//   }
// }
