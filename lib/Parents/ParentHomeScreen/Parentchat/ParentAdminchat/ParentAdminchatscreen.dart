import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String role;      // 'doctor' or 'parent'
  final String chatId;    // Unique chat identifier
  final String doctorId;  // Doctor's ID
  final String parentId;  // Parent's ID
  final bool isParent;    // Whether current user is parent

  const ChatScreen({
    super.key,
    required this.role,
    required this.chatId,
    required this.doctorId,
    required this.parentId,
    required this.isParent,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;
  bool _isTyping = false;
  late String _currentUserId;
  late bool _isAuthorized;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _setupAuthorization();
  }

  void _setupAuthorization(){


    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _currentUserId=widget.parentId ;
      _isAuthorized = true;
      return;
    }

    _currentUserId = currentUser.uid;

    // Verify if the current user is authorized to access this chat
    if (widget.isParent) {
      _isAuthorized = _currentUserId == widget.parentId;
    } else {
      _isAuthorized = _currentUserId == widget.doctorId;
    }

    // If not authorized, show error and navigate back
    if (!_isAuthorized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are not authorized to access this chat'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    // Create or update chat document
    _initializeChatDocument();
  }

  Future<void> _initializeChatDocument() async {
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chatId)
        .set({
      'doctor_id': widget.doctorId,
      'parent_id': widget.parentId,
      'participants': [widget.doctorId, widget.parentId],
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
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
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthorized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
    final isDoctor = !widget.isParent;
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
            child: CircleAvatar(
              radius: 18,
              backgroundImage: isDoctor
                  ? const NetworkImage("https://img.freepik.com/premium-vector/parents-with-kids-avatars-characters_24877-24085.jpg")
                  :const AssetImage("assets/images/Mohsen.jpg") ,
            ),),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDoctor ? 'Parent' : 'Doctor',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('UserStatus')
                    .doc(isDoctor ? widget.parentId : widget.doctorId)
                    .snapshots(),
                builder: (context, snapshot) {
                  final isOnline = snapshot.hasData &&
                      snapshot.data!.exists &&
                      snapshot.data!.get('online') == true;

                  return Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[100],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.video_call),
          onPressed: () {
            // Implement video call functionality
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle menu options
            switch (value) {
              case 'clear':
                _showClearChatDialog();
                break;
              case 'report':
                _showReportDialog();
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'clear',
              child: Text('Clear Chat'),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Text('Report Issue'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showClearChatDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Chat'),
          content: const Text('Are you sure you want to clear all messages?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearChat();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearChat() async {
    final batch = FirebaseFirestore.instance.batch();
    final messages = await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chatId)
        .collection('Messages')
        .get();

    for (var message in messages.docs) {
      batch.delete(message.reference);
    }

    await batch.commit();
  }

  Future<void> _showReportDialog() async {
    final TextEditingController reportController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Issue'),
          content: TextField(
            controller: reportController,
            decoration: const InputDecoration(
              hintText: 'Describe the issue...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                await _submitReport(reportController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitReport(String reportText) async {
    await FirebaseFirestore.instance
        .collection('Reports')
        .add({
      'chat_id': widget.chatId,
      'reporter_id': _currentUserId,
      'reporter_role': widget.role,
      'report_text': reportText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Widget _buildChatMessages() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .doc(widget.chatId)
            .collection('Messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
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
    final isCurrentUserMessage = message['sender_id'] == _currentUserId;
    final timestamp = message['timestamp'] as Timestamp?;
    final time = timestamp != null
        ? DateFormat('h:mm a').format(timestamp.toDate())
        : 'N/A';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
        isCurrentUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUserMessage) _buildAvatar(message['sender_role'] == 'doctor'),
          if (!isCurrentUserMessage) const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isCurrentUserMessage ? Colors.blue[700] : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: !isCurrentUserMessage ? const Radius.circular(0) : null,
                  bottomRight: isCurrentUserMessage ? const Radius.circular(0) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: isCurrentUserMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isCurrentUserMessage ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: isCurrentUserMessage
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                      ),
                      if (isCurrentUserMessage) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message['read'] == true
                              ? Icons.done_all
                              : Icons.done,
                          size: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isDoctor) {
    return Container(
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
        color: Colors.blue[700]!,
        ),
        ),
      child: CircleAvatar(
        radius: 16,
        backgroundImage: isDoctor
            ? const AssetImage("assets/images/Mohsen.jpg")
            :const NetworkImage("https://img.freepik.com/premium-vector/parents-with-kids-avatars-characters_24877-24085.jpg"),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              color: Colors.blue[700],
              onPressed: _showAttachmentOptions,
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
                  onChanged: (text) {
                    setState(() => _isTyping = text.isNotEmpty);
                    _updateTypingStatus(isTyping: text.isNotEmpty);
                  },
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  _isTyping ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: _isTyping ? sendMessage : _handleVoiceMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAttachmentOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageAttachment();
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  _handleDocumentAttachment();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImageAttachment() async {
    // Implement image picker functionality
  }

  Future<void> _handleDocumentAttachment() async {
    // Implement document picker functionality
  }

  Future<void> _handleVoiceMessage() async {
    // Implement voice recording functionality
  }

  Future<void> _updateTypingStatus({required bool isTyping}) async {
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chatId)
        .update({
      '${widget.role}_typing': isTyping,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendMessage() async {
    if (!_isAuthorized) return;

    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final message = {
      'sender_id': _currentUserId,
      'sender_role': widget.role,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
      'type': 'text',
    };

    try {
      // Add message to the messages subcollection
      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .collection('Messages')
          .add(message);

      _messageController.clear();
      setState(() => _isTyping = false);
      _scrollToBottom();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _updateTypingStatus(isTyping: false);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}