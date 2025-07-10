import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    Key? key,
    required this.methodName,
    required this.svgAsset,
    required this.accountNumber,
    required this.rate,
    required this.feePercent,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  /// Nombre legible del método (p.ej. “Zelle”, “PayPal”…)
  final String methodName;

  /// Ruta al SVG (asset o URL)
  final String svgAsset;

  /// Número de cuenta / ID
  final String accountNumber;

  /// Cuántos CUP recibe el usuario por cada 1 USD
  final double rate;

  /// Porcentaje de fee que aplica antes de conversión
  final double feePercent;

  /// Callback al pulsar la card
  final VoidCallback onTap;

  /// Si está seleccionado (para resaltar)
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // Cálculo de CUP netos por USD
    final netRate = rate * (1 - feePercent / 100);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: isSelected ? 8 : 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Logo SVG
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: SvgPicture.asset(svgAsset, fit: BoxFit.contain),
              ),
              SizedBox(width: 12.w),

              // Texto descriptivo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1) Nombre del método
                    Text(
                      methodName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // 2) Número de cuenta
                    Text(
                      accountNumber,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800],
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // 3) Detalle de la conversión
                    Text(
                      feePercent == 0
                          ? 'Recibes ${rate.toStringAsFixed(2)} CUP / \$1'
                          : 'Recibes ${netRate.toStringAsFixed(2)} CUP / \$1 después de ${feePercent.toStringAsFixed(0)} % fee',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Indicador de selección
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 24.w,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
