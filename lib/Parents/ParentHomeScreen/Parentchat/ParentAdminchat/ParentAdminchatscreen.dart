import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ----- MODELS -----

class ChatMessage {
  final String senderId;
  final String senderRole;
  final String text;
  final Timestamp? timestamp;
  final bool read;
  final String type;

  ChatMessage({
    required this.senderId,
    required this.senderRole,
    required this.text,
    this.timestamp,
    this.read = false,
    this.type = 'text',
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['sender_id'] ?? '',
      senderRole: map['sender_role'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] as Timestamp?,
      read: map['read'] ?? false,
      type: map['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'sender_role': senderRole,
      'text': text,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'read': read,
      'type': type,
    };
  }
}

// ----- CONTROLLERS/SERVICES -----

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Initialize chat document
  Future<void> initializeChatDocument(String chatId, String doctorId, String parentId) async {
    await _firestore
        .collection('Chats')
        .doc(chatId)
        .set({
      'doctor_id': doctorId,
      'parent_id': parentId,
      'participants': [doctorId, parentId],
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get user online status stream
  Stream<DocumentSnapshot> getUserStatusStream(String userId) {
    return _firestore
        .collection('UserStatus')
        .doc(userId)
        .snapshots();
  }

  // Send a message
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .add(message.toMap());

    await _firestore
        .collection('Chats')
        .doc(chatId)
        .update({
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Update typing status
  Future<void> updateTypingStatus(String chatId, String role, bool isTyping) async {
    await _firestore
        .collection('Chats')
        .doc(chatId)
        .update({
      '${role}_typing': isTyping,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Clear chat messages
  Future<void> clearChat(String chatId) async {
    final batch = _firestore.batch();
    final messages = await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .get();

    for (var message in messages.docs) {
      batch.delete(message.reference);
    }

    await batch.commit();
  }

  // Submit a report
  Future<void> submitReport(String chatId, String reporterId, String reporterRole, String reportText) async {
    await _firestore.collection('Reports').add({
      'chat_id': chatId,
      'reporter_id': reporterId,
      'reporter_role': reporterRole,
      'report_text': reportText,
      'timestamp': FieldValue.serverTimestamp(),
    });

  }

  // Get doctor information
  Future<DocumentSnapshot> getDoctorInfo(String doctorId) {
    return _firestore.collection("Doctors").doc(doctorId).get();
  }
}

// ----- UI COMPONENTS -----

class ChatScreen extends StatefulWidget {
  final String role; // 'doctor' or 'parent'
  final String chatId; // Unique chat identifier
  final String doctorId; // Doctor's ID
  final String parentId; // Parent's ID
  final bool isParent; // Whether current user is parent
  final bool isOthers; // Whether current user is others
  final String? doctorOthersId; // DoctorName + DoctorPhone

  const ChatScreen({
    super.key,
    required this.role,
    required this.chatId,
    required this.doctorId,
    required this.parentId,
    required this.isParent,
    required this.isOthers,
    this.doctorOthersId
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  bool _showScrollToBottom = false;
  bool _isTyping = false;
  String _currentUserId = '';
  bool _isAuthorized = false;
  bool _isLoading = true;
  late String _chatId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _setupAuthorization();
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

  Future<void> _setupAuthorization() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final currentUser = _chatService.currentUser;

      // Handle parent access without authentication
      if (currentUser == null && widget.role != "Doctor") {
        _currentUserId = widget.parentId;
        _isAuthorized = true;
        _chatId = widget.chatId;
        await _chatService.initializeChatDocument(_chatId, widget.doctorId, widget.parentId);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Handle unauthorized doctor access
      if (currentUser == null && widget.role == "Doctor") {
        _handleUnauthorizedAccess('You need to be logged in to access doctor chats');
        return;
      }

      // User is authenticated
      _currentUserId = currentUser!.uid;

      // Handle doctor info retrieval for "others" mode
      if (widget.isOthers) {
        try {
          final doctorDoc = await _chatService.getDoctorInfo(widget.doctorOthersId!);

          if (doctorDoc.exists) {
            final doctorData = doctorDoc.data() as Map<String, dynamic>?;
            _currentUserId = doctorData?["Doctor_id"];
            _chatId = _currentUserId + widget.parentId;

            if (_currentUserId.isEmpty) {
              throw Exception("Doctor_id not found in document");
            }
          } else {
            throw Exception("Doctor document not found");
          }
          _isAuthorized = true;
          setState(() {
            _isLoading = false;
          });

          await _chatService.initializeChatDocument(_chatId, widget.doctorId, widget.parentId);
          return;
        } catch (e) {
          _handleUnauthorizedAccess('Error retrieving doctor information: ${e.toString()}');
          return;
        }
      }

      // Check authorization based on role
      _chatId = widget.chatId;
      if (widget.isParent) {
        _isAuthorized = _currentUserId == widget.parentId;
      } else {
        _isAuthorized = _currentUserId == widget.doctorId;
      }

      // Handle unauthorized access
      if (!_isAuthorized) {
        _handleUnauthorizedAccess('You are not authorized to access this chat');
        return;
      }

      // Initialize chat document if authorized
      setState(() {
        _isLoading = false;
      });
      await _chatService.initializeChatDocument(_chatId, widget.doctorId, widget.parentId);
    } catch (e) {
      _handleUnauthorizedAccess('Authorization error: ${e.toString()}');
    }
  }

  void _handleUnauthorizedAccess(String message) {
    setState(() {
      _isLoading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    if (!_isAuthorized) return;

    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final message = ChatMessage(
      senderId: _currentUserId,
      senderRole: widget.role,
      text: messageText,
    );

    try {
      await _chatService.sendMessage(_chatId, message);

      _messageController.clear();
      setState(() => _isTyping = false);
      await _chatService.updateTypingStatus(_chatId, widget.role, false);
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

  void _updateTypingStatus(bool isTyping) {
    if (_isTyping != isTyping) {
      setState(() => _isTyping = isTyping);
      _chatService.updateTypingStatus(_chatId, widget.role, isTyping);
    }
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
                await _chatService.clearChat(_chatId);
              },
            ),
          ],
        );
      },
    );
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
                await _chatService.submitReport(
                    _chatId,
                    _currentUserId,
                    widget.role,
                    reportController.text
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sent Successfully "),backgroundColor: CupertinoColors.activeGreen,));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthorized) {
      return const Scaffold(
        body: Center(
          child: Text('You are not authorized to access this chat'),
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
    final otherUserId = isDoctor ? widget.parentId : widget.doctorId;

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
                  : const AssetImage("assets/images/man-teacher-with-chalkboard-on-blue-background-vector-33671420.jpg") as ImageProvider,
            ),
          ),
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
                stream: _chatService.getUserStatusStream(otherUserId),
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

        PopupMenuButton<String>(
          onSelected: (value) {
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

  Widget _buildChatMessages() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getMessagesStream(_chatId),
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
              final messageData = messages[index].data() as Map<String, dynamic>;
              final message = ChatMessage.fromMap(messageData);
              final timestamp = message.timestamp;
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

  Widget _buildMessageBubble(ChatMessage message) {
    final isCurrentUserMessage = message.senderId == _currentUserId;
    final timestamp = message.timestamp;
    final time = timestamp != null
        ? DateFormat('h:mm a').format(timestamp.toDate())
        : 'N/A';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isCurrentUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUserMessage)
            _buildAvatar(message.senderRole == 'doctor'),
          if (!isCurrentUserMessage) const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isCurrentUserMessage ? Colors.blue[700] : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft:
                  !isCurrentUserMessage ? const Radius.circular(0) : null,
                  bottomRight:
                  isCurrentUserMessage ? const Radius.circular(0) : null,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
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
                    message.text,
                    style: TextStyle(
                      color:
                      isCurrentUserMessage ? Colors.white : Colors.black87,
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
                              ? Colors.white70
                              : Colors.grey[600],
                        ),
                      ),
                      if (isCurrentUserMessage) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.read ? Icons.done_all : Icons.done,
                          size: 14,
                          color: Colors.white70,
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
            ? const AssetImage("assets/images/man-teacher-with-chalkboard-on-blue-background-vector-33671420.jpg") as ImageProvider
            : const NetworkImage("https://img.freepik.com/premium-vector/parents-with-kids-avatars-characters_24877-24085.jpg"),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
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
                    _updateTypingStatus(text.isNotEmpty);
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blue,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  _isTyping ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: _isTyping ? _sendMessage : _handleVoiceMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleVoiceMessage() async {
    // Implement voice recording functionality
  }

  @override
  void dispose() {
    _chatService.updateTypingStatus(_chatId, widget.role, false);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}