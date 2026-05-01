import 'dart:convert';

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
  GeminiService();

  GenerativeModel _model() => GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: Env.geminiApiKey,
      );

  Future<List<PlaceSuggestion>> suggestPlaces({
    required String country,
    required String city,
    int count = 6,
  }) async {
    if (!Env.hasGemini) return const [];
    final prompt = '''
Devolve APENAS JSON válido (sem markdown) com uma lista de sugestões culturais e típicas para visitar/comer/fazer em $city, $country.
Formato: [{"name": "...", "category": "...", "why_typical": "...", "suggested_time_slot": "..."}]
Regras:
- $count itens
- category deve ser uma destas: "food", "landmark", "museum", "experience", "nightlife", "nature"
- suggested_time_slot exemplo: "09:00-11:00"
''';

    final resp = await _model().generateContent([Content.text(prompt)]);
    final txt = resp.text ?? '[]';
    final decoded = jsonDecode(txt);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(
          (m) => PlaceSuggestion(
            name: (m['name'] ?? '').toString(),
            category: (m['category'] ?? '').toString(),
            whyTypical: (m['why_typical'] ?? '').toString(),
            suggestedTimeSlot: (m['suggested_time_slot'] ?? '').toString(),
          ),
        )
        .where((p) => p.name.isNotEmpty)
        .toList();
  }
}

final geminiServiceProvider = Provider<GeminiService>((_) => GeminiService());

