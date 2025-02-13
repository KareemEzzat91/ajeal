import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/ParentAdminchat/ParentAdminchatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalChatScreen extends StatefulWidget {
  final String childName; // لتحديد الدردشة
  final String doctorId;
  final String parentId;
  final bool isparent;
  const GlobalChatScreen({super.key,required this.childName, required this.doctorId, required this.parentId, required this.isparent});

  @override
  _GlobalChatScreenState createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final TextEditingController _messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://thumbs.dreamstime.com/b/global-chat-logo-template-design-world-207780009.jpg'),
            ),
            SizedBox(width: 8),
            Text('Global Chat'),
            Spacer(),
          ],
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          // Chat Messages Displayed
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('global_chat')
                    .doc('messages')
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No messages yet.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)));
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].data() as Map<String, dynamic>;
                      final isDoctorMessage = message['sender_id'] == widget.doctorId;
                      final isMyMessage = message['sender_id'] == widget.parentId;

                      return GestureDetector(
                        onTap: (){  
                          widget.isparent==false &&message["sender_id"]!=widget.doctorId ?Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(chatId: widget.doctorId+ message['sender_id'], doctorId: widget.doctorId, parentId: message['sender_id'], isparent: false))) :null;
                        },
                        child: ChatBubble(
                          message: message['text'],
                          sender: isDoctorMessage ? "Doctor" : message["senderName"],
                          time: message['timestamp'] != null
                              ? (message['timestamp'] as Timestamp).toDate().toString().split(' ')[1]
                              : 'N/A',
                          messageType: isDoctorMessage ? MessageType.doctor : (isMyMessage ? MessageType.myMessage : MessageType.otherUser),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Message Input Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.blueAccent),
                  onPressed: () {
                    // Handle attachments
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Send Message Function
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text;

      // Send message to Firestore
      final messageRef = FirebaseFirestore.instance
          .collection('global_chat')
          .doc('messages')
          .collection('messages');

      await messageRef.add({
        'sender_id': widget.isparent? widget.parentId: widget.doctorId,  // Or doctorId if doctor is sending
        'text': messageText,
        'senderName':widget.isparent?widget.childName:"Doctor",
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear(); // Clear the input after sending
    }
  }
}

enum MessageType {
  doctor,
  myMessage,
  otherUser,
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String sender;
  final String time;
  final MessageType messageType;

  const ChatBubble({
    required this.message,
    required this.sender,
    required this.time,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    Color bubbleColor;
    CrossAxisAlignment alignment;
    MainAxisAlignment rowAlignment;
    Widget? avatar;

    switch (messageType) {
      case MessageType.doctor:
        bubbleColor = Colors.blue[100]!;
        alignment = CrossAxisAlignment.start;
        rowAlignment = MainAxisAlignment.start;
        avatar = const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/images/Mohsen.jpg'),
        );
        break;
      case MessageType.myMessage:
        bubbleColor = Colors.green[100]!;
        alignment = CrossAxisAlignment.end;
        rowAlignment = MainAxisAlignment.end;
        avatar = null;
        break;
      case MessageType.otherUser:
        bubbleColor = Colors.grey[300]!;
        alignment = CrossAxisAlignment.start;
        rowAlignment = MainAxisAlignment.start;
        avatar = const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: rowAlignment,
        children: [
          if (avatar != null) avatar,
          if (avatar != null) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                Text(
                  sender,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String convertTo12Hour(String time) {
  try {  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  // تحويل الساعة إلى صيغة 12 ساعة
  String period = hours >= 12 ? "PM" : "AM";
  hours = hours > 12 ? hours - 12 : hours;

  // تقريب الدقائق
  minutes = (minutes + 0.5).toInt(); // تقريبي

  return "$hours:${minutes.toString().padLeft(2, '0')} $period";}catch(e){
    return "N/A";
  }

}
