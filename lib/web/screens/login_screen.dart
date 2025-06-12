import 'package:em_sala_mais/backend/services/user.service.dart';
import 'package:em_sala_mais/web/screens/home_screen.dart';
import 'package:em_sala_mais/web/screens/user_create.dart';
import 'package:flutter/material.dart';
import '../../components/widgets/custom_tf.dart';
import '../../components/widgets/custom_btn.dart';
import '../../theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userService = UserService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showUserCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => const UserCreateDialog(),
    );
  }

  void _login() async {
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().contains('Invalid login credentials')
                ? 'Credenciais inválidas'
                : 'Erro ao realizar o login'),
            backgroundColor: Colors.red,
          ),
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
    final double iconSize = ((height < width ? height : width) * 0.05).clamp(10, 20);

    final bool isDesktop = width > 800;
    final bool isTablet = width > 600 && width <= 800;
    final double regularFontSize = width * (isDesktop ? 0.015 : isTablet ? 0.02 : 0.04);
    final double buttonFontSize = width * (isDesktop ? 0.016 : isTablet ? 0.022 : 0.042);
    final double logoHeight = height * 0.25;
    final double verticalSpacing = height * 0.015;
    final double cardWidth = isDesktop ? width * 0.4 : isTablet ? width * 0.7 : width * 0.9;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: !isTablet && !isDesktop
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: logoHeight,
                            child: Image.asset('assets/images/emsalamais.png'),
                          ),
                          SizedBox(height: height * 0.04),
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            borderColor: AppColors.ciano,
                            labelColor: AppColors.ciano,
                            prefixIcon: Icons.email,
                            iconSize: iconSize,
                            iconColor: AppColors.ciano,
                            height: height * 0.065,
                            fontSize: regularFontSize,
                          ),
                          SizedBox(height: verticalSpacing),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Senha',
                            obscureText: !_isPasswordVisible,
                            borderColor: AppColors.ciano,
                            labelColor: AppColors.ciano,
                            prefixIcon: Icons.lock,
                            iconSize: iconSize,
                            iconColor: AppColors.ciano,
                            height: height * 0.065,
                            fontSize: regularFontSize,
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
                          SizedBox(height: height * 0.04),
                          _isLoading
                              ? const CircularProgressIndicator(color: AppColors.ciano)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      text: 'Criar Conta',
                                      onPressed: _showUserCreateDialog,
                                      backgroundColor: AppColors.ciano,
                                      width: width * 0.45,
                                      maxWidth: 180,
                                      height: height * 0.065,
                                      fontSize: buttonFontSize,
                                    ),
                                    SizedBox(width: width * 0.02),
                                    CustomButton(
                                      text: 'Entrar',
                                      onPressed: _login,
                                      backgroundColor: AppColors.ciano,
                                      width: width * 0.45,
                                      maxWidth: 180,
                                      height: height * 0.065,
                                      fontSize: buttonFontSize,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    )
                  : Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.all(isDesktop ? 40 : 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: logoHeight,
                            child: Image.asset('assets/images/emsalamais.png'),
                          ),
                          SizedBox(height: height * 0.04),
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            borderColor: AppColors.ciano,
                            labelColor: AppColors.ciano,
                            prefixIcon: Icons.email,
                            iconSize: iconSize,
                            iconColor: AppColors.ciano,
                            width: isDesktop ? width * 0.28 : null,
                            height: height * 0.065,
                            maxWidth: 400,
                            fontSize: regularFontSize,
                          ),
                          SizedBox(height: verticalSpacing),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Senha',
                            obscureText: !_isPasswordVisible,
                            borderColor: AppColors.ciano,
                            labelColor: AppColors.ciano,
                            prefixIcon: Icons.lock,
                            iconSize: iconSize,
                            iconColor: AppColors.ciano,
                            width: isDesktop ? width * 0.28 : null,
                            height: height * 0.065,
                            maxWidth: 400,
                            fontSize: regularFontSize,
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
                          SizedBox(height: height * 0.04),
                          _isLoading
                              ? const CircularProgressIndicator(color: AppColors.ciano)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      text: 'Entrar',
                                      onPressed: _login,
                                      backgroundColor: AppColors.ciano,
                                      width: isDesktop ? 150 : width * 0.45,
                                      maxWidth: 180,
                                      height: isDesktop ? 50 : height * 0.065,
                                      fontSize: buttonFontSize,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
