import 'dart:convert';
import 'package:flutter/services.dart';

class TarotDataController {
  // Map to hold Major Arcana interpretations
  late Map<String, String> majorArcanaWealth;
  late Map<String, String> majorArcanaHealth;
  late Map<String, String> majorArcanaLove;
  late Map<String, String> majorArcanaCareer;

  // Map to hold Major Arcana names
  late Map<String, String> majorArcanaNames;

  // List of suits for Minor Arcana
  final List<String> suits = ["Wands", "Cups", "Swords", "Pentacles"];

  // Initialization function
  Future<void> initialize() async {
    // Load JSON files
    final wealthData = await _loadJsonFile('assets/tarot_data/major_arcana_wealth.json');
    final healthData = await _loadJsonFile('assets/tarot_data/major_arcana_health.json');
    final loveData = await _loadJsonFile('assets/tarot_data/major_arcana_love.json');
    final careerData = await _loadJsonFile('assets/tarot_data/major_arcana_career.json');
    final namesData = await _loadJsonFile('assets/tarot_data/major_arcana_names.json');

    // Populate maps
    majorArcanaWealth = Map<String, String>.from(wealthData);
    majorArcanaHealth = Map<String, String>.from(healthData);
    majorArcanaLove = Map<String, String>.from(loveData);
    majorArcanaCareer = Map<String, String>.from(careerData);
    majorArcanaNames = Map<String, String>.from(namesData);
  }

  // Function to load a JSON file
  Future<Map<String, dynamic>> _loadJsonFile(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }

  // Get Major Arcana interpretation (4 functions)
  String getWealthInterpretation(String cardIndex) {
    return majorArcanaWealth[cardIndex] ?? "Unknown description.";
  }

  String getHealthInterpretation(String cardIndex) {
    return majorArcanaHealth[cardIndex] ?? "Unknown description.";
  }

  String getLoveInterpretation(String cardIndex) {
    return majorArcanaLove[cardIndex] ?? "Unknown description.";
  }

  String getCareerInterpretation(String cardIndex) {
    return majorArcanaCareer[cardIndex] ?? "Unknown description.";
  }

  // Get Major Arcana card name
  String getMajorArcanaName(String cardIndex) {
    return majorArcanaNames[cardIndex] ?? "Unknown card";
  }

  // Get Minor Arcana card name
  String getMinorArcanaName(String suit, int cardIndex) {
    final List<String> minorArcanaNames = [
      "Ace",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Page",
      "Knight",
      "Queen",
      "King"
    ];

    if (cardIndex < 1 || cardIndex > 14 || !suits.contains(suit)) {
      return "Invalid card";
    }

    return "${minorArcanaNames[cardIndex - 1]} of $suit";
  }
}