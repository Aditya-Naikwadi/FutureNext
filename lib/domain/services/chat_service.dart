import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:futurenext/core/constants/app_strings.dart';

class ChatService {
  final String apiKey;
  late final GenerativeModel _model;
  ChatSession? _chatSession;

  ChatService({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      systemInstruction: Content.system('''
You are a friendly and knowledgeable career counselor named "${AppStrings.appName} Guide". 
Your goal is to help Indian students who have just completed their 10th grade.
Provide advice on:
- Career options (Science, Commerce, Arts, etc.)
- Subject selection for 11th and 12th grade.
- Entrance exams like JEE, NEET, CLAT, NATA, etc.
- Skill development and top colleges in India.

Keep your tone encouraging, professional but approachable, and simple to understand for teenagers.
If a student is undecided, ask helpful questions to narrow down their interests.
Always provide context relevant to the Indian education system.
'''),
    );
  }

  Future<String> sendMessage(String message) async {
    _chatSession ??= _model.startChat();
    final response = await _chatSession!.sendMessage(Content.text(message));
    return response.text ?? 'I apologize, but I could not generate a response. Please try again.';
  }

  void clearHistory() {
    _chatSession = null;
  }
}
