import 'package:em_sala_mais/backend/services/user.service.dart';
import 'package:em_sala_mais/backend/services/mobile_user.service.dart';
import 'package:em_sala_mais/mobile/screens/academic_data_screen.dart';
import 'package:em_sala_mais/mobile/screens/home_screen.dart';
import 'package:em_sala_mais/mobile/screens/user_create_screen.dart';
import 'package:em_sala_mais/mobile/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/widgets/custom_tf.dart';
import '../../components/widgets/custom_btn.dart';
import '../../theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userService = UserService();
  final _mobileUserService = MobileUserService();
  final _supabase = Supabase.instance.client;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // Basic validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o email e a senha.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final session = await _userService.signIn(
        _passwordController.text.trim(),
        _emailController.text.trim(),
      );

      if (session != null && mounted) {
        final mobileUser = await _mobileUserService
            .getMobileUserByAuthId(_supabase.auth.currentUser!.id);

        if (mounted) {
          if (mobileUser == null) {
            // First login, go to academic data screen
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AcademicDataScreen()));
          } else {
            // User already linked, go to home screen
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().contains('Invalid login credentials')
                  ? 'Credenciais inválidas'
                  : 'Erro ao realizar o login')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserCreateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final bool isDesktop = width > 1024;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    double horizontalPadding;
    double logoHeight;
    double verticalSpacing;
    double cardWidth;
    double cardPadding;
    double fontSize;
    double buttonFontSize;
    double iconSize;

    if (isDesktop) {
      horizontalPadding = 0;
      logoHeight = width * 0.08;
      verticalSpacing = height * 0.03;
      cardWidth = width * 0.25;
      cardWidth = cardWidth.clamp(340.0, 420.0);
      cardPadding = 30.0;
      fontSize = 16.0 / textScaleFactor;
      buttonFontSize = 16.0 / textScaleFactor;
      iconSize = 22.0 / textScaleFactor;
    } else {
      horizontalPadding = width * 0.08;
      logoHeight = height * 0.15;
      verticalSpacing = height * 0.05;
      cardWidth = width - (horizontalPadding * 2);
      cardPadding = width * 0.06;
      fontSize = 16.0 / textScaleFactor;
      buttonFontSize = 16.0 / textScaleFactor;
      iconSize = 22.0 / textScaleFactor;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : horizontalPadding,
                vertical: verticalSpacing * 1.5,
              ),
              child: isDesktop
                  ? _buildDesktopLayout(
                      logoHeight,
                      verticalSpacing,
                      cardWidth,
                      cardPadding,
                      fontSize,
                      buttonFontSize,
                      iconSize,
                    )
                  : _buildMobileLayout(
                      height,
                      logoHeight,
                      verticalSpacing,
                      cardPadding,
                      fontSize,
                      buttonFontSize,
                      iconSize,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(
    double logoHeight,
    double verticalSpacing,
    double cardWidth,
    double cardPadding,
    double fontSize,
    double buttonFontSize,
    double iconSize,
  ) {
    return SizedBox(
      width: cardWidth,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildFormChildren(logoHeight, verticalSpacing, fontSize,
              buttonFontSize, iconSize, 48),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    double height,
    double logoHeight,
    double verticalSpacing,
    double cardPadding,
    double fontSize,
    double buttonFontSize,
    double iconSize,
  ) {
    return Padding(
      padding: EdgeInsets.all(cardPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildFormChildren(logoHeight, verticalSpacing, fontSize,
            buttonFontSize, iconSize, height * 0.055),
      ),
    );
  }

  List<Widget> _buildFormChildren(
    double logoHeight,
    double verticalSpacing,
    double fontSize,
    double buttonFontSize,
    double iconSize,
    double buttonHeight,
  ) {
    return [
      SizedBox(
        height: logoHeight,
        child: Image.asset('assets/images/emsalamais.png'),
      ),
      SizedBox(height: verticalSpacing * 1.2),
      CustomTextField(
        controller: _emailController,
        label: 'Email',
        borderColor: AppColors.ciano,
        labelColor: AppColors.ciano,
        fontSize: fontSize,
        prefixIcon: Icons.email_outlined,
        iconColor: AppColors.ciano,
        iconSize: iconSize,
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: verticalSpacing * 0.8),
      CustomTextField(
        controller: _passwordController,
        label: 'Senha',
        borderColor: AppColors.ciano,
        labelColor: AppColors.ciano,
        fontSize: fontSize,
        prefixIcon: Icons.lock_outline,
        iconColor: AppColors.ciano,
        iconSize: iconSize,
        obscureText: !_isPasswordVisible,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.ciano,
            size: iconSize,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      SizedBox(height: verticalSpacing * 1.2),
      _isLoading
          ? const CircularProgressIndicator(color: AppColors.ciano)
          : CustomButton(
              text: 'Entrar',
              onPressed: _login,
              backgroundColor: AppColors.ciano,
              icon: Icons.arrow_forward_rounded,
              width: double.infinity,
              height: buttonHeight,
              fontSize: buttonFontSize,
              iconSize: iconSize,
            ),
      SizedBox(height: verticalSpacing * 0.5),
      TextButton(
        onPressed: _navigateToSignUp,
        child: Text(
          'Não tem uma conta? Cadastre-se',
          style: TextStyle(
            color: AppColors.ciano,
            fontSize: fontSize * 0.9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];
  }
}
