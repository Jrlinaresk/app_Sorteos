import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:sorteos_app/validators/validators.dart';
import '../../widgets/payment_method_card.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String userId;
  const PaymentScreen({super.key, required this.userId});

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
  final bool _sending = false;
  String? _amountError;
  String? _selectedSvg;
  final String _selectedMethodName = '';

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
    String svg,
    String methodName,
    double rate,
    double fee,
    double minAmount,
  ) {
    // al cambiar de método, actualizo también el error
    final text = _amountController.text.trim();
    final value = double.tryParse(text.replaceAll(',', '.'));

    setState(() {
      _selectedAccount = account;
      _selectedSvg = svg;
      _selecedMethodName = methodName;
      _selectedRate = rate;
      _selectedFee = fee;
      _selectedMin = minAmount;
      _amountError = null;

      // re-validar tras cambiar de método
      if (value != null && value < _selectedMin) {
        _amountError =
            'Con $_selecedMethodName el mínimo es \$${_selectedMin.toStringAsFixed(2)}';
      } else {
        _amountError = null;
      }
    });
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
        'rate': 2.20,
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
        title: Row(
          children: [
            // El título
            Expanded(
              child: Text(
                'Depositar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Botón de cierre
            InkWell(
              onTap: () => context.goNamed('home'),
              child: Padding(
                padding: EdgeInsets.only(right: context.canPop() ? 24.w : 16.w),
                child: Icon(Icons.close, size: 24.w, color: Colors.black54),
              ),
            ),
          ],
        ),
        titleSpacing: context.canPop() ? 0 : 16.w,
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
                String? err;

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
                          m['svg'] as String,
                          m['methodName'] as String,
                          m['rate'] as double,
                          m['fee'] as double,
                          m['minAmount'] as double,
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
                  // Text & icon color
                  foregroundColor: MaterialTheme.greenColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: MaterialTheme.whiteColor,
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  // …tu lógica de validación…
                  final amount = double.parse(
                    _amountController.text.replaceAll(',', '.'),
                  );
                  // notificar por local notification…
                  // y ahora navegamos:
                  await context.pushNamed(
                    'confirmTransfer',
                    extra: {
                      'userId': widget.userId,
                      'methodName': _selecedMethodName,
                      'svg': _selectedSvg!,
                      'account': _selectedAccount!,
                      'rate': _selectedRate!,
                      'fee': _selectedFee!,
                      'minAmount': _selectedMin,
                      'amountUsd': amount,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
