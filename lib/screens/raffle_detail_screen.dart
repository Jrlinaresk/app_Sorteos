// lib/screens/raffle_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/theme/theme.dart';
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

  Future<void> _participate(Raffle r) async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.participate(r.id, _userId!);
      await ref.refresh(raffleDetailProvider(r.id).future);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('¡Participación exitosa!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            // Give the title an Expanded so it can shrink and show “...” if too long
            Expanded(
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            // Then your balance widget—always returns a Widget, never null
            userAsync.when(
              data: (user) {
                if (user == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${user.balance.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading:
                  () => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
              error: (_, __) => const Icon(Icons.error, color: Colors.white),
            ),
          ],
        ),
      ),

      body: asyncR.when(
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

          return Padding(
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 2, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- BLOQUE 1: IMAGEN + TÍTULO
                  if (r.imageUrl != null)
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
                                  r.imageUrl != null
                                      ? CachedNetworkImage(
                                        imageUrl: r.imageUrl!,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              color: Colors.grey.shade200,
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
                            // 2) Texto en la parte inferior, sobre una franja semitransparente
                            if ((r.description ?? '').isNotEmpty)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- BLOQUE 3: ESTADÍSTICAS
                      if (status == 'open')
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showParticipants(r.participants);
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
                                      '\$${r.ticketPrice.toStringAsFixed(2)}',
                                  sub: 'Ticket',
                                ),
                                _StatItem(
                                  icon: Icons.attach_money,
                                  label: '\$${r.itemPrice.toStringAsFixed(2)}',
                                  sub: 'Premio',
                                ),
                              ],
                            ),
                          ),
                        ),

                      Container(
                        padding: EdgeInsets.only(top: 8),
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
                            status == 'open' ? 'Participar' : 'Ver Ganadores',
                          ),
                          style: ElevatedButton.styleFrom(
                            // Text & icon color
                            foregroundColor: MaterialTheme.greenColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (status == 'open') {
                              _participate(r);
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
          );
        },
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
    Key? key,
    required this.target,
    this.panelColor = const Color(0x22000000),
    this.digitColor = Colors.white,
    this.labelColor = Colors.white70,
  }) : super(key: key);

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

    Widget _buildPanel(String value, String label) {
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
        _buildPanel(days.toString(), 'Days'),
        _buildPanel(hours.toString(), 'Hours'),
        _buildPanel(minutes.toString(), 'Minutes'),
        _buildPanel(seconds.toString(), 'Seconds'),
      ],
    );
  }
}
