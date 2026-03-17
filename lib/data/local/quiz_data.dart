import 'package:futurenext/data/models/quiz_model.dart';
import 'package:futurenext/data/models/career_model.dart';

class QuizData {
  static const List<Question> questions = [
    Question(
      id: 'q1',
      text: 'If you were given a broken electronic device, what would you most likely do?',
      options: [
        QuizOption(
          text: 'Try to open it and understand why the circuits failed.',
          scores: {CareerCategoryType.technology: 1.0, CareerCategoryType.science: 0.5},
        ),
        QuizOption(
          text: 'Research the scientific principles behind how it works.',
          scores: {CareerCategoryType.science: 1.0},
        ),
        QuizOption(
          text: 'Think about how the design could be more aesthetically pleasing.',
          scores: {CareerCategoryType.arts: 1.0},
        ),
        QuizOption(
          text: 'Consider the cost of repair vs. buying a new one.',
          scores: {CareerCategoryType.commerce: 1.0},
        ),
      ],
    ),
    Question(
      id: 'q2',
      text: 'Which of these activities sounds most exciting for a weekend project?',
      options: [
        QuizOption(
          text: 'Building a simple mobile app or website.',
          scores: {CareerCategoryType.technology: 1.0},
        ),
        QuizOption(
          text: 'Volunteering at a local health clinic or hospital.',
          scores: {CareerCategoryType.medicine: 1.0},
        ),
        QuizOption(
          text: 'Starting a small online business or selling a product.',
          scores: {CareerCategoryType.commerce: 1.0},
        ),
        QuizOption(
          text: 'Writing a short story, poem, or blog post.',
          scores: {CareerCategoryType.arts: 1.0, CareerCategoryType.media: 0.5},
        ),
      ],
    ),
    Question(
      id: 'q3',
      text: 'When you read the news, what section do you check first?',
      options: [
        QuizOption(
          text: 'Science & Discovery: New planets or inventions.',
          scores: {CareerCategoryType.science: 1.0, CareerCategoryType.technology: 0.5},
        ),
        QuizOption(
          text: 'Business & Markets: How companies and economies are doing.',
          scores: {CareerCategoryType.commerce: 1.0},
        ),
        QuizOption(
          text: 'Politics & Law: Changes in rules and social justice.',
          scores: {CareerCategoryType.law: 1.0},
        ),
        QuizOption(
          text: 'Sports: Match results and athlete performances.',
          scores: {CareerCategoryType.sports: 1.0},
        ),
      ],
    ),
    Question(
      id: 'q4',
      text: 'How do you prefer to help people?',
      options: [
        QuizOption(
          text: 'By treating their illness or physical pain.',
          scores: {CareerCategoryType.medicine: 1.0},
        ),
        QuizOption(
          text: 'By fighting for their rights in a court of law.',
          scores: {CareerCategoryType.law: 1.0},
        ),
        QuizOption(
          text: 'By teaching them a new skill or subject.',
          scores: {CareerCategoryType.education: 1.0},
        ),
        QuizOption(
          text: 'By creating tools that make their lives easier.',
          scores: {CareerCategoryType.technology: 1.0},
        ),
      ],
    ),
    Question(
      id: 'q5',
      text: 'Which environment do you thrive in most?',
      options: [
        QuizOption(
          text: 'A quiet lab with advanced equipment.',
          scores: {CareerCategoryType.science: 1.0, CareerCategoryType.medicine: 0.5},
        ),
        QuizOption(
          text: 'A bustling office or stock exchange floor.',
          scores: {CareerCategoryType.commerce: 1.0},
        ),
        QuizOption(
          text: 'A creative studio with paints, cameras, or instruments.',
          scores: {CareerCategoryType.arts: 1.0, CareerCategoryType.media: 0.5},
        ),
        QuizOption(
          text: 'An outdoor field, stadium, or gym.',
          scores: {CareerCategoryType.sports: 1.0},
        ),
      ],
    ),
  ];
}
