// lib/screens/raffle_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/enums/enums.dart';
import 'package:sorteos_app/notificaciones/snackbars.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:sorteos_app/widgets/raffle_card.dart';
import '../extensions/raffle_status_extension.dart';
import '../models/raffle.dart';
import '../models/participant.dart';
import '../providers/providers.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class RaffleDetailScreen extends ConsumerStatefulWidget {
  final String raffleId;
  final String name;
  const RaffleDetailScreen({
    required this.raffleId,
    required this.name,
    super.key,
  });

  @override
  ConsumerState<RaffleDetailScreen> createState() => _RaffleDetailScreenState();
}

class _RaffleDetailScreenState extends ConsumerState<RaffleDetailScreen> {
  bool _loading = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(
        () => _userId = prefs.getString('userId') ?? prefs.getString('phone'),
      );
    });
  }

  Future<void> _participate(Raffle r, int cnt) async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      // Llamas a tu endpoint de participación
      await api.participate(r.id, _userId!);

      // Refrescas los datos de la rifa
      await ref.refresh(raffleDetailProvider(r.id).future);

      // Navegas a la pantalla de éxito
      cnt == 0
          ? context.goNamed('transactionComplete')
          : AppSnackbar.showSnackbar(
            context,
            '¡Genial.. has aumentado tus posibilidades!',
            "Ya tienes ${cnt + 1} tickets",
            TypeSnackBar.success,
          );
    } on Exception catch (e) {
      final msg = e.toString().toLowerCase();

      // Detectar si es saldo insuficiente
      if (msg.contains('saldo insuficiente')) {
        context.pushNamed(
          'transactionError',
          extra: {'status': TxStatus.insufficientFunds, 'userId': _userId!},
        );
      } else {
        // Otro error de servidor
        context.goNamed(
          'transactionError',
          extra: {'status': TxStatus.serverError, 'userId': _userId!},
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showParticipants(List<Participant> list) {
    // 1) Construir mapas de recuento y participante único
    final Map<String, int> counts = {};
    final Map<String, Participant> uniqueMap = {};
    for (var p in list) {
      counts[p.id] = (counts[p.id] ?? 0) + 1;
      uniqueMap[p.id] = p;
    }
    final uniqueList = uniqueMap.values.toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => DraggableScrollableSheet(
            expand: false,
            builder:
                (_, ctl) => ListView.builder(
                  controller: ctl,
                  itemCount: uniqueList.length,
                  itemBuilder: (_, i) {
                    final p = uniqueList[i];
                    final cnt = counts[p.id]!;
                    final isMe = p.id == _userId;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        isMe ? Icons.person : Icons.person_outline,
                        color: isMe ? Colors.blue : null,
                        size: 20,
                      ),
                      title: Text(
                        p.nickname,
                        style: TextStyle(
                          fontWeight:
                              isMe ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        isMe
                            ? 'Tienes $cnt tickets'
                            : '${maskPhone(p.phone)}${cnt > 1 ? '  ($cnt)' : ''}',
                      ),
                    );
                  },
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncR = ref.watch(raffleDetailProvider(widget.raffleId));
    final userAsync =
        _userId == null
            ? const AsyncValue.data(null)
            : ref.watch(userProvider(_userId!));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: MaterialTheme.whiteColor),
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            // Give the title an Expanded so it can shrink and show “...” if too long
            Expanded(
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  color: MaterialTheme.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        color: MaterialTheme.whiteColor,
        height: double.infinity,
        child: asyncR.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (r) {
            final condicion = r.itemCondition;
            final status = r.status;
            final ext = status;
            final participants = r.participants;
            final remaining =
                r.drawDate != null
                    ? r.drawDate!.difference(DateTime.now().toLocal())
                    : Duration.zero;

            return !_loading
                ? Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                      bottom: 0,
                      left: 16,
                      right: 16,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- BLOQUE 1: IMAGEN + TÍTULO
                          if (r.imageUrl != '')
                            SizedBox(
                              width: 56.w,
                              height: 300.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Stack(
                                  children: [
                                    // 1) Imagen de fondo a cubrir todo el espacio
                                    Positioned.fill(
                                      child:
                                          r.imageUrl != ''
                                              ? CachedNetworkImage(
                                                cacheManager: CacheManager(
                                                  Config(
                                                    'customCacheKey',
                                                    stalePeriod: const Duration(
                                                      days: 31,
                                                    ),
                                                    maxNrOfCacheObjects: 100,
                                                  ),
                                                ),
                                                imageUrl: r.imageUrl!,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    (context, url) => Container(
                                                      color:
                                                          MaterialTheme
                                                              .whiteColor,
                                                      child: Center(
                                                        child: Image.asset(
                                                          'assets/images/placeholder.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                          color: MaterialTheme
                                                              .greenColor
                                                              .withValues(
                                                                alpha: 0.15,
                                                              ),
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color:
                                                                MaterialTheme
                                                                    .greenColor,
                                                            size: 32.w,
                                                          ),
                                                        ),
                                              )
                                              : Container(
                                                color: MaterialTheme.greenColor,
                                                child: Icon(
                                                  Icons.card_giftcard,
                                                  size: 32.w,
                                                  color:
                                                      MaterialTheme.greenColor,
                                                ),
                                              ),
                                    ),
                                    // 2) Texto en la parte inferior, sobre una franja semitransparente
                                    if ((r.description ?? '').isNotEmpty)
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          color: MaterialTheme.greenColor
                                              .withValues(alpha: .8),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          // maxLines y overflow para evitar que crezca demasiado
                                          child: Text(
                                            r.description!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ext.backgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        condicion,
                                        style: TextStyle(
                                          color: ext.textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 8.0),

                          // --- BLOQUE 4: FECHA / COUNTDOWN / ESTADO
                          // dentro de tu build:
                          if (status == 'open')
                            Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 8),
                              child: CountdownDisplay(
                                target: r.drawDate!,
                                panelColor: MaterialTheme.greenColor.withValues(
                                  alpha: .9,
                                ),
                                digitColor: Colors.white,
                                labelColor: Colors.white70,
                              ),
                            ),
                          if (status == 'open')
                            Text(
                              '🎉 ¡Atento! El sorteo cierra automáticamente al llegar la fecha límite ⏰. 🏆 Los ganadores reciben un SMS y también pueden verlos aquí en la app. 📲',
                            ),
                          SizedBox(height: 8),

                          // --- BOTÓN PARTICIPAR
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // --- BLOQUE 3: ESTADÍSTICAS
                              if (status == 'open')
                                Card(
                                  color: MaterialTheme.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            r.participants.isNotEmpty
                                                ? _showParticipants(
                                                  r.participants,
                                                )
                                                : ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'No hay participantes aun 😢',
                                                    ),
                                                  ),
                                                );
                                          },
                                          child: _StatItem(
                                            icon: Icons.people,
                                            label:
                                                '${participants.length}/${r.maxParticipants}',
                                            sub: 'Participantes',
                                          ),
                                        ),
                                        _StatItem(
                                          icon: Icons.confirmation_number,
                                          label:
                                              '\$${formatCeil2(r.ticketPrice * 400)}',
                                          sub: 'Ticket',
                                        ),
                                        // _StatItem(
                                        //   icon: Icons.attach_money,
                                        //   label:
                                        //       '\$${r.itemPrice.toStringAsFixed(2)}',
                                        //   sub: 'Premio',
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),

                              Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16.0),
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon:
                                      _loading
                                          ? SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : Icon(
                                            Icons.how_to_reg,
                                            // You can also override the icon color individually if you like:
                                            // color: MaterialTheme.redColor,
                                          ),
                                  label: Text(
                                    status == 'open'
                                        ? 'Participar'
                                        : 'Ver Ganadores',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    // Text & icon color
                                    foregroundColor: MaterialTheme.greenColor,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: MaterialTheme.whiteColor,
                                    textStyle: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (status == 'open') {
                                      _participate(r, participants.length);
                                    } else {
                                      _showParticipants(r.winners);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  String maskPhone(String phone) {
    const prefixLen = 3; // “+53”
    const suffixLen = 2; // los dos últimos dígitos
    final starsCount = phone.length - prefixLen - suffixLen;
    return phone.replaceRange(
      prefixLen,
      phone.length - suffixLen,
      '*' * starsCount,
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.label, required this.sub});
  final IconData icon;
  final String label, sub;
  @override
  Widget build(BuildContext c) => Column(
    children: [
      Icon(icon, size: 28, color: MaterialTheme.greenColor),
      SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Text(sub, style: TextStyle(color: Colors.grey[600])),
    ],
  );
}

/// Un widget que muestra días, horas, minutos y segundos hasta [target]
/// con un estilo tipo “24 : 06 : 22 : 59” y etiquetas debajo.
class CountdownDisplay extends StatefulWidget {
  final DateTime target;

  /// Color de fondo de cada panel (opcional)
  final Color panelColor;

  /// Color del texto de los dígitos
  final Color digitColor;

  /// Color del texto de las etiquetas
  final Color labelColor;
  const CountdownDisplay({
    super.key,
    required this.target,
    this.panelColor = const Color(0x22000000),
    this.digitColor = Colors.white,
    this.labelColor = Colors.white70,
  });

  @override
  _CountdownDisplayState createState() => _CountdownDisplayState();
}

class _CountdownDisplayState extends State<CountdownDisplay> {
  late Timer _timer;
  Duration _diff = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateDiff();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDiff();
    });
  }

  void _updateDiff() {
    final now = DateTime.now();
    setState(() {
      _diff = widget.target.difference(now);
      if (_diff.isNegative) _diff = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final days = _diff.inDays;
    final hours = _diff.inHours % 24;
    final minutes = _diff.inMinutes % 60;
    final seconds = _diff.inSeconds % 60;

    Widget buildPanel(String value, String label) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: widget.panelColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _twoDigits(int.parse(value)),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.digitColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: widget.labelColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildPanel(days.toString(), 'Days'),
        buildPanel(hours.toString(), 'Hours'),
        buildPanel(minutes.toString(), 'Minutes'),
        buildPanel(seconds.toString(), 'Seconds'),
      ],
    );
  }
}
