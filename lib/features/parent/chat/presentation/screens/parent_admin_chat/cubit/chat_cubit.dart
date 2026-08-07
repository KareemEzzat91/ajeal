import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:ajeal/core/models/chat_message/chat_message.dart';
import 'package:ajeal/features/parent/data/chat_repository.dart';
import 'package:ajeal/features/parent/chat/presentation/screens/parent_admin_chat/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  final String role;
  final String doctorId;
  final String parentId;
  final bool isParent;
  final bool isOthers;
  final String? doctorOthersId;

  StreamSubscription? _messagesSubscription;
  StreamSubscription? _userStatusSubscription;

  ChatCubit({
    required ChatRepository repository,
    required this.role,
    required this.doctorId,
    required this.parentId,
    required this.isParent,
    required this.isOthers,
    this.doctorOthersId,
  })  : _repository = repository,
        super(const ChatState()) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      emit(state.copyWith(isLoading: true));

      final currentUser = _repository.currentUser;
      String userId = '';
      String chatId = '';
      bool isAuthorized = false;

      // Handle parent access without authentication
      if (currentUser == null && role != "Doctor") {
        userId = parentId;
        isAuthorized = true;
        chatId = doctorId + parentId;

        emit(state.copyWith(
          currentUserId: userId,
          isAuthorized: isAuthorized,
          chatId: chatId,
        ));

        await _repository.initializeChatDocument(chatId, doctorId, parentId);
        _subscribeToStreams(chatId);
        emit(state.copyWith(isLoading: false));
        return;
      }

      // Handle unauthorized doctor access
      if (currentUser == null && role == "Doctor") {
        emit(state.copyWith(
          isLoading: false,
          isAuthorized: false,
          errorMessage: 'You need to be logged in to access doctor chats',
        ));
        return;
      }

      // User is authenticated
      userId = currentUser!.uid;

      // Handle doctor info retrieval for "others" mode
      if (isOthers) {
        try {
          final doctorDoc = await _repository.getDoctorInfo(doctorOthersId!);

          if (doctorDoc.exists) {
            final doctorData = doctorDoc.data() as Map<String, dynamic>?;
            userId = doctorData?["Doctor_id"] ?? '';
            chatId = userId + parentId;

            if (userId.isEmpty) {
              throw Exception("Doctor_id not found in document");
            }
          } else {
            throw Exception("Doctor document not found");
          }
          isAuthorized = true;

          emit(state.copyWith(
            currentUserId: userId,
            isAuthorized: isAuthorized,
            chatId: chatId,
            isLoading: false,
          ));

          await _repository.initializeChatDocument(chatId, doctorId, parentId);
          _subscribeToStreams(chatId);
          return;
        } catch (e) {
          emit(state.copyWith(
            isLoading: false,
            isAuthorized: false,
            errorMessage:
                'Error retrieving doctor information: ${e.toString()}',
          ));
          return;
        }
      }

      // Check authorization based on role
      chatId = doctorId + parentId;
      if (isParent) {
        isAuthorized = userId == parentId;
      } else {
        isAuthorized = userId == doctorId;
      }

      // Handle unauthorized access
      if (!isAuthorized) {
        emit(state.copyWith(
          isLoading: false,
          isAuthorized: false,
          errorMessage: 'You are not authorized to access this chat',
        ));
        return;
      }

      // Initialize chat document if authorized
      emit(state.copyWith(
        currentUserId: userId,
        isAuthorized: isAuthorized,
        chatId: chatId,
        isLoading: false,
      ));

      await _repository.initializeChatDocument(chatId, doctorId, parentId);
      _subscribeToStreams(chatId);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isAuthorized: false,
        errorMessage: 'Authorization error: ${e.toString()}',
      ));
    }
  }

  void _subscribeToStreams(String chatId) {
    // Subscribe to messages stream
    _messagesSubscription =
        _repository.getMessagesStream(chatId).listen((messages) {
      emit(state.copyWith(messages: messages));
    });

    // Subscribe to other user's status
    final otherUserId = isParent ? doctorId : parentId;
    _userStatusSubscription =
        _repository.getUserStatusStream(otherUserId).listen((snapshot) {
      final isOnline = snapshot.exists && snapshot.get('online') == true;
      emit(state.copyWith(isOtherUserOnline: isOnline));
    });
  }

  void updateTypingStatus(bool isTyping) {
    if (state.isTyping != isTyping) {
      emit(state.copyWith(isTyping: isTyping));
      _repository.updateTypingStatus(state.chatId, role, isTyping);
    }
  }

  Future<void> sendMessage(String text) async {
    if (!state.isAuthorized || text.trim().isEmpty) return;

    try {
      final message = ChatMessage(
        senderId: state.currentUserId,
        senderRole: role,
        text: text.trim(),
      );

      await _repository.sendMessage(state.chatId, message);
      updateTypingStatus(false);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to send message: ${e.toString()}',
      ));
    }
  }

  Future<void> clearChat() async {
    try {
      await _repository.clearChat(state.chatId);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to clear chat: ${e.toString()}',
      ));
    }
  }

  Future<void> submitReport(String reportText) async {
    try {
      await _repository.submitReport(
          state.chatId, state.currentUserId, role, reportText);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to submit report: ${e.toString()}',
      ));
    }
  }

  void updateScrollToBottomState(bool show) {
    if (state.showScrollToBottom != show) {
      emit(state.copyWith(showScrollToBottom: show));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _userStatusSubscription?.cancel();
    _repository.updateTypingStatus(state.chatId, role, false);
    return super.close();
  }
}
