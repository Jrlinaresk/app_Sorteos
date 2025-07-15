import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorteos_app/styles/field_styles.dart';
import 'package:sorteos_app/theme/theme.dart';

/// Un TextField personalizado que muestra el texto de error
/// por fuera de la tarjeta en lugar de dentro.
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.fieldKey,
    this.label,
    this.keyboardType = TextInputType.text,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.validators,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureToggleIcon,
    this.onObscureTogglePressed,
    this.editable = true,
    this.showObscureToggle = false,
    this.onChanged,
    this.maxCaracter = 150,
    this.colorLabel = Colors.grey,
  });

  final int maxCaracter;
  final TextInputType? keyboardType;

  final Color? colorLabel;

  /// Callback que notifica cambios de texto
  final ValueChanged<String>? onChanged;

  /// Etiqueta que aparece por encima del campo (opcional)
  final String? label;

  /// Texto de hint dentro del campo
  final String hint;

  /// Controlador asociado al TextField
  final TextEditingController controller;

  /// Si el campo oculta el texto (por ej. contraseña)
  final bool obscure;

  /// Si el campo es editable
  final bool editable;

  /// Si se muestra el icono para alternar visibilidad de contraseña
  final bool showObscureToggle;

  /// Validador que devuelve un string de error o null
  final List<String? Function(dynamic)>? validators;

  /// Icono y callback a la derecha del campo
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;

  /// Icono y callback para el toggle de ocultar/mostrar contraseña
  final IconData? obscureToggleIcon;
  final VoidCallback? onObscureTogglePressed;

  final dynamic fieldKey;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode =
        FocusNode()..addListener(() {
          if (_focusNode.hasFocus) {
            // Cuando recibe foco, limpiamos el error inmediatamente
            widget.onChanged?.call(widget.controller.text);
          }
        });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: widget.fieldKey,
      initialValue: widget.controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validate,
      builder: (fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta con el TextField
            Material(
              elevation: 1,
              shadowColor: const Color.fromARGB(205, 116, 188, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              color: Colors.pinkAccent,
              child: TextFormField(
                style: TextStyle(fontSize: 24, color: Colors.white),
                keyboardType: widget.keyboardType,
                focusNode: _focusNode,
                controller: widget.controller,
                obscureText: widget.obscure,
                readOnly: !widget.editable,
                onChanged: (val) {
                  // Actualiza el estado del FormField
                  fieldState.didChange(val);
                  // Notifica al padre del cambio
                  widget.onChanged?.call(val);
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    widget.maxCaracter,
                  ), // 👈 Limita a 18 caracteres
                ],
                decoration: FieldStyles.base(
                  hint: widget.hint,
                  editable: widget.editable,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showObscureToggle &&
                          widget.obscureToggleIcon != null)
                        IconButton(
                          padding: const EdgeInsets.only(right: 16),
                          icon: Icon(
                            widget.obscureToggleIcon,
                            color: MaterialTheme.oranchColor.withValues(
                              alpha: .8,
                            ),
                          ),
                          onPressed: widget.onObscureTogglePressed,
                        ),
                      if (widget.suffixIcon != null)
                        IconButton(
                          icon: Icon(
                            widget.suffixIcon,
                            color: MaterialTheme.whiteColor,
                          ),
                          onPressed: widget.onSuffixIconPressed,
                        ),
                    ],
                  ),
                ).copyWith(errorText: null), // anulamos el error interno
              ),
            ),

            // Mensaje de error fuera de la tarjeta
            if (fieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  fieldState.errorText!,
                  style: TextStyle(
                    fontSize: 16,
                    color: MaterialTheme.whiteColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String? validate(value) {
    if (widget.validators == null) return null;
    for (final validators in widget.validators!) {
      final error = validators(value);
      if (error != null) return error;
    }
    return null;
  }
}
