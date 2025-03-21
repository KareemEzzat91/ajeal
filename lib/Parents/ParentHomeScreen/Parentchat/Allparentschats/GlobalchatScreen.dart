import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/ParentAdminchat/ParentAdminchatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalChatScreen extends StatefulWidget {
  final String childName;
  final String doctorId;
  final String parentId;
  final bool isparent;

  const GlobalChatScreen({
    super.key,
    required this.childName,
    required this.doctorId,
    required this.parentId,
    required this.isparent,
  });

  @override
  _GlobalChatScreenState createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final showButton = _scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 500;
      if (_showScrollToBottom != showButton) {
        setState(() => _showScrollToBottom = showButton);
      }
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              _buildChatMessages(),
              _buildMessageInput(),
            ],
          ),
          if (_showScrollToBottom)
            Positioned(
              right: 16,
              bottom: 80,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.blue[700],
                onPressed: _scrollToBottom,
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue[700],
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://thumbs.dreamstime.com/b/global-chat-logo-template-design-world-207780009.jpg',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Global Chat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Online Members',
                style: TextStyle(fontSize: 12, color: Colors.blue[100]),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Show chat options
          },
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('global_chat')
              .doc(widget.doctorId)
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No messages yet.\nStart the conversation!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }

            final messages = snapshot.data!.docs;
            String? previousDate;

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index].data() as Map<String, dynamic>;
                final timestamp = message['timestamp'] as Timestamp?;
                final currentDate = timestamp != null
                    ? DateFormat('MMMM d, y').format(timestamp.toDate())
                    : null;

                // Show date divider if date changes
                Widget? dateDivider;
                if (currentDate != null && currentDate != previousDate) {
                  dateDivider = _buildDateDivider(currentDate);
                  previousDate = currentDate;
                }

                return Column(
                  children: [
                    if (dateDivider != null) dateDivider,
                    _buildMessageBubble(message),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isDoctorMessage = message['sender_id'] == widget.doctorId;
    final isMyMessage = message['sender_id'] == widget.parentId;
    final timestamp = message['timestamp'] as Timestamp?;
    final time = timestamp != null
        ? DateFormat('h:mm a').format(timestamp.toDate())
        : 'N/A';

    return GestureDetector(
      onTap: () {
        if (widget.isparent == false &&
            message["sender_id"] != widget.doctorId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                isOthers: false,
                role: "doctor",
                doctorId: widget.doctorId,
                parentId: message['sender_id'],
                isParent: false,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment:
              isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMyMessage) _buildAvatar(isDoctorMessage),
            if (!isMyMessage) const SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: _getBubbleColor(isDoctorMessage, isMyMessage),
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isMyMessage ? null : const Radius.circular(0),
                  bottomRight: isMyMessage ? const Radius.circular(0) : null,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: isMyMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isMyMessage)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        isDoctorMessage ? "Doctor" : message["senderName"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isDoctorMessage ? Colors.white : Colors.grey[800],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isDoctorMessage || isMyMessage
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDoctorMessage || isMyMessage
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isMyMessage) const SizedBox(width: 8),
            if (isMyMessage) _buildMessageStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDoctorMessage) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDoctorMessage ? Colors.blue[700]! : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: isDoctorMessage ? Colors.blue[100] : Colors.grey[200],
        child: isDoctorMessage
            ? const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/images/man-teacher-with-chalkboard-on-blue-background-vector-33671420.jpg'),
              )
            : Icon(
                Icons.person,
                size: 18,
                color: Colors.grey[600],
              ),
      ),
    );
  }

  Widget _buildMessageStatus() {
    return const Icon(
      Icons.done_all,
      size: 16,
      color: Colors.blue,
    );
  }

  Color _getBubbleColor(bool isDoctorMessage, bool isMyMessage) {
    if (isDoctorMessage) return Colors.blue[700]!;
    if (isMyMessage) return Colors.green[600]!;
    return Colors.grey[200]!;
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 10,
            offset:  Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              color: Colors.blue[700],
              onPressed: () {
                // Handle attachments
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                ),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blue ,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset:  Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text;
// update to send the message to doctor only and his patient
      await FirebaseFirestore.instance
          .collection('global_chat')
          .doc(widget.doctorId)
          .collection('messages')
          .add({
        'sender_id': widget.isparent ? widget.parentId : widget.doctorId,
        'text': messageText,
        'senderName': widget.isparent ? widget.childName : "Doctor",
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
