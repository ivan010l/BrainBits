import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  // Quiz Settings
  int _questionCount = 5;
  QuizType _quizType = QuizType.multiple;
  Difficulty _difficulty = Difficulty.medium;
  String _selectedCategory = 'General Knowledge';

  // Quiz State
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;
  int _timerValue = 15;
  Timer? _timer;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  // Stats (Dummy data for now)
  int totalQuizzes = 24;
  int highestScore = 95;
  double avgScore = 82.5;

  // Getters
  int get questionCount => _questionCount;
  QuizType get quizType => _quizType;
  Difficulty get difficulty => _difficulty;
  String get selectedCategory => _selectedCategory;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isQuizFinished => _isQuizFinished;
  int get timerValue => _timerValue;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isAnswered => _isAnswered;

  // Setters for Settings
  void setQuestionCount(int count) {
    _questionCount = count;
    notifyListeners();
  }

  void setQuizType(QuizType type) {
    _quizType = type;
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Quiz Logic
  void startQuiz() {
    _questions = _generateDummyQuestions();
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizFinished = false;
    _isAnswered = false;
    _selectedAnswerIndex = null;
    startTimer();
    notifyListeners();
  }

  void startTimer() {
    _timerValue = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerValue > 0) {
        _timerValue--;
        notifyListeners();
      } else {
        submitAnswer(-1); // Timeout
      }
    });
  }

  void submitAnswer(int index) {
    if (_isAnswered) return;
    _timer?.cancel();
    _isAnswered = true;
    _selectedAnswerIndex = index;

    if (index != -1 && index == _questions[_currentQuestionIndex].options.indexOf(_questions[_currentQuestionIndex].correctAnswer)) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _isAnswered = false;
      _selectedAnswerIndex = null;
      startTimer();
    } else {
      _isQuizFinished = true;
      _timer?.cancel();
      totalQuizzes++;
    }
    notifyListeners();
  }

  void resetQuiz() {
    _isQuizFinished = false;
    _currentQuestionIndex = 0;
    _score = 0;
    notifyListeners();
  }

  List<Question> _generateDummyQuestions() {
    // In a real app, this would fetch from a service based on settings
    return List.generate(_questionCount, (index) => Question(
      category: _selectedCategory,
      type: _quizType,
      difficulty: _difficulty,
      question: 'Sample Question ${index + 1} for $_selectedCategory?',
      correctAnswer: 'Option A',
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
