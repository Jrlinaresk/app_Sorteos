import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sorteos_app/extensions/raffle_status_extension.dart';
import '../models/raffle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/theme/theme.dart';

class RaffleCard extends StatelessWidget {
  const RaffleCard({Key? key, required this.raffle, required this.onTap})
    : super(key: key);

  final Raffle raffle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Color de status: verde si closed, naranja si open, gris si cancelled
    final status = raffle.status; // 'open' | 'closed' | 'cancelled'

    return Card(
      color:
          status == 'open'
              ? Colors.white
              : status.backgroundColor.withValues(alpha: .88),
      margin: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 0.w, right: 16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      elevation: 8.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // Imagen circular (si existe)
              // Dentro de Row(), sustituye este bloque:
              // Fixed-size image + placeholder + errorBuilder
              SizedBox(
                width: 56.w,
                height: 56.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      raffle.imageUrl != null
                          ? CachedNetworkImage(
                            cacheManager: CacheManager(
                              Config(
                                'customCacheKey',
                                stalePeriod: const Duration(days: 31),
                                maxNrOfCacheObjects: 100,
                              ),
                            ),
                            imageUrl: raffle.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: MaterialTheme.whiteColor,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 32.w,
                                  ),
                                ),
                          )
                          : Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.card_giftcard,
                              size: 32.w,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
              SizedBox(width: 12.w),

              // Texto principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                raffle.name.replaceFirst("Rifa ", ''),
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Card(
                              color: status.backgroundColor.withValues(
                                alpha: 1,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 2.0,
                                  bottom: 2.0,
                                ),
                                child: Text(
                                  raffle.itemCondition ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.fontSize,
                                    color: status.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 4.w),
                        Row(
                          children: [
                            Icon(
                              // Icono de la rifa
                              Icons.account_box,
                              color: status.textColor,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Interesados: ${raffle.participants.length.toString()} / ${raffle.maxParticipants.toString()}',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              // Icono de la rifa
                              Icons.confirmation_number,
                              color: status.textColor,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Participar por: \$${formatCeil2(raffle.ticketPrice * 400)}',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Status y fecha
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            color: status.backgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 2.0,
                                bottom: 2.0,
                              ),
                              child: Text(
                                status.label,
                                style: TextStyle(
                                  color: status.textColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.h),
                        if (raffle.status == 'open' &&
                            raffle.drawDate != null) ...[
                          SizedBox(height: 8.h),
                          CountdownTimer(
                            target: raffle.drawDate!,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: status.textColor),
                          ),
                        ],

                        // const Spacer(),
                        // if (raffle.drawDate != null)
                        //   Text(
                        //     '${raffle.drawDate!.day}/${raffle.drawDate!.month}/${raffle.drawDate!.year}',
                        //     style: Theme.of(context).textTheme.bodySmall,
                        //   ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flecha de navegación
              Icon(Icons.chevron_right, color: MaterialTheme.greenColor),
            ],
          ),
        ),
      ),
    );
  }
}

String formatCeil2(double value) {
  final up = (value * 100).ceil() / 100;
  return up.toStringAsFixed(2);
}

/// Widget que muestra días, horas, minutos y segundos hasta [target].
class CountdownTimer extends StatelessWidget {
  final DateTime target;
  final TextStyle? style;

  const CountdownTimer({Key? key, required this.target, this.style})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final diff = target.difference(now);

        if (diff.isNegative) {
          return Text('¡Rifa terminada!', style: style);
        }

        final days = diff.inDays;
        final hours = diff.inHours % 24;
        final minutes = diff.inMinutes % 60;
        final seconds = diff.inSeconds % 60;

        final parts = <String>[];
        if (days > 0) parts.add('${days}d');
        if (hours > 0 || days > 0) parts.add('${hours}h');
        if (minutes > 0 || hours > 0 || days > 0) parts.add('${minutes}m');
        parts.add('${seconds}s');

        return Text(
          parts.join(' '),
          style: style ?? Theme.of(context).textTheme.bodySmall,
        );
      },
    );
  }
}
