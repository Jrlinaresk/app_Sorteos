// lib/screens/confirm_transfer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sorteos_app/enums/enums.dart';
import 'package:sorteos_app/models/transferencia/create_transaction.dto.dart';
import 'package:sorteos_app/providers/providers.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:uuid/uuid.dart';

class ConfirmTransferScreen extends ConsumerStatefulWidget {
  final String methodName, svgAsset, account, userId;
  final double rate, fee, minAmount, amountUsd;

  const ConfirmTransferScreen({
    super.key,
    required this.userId,
    required this.methodName,
    required this.svgAsset,
    required this.account,
    required this.rate,
    required this.fee,
    required this.minAmount,
    required this.amountUsd,
  });

  @override
  ConsumerState<ConfirmTransferScreen> createState() =>
      _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends ConsumerState<ConfirmTransferScreen> {
  final _codeController = TextEditingController();
  bool _sending = false, _completed = false;
  String? _error, _operationId;

  @override
  void initState() {
    super.initState();
    // pre‑generamos el ID pero no lo mostramos hasta confirmar
    final now = DateTime.now();
    final date =
        "${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    final suffix = const Uuid().v4().substring(0, 4).toUpperCase();
    _operationId = "T$date-$suffix";
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'Por favor ingresa el código recibido');
      return;
    }
    setState(() {
      _error = null;
      _sending = true;
    });

    // DTO con todos los campos
    final dto = CreateTransactionDto(
      userId: widget.userId,
      amountUsd: widget.amountUsd,
      paymentMethod: widget.methodName,
      account: widget.account,
      rate: widget.rate,
      fee: widget.fee,
      description: 'Depósito vía ${widget.methodName}',
      confirmationCode: code,
      typeOperation: TxType.deposit.name,
    );
    try {
      // Aquí obtienes el Future de la creación
      final tx = await ref.read(createTransactionProvider(dto).future);
      // si llega aquí, fue exitoso
      setState(() {
        _completed = true;
        _sending = false;
      });
    } catch (e) {
      // si hay error, lo capturas aquí
      setState(() {
        _error = e.toString();
        _sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final netRate = widget.rate * (1 - widget.fee / 100);
    // ── Detalles de Fee / Tasa / Equivalente ──
    final cupReceived = widget.amountUsd * netRate;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 16,
                  top: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ─── Top Bar ───────────────────────────────
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 12.h,
                        bottom: 0.h,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => context.pop(),
                            child: Icon(Icons.arrow_back, size: 28.w),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () => context.goNamed('home'),
                            child: Icon(Icons.close, size: 28.w),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ─── Contenido Principal ───────────────────
                    SvgPicture.asset(
                      widget.svgAsset,
                      width: 128.w,
                      height: 128.w,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      widget.methodName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Lógica de transformación
                            String toCopy = widget.account;
                            if (widget.account.startsWith('+53')) {
                              // ETECSA: quitamos "+53"
                              toCopy = widget.account.substring(3);
                            } else if (widget.account.contains('-')) {
                              // Bank CUP/MLC: quitamos guiones
                              toCopy = widget.account.replaceAll('-', '');
                            }
                            // Zelle (u otros): queda tal cual

                            // Copiar al portapapeles
                            Clipboard.setData(ClipboardData(text: toCopy));
                          },
                          child: Text(
                            widget.account,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.h),
                    Text(
                      'Depositar',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${widget.amountUsd.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Solo mostramos el fee si no es 0
                        if (widget.fee > 0)
                          Text(
                            'Fee: ${widget.fee.toStringAsFixed(0)} %',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                        // Si no es Bank CUP mostramos la tasa neta
                        if (widget.methodName != 'Bank CUP')
                          Padding(
                            padding: EdgeInsets.only(
                              top: widget.fee > 0 ? 4.h : 0,
                            ),
                            child: Text(
                              'Tasa neta: ${netRate.toStringAsFixed(2)} CUP/USD',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),

                        // Siempre mostramos cuánto recibirá en CUP
                        Padding(
                          padding: EdgeInsets.only(
                            top:
                                (widget.fee > 0 ||
                                        widget.methodName != 'Bank CUP')
                                    ? 4.h
                                    : 0,
                          ),
                          child: Text(
                            'Recibirás: ${cupReceived.toStringAsFixed(2)} CUP',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: MaterialTheme.greenColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ─── Si no está completado, pido código ───
            if (!_completed) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: SizedBox(
                  width: 196.w,
                  child: TextField(
                    textAlign: TextAlign.start,
                    controller: _codeController,
                    decoration: InputDecoration(
                      hintText: 'Código de confirmación',
                      errorText: _error,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ),
              if (_error != null) SizedBox(height: 8.h),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: ElevatedButton(
                  onPressed: _sending ? null : _submitCode,
                  child:
                      _sending
                          ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text('Confirmar código'),
                  style: ElevatedButton.styleFrom(
                    // Text & icon color
                    foregroundColor: MaterialTheme.greenColor,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    backgroundColor: MaterialTheme.whiteColor,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],

            // ─── Si ya completó, muestro estado ────────
            if (_completed) ...[
              Text(
                'ID: $_operationId',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: ElevatedButton.icon(
                  onPressed: () => context.goNamed('home'),
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  label: Text(
                    'Finalizado',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.1),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
