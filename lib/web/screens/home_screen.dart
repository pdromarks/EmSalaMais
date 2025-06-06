import 'package:em_sala_mais/web/screens/room_allocation_crud_screen.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'bloco_crud_screen.dart';
import 'room_crud_screen.dart';
import 'teacher_crud_screen.dart';
import 'subject_crud_screen.dart';
import 'course_crud_screen.dart';
import 'group_crud_screen.dart';
import 'schedule_crud_screen.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Widget screen;

  MenuItem({required this.title, required this.icon, required this.screen});
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
      title: 'Blocos',
      icon: Icons.apartment,
      screen: const BlocoCrudScreen(),
    ),
    MenuItem(
      title: 'Salas',
      icon: Icons.meeting_room,
      screen: const RoomCrudScreen(),
    ),
    MenuItem(
      title: 'Cursos',
      icon: Icons.school,
      screen: const CourseCrudScreen(),
    ),
    MenuItem(
      title: 'Disciplinas',
      icon: Icons.book,
      screen: const SubjectCrudScreen(),
    ),
    MenuItem(
      title: 'Professores',
      icon: Icons.person,
      screen: const TeacherCrudScreen(),
    ),
    MenuItem(
      title: 'Turmas',
      icon: Icons.groups,
      screen: const GroupCrudScreen(),
    ),
    MenuItem(
      title: 'Horários',
      icon: Icons.schedule,
      screen: const ScheduleCrudScreen(),
    ),
    MenuItem(
      title: 'Ensalamento',
      icon: Icons.schedule,
      screen: const RoomAllocationCrudScreen(),
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
          builder:
              (context) => Row(
                children: [
                  if (!isDesktop)
                    IconButton(
                      icon: const Icon(Icons.menu, color: AppColors.verdeUNICV),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  SizedBox(width: 10),
                  Image.asset('assets/images/LogoUNICV.png', height: 45),
                  const SizedBox(width: 10),
                ],
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.verdeUNICV,
            ),
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
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
            title: const Text('Sair', style: TextStyle(color: Colors.grey)),
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
