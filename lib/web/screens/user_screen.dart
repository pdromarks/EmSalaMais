import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/widgets/custom_tf.dart';
import '../../theme/theme.dart';
import './user_create.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _emailController = TextEditingController();
  final _supabase = Supabase.instance.client;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _supabase.auth.currentUser;
    if (_currentUser != null) {
      _emailController.text = _currentUser!.email ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showUserCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => const UserCreateDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final contentPadding = isSmallScreen ? 16.0 : 24.0;
    final contentWidth = isSmallScreen ? screenSize.width : 800.0;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Gerenciamento do Usuário',
          style: TextStyle(color: AppColors.verdeUNICV),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.verdeUNICV),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            tooltip: 'Sair',
            onPressed: () async {
              await _supabase.auth.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: contentWidth,
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(contentPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Meus Dados',
                                  style: TextStyle(
                                    color: AppColors.verdeUNICV,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _showUserCreateDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.verdeUNICV,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text(
                                    'Novo Usuário',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              borderColor: AppColors.verdeUNICV,
                              labelColor: AppColors.verdeUNICV,
                              prefixIcon: Icons.email_outlined,
                              iconColor: AppColors.verdeUNICV,
                              keyboardType: TextInputType.emailAddress,
                              fontSize: isSmallScreen ? 14 : 16,
                              enabled: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
