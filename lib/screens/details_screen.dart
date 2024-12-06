import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_plan/screens/places_screen.dart';
import 'package:soul_plan/services/city_autocomplete_service.dart';
import 'package:soul_plan/services/date_idea_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DetailsScreen extends StatefulWidget {
  final String suggestion;
  const DetailsScreen({Key? key, required this.suggestion}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String? selectedPriceRange;
  TextEditingController cityController = TextEditingController();
  final CityAutocompleteService _cityAutocompleteService = CityAutocompleteService();
  List<String> citySuggestions = [];
  final List<String> priceRanges = ['Free', '\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  bool get isPriceSensitive => DateIdeaService.isPriceSensitiveActivity(widget.suggestion);
  bool get isMuseumOrHistorical => DateIdeaService.isMuseumOrHistoricalActivity(widget.suggestion);

  String _getDateIdeaTitle(String suggestion) {
    final parts = suggestion.split('\n');
    if (parts.isNotEmpty) {
      return parts[0].replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
    }
    return "Date Idea";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2E2E2E)),
          onPressed: () => Navigator.pop(context),
        ).animate().fadeIn(delay: 200.ms),
        title: Text(
          "Customize Your Date",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateIdeaCard(),
                SizedBox(height: 30),
                if (isPriceSensitive || isMuseumOrHistorical) ...[
                  _buildSectionTitle("Select Price Range"),
                  SizedBox(height: 10),
                  _buildPriceRangeSelector(),
                ] else
                  _buildNonApplicablePriceText(),
                SizedBox(height: 30),
                _buildSectionTitle("Enter City"),
                SizedBox(height: 10),
                _buildCityAutocomplete(),
                SizedBox(height: 30),
                _buildFindPlacesButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDateIdeaCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Date Idea",
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          SizedBox(height: 12),
          Text(
            _getDateIdeaTitle(widget.suggestion),
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Color(0xFF2E2E2E),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY();
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E2E2E),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY();
  }

  Widget _buildNonApplicablePriceText() {
    return Text(
      "Price range not applicable for this activity",
      style: GoogleFonts.lato(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: Color(0xFF2E2E2E).withOpacity(0.7),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }
  Widget _buildPriceRangeSelector() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: priceRanges.map((range) {
        final isSelected = selectedPriceRange == range;
        return _buildPriceButton(
          text: range,
          isSelected: isSelected,
          onPressed: () {
            setState(() {
              selectedPriceRange = isSelected ? null : range;
            });
          },
        );
      }).toList(),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildPriceButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFE91C40) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Color(0xFFE91C40) : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Color(0xFF2E2E2E),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCityAutocomplete() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.length < 3) {
            return const Iterable<String>.empty();
          }
          return _getCitySuggestions(textEditingValue.text);
        },
        onSelected: (String selection) {
          cityController.text = selection;
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          cityController = controller;
          return TextField(
            controller: controller,
            focusNode: focusNode,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Color(0xFF2E2E2E),
            ),
            decoration: InputDecoration(
              hintText: "e.g., New York",
              hintStyle: GoogleFonts.lato(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              prefixIcon: Icon(Icons.location_city, color: Color(0xFFE91C40)),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildFindPlacesButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Color(0xFFE91C40),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE91C40).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _onFindPlacesPressed,
          child: Center(
            child: Text(
              "Find Perfect Places",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  void _onFindPlacesPressed() {
    if ((isPriceSensitive || isMuseumOrHistorical) && selectedPriceRange != null && cityController.text.isNotEmpty) {
      _navigateToPlacesScreen();
    } else if (!isPriceSensitive && !isMuseumOrHistorical && cityController.text.isNotEmpty) {
      _navigateToPlacesScreen(priceRange: 'Any');
    } else {
      _showErrorSnackBar();
    }
  }

  void _navigateToPlacesScreen({String? priceRange}) {
    List<String> dateCategories = DateIdeaService.categorizeDateIdea(widget.suggestion);
    String dateCategory = dateCategories.isNotEmpty ? dateCategories.first : 'other';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacesScreen(
          suggestion: widget.suggestion,
          priceRange: priceRange ?? selectedPriceRange!,
          city: cityController.text,
          dateCategory: dateCategory,
        ),
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Please select a price range (if applicable) and enter a city",
          style: GoogleFonts.lato(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }

  Future<Iterable<String>> _getCitySuggestions(String input) async {
    try {
      return await _cityAutocompleteService.getCitySuggestions(input);
    } catch (e) {
      print('Error getting city suggestions: $e');
      return [];
    }
  }
}
