import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../config/env.dart';

class PlaceSuggestion {
  const PlaceSuggestion({
    required this.name,
    required this.category,
    required this.whyTypical,
    required this.suggestedTimeSlot,
  });

  final String name;
  final String category;
  final String whyTypical;
  final String suggestedTimeSlot;
}

class GeminiService {
  GenerativeModel _getModel() => GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: Env.geminiApiKey,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
    ),
  );

  Future<List<PlaceSuggestion>> suggestPlaces({
    required String country,
    required String city,
    int count = 6,
  }) async {
    if (!Env.hasGemini) return const [];
    
    final prompt = '''
Return ONLY a valid JSON array (no markdown, no extra text) with $count cultural and typical suggestions to visit/eat/do in $city, $country.

Format EXACTLY as: [{"name": "...", "category": "...", "why_typical": "...", "suggested_time_slot": "..."}]

Rules:
- Return exactly $count items
- category must be ONE of: "food", "landmark", "museum", "experience", "nightlife", "nature"
- suggested_time_slot format: "HH:MM-HH:MM" (e.g., "09:00-11:00")
- name must be very short (max 3-4 words)
- why_typical must be extremely concise (max 1 short sentence, max 10 words)
- All fields are required
- Return ONLY the JSON array, nothing else
''';

    try {
      final resp = await _getModel().generateContent([Content.text(prompt)]);
      final txt = resp.text;
      
      if (txt == null || txt.isEmpty) {
        log('GeminiService: Empty response from API');
        throw Exception('Empty response from Gemini API');
      }

      log('GeminiService Raw Response: $txt'); 
      
      // Clean up markdown block or extra text if any
      String cleanTxt = txt.trim();
      final startIdxList = cleanTxt.indexOf('[');
      final startIdxObj = cleanTxt.indexOf('{');
      int startIdx = -1;
      int endIdx = -1;
      
      if (startIdxList != -1 && (startIdxObj == -1 || startIdxList < startIdxObj)) {
        startIdx = startIdxList;
        endIdx = cleanTxt.lastIndexOf(']');
      } else if (startIdxObj != -1) {
        startIdx = startIdxObj;
        endIdx = cleanTxt.lastIndexOf('}');
      }
      
      if (startIdx != -1 && endIdx != -1 && endIdx >= startIdx) {
        cleanTxt = cleanTxt.substring(startIdx, endIdx + 1);
      }

      dynamic decoded = jsonDecode(cleanTxt);
      
      // If JSON comes as an object {"places": [...]}, extract the list
      if (decoded is Map<String, dynamic>) {
        final possibleList = decoded.values.firstWhere(
          (v) => v is List, 
          orElse: () => null,
        );
        if (possibleList != null) {
          decoded = possibleList;
        }
      }

      // Verify we have a list
      if (decoded is! List) {
        log('GeminiService: Parse failed. Expected List, got ${decoded.runtimeType}');
        throw Exception('Invalid JSON structure returned by Gemini: expected a List');
      }
      
      final results = decoded
          .whereType<Map<String, dynamic>>()
          .map(
            (m) => PlaceSuggestion(
              name: (m['name'] ?? '').toString().trim(),
              category: (m['category'] ?? '').toString().trim(),
              whyTypical: (m['why_typical'] ?? '').toString().trim(),
              suggestedTimeSlot: (m['suggested_time_slot'] ?? '').toString().trim(),
            ),
          )
          .where((p) => p.name.isNotEmpty && p.category.isNotEmpty)
          .toList();
          
      if (results.isEmpty) {
         throw Exception('Parsed JSON contained no valid items.');
      }
      return results;
    } catch (e, stackTrace) {
      log('GeminiService Error: $e', error: e, stackTrace: stackTrace);
      // Throw the error so the Riverpod provider transitions to an error state
      // and the UI can show the actual error message.
      throw Exception('Falha ao gerar: $e');
    }
  }
}

final geminiServiceProvider = Provider<GeminiService>((_) => GeminiService());