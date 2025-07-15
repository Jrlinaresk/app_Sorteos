import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:sorteos_app/enums/enums.dart';
import 'package:sorteos_app/notificaciones/snackbars.dart';
import 'package:sorteos_app/theme/custom_scaffold.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:sorteos_app/validators/validators.dart';
import 'package:sorteos_app/widgets/custom_text_field.dart';
import 'package:sorteos_app/widgets/ok_button.dart';
import '../../models/user.dart';
import '../../providers/providers.dart';

class ProfileRegisterScreen extends ConsumerStatefulWidget {
  const ProfileRegisterScreen({super.key});
  @override
  ConsumerState<ProfileRegisterScreen> createState() =>
      _ProfileRegisterScreenState();
}

class _ProfileRegisterScreenState extends ConsumerState<ProfileRegisterScreen> {
  String? _phone;
  bool _isPermissionGranted = false;
  final _nickController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    MobileNumber.listenPhonePermission((granted) {
      setState(() => _isPermissionGranted = granted);
      if (granted) initMobileNumberState();
    });
    initMobileNumberState();
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    setState(() => _isPermissionGranted = true);
    try {
      final num = await MobileNumber.mobileNumber;
      final sims = await MobileNumber.getSimCards;
      setState(() {
        _phone = num ?? sims?.first.number;
      });
    } catch (e) {
      debugPrint("Error obteniendo número: $e");
      setState(() => _error = 'No se pudo obtener tu número');
    }
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
    });
    if (_phone == null) {
      setState(() => _error = 'Por favor, concede permiso o reinicia la app');
      return;
    }
    final nick = _nickController.text.trim();
    if (nick.isEmpty) {
      setState(() => _error = 'El nickname no puede estar vacío');
      return;
    }

    setState(() => _loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final User user = await api.createUser('+${_phone!.split("+")[1]}', nick);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.id);
      await prefs.setString('phone', user.phone);
      await prefs.setString('nickname', user.nickname);

      if (mounted) GoRouter.of(context).goNamed('home');
    } catch (e) {
      // 1) convertimos el error a string
      var message = e.toString();

      // 2) Si viene con un prefijo tipo "Exception: ", lo quitamos
      const prefix = 'Exception: ';
      if (message.startsWith(prefix)) {
        message = message.substring(prefix.length);
      }

      String msg;
      try {
        // 3) parseamos el JSON
        final data = json.decode(message);
        // 4) si viene un Map y tiene 'message', lo usamos
        if (data is Map && data['message'] is String) {
          msg = data['message'];
        } else {
          // si no, devolvemos el texto tal cual
          msg = message;
        }
      } catch (_) {
        // si no es JSON válido, devolvemos el texto completo
        msg = message;
      }

      try {
        final api = ref.read(apiServiceProvider);
        final user = await api.login('+${_phone!.split("+")[1]}', nick);
        // guardas user.id en prefs y navegas:
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.id);
        await prefs.setString('phone', user.phone);
        await prefs.setString('nickname', user.nickname);

        context.goNamed('home', extra: {'userId': user.id});
      } catch (e) {
        AppSnackbar.showSnackbar(
          context,
          '¡Algo salió mal, intenta de nuevo!',
          e.toString(),
          TypeSnackBar.error,
        );
      }

      setState(() => _error = msg);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScaffold(
      // Aquí sustituimos `child:` por un Column principal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 1) Contenido desplazable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 16,
                top: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo_white.png'),
                    radius: 128.h,
                    backgroundColor: Colors.transparent,
                  ),
                  Card(
                    color: MaterialTheme.greenColor.withValues(alpha: .1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                        bottom: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: MaterialTheme.whiteColor.withValues(
                              alpha: .8,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.start,
                              _isPermissionGranted
                                  ? (_phone != null
                                      ? '+${_phone!.split("+")[1]}'
                                      : 'Obteniendo…')
                                  : 'Permiso denegado',
                              style: TextStyle(
                                fontSize:
                                    theme.textTheme.headlineLarge!.fontSize,
                                color: MaterialTheme.whiteColor.withValues(
                                  alpha: .8,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Tu número de teléfono se ha detectado automáticamente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: theme.textTheme.bodySmall!.fontSize,
                        color: MaterialTheme.whiteColor.withValues(alpha: .8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  CustomTextField(
                    maxCaracter: 18,
                    label: 'Nombre',
                    hint: 'Nickname',
                    editable: true,
                    controller: _nickController,
                    suffixIcon: Icons.badge_outlined,
                    validators: [CoreValidators.validateFirstAndSecondName],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Es el nombre que verán los demás usuarios cuando participes en las rifas 😊',
                      style: TextStyle(
                        fontSize: theme.textTheme.bodySmall!.fontSize,
                        color: MaterialTheme.whiteColor.withValues(alpha: .8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2) Botón siempre abajo
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: [
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.white)),
                ],
                SizedBox(height: 16),
                OkButton(
                  onPressed: () {
                    _loading ? null : _submit();
                  },
                  title: 'Continuar',
                  isLoading: _loading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
