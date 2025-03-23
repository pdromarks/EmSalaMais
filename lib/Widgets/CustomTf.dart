import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final Color? labelColor;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.controller,
    this.labelColor,
    this.borderColor,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Estado para controlar a visibilidade da senha

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: widget.labelColor ?? Colors.black, // Define a cor do label
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.grey, // Define a cor da borda
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.grey, // Borda quando não focado
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.teal, // Borda quando focado
            width: 2.0,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Alterna a visibilidade
                  });
                },
              )
            : null,
      ),
    );
  }
}
