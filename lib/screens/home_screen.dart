import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'bloco_crud_screen.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Widget screen;

  MenuItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<MenuItem> _menuItems = [
    MenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      screen: const Center(child: Text('Dashboard')), // Placeholder
    ),
    MenuItem(
      title: 'Blocos',
      icon: Icons.apartment,
      screen: const BlocoCrudScreen(),
    ),
    MenuItem(
      title: 'Salas',
      icon: Icons.meeting_room,
      screen: const Center(child: Text('Salas')), // Placeholder
    ),
    MenuItem(
      title: 'Professores',
      icon: Icons.person,
      screen: const Center(child: Text('Professores')), // Placeholder
    ),
    MenuItem(
      title: 'Disciplinas',
      icon: Icons.book,
      screen: const Center(child: Text('Disciplinas')), // Placeholder
    ),
    MenuItem(
      title: 'Horários',
      icon: Icons.schedule,
      screen: const Center(child: Text('Horários')), // Placeholder
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final bool isDesktop = width > 1024;
    final double sidebarWidth = isDesktop ? width * 0.2 : width * 0.7;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (context) => Row(
            children: [
              if (!isDesktop) 
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.verdeUNICV),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              Image.asset(
                'assets/images/emsalamais.png',
                height: 40,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.verdeUNICV),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.verdeUNICV),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
        ],
      ),
      drawer: !isDesktop ? _buildSidebar(sidebarWidth) : null,
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(sidebarWidth),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: _menuItems[_selectedIndex].screen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(double width) {
    return Container(
      width: width,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedIndex == index;
                
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected ? AppColors.verdeUNICV : Colors.grey,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? AppColors.verdeUNICV : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    if (MediaQuery.of(context).size.width <= 1024) {
                      Navigator.pop(context); // Fecha o drawer em modo mobile
                    }
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.grey),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // Implementar lógica de logout
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
