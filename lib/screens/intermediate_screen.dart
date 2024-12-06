import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntermediateScreen extends StatefulWidget {
  @override
  _IntermediateScreenState createState() => _IntermediateScreenState();
}

class _IntermediateScreenState extends State<IntermediateScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _navigateAfterDelay();
    _changeMessage();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  List<String> _getMessages() {
    return [
      "Get ready for your partner's questions...",
      "Preparing for the next round...",
      "Almost there! Your partner's turn is coming up...",
      "Switching gears for your partner's input...",
    ];
  }

  void _navigateAfterDelay() {
    Future.delayed(Duration(seconds: 8), () {
      Navigator.of(context).pop();
    });
  }

  void _changeMessage() {
    if (mounted) {
      setState(() => _messageIndex = (_messageIndex + 1) % 4);
      Future.delayed(Duration(seconds: 2), _changeMessage);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _getMessages();

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
          'Switching Partners',
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
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(30),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Color(0xFFE91C40),
                  ),
                ).animate().fadeIn(delay: 200.ms),
                SizedBox(height: 30),
                Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(3),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
                    strokeWidth: 3,
                  ),
                ).animate().fadeIn(delay: 400.ms),
                SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    messages[_messageIndex],
                    key: ValueKey<int>(_messageIndex),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E2E2E),
                      height: 1.5,
                    ),
                  ).animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
