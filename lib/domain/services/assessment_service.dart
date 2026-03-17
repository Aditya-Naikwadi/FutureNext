import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:futurenext/data/agent_prompt.dart';
import 'package:futurenext/data/models/assessment_model.dart';

class AssessmentService {
  final String apiKey;
  late final GenerativeModel _model;
  ChatSession? _chatSession;

  AssessmentService({required this.apiKey}) {
    if (apiKey == 'YOUR_API_KEY' || apiKey.isEmpty) {
      _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: 'DUMMY'); // Placeholder
      return;
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.2,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
      systemInstruction: Content.system(AgentPrompt.systemPrompt),
    );
  }

  bool get isApiKeyValid => apiKey != 'YOUR_API_KEY' && apiKey.isNotEmpty;

  /// Starts a new assessment session
  Future<String> startAssessment() async {
    if (!isApiKeyValid) {
      return 'API KEY MISSING: Please provide a valid Gemini API key in lib/main.dart to start your AI-powered career assessment.';
    }
    _chatSession = _model.startChat();
    // We send an empty message or a "start" signal to trigger the Greeting (Step 1)
    final response = await _chatSession!.sendMessage(Content.text('Initialize Assessment'));
    return response.text ?? 'Welcome to FutureNext! Ready to start?';
  }

  /// Sends a batch of answers for cumulative analysis and returns structured results
  Future<AssessmentResults> analyzeBatch(List<String> answers) async {
    if (!isApiKeyValid) {
      throw Exception('API KEY MISSING');
    }
    
    final prompt = '''
    The following are the answers from a 10th-grade student's career assessment:
    ${answers.asMap().entries.map((e) => "Question ${e.key + 1}: ${e.value}").join('\n')}
    
    Based on these 10 answers, please perform the following:
    1. Identify their strongest career domain (Technical, Medical, Financial, or Design).
    2. Provide a ranked results table of the 15 roles within that domain.
    3. Provide a Top Role Card with a personalized narrative.
    4. Provide a Career Roadmap from 10th grade.
    
    FOLLOW THE EXACT OUTPUT FORMAT SPECIFIED IN YOUR SYSTEM INSTRUCTIONS (JSON block first, then Sections 2-4).
    ''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';

    if (text.contains('```json')) {
      try {
        final jsonStr = text.split('```json')[1].split('```')[0].trim();
        final jsonData = jsonDecode(jsonStr);
        
        return AssessmentResults(
          domain: jsonData['domain'] as String,
          results: (jsonData['results'] as List)
              .map((e) => CareerRecommendation.fromJson(e))
              .toList(),
          topRoleCard: text.contains('SECTION 2:') ? text.split('SECTION 2:')[1].split('SECTION 3:')[0].trim() : 'Detailed assessment available in your roadmap.',
          roadmap: text.contains('SECTION 3:') ? text.split('SECTION 3:')[1].split('SECTION 4:')[0].trim() : 'Roadmap generation in progress.',
        );
      } catch (e) {
        throw Exception('Failed to process AI results: $e');
      }
    }
    
    throw Exception('The AI response was not in the expected format. Please try again.');
  }

  /// Resets the assessment
  void reset() {
    _chatSession = null;
  }
}
