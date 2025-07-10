class CoreValidators {
  /// Valida un monto entre 100 y 10000, con hasta 5 dígitos enteros y 2 decimales.
  static String? validateAmount(value) {
    if (value == null || value.trim().isEmpty) {
      return 'El monto es obligatorio';
    }
    final input = value.trim();
    // Regex: de 1 a 5 dígitos, opcionalmente seguido de . o , y hasta 2 dígitos
    final moneyRegEx = RegExp(r'^\d{1,5}(?:[.,]\d{1,2})?$');
    if (!moneyRegEx.hasMatch(input)) {
      return 'Formato inválido';
    }
    final amount = double.parse(input.replaceAll(',', '.'));
    if (amount < 100) {
      return 'El monto debe ser al menos 100';
    }
    if (amount > 10000) {
      return 'El monto no puede exceder 10 000';
    }
    return null;
  }

  static String? validateEmail(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Correo es obligatorio';
    }
    final trimmed = value.trim();
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegExp.hasMatch(trimmed)) {
      return 'Correo electrónico inválido';
    }
    return null;
  }

  static String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    // if (value.length > 64) {
    //   return 'validators.password.maxLength'Args(['64']);
    // }

    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'\d');
    final special = RegExp(r'''[!@#\$&*~%^()_+=\[\]{}|\\;:"',.<>/?-]''');

    // if (!upper.hasMatch(value)) {
    //   return 'validators.password.uppercase';
    // }
    // if (!lower.hasMatch(value)) {
    //   return 'validators.password.lowercase';
    // }
    if (!digit.hasMatch(value)) {
      return 'La contraseña debe contener al menos un número';
    }
    // if (!special.hasMatch(value)) {
    //   return 'validators.password.specialChar';
    // }
    return null;
  }

  static String? validateFirstAndSecondName(value) {
    if (value == null || value.isEmpty) {
      return 'Debe ingresar al menos su nombre';
    }
    final parts = value.split(RegExp(r'\s+'));
    if (parts.length > 2) {
      return 'Solo se permiten dos nombres';
    }

    final firstError = _validateNamePart(parts[0], field: 'Primer nombre');
    if (firstError != null) return firstError;

    if (parts.length == 2) {
      final secondError = _validateNamePart(parts[1], field: 'Segundo nombre');
      if (secondError != null) return secondError;
    }

    return null;
  }

  static String? validateFirstSurname(value) {
    if (value == null || value.isEmpty) {
      return 'El primer apellido es obligatorio';
    }
    return _validateNamePart(value, field: 'Primer apellido');
  }

  static String? validateSecondSurname(value) {
    if (value == null || value.isEmpty) return null;
    return _validateNamePart(value, field: 'Segundo apellido');
  }

  static String? _validateNamePart(String part, {required String field}) {
    if (part.length < 2) {
      return 'debe tener al menos 2 caracteres';
    }
    if (part.length > 50) {
      return 'no debe superar los 50 caracteres';
    }
    final nameRegExp = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúÑñ]+$");
    if (!nameRegExp.hasMatch(part)) {
      return 'contiene caracteres inválidos';
    }
    const lowercaseExceptions = {
      'de',
      'la',
      'del',
      'los',
      'las',
      'y',
      'en',
      'al',
    };
    if (lowercaseExceptions.contains(part.toLowerCase())) {
      if (part != part.toLowerCase()) {
        return 'contiene una palabra que debe estar en minúscula: "$part"';
      }
      return null;
    }
    final first = part[0];
    if (first != first.toUpperCase()) {
      return 'debe comenzar con mayúscula';
    }
    return null;
  }

  static String? validateInstagramUrl(value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu perfil de Instagram';
    }
    final url = value;
    final pattern = RegExp(
      r'^(https?:\/\/)?(www\.)?instagram\.com\/[A-Za-z0-9._]{1,30}\/?$',
    );
    if (!pattern.hasMatch(url)) {
      return 'La URL de Instagram no es válida';
    }
    return null;
  }

  static String? validateFacebookUrl(value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu perfil de Facebook';
    }
    final url = value;
    final pattern = RegExp(
      r'^(https?:\/\/)?(www\.)?facebook\.com\/[A-Za-z0-9\.]{1,50}\/?$',
    );
    if (!pattern.hasMatch(url)) {
      return 'La URL de Facebook no es válida';
    }
    return null;
  }

  static String? validateXUrl(value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu perfil de X (antes Twitter)';
    }
    final url = value;
    final pattern = RegExp(
      r'^(https?:\/\/)?(www\.)?(x\.com|twitter\.com)\/[A-Za-z0-9_]{1,15}\/?$',
    );
    if (!pattern.hasMatch(url)) {
      return 'La URL de X (antes Twitter) no es válida';
    }
    return null;
  }

  static String? validatePhone(value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un número de teléfono';
    }
    final trimmed = value;
    final digitsOnly = trimmed.replaceAll(RegExp(r'[ \-\(\)]'), '');
    final phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegExp.hasMatch(digitsOnly)) {
      return 'El número de teléfono no es válido';
    }
    return null;
  }
}
