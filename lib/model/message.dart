import 'package:petandgo/model/user.dart';

class Message {
    final String sender;
    final String receiver;
    final String created_at; // Would usually be type DateTime or Firebase Timestamp in production apps
    final String text;
    final bool unread;

    Message({
        this.sender,
        this.receiver,
        this.created_at,
        this.text,
        this.unread,
    });

    factory Message.fromJson(Map<String, dynamic> json) {
        return Message(
            sender: json['sender'],
            created_at: json['created_at'],
            text: json['text'],
            receiver: json['receiver']
        );
    }
}