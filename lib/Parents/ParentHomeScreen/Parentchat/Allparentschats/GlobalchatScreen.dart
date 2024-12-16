import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalChatScreen extends StatefulWidget {
  @override
  _GlobalChatScreenState createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String doctorId = 'doctor123'; // Example Doctor ID
  final String parentId = 'parent456'; // Example Parent ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://www.example.com/doctor-avatar.png'),
            ),
            SizedBox(width: 8),
            Text('Dr. Sarah'),
            Spacer(),
            Text('🟢 Online', style: TextStyle(color: Colors.green)),
          ],
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          // Chat Messages Displayed
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('global_chat')
                  .doc('messages')
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final isDoctorMessage = message['sender_id'] == doctorId;
                    return ChatBubble(
                      message: message['text'],
                      sender: isDoctorMessage ? 'Doctor' : 'Parent',
                      time: message['timestamp'] != null
                          ? (message['timestamp'] as Timestamp).toDate().toString().split(' ')[1]
                          : 'N/A',
                      isDoctorMessage: isDoctorMessage,
                    );
                  },
                );
              },
            ),
          ),
          // Message Input Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Handle attachments
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
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
        'sender_id': parentId,  // Or doctorId if doctor is sending
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear(); // Clear the input after sending
    }
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String sender;
  final String time;
  final bool isDoctorMessage;

  const ChatBubble({
    required this.message,
    required this.sender,
    required this.time,
    required this.isDoctorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
        isDoctorMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isDoctorMessage)
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://www.example.com/doctor-avatar.png'),
            ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: isDoctorMessage ? Colors.blue[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: isDoctorMessage
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
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
