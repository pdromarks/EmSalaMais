import 'package:flutter/material.dart';
import '../../components/screens/custom_form_dialog.dart';
import '../../backend/services/user.service.dart';
import '../../theme/theme.dart';

class UserCreateDialog extends StatelessWidget {
  const UserCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return CustomFormDialog(
      title: 'Criar Nova Conta',
      fields: [
        CustomFormField(
          label: 'Email',
          controller: emailController,
          icon: Icons.email_outlined,
        ),
        CustomFormField(
          label: 'Senha',
          controller: passwordController,
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        CustomFormField(
          label: 'Confirmar Senha',
          controller: confirmPasswordController,
          icon: Icons.lock_outline,
          isPassword: true,
        ),
      ],
      onSave: (Map<String, dynamic> formData) async {
        // Validate fields
        if (emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            confirmPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, preencha todos os campos.')),
          );
          return;
        }

        if (passwordController.text != confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('As senhas não coincidem.')),
          );
          return;
        }

        try {
          await UserService().signUpUser(
            passwordController.text.trim(),
            emailController.text.trim(),
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Conta criada com sucesso! Faça login para continuar.'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(); // Close dialog
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao criar conta. Tente novamente.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}
