import '../models/quiz_model.dart';

class QuizData {
  static const List<QuizQuestion> mainProgressQuestions = [
    QuizQuestion(
      id: 'q1',
      question: 'When you encounter a broken electronic device, what is your first instinct?',
      options: [
        QuizOption(text: 'Try to open it and understand how it works internally.', careerWeights: {'tech': 3, 'robotics': 2}),
        QuizOption(text: 'Think about how its design could be improved.', careerWeights: {'arts': 2, 'tech': 1}),
        QuizOption(text: 'Look for a professional to fix it safely.', careerWeights: {'law': 1, 'medicine': 1}),
        QuizOption(text: 'Research why this model has such frequent issues.', careerWeights: {'commerce': 2, 'media': 1}),
      ],
    ),
    QuizQuestion(
      id: 'q2',
      question: 'Which of these activities sounds most exciting to you?',
      options: [
        QuizOption(text: 'Conducting a biological experiment in a lab.', careerWeights: {'medicine': 3}),
        QuizOption(text: 'Writing a persuasive article about a social issue.', careerWeights: {'media': 2, 'law': 2}),
        QuizOption(text: 'Organizing a school event with a strict budget.', careerWeights: {'commerce': 3, 'sports': 1}),
        QuizOption(text: 'Teaching a group of younger students a new skill.', careerWeights: {'education': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q3',
      question: 'What kind of books or articles do you enjoy reading most?',
      options: [
        QuizOption(text: 'Biographies of successful business leaders.', careerWeights: {'commerce': 3}),
        QuizOption(text: 'Technical guides on how software or apps are made.', careerWeights: {'tech': 3}),
        QuizOption(text: 'Mystery novels or legal thrillers.', careerWeights: {'law': 3}),
        QuizOption(text: 'Books on human psychology and behavioral science.', careerWeights: {'medicine': 2, 'education': 2}),
      ],
    ),
    QuizQuestion(
      id: 'q4',
      question: 'In a group project, what role do you naturally take?',
      options: [
        QuizOption(text: 'The one who designs the final presentation visuals.', careerWeights: {'arts': 3}),
        QuizOption(text: 'The one who analyzes the data and facts.', careerWeights: {'tech': 2, 'medicine': 2}),
        QuizOption(text: 'The one who manages the team and assigns tasks.', careerWeights: {'commerce': 2, 'sports': 2}),
        QuizOption(text: 'The one who presents the final work to the class.', careerWeights: {'media': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q5',
      question: 'How do you prefer to spend your free time?',
      options: [
        QuizOption(text: 'Playing competitive sports or exercising.', careerWeights: {'sports': 3}),
        QuizOption(text: 'Drawing, painting, or creating digital art.', careerWeights: {'arts': 3}),
        QuizOption(text: 'Volunteering for a social cause or community service.', careerWeights: {'education': 2, 'medicine': 1}),
        QuizOption(text: 'Solving complex puzzles or playing strategy games.', careerWeights: {'tech': 2, 'commerce': 1}),
      ],
    ),
    QuizQuestion(
      id: 'q6',
      question: 'If you could visit any of these places, which would it be?',
      options: [
        QuizOption(text: 'A high-tech research facility at NASA.', careerWeights: {'tech': 3}),
        QuizOption(text: 'A historic Supreme Court or legal assembly.', careerWeights: {'law': 3}),
        QuizOption(text: 'A world-class hospital or surgical center.', careerWeights: {'medicine': 3}),
        QuizOption(text: 'A bustling stock exchange or startup incubator.', careerWeights: {'commerce': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q7',
      question: 'Which of these subjects do you find easiest to master?',
      options: [
        QuizOption(text: 'Mathematics and Logic.', careerWeights: {'tech': 2, 'commerce': 2}),
        QuizOption(text: 'Biology and Life Sciences.', careerWeights: {'medicine': 3}),
        QuizOption(text: 'Languages and Literature.', careerWeights: {'media': 2, 'law': 1}),
        QuizOption(text: 'History and Social Studies.', careerWeights: {'education': 2, 'law': 2}),
      ],
    ),
    QuizQuestion(
      id: 'q8',
      question: 'What motivates you most about a future career?',
      options: [
        QuizOption(text: 'The opportunity to innovate and build new things.', careerWeights: {'tech': 3, 'arts': 1}),
        QuizOption(text: 'The chance to help people and save lives.', careerWeights: {'medicine': 3, 'education': 1}),
        QuizOption(text: 'Winning cases and ensuring justice is served.', careerWeights: {'law': 3}),
        QuizOption(text: 'Achieving financial success and building a brand.', careerWeights: {'commerce': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q9',
      question: 'How do you handle a situation where someone is being treated unfairly?',
      options: [
        QuizOption(text: 'I argue the case logically using facts and rules.', careerWeights: {'law': 3}),
        QuizOption(text: 'I try to comfort the person and provide support.', careerWeights: {'education': 2, 'medicine': 1}),
        QuizOption(text: 'I document the situation and tell people about it.', careerWeights: {'media': 3}),
        QuizOption(text: 'I look for a systematic way to prevent it from happening.', careerWeights: {'commerce': 2, 'tech': 1}),
      ],
    ),
    QuizQuestion(
      id: 'q10',
      question: 'Which of these digital tools do you use most comfortably?',
      options: [
        QuizOption(text: 'Programming editors or command-line tools.', careerWeights: {'tech': 3}),
        QuizOption(text: 'Design software like Canva or Photoshop.', careerWeights: {'arts': 3}),
        QuizOption(text: 'Video editing or social media apps.', careerWeights: {'media': 3}),
        QuizOption(text: 'Spreadsheets or financial planning tools.', careerWeights: {'commerce': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q11',
      question: 'Are you interested in how the government functions?',
      options: [
        QuizOption(text: 'Very interested, I want to be part of the change.', careerWeights: {'law': 3, 'education': 1}),
        QuizOption(text: 'Somewhat, mainly how it affects the economy.', careerWeights: {'commerce': 3}),
        QuizOption(text: 'Not really, I prefer scientific or creative topics.', careerWeights: {'tech': 1, 'arts': 1}),
        QuizOption(text: 'Only in how it communicates with the public.', careerWeights: {'media': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q12',
      question: 'Do you enjoy physical activities and outdoor challenges?',
      options: [
        QuizOption(text: 'Yes, I thrive in active environment.', careerWeights: {'sports': 3}),
        QuizOption(text: 'I prefer mental challenges over physical ones.', careerWeights: {'tech': 2, 'law': 1}),
        QuizOption(text: 'I like a mix of both.', careerWeights: {'medicine': 1, 'education': 1}),
        QuizOption(text: 'No, I prefer quiet and indoor spaces.', careerWeights: {'arts': 2}),
      ],
    ),
    QuizQuestion(
      id: 'q13',
      question: 'How do you react to seeing a beautiful building or a clever advertisement?',
      options: [
        QuizOption(text: 'I analyze the message and how it reaches people.', careerWeights: {'media': 3}),
        QuizOption(text: 'I admire the aesthetic and creative effort.', careerWeights: {'arts': 3}),
        QuizOption(text: 'I wonder how much it cost to produce or build.', careerWeights: {'commerce': 3}),
        QuizOption(text: 'I think about the structural engineering behind it.', careerWeights: {'tech': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q14',
      question: 'Do you like working with children or elderly people?',
      options: [
        QuizOption(text: 'Yes, I find it fulfilling to guide them.', careerWeights: {'education': 3}),
        QuizOption(text: 'I prefer working with peers or adults.', careerWeights: {'commerce': 2, 'law': 2}),
        QuizOption(text: 'I am better with technology than with people.', careerWeights: {'tech': 3}),
        QuizOption(text: 'I like helping them in a professional health capacity.', careerWeights: {'medicine': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q15',
      question: 'What is your opinion on artificial intelligence?',
      options: [
        QuizOption(text: 'It is a fascinating tool that I want to build.', careerWeights: {'tech': 3}),
        QuizOption(text: 'It is a threat to creativity and human jobs.', careerWeights: {'arts': 1, 'law': 1}),
        QuizOption(text: 'It is a great way to optimize business profits.', careerWeights: {'commerce': 3}),
        QuizOption(text: 'It can revolutionize healthcare and education.', careerWeights: {'medicine': 2, 'education': 2}),
      ],
    ),
    QuizQuestion(
      id: 'q16',
      question: 'Do you enjoy public speaking or being on stage?',
      options: [
        QuizOption(text: 'Yes, I love the spotlight.', careerWeights: {'media': 3, 'arts': 2}),
        QuizOption(text: 'I am comfortable if I have something important to say.', careerWeights: {'law': 2, 'education': 2}),
        QuizOption(text: 'I prefer to stay in the background.', careerWeights: {'tech': 2, 'commerce': 1}),
        QuizOption(text: 'Only if it is about a topic I am passionate about.', careerWeights: {'medicine': 1}),
      ],
    ),
    QuizQuestion(
      id: 'q17',
      question: 'How do you approach a long list of tasks?',
      options: [
        QuizOption(text: 'I create a detailed schedule and prioritize.', careerWeights: {'commerce': 3}),
        QuizOption(text: 'I dive into the hardest task first.', careerWeights: {'tech': 2}),
        QuizOption(text: 'I look for creative ways to finish them faster.', careerWeights: {'arts': 2}),
        QuizOption(text: 'I make sure everyone else knows what to do.', careerWeights: {'sports': 2}),
      ],
    ),
    QuizQuestion(
      id: 'q18',
      question: 'Are you interested in fashion or interior decor?',
      options: [
        QuizOption(text: 'Yes, I have a strong sense of style.', careerWeights: {'arts': 3}),
        QuizOption(text: 'I appreciate it, but I wouldn\'t want it as a career.', careerWeights: {'media': 1}),
        QuizOption(text: 'I am more interested in the material science of it.', careerWeights: {'tech': 2}),
        QuizOption(text: 'I am interested in the retail and business side.', careerWeights: {'commerce': 3}),
      ],
    ),
    QuizQuestion(
      id: 'q19',
      question: 'Do you follow news about international politics or space?',
      options: [
        QuizOption(text: 'Yes, I follow international relations closely.', careerWeights: {'law': 3}),
        QuizOption(text: 'I follow space exploration and tech news.', careerWeights: {'tech': 3}),
        QuizOption(text: 'I follow health and wellness breakthroughs.', careerWeights: {'medicine': 3}),
        QuizOption(text: 'I follow sports and entertainment news.', careerWeights: {'sports': 2, 'media': 2}),
      ],
    ),
    QuizQuestion(
      id: 'q20',
      question: 'What is your favorite type of documentary?',
      options: [
        QuizOption(text: 'True crime or legal investigations.', careerWeights: {'law': 3}),
        QuizOption(text: 'The making of a tech giant or startup.', careerWeights: {'commerce': 2, 'tech': 2}),
        QuizOption(text: 'Nature and wildlife conservation.', careerWeights: {'education': 1, 'medicine': 1}),
        QuizOption(text: 'The life of a legendary artist or musician.', careerWeights: {'arts': 3}),
      ],
    ),
  ];

  static const List<QuizQuestion> followUpQuestions = [
    QuizQuestion(
      id: 'f1',
      question: 'You selected "None of these". Are you more comfortable with people or abstract ideas?',
      options: [
        QuizOption(text: 'I love interacting with people.', careerWeights: {'education': 2, 'media': 1, 'commerce': 1}),
        QuizOption(text: 'I prefer working with ideas and concepts.', careerWeights: {'tech': 2, 'arts': 1, 'law': 1}),
      ],
    ),
    QuizQuestion(
      id: 'f2',
      question: 'Do you prefer a stable, predictable routine or a dynamic, changing one?',
      options: [
        QuizOption(text: 'Stable and predictable.', careerWeights: {'commerce': 1, 'law': 1, 'education': 1}),
        QuizOption(text: 'Dynamic and ever-changing.', careerWeights: {'media': 2, 'tech': 1, 'sports': 2}),
      ],
    ),
    QuizQuestion(
      id: 'f3',
      question: 'What is your primary goal: Helping individuals, solving systems, or personal expression?',
      options: [
        QuizOption(text: 'Helping individuals.', careerWeights: {'medicine': 2, 'education': 2}),
        QuizOption(text: 'Solving systems.', careerWeights: {'tech': 2, 'commerce': 2}),
        QuizOption(text: 'Personal expression.', careerWeights: {'arts': 3, 'media': 2}),
      ],
    ),
    QuizQuestion(
      id: 'f4',
      question: 'Are you more drawn to logic or intuition?',
      options: [
        QuizOption(text: 'Logic and facts.', careerWeights: {'tech': 2, 'law': 2, 'commerce': 1}),
        QuizOption(text: 'Intuition and feeling.', careerWeights: {'arts': 2, 'education': 1, 'medicine': 1}),
      ],
    ),
    QuizQuestion(
      id: 'f5',
      question: 'Do you value independence or teamwork more?',
      options: [
        QuizOption(text: 'Working independently.', careerWeights: {'tech': 1, 'arts': 2, 'commerce': 1}),
        QuizOption(text: 'Working in a team.', careerWeights: {'sports': 2, 'media': 2, 'education': 1}),
      ],
    ),
  ];
}
