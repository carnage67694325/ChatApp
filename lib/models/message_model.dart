import 'package:scholar_chat/constants.dart';

class MessageModel {
  final String message;
  final String id;

  MessageModel(this.id, {required this.message});
  factory MessageModel.fromJson(jasonData) {
    return MessageModel(message: jasonData[kMessage], jasonData['id']);
  }
}
