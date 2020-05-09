import 'package:petandgo/model/user.dart';

class Message {
    final User sender;
    final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
    final String text;
    final bool isLiked;
    final bool unread;

    Message({
        this.sender,
        this.time,
        this.text,
        this.isLiked,
        this.unread,
    });
}

final User currentUser = User(
    name: 'Current User',
);

// USERS
final User greg = User(
    name: 'Greg',
);
final User james = User(
    name: 'James',
);
final User john = User(
    name: 'John',
);
final User olivia = User(
    name: 'Olivia',
);
final User sam = User(
    name: 'Sam',
);
final User sophia = User(
    name: 'Sophia',
);
final User steven = User(
    name: 'Steven',
);

// FAVORITE CONTACTS
List<User> favorites = [sam, steven, olivia, john, greg];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
    Message(
        sender: james,
        time: '5:30 PM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: false,
        unread: true,
    ),
    Message(
        sender: olivia,
        time: '4:30 PM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: false,
        unread: true,
    ),
    Message(
        sender: john,
        time: '3:30 PM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: false,
        unread: false,
    ),
    Message(
        sender: sophia,
        time: '2:30 PM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: false,
        unread: true,
    ),
    Message(
        sender: steven,
        time: '1:30 PM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: false,
        unread: false,
    ),
    Message(
        sender: sam,
        time: '12:30 PM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: false,
        unread: false,
    ),
    Message(
        sender: greg,
        time: '11:30 AM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: false,
        unread: false,
    ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
    Message(
        sender: james,
        time: '5:30 PM',
        text: 'Hey, how\'s it going? What did you do today?',
        isLiked: true,
        unread: true,
    ),
    Message(
        sender: currentUser,
        time: '4:30 PM',
        text: 'Just walked my doge. She was super duper cute. The best pupper!!',
        isLiked: false,
        unread: true,
    ),
    Message(
        sender: james,
        time: '3:45 PM',
        text: 'How\'s the doggo?',
        isLiked: false,
        unread: true,
    ),
    Message(
        sender: james,
        time: '3:15 PM',
        text: 'All the food',
        isLiked: true,
        unread: true,
    ),
    Message(
        sender: currentUser,
        time: '2:30 PM',
        text: 'Nice! What kind of food did you eat?',
        isLiked: false,
        unread: true,
    ),
    Message(
        sender: james,
        time: '2:00 PM',
        text: 'I ate so much food today.',
        isLiked: false,
        unread: true,
    ),
];