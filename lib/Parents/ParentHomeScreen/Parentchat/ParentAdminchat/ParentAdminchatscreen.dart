import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId; // لتحديد الدردشة
  final String doctorId;
  final String parentId;
  final bool isparent;

  ChatScreen({
    required this.chatId,
    required this.doctorId,
    required this.parentId,
    required this.isparent,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // إرسال الرسائل إلى Firestore
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text;
      final senderId = widget.isparent? widget.parentId: FirebaseAuth.instance.currentUser?.uid ?? widget.parentId;

      final messageRef = FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .collection('Messages');

      await messageRef.add({
        'sender_id': senderId,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: widget.isparent
                  ? const AssetImage('assets/images/Mohsen.jpg') as ImageProvider:const NetworkImage(
                  "https://static.vecteezy.com/system/resources/previews/019/818/399/original/happy-family-with-children-mother-father-and-kids-cute-cartoon-characters-isolated-colorful-illustration-in-flat-style-free-png.png")
               ,
            ),
            const SizedBox(width: 8),
            widget.isparent ?  const Text('Dr. Mohammed',style: TextStyle(fontSize: 15),):const Text("Parents",style: TextStyle(fontSize: 15)),
            const Spacer(),
            const Text('🟢 Online', style: TextStyle(color: Colors.green,fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          // عرض الرسائل من Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(widget.chatId)
                  .collection('Messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final isDoctorMessage = message['sender_id'] == widget.parentId;// اهلا  sendrid = dr_id

                    return ChatBubble(
                      message: message['text'],
                      sender: isDoctorMessage ? 'Parent':'Doctor' ,
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
          // قسم إدخال الرسائل
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    // إضافة وظيفة المرفقات هنا
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
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage, // إرسال الرسالة
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    final isdark =Theme.of(context).brightness==Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isDoctorMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isDoctorMessage)
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png'),
            ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: isDoctorMessage ? Colors.blue[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: isDoctorMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  sender,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 16,color: isdark?Colors.white:Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  convertTo12Hour(time),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
