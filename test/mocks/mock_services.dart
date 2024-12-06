import 'package:soul_plan/models/questionnaire.dart';
import 'package:soul_plan/services/gemini_service.dart';
import 'package:soul_plan/services/foursquare_service.dart';

class MockGeminiService extends GeminiService {
  @override
  Future<String?> regenerateDescription(String suggestion, String language) async {
    return 'Mock description';
  }

  @override
  Future<List<String>> getDateSuggestions(
      Questionnaire user,
      Questionnaire partner, {
        required String language,
      }) async {
    return ['Mock date suggestion 1', 'Mock date suggestion 2'];
  }

  @override
  Future<String> getAtHomeDateAdvice(String suggestion, String language) async {
    return 'Mock at-home advice';
  }

  @override
  Future<Map<String, dynamic>> analyzeSentiment(Questionnaire questionnaire) async {
    return {
      'overallMood': 'positive',
      'dominantEmotions': ['happy'],
      'notablePatterns': ['excited'],
      'positivityScore': 8
    };
  }
}

class MockFoursquareService extends FoursquareService {
  @override
  Future<List<Map<String, dynamic>>> getPlaces(String destination) async {
    return [
      {
        'name': 'Mock Place',
        'description': 'Mock Description',
        'address': 'Mock Address',
        'category': 'Mock Category',
        'rating': 4.5,
        'imageUrl': 'mock_url'
      }
    ];
  }

  @override
  Future<List<String>> getImageUrls(String destination, int count) async {
    return ['mock_url_1', 'mock_url_2'];
  }
}
