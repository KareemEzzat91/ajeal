
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/ParentAdminchat/ChatMessage.dart';
import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final bool isLoading;
  final bool isAuthorized;
  final bool isTyping;
  final List<ChatMessage> messages;
  final String chatId;
  final String currentUserId;
  final String errorMessage;
  final bool showScrollToBottom;
  final bool isOtherUserOnline;

  const ChatState({
    this.isLoading = true,
    this.isAuthorized = false,
    this.isTyping = false,
    this.messages = const [],
    this.chatId = '',
    this.currentUserId = '',
    this.errorMessage = '',
    this.showScrollToBottom = false,
    this.isOtherUserOnline = false,
  });

  ChatState copyWith({
    bool? isLoading,
    bool? isAuthorized,
    bool? isTyping,
    List<ChatMessage>? messages,
    String? chatId,
    String? currentUserId,
    String? errorMessage,
    bool? showScrollToBottom,
    bool? isOtherUserOnline,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      isTyping: isTyping ?? this.isTyping,
      messages: messages ?? this.messages,
      chatId: chatId ?? this.chatId,
      currentUserId: currentUserId ?? this.currentUserId,
      errorMessage: errorMessage ?? this.errorMessage,
      showScrollToBottom: showScrollToBottom ?? this.showScrollToBottom,
      isOtherUserOnline: isOtherUserOnline ?? this.isOtherUserOnline,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isAuthorized,
    isTyping,
    messages,
    chatId,
    currentUserId,
    errorMessage,
    showScrollToBottom,
    isOtherUserOnline,
  ];
}
