import 'package:ajeal/parents/parent_home_screen/parent_chat/parent_admin_chat/chat_message.dart';
import 'package:ajeal/parents/parent_home_screen/parent_chat/parent_admin_chat/chat_repository.dart';
import 'package:ajeal/parents/parent_home_screen/parent_chat/parent_admin_chat/cubit/chat_cubit.dart';
import 'package:ajeal/parents/parent_home_screen/parent_chat/parent_admin_chat/cubit/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String role; // 'doctor' or 'parent'
  final String doctorId; // Doctor's ID
  final String parentId; // Parent's ID
  final bool isParent; // Whether current user is parent
  final bool isOthers; // Whether current user is others
  final String? doctorOthersId; // DoctorName + DoctorPhone

  const ChatScreen({
    super.key,
    required this.role,
    required this.doctorId,
    required this.parentId,
    required this.isParent,
    required this.isOthers,
    this.doctorOthersId
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit(
      repository: ChatRepository(),
      role: widget.role,
      doctorId: widget.doctorId,
      parentId: widget.parentId,
      isParent: widget.isParent,
      isOthers: widget.isOthers,
      doctorOthersId: widget.doctorOthersId,
    );

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final showButton = _scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 500;
      _chatCubit.updateScrollToBottomState(showButton);
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

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    await _chatCubit.sendMessage(messageText);
    _messageController.clear();
    _scrollToBottom();
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
                await _chatCubit.clearChat();
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
                await _chatCubit.submitReport(reportController.text);
                if (!context.mounted) return;
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
    return BlocProvider(
      create: (context) => _chatCubit,
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (!state.isAuthorized) {
            return const Scaffold(
              body: Center(
                child: Text('You are not authorized to access this chat'),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: _buildAppBar(state),
            body: Stack(
              children: [
                Column(
                  children: [
                    _buildChatMessages(state),
                    _buildMessageInput(state),
                  ],
                ),
                if (state.showScrollToBottom)
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
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatState state) {
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
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: state.isOtherUserOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    state.isOtherUserOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[100],
                    ),
                  ),
                ],
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

  Widget _buildChatMessages(ChatState state) {
    final messages = state.messages;

    return Expanded(
      child: messages.isEmpty
          ? Center(
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
      )
          : ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final timestamp = message.timestamp;
          final currentDate = timestamp != null
              ? DateFormat('MMMM d, y').format(timestamp.toDate())
              : null;

          final previousDate = index > 0 && messages[index - 1].timestamp != null
              ? DateFormat('MMMM d, y').format(messages[index - 1].timestamp!.toDate())
              : null;

          Widget? dateDivider;
          if (currentDate != null && currentDate != previousDate) {
            dateDivider = _buildDateDivider(currentDate);
          }

          return Column(
            children: [
              if (dateDivider != null) dateDivider,
              _buildMessageBubble(message, state.currentUserId),
            ],
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

  Widget _buildMessageBubble(ChatMessage message, String currentUserId) {
    final isCurrentUserMessage = message.senderId == currentUserId;
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

  Widget _buildMessageInput(ChatState state) {
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
                    _chatCubit.updateTypingStatus(text.isNotEmpty);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  maxLines: null,
                  style: const TextStyle(color: Colors.grey),
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
                icon: const Icon(
                   Icons.send ,
                  color: Colors.white,
                ),
                onPressed: state.isTyping ? _sendMessage : null,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}