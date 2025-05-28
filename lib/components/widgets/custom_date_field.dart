import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de data
import '../../theme/theme.dart'; // Para AppColors

class CustomDateField extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> onChanged;
  final TextEditingController? controller;
  final double? fontSize;
  final double? width;

  const CustomDateField({
    Key? key,
    required this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onChanged,
    this.controller,
    this.fontSize,
    this.width,
  }) : super(key: key);

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      _controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }
  }

  @override
  void didUpdateWidget(CustomDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
      if (_selectedDate != null) {
        _controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      } else {
        _controller.clear();
      }
    }
    // Se o controller externo mudar, atualizar o nosso controller interno
    if (widget.controller != null && widget.controller != _controller) {
        _controller = widget.controller!;
        // Sincronizar o texto se o controller externo já tiver um valor
        if (_controller.text.isNotEmpty) {
            try {
                _selectedDate = DateFormat('dd/MM/yyyy').parse(_controller.text);
            } catch (e) {
                // Se o formato for inválido, limpar _selectedDate
                 _selectedDate = null;
            }
        } else {
            _selectedDate = null;
        }
    } else if (widget.controller == null && _controller != widget.controller){
        // Se o controller externo for removido, manter o controller interno, mas resetar se necessário.
        // Esta lógica pode precisar de ajuste dependendo do comportamento desejado.
        // Por ora, se o initialDate for nulo e o controller também, limpamos.
        if(widget.initialDate == null) {
            _controller.clear();
            _selectedDate = null;
        }
    }
  }

  @override
  void dispose() {
    // Dispose do controller apenas se ele foi criado internamente
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.firstDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2101),
      locale: const Locale('pt', 'BR'), // Para calendário em português
      builder: (BuildContext context, Widget? child) { // Estilização do DatePicker
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.verdeUNICV, // Cor primária
              onPrimary: Colors.white, // Cor do texto sobre a cor primária
              surface: Colors.white, // Fundo dos dias
              onSurface: Colors.black, // Cor do texto dos dias
            ),
            dialogBackgroundColor: Colors.white,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
        widget.onChanged(_selectedDate);
      });
    } else if (picked == null && _controller.text.isNotEmpty && _selectedDate != null){
      // Se o usuário cancelar e já havia uma data, não limpar, mas chamar onChanged com a data atual.
      // Se o comportamento desejado for limpar ao cancelar, essa condição pode ser alterada.
      // widget.onChanged(_selectedDate); // Ou widget.onChanged(null) se for para limpar.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: AppColors.verdeUNICV,
              fontSize: widget.fontSize ?? 16,
              fontWeight: FontWeight.w700,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 0, 
              top: 8, 
              bottom: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.calendar_today,
                color: AppColors.verdeUNICV,
              ),
            ),
          ),
          child: Text(
            _controller.text,
            style: TextStyle(
              fontSize: widget.fontSize ?? 16,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
} 