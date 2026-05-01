class Env {
  static const spotifyClientId = String.fromEnvironment('SPOTIFY_CLIENT_ID');
  static const spotifyClientSecret =
      String.fromEnvironment('SPOTIFY_CLIENT_SECRET');

  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get hasSpotify =>
      spotifyClientId.isNotEmpty && spotifyClientSecret.isNotEmpty;

  static bool get hasGemini => geminiApiKey.isNotEmpty;
}

