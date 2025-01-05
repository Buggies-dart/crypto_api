import 'package:crypto_app/Pages/home.dart';
import 'package:flutter/material.dart';



class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomePage(),
      floatingActionButton: SizedBox( height: 80, width: 75,
        child: FloatingActionButton( backgroundColor: Colors.black,
        shape: const CircleBorder(),
          onPressed: () {
  
          },
          child: const Icon(Icons.swap_horiz, color: Colors.white, size: 40,),
          
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath( 
      clipper: BottomAppBarClipper(), // Apply custom clipper here
      child:  const Material( elevation: 20, shadowColor: Colors.black,
        child: BottomAppBar( 
          color: Colors.white,
         
          child: SizedBox(
            height: 70,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.home, size: 30),
                Icon(Icons.credit_card, size: 30),
                SizedBox(width: 56), // Leave space for the FAB
                Icon(Icons.analytics, size: 30),
                Icon(Icons.account_circle, size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Clipper to create inward curve in BottomAppBar
class BottomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
  final path = Path();
  const double fabSize = 80.0; // Size of the FloatingActionButton
  const double fabMargin = 8.0; // Space between FAB and BottomAppBar
  const double fabRadius = fabSize / 2.1 + fabMargin;

  // Start from the left
  path.moveTo(0, 0);

  // Draw straight line to where the curve begins
  path.lineTo(size.width / 2 - fabRadius, 0);

  // Create the U-shaped curve
  path.quadraticBezierTo(
    size.width / 2, fabRadius * 2, // Control point (center of the U curve)
    size.width / 2 + fabRadius, 0, // End point of the U curve
  );

  // Continue drawing the line to the right edge
  path.lineTo(size.width, 0);

  // Close the path to the bottom of the container
  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}