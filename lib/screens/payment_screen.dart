import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:sorteos_app/validators/validators.dart';

import '../widgets/payment_method_card.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _amountController = TextEditingController();
  String? _selectedAccount;
  double? _selectedRate;
  double? _selectedFee;
  double _selectedMin = 1.0;
  String _selecedMethodName = 'Bank CUP';
  bool _sending = false;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _selectedMin = 1.0;
    _selecedMethodName = 'Bank CUP';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onMethodTap(
    String account,
    double rate,
    double fee,
    double minAmount,
    String methodName,
  ) {
    // al cambiar de método, actualizo también el error
    final text = _amountController.text.trim();
    final value = double.tryParse(text.replaceAll(',', '.'));

    setState(() {
      _selectedAccount = account;
      _selectedRate = rate;
      _selectedFee = fee;
      _selectedMin = minAmount;
      _selecedMethodName = methodName;

      // re-validar tras cambiar de método
      if (value != null && value < _selectedMin) {
        _amountError =
            'Con $_selecedMethodName el mínimo es \$${_selectedMin.toStringAsFixed(2)}';
      } else {
        _amountError = null;
      }
    });
  }

  Future<void> _sendConfirmationCode() async {
    final text = _amountController.text.trim();
    final amount = double.tryParse(text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      setState(() => _amountError = 'Introduce un monto válido');
      return;
    }
    // Ahora verifico el mínimo dinámico
    if (_selectedMin != null && amount! < _selectedMin!) {
      setState(
        () =>
            _amountError =
                'Para $_selectedAccount el mínimo es \$${_selectedMin!.toStringAsFixed(2)}',
      );
      return;
    }
    setState(() {
      _amountError = null;
      _sending = true;
    });

    // Generar código aleatorio de 6 dígitos
    final code = Random().nextInt(900000) + 100000;

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Código enviado a $_selectedAccount')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Métodos de pago de ejemplo
    final methods = [
      {
        'methodName': 'Zelle',
        'svg': 'assets/svg/zelle.svg',
        'account': 'milyochavez90@gmail.com',
        'rate': 380.00,
        'fee': 5.0,
        'minAmount': 10.0,
      },
      {
        'methodName': 'Bank CUP',
        'svg': 'assets/svg/bankcup.svg',
        'account': '9204-0699-9913-0529',
        'rate': 1.00,
        'fee': 0.0,
        'minAmount': 100.0,
      },
      {
        'methodName': 'Bank MLC',
        'svg': 'assets/svg/bankmlc.svg',
        'account': '9225-9598-7173-2878',
        'rate': 240.00,
        'fee': 0.0,
        'minAmount': 5.0,
      },
      {
        'methodName': 'Saldo Mobil',
        'svg': 'assets/svg/etecsa.svg',
        'account': '+5351979128',
        'rate': 2.50,
        'fee': 3.0,
        'minAmount': 50.0,
      },
    ];

    // Si tenemos método y monto, calculamos CUP netos
    double? netCUP;
    final amt = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amt != null && _selectedRate != null && _selectedFee != null) {
      netCUP = amt * _selectedRate! * (1 - _selectedFee! / 100);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Depositar'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                // Permite solo dígitos, punto y coma
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                // Longitud máxima: 8 caracteres ('12345.67')
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: InputDecoration(
                hintText: '0.00',
                prefixIcon: const Icon(Icons.attach_money),
                errorText: _amountError,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                final sanitized = text.replaceAll(',', '.');
                final value = double.tryParse(sanitized);
                String? err = null;

                // validación de formato / longitud
                err = CoreValidators.validateAmount(text);

                // si no hay error sintáctico, compruebo mínimo
                if (err == null && value != null && value < _selectedMin) {
                  err =
                      'Para $_selectedAccount el mínimo es \$${_selectedMin.toStringAsFixed(2)}';
                }

                setState(() => _amountError = err);
              },
            ),

            // 1) Input de Monto
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '¿Cuánto dinero quieres depositar?',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: MaterialTheme.greenColor,
                ),
              ),
            ),
            // Lista de métodos
            Expanded(
              child: ListView.separated(
                itemCount: methods.length,
                separatorBuilder: (_, __) => SizedBox(height: 0.h),
                itemBuilder: (ctx, i) {
                  final m = methods[i];
                  final acct = m['account'] as String;
                  return PaymentMethodCard(
                    methodName: m['methodName'] as String,
                    svgAsset: m['svg'] as String,
                    accountNumber: acct,
                    rate: m['rate'] as double,
                    feePercent: m['fee'] as double,
                    isSelected: acct == _selectedAccount,
                    onTap:
                        () => _onMethodTap(
                          acct,
                          m['rate'] as double,
                          m['fee'] as double,
                          m['minAmount'] as double,
                          m['methodName'] as String,
                        ),
                  );
                },
              ),
            ),

            if (netCUP != null) ...[
              Center(
                child: Text(
                  'Recibirás aprox. ${netCUP.toStringAsFixed(2)} CUP',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            // Botón enviar código
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: ElevatedButton.icon(
                icon:
                    _sending
                        ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.send),
                label: Text(
                  _sending
                      ? 'Enviando...'
                      : _selectedAccount == null
                      ? 'Selecciona un método'
                      : 'Enviar código de confirmación',
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    (_selectedAccount == null ||
                            _sending ||
                            amt == null ||
                            amt <= 0)
                        ? null
                        : _sendConfirmationCode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
