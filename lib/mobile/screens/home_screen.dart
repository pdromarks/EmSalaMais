import 'package:flutter/material.dart';
import '../../theme/theme.dart'; // Assuming theme.dart is in lib/theme/
import './room_allocation_screen.dart'; // Import RoomAllocationScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Placeholder for the pages to be displayed by the BottomNavigationBar
  static const List<Widget> _widgetOptions = <Widget>[
    RoomAllocationScreen(), // Navigate to RoomAllocationScreen for Home
    Text('Index 1: Search'), // Placeholder for Search screen content
    Text('Index 2: Rooms'), // Placeholder for Rooms screen content
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para responsividade
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    // final bool isDesktop = width > 1024; // Assuming we might need responsive logic later
    // final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Define sizes based on screen dimensions (can be adjusted as in AccessKeyScreen)
    double logoHeight = height * 0.05; // Adjusted for AppBar
    // double iconSize = 24.0;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1), // Match academic_data_screen
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back button if HomeScreen is not supposed to have one
        title: SizedBox(
          height: logoHeight,
          child: Image.asset(
            'assets/images/LogoUNICV.png', // Match academic_data_screen logo
            fit: BoxFit.contain,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Perfil do Usuário',
            onPressed: () {
              // TODO: Navigate to user profile screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
              print('Navigate to User Profile Screen');
            },
          ),
        ],
        backgroundColor: Colors.white, // Or AppColors.primary or similar from your theme
        elevation: 1.0, // Small shadow for the AppBar
        iconTheme: IconThemeData(color: AppColors.verdeUNICV), // Match academic_data_screen color
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_outlined),
            activeIcon: Icon(Icons.meeting_room),
            label: 'Rooms',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.verdeUNICV, // Match academic_data_screen color
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        elevation: 5.0, // Shadow for the BottomNavigationBar
      ),
    );
  }
}
