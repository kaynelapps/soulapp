import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/anniversary_date_idea.dart';

class AnniversaryDateDetailScreen extends StatefulWidget {
  final AnniversaryDateIdea dateIdea;

  const AnniversaryDateDetailScreen({required this.dateIdea});

  @override
  _AnniversaryDateDetailScreenState createState() => _AnniversaryDateDetailScreenState();
}

class _AnniversaryDateDetailScreenState extends State<AnniversaryDateDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(),
                    _buildDescription(),
                    _buildSteps(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF2E2E2E)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.dateIdea.title,
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 300,
      width: double.infinity,
      child: Hero(
        tag: widget.dateIdea.title,
        child: Image.asset(
          widget.dateIdea.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 12),
          Text(
            widget.dateIdea.description,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Color(0xFF2E2E2E),
              height: 1.5,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Steps to Make it Special',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 16),
          ...widget.dateIdea.steps.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.favorite, size: 16, color: Colors.pink),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Color(0xFF2E2E2E),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 200 * entry.key),
            );
          }).toList(),
        ],
      ),
    );
  }
}
