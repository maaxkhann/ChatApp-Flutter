import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? id;
  final String? currentUserId;
  final String? otherUserId;
  final String? senderName;
  final String? chatId; // unique chat room id (user1_user2 OR groupId)
  final String? message;
  final String? mediaUrl; // image/video/audio/file
  final String? type; // text, image, video, audio, file
  final bool? isGroup;
  final Timestamp? timestamp;
  final List<String>? readBy; // users who have read the message
  final List<String>? deletedFor; // users who have read the message
  // 🔥 Chat-level fields
  final List<String>? participants;
  final String? groupName;
  final String? lastMessage;
  final Timestamp? lastMessageTime;
  final UserModel? userModel;
  final int unreadCount;

  ChatModel({
    this.id,
    this.currentUserId,
    this.otherUserId,
    this.senderName,
    this.chatId,
    this.message,
    this.mediaUrl,
    this.type,
    this.isGroup,
    this.timestamp,
    this.readBy,
    this.deletedFor,
    this.participants,
    this.groupName,
    this.lastMessage,
    this.lastMessageTime,
    this.userModel,
    this.unreadCount = 0,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String docId,
      {Map<String, dynamic>? userModel}) {
    return ChatModel(
        id: docId ?? '',
        currentUserId: map['currentUserId'] ?? '',
        otherUserId: map['otherUserId'] ?? '',
        senderName: map['senderName'] ?? '',
        chatId: map['chatId'] ?? '',
        message: map['message'] ?? '',
        mediaUrl: map['mediaUrl'] ?? '',
        type: map['type'] ?? 'text',
        unreadCount: map['unreadCount'] ?? 0,
        isGroup: map['isGroup'] ?? false,
        timestamp: map['timestamp'] ?? null,
        readBy: map['readBy'] != null ? List<String>.from(map['readBy']) : [],
        deletedFor: List<String>.from(map['deletedFor'] ?? []),
        // Chat-level extras
        participants: map['participants'] != null
            ? List<String>.from(map['participants'])
            : [],
        groupName: map['groupName'] ?? '',
        lastMessage: map['lastMessage'] ?? '',
        lastMessageTime: map['timeStamp'] ??
            null, // notice chats collection uses `timeStamp`
        userModel: userModel != null ? UserModel.fromMap(userModel) : null);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentUserId': currentUserId,
      'otherUserId': otherUserId,
      'senderName': senderName,
      'chatId': chatId,
      'message': message,
      'mediaUrl': mediaUrl,
      'type': type,
      'isGroup': isGroup,
      'timestamp': timestamp,
      'readBy': readBy,
      'deletedFor': deletedFor,
      // Chat-level extras
      'participants': participants,
      'groupName': groupName,
      'lastMessage': lastMessage,
      'timeStamp': lastMessageTime,
      'userModel': userModel,
      'unreadCount': unreadCount
    };
  }

  ChatModel copyWith({int? unreadCount}) {
    return ChatModel(
      id: id,
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      senderName: senderName,
      chatId: chatId,
      message: message,
      type: type,
      isGroup: isGroup,
      participants: participants,
      timestamp: timestamp,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      readBy: readBy,
      deletedFor: deletedFor,
      userModel: userModel,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
