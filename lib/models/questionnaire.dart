import 'package:flutter/material.dart';

class Question {
  final String question;
  final List<String> options;

  Question({required this.question, required this.options});
}

class Questionnaire {
  int _currentQuestionIndex = 0;
  final List<String> _answers = [];
  List<Question> _questions = [];

  int get currentQuestionIndex => _currentQuestionIndex;

  List<Question> getQuestions(BuildContext context) {
    return [
      Question(
        question: "How are you feeling today?",
        options: [
          "Energized",
          "Calm",
          "Tired",
          "Stressed",
          "Excited",
          "Pensive",
          "Down",
        ],
      ),
      Question(
        question: "How was your day?",
        options: [
          "Great",
          "Good",
          "Just okay",
          "Rough",
          "Exhausting",
        ],
      ),
      Question(
        question: "What's your current energy level like?",
        options: [
          "Full of energy",
          "Pretty good",
          "Low on energy",
        ],
      ),
      Question(
        question: "What kind of vibe are you looking for in your next date?",
        options: [
          "Fun and adventurous",
          "Romantic and intimate",
          "Relaxed and casual",
          "Something new and exciting",
        ],
      ),
      Question(
        question: "Are you feeling more talkative or prefer something quieter?",
        options: [
          "Ready for good conversation",
          "Prefer something low-key",
        ],
      ),
      Question(
        question: "What would make your day better right now?",
        options: [
          "A fun activity to get me moving",
          "A quiet moment to relax and unwind",
          "Something exciting to distract me",
          "Just some good company",
        ],
      ),
    ];
  }

  double get progress =>
      _questions.isEmpty ? 0 : (_currentQuestionIndex + 1) / _questions.length;

  void initializeQuestions(BuildContext context) {
    _questions = getQuestions(context);
  }

  Question get currentQuestion => _questions[_currentQuestionIndex];

  void answerCurrentQuestion(String answer) {
    _answers.add(answer);
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    }
  }

  bool isComplete() => _currentQuestionIndex >= _questions.length;

  List<String> get answers => _answers;

  List<Question> get questions => _questions;
}
