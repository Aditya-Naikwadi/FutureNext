import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/services/chat_service.dart';
import '../../domain/services/storage_service.dart';

// Events
abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatMessageSent extends ChatEvent {
  final String message;
  ChatMessageSent(this.message);
}

class ChatHistoryCleared extends ChatEvent {}

class ChatHistoryLoaded extends ChatEvent {}

// States
abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {
  final List<Map<String, dynamic>> messages;
  ChatLoading(this.messages);
}
class ChatLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;
  ChatLoaded(this.messages);
  @override
  List<Object?> get props => [messages];
}
class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  final StorageService _storageService;

  ChatBloc(this._chatService, this._storageService) : super(ChatInitial()) {
    on<ChatHistoryLoaded>((event, emit) {
      final history = _storageService.getChatHistory().cast<Map<String, dynamic>>();
      emit(ChatLoaded(history));
    });

    on<ChatMessageSent>((event, emit) async {
      final currentMessages = state is ChatLoaded 
          ? (state as ChatLoaded).messages 
          : (state is ChatLoading ? (state as ChatLoading).messages : <Map<String, dynamic>>[]);
      
      final newUserMessage = {'role': 'user', 'text': event.message, 'timestamp': DateTime.now().toIso8601String()};
      final updatedMessages = List<Map<String, dynamic>>.from(currentMessages)..add(newUserMessage);
      
      emit(ChatLoading(updatedMessages));
      await _storageService.saveChatMessage(newUserMessage);

      try {
        final response = await _chatService.sendMessage(event.message);
        final newBotMessage = {'role': 'bot', 'text': response, 'timestamp': DateTime.now().toIso8601String()};
        final finalMessages = List<Map<String, dynamic>>.from(updatedMessages)..add(newBotMessage);
        
        await _storageService.saveChatMessage(newBotMessage);
        emit(ChatLoaded(finalMessages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<ChatHistoryCleared>((event, emit) async {
      await _storageService.clearChatHistory();
      _chatService.clearHistory();
      emit(ChatLoaded([]));
    });
  }
}
