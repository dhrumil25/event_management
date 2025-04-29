import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:event_booking_app/pages/booking.dart';
import 'package:event_booking_app/pages/UserHome.dart';
import 'package:event_booking_app/pages/profile.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    UserHome(),
    Booking(),
    UserProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.black,
          height: 60,
          animationDuration: Duration(milliseconds: 500),
          items:const [
            Icon(Icons.home_outlined,color: Colors.white,size: 25,),
            Icon(Icons.book,color: Colors.white,size: 25,),
            Icon(Icons.person_outline,color: Colors.white,size: 25,),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          index: _currentIndex,
        ),
    );
  }
}
