import 'package:flutter/material.dart';

class ConstructionScreen extends StatelessWidget {
  final String title;
  
  const ConstructionScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/clumsy_construction.png',
              height: 250,
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Fustat',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This screen is under construction',
              style: TextStyle(
                fontFamily: 'Fustat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
