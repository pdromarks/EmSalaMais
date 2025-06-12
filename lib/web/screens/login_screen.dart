import 'package:em_sala_mais/backend/services/user.service.dart';
import 'package:em_sala_mais/web/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../../components/widgets/custom_tf.dart';
import '../../components/widgets/custom_btn.dart';
import '../../../../theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final double iconSize = ((height < width ? height : width) * 0.05).clamp(
      10,
      20,
    );

    final bool isDesktop = width > 800;
    final bool isTablet = width > 600 && width <= 800;
    final double regularFontSize =
        width *
        (isDesktop
            ? 0.015
            : isTablet
            ? 0.02
            : 0.04);
    final double buttonFontSize =
        width *
        (isDesktop
            ? 0.016
            : isTablet
            ? 0.022
            : 0.042);
    final double smallFontSize =
        width *
        (isDesktop
            ? 0.012
            : isTablet
            ? 0.018
            : 0.035);
    final double logoHeight = height * 0.25;
    final double verticalSpacing = height * 0.015;
    final double cardWidth =
        isDesktop
            ? width * 0.4
            : isTablet
            ? width * 0.7
            : width * 0.9;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child:
                  !isTablet && !isDesktop
                      // Layout para Mobile
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: logoHeight,
                              child: Image.asset(
                                'assets/images/emsalamais.png',
                              ),
                            ),
                            SizedBox(height: height * 0.04),
                            CustomTextField(
                              label: 'Email',
                              borderColor: AppColors.ciano,
                              labelColor: AppColors.ciano,
                              prefixIcon: Icons.email,
                              iconSize: iconSize,
                              iconColor: AppColors.ciano,
                              height: height * 0.065,
                              fontSize: regularFontSize,
                              controller: emailController,
                            ),
                            SizedBox(height: verticalSpacing),
                            CustomTextField(
                              label: 'Senha',
                              obscureText: !_isPasswordVisible,
                              borderColor: AppColors.ciano,
                              labelColor: AppColors.ciano,
                              prefixIcon: Icons.lock,
                              iconSize: iconSize,
                              iconColor: AppColors.ciano,
                              height: height * 0.065,
                              fontSize: regularFontSize,
                              controller: passwordController,
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
                            SizedBox(height: 25),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Esqueci a minha senha',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontSize: smallFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            CustomButton(
                              text: 'Cadastrar',
                              onPressed: () async {
                                String email = emailController.text;
                                String password = passwordController.text;
                                try {
                                  var response = await UserService().signUpUser(
                                    password,
                                    email,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Conta criada com sucesso! Faça login para continuar.',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Erro ao cadastrar sua conta.',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                              backgroundColor: AppColors.ciano,
                              width: width * 0.45,
                              maxWidth: 180,
                              height: height * 0.065,
                              fontSize: buttonFontSize,
                            ),
                            SizedBox(height: height * 0.02),
                            CustomButton(
                              text: 'Entrar',
                              onPressed: () async {
                                String email = emailController.text;
                                String password = passwordController.text;
                                try {
                                  var response = await UserService().signIn(
                                    password,
                                    email,
                                  );
                                  Navigator.pushReplacementNamed(context, '/home');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Login inválido. Verifique suas credenciais.',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  print(e);
                                }
                              },
                              backgroundColor: AppColors.ciano,
                              width: width * 0.45,
                              maxWidth: 180,
                              height: height * 0.065,
                              fontSize: buttonFontSize,
                            ),
                          ],
                        ),
                      )
                      // Layout para Tablet e Desktop
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
                              child: Image.asset(
                                'assets/images/emsalamais.png',
                              ),
                            ),
                            SizedBox(height: height * 0.04),
                            CustomTextField(
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
                              controller: emailController,
                            ),
                            SizedBox(height: verticalSpacing),
                            CustomTextField(
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
                              controller: passwordController,
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
                            SizedBox(height: 25),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Esqueci a minha senha',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontSize: smallFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            CustomButton(
                              text: 'Entrar',
                              onPressed: () async {
                                String email = emailController.text;
                                String password = passwordController.text;
                                try {
                                  var response = await UserService().signIn(
                                    password,
                                    email,
                                  );
                                  Navigator.pushReplacementNamed(context, '/home');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Login inválido. Verifique suas credenciais.',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  print(e);
                                }
                              },
                              backgroundColor: AppColors.ciano,
                              width: isDesktop ? 150 : width * 0.45,
                              maxWidth: 180,
                              height: isDesktop ? 50 : height * 0.065,
                              fontSize: buttonFontSize,
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
