import 'package:em_sala_mais/backend/services/user.service.dart';
import 'package:flutter/material.dart';
import '../../components/widgets/custom_tf.dart';
import '../../components/widgets/custom_btn.dart';
import '../../theme/theme.dart';

class UserCreateScreen extends StatefulWidget {
  const UserCreateScreen({super.key});

  @override
  _UserCreateScreenState createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userService = UserService();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authResponse = await _userService.signUpUser(
        _passwordController.text.trim(),
        _emailController.text.trim(),
      );

      if (authResponse != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Usuário cadastrado com sucesso! Faça o login.')),
        );
        Navigator.of(context).pop(); // Go back to login screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().contains('AuthException')
                  ? 'Erro ao cadastrar usuário.'
                  : 'Ocorreu um erro inesperado.')),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ciano),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : horizontalPadding,
                vertical: verticalSpacing,
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
      SizedBox(height: verticalSpacing * 0.8),
      CustomTextField(
        controller: _confirmPasswordController,
        label: 'Confirmar Senha',
        borderColor: AppColors.ciano,
        labelColor: AppColors.ciano,
        fontSize: fontSize,
        prefixIcon: Icons.lock_outline,
        iconColor: AppColors.ciano,
        iconSize: iconSize,
        obscureText: !_isConfirmPasswordVisible,
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.ciano,
            size: iconSize,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      SizedBox(height: verticalSpacing * 1.2),
      _isLoading
          ? const CircularProgressIndicator(color: AppColors.ciano)
          : CustomButton(
              text: 'Cadastrar',
              onPressed: _signUp,
              backgroundColor: AppColors.ciano,
              icon: Icons.person_add_alt_1_rounded,
              width: double.infinity,
              height: buttonHeight,
              fontSize: buttonFontSize,
              iconSize: iconSize,
            ),
    ];
  }
}
