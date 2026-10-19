import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../core/data/clock.dart';
import '../../core/data/seed.dart';
import '../../core/format/price.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/order.dart';
import '../../core/models/store.dart';
import '../../core/order_engine/order_engine.dart';
import '../../core/theme/kafza_theme.dart';
import '../../core/widgets/kafza_sheet.dart';

/// Opens the demo panel: it stands in for the back-office and Yassir Express.
Future<void> showDemoPanel(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 560),
      builder: (_) => const _DemoPanel(),
    );

class _DemoPanel extends ConsumerStatefulWidget {
  const _DemoPanel();

  @override
  ConsumerState<_DemoPanel> createState() => _DemoPanelState();
}

class _DemoPanelState extends ConsumerState<_DemoPanel> {
  final _balance = TextEditingController();

  @override
  void dispose() {
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final secondary = text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant);
    final state = ref.watch(orderEngineProvider);
    final engine = ref.read(orderEngineProvider.notifier);
    final now = ref.watch(clockProvider);
    final client = state.client(demoClientId);
    final courierOrders =
        state.orders.where((o) => o.status == OrderStatus.ready || o.status == OrderStatus.pickedUp).toList();
    final pendingStores = state.stores.where((s) => s.status == StoreStatus.pending).toList();

    Widget section(String title, List<Widget> children) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: KafzaSpacing.sm,
            children: [Text(title, style: text.titleMedium), ...children],
          ),
        );

    Widget row(String title, String subtitle, List<Widget> actions) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.bodyLarge),
              Text(subtitle, style: secondary),
              const SizedBox(height: KafzaSpacing.sm),
              Wrap(spacing: KafzaSpacing.sm, runSpacing: KafzaSpacing.sm, children: actions),
            ],
          ),
        );

    final destructive = TextButton.styleFrom(foregroundColor: scheme.error);
    final newBalance = int.tryParse(_balance.text);

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(
        KafzaSpacing.lg,
        0,
        KafzaSpacing.lg,
        KafzaSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.demoPanel, style: text.titleLarge),
          Text(l10n.demoPanelHint, style: secondary),

          section(l10n.demoClock, [
            Text(
              l10n.demoClockNow(DateFormat.MMMEd(l10n.localeName).add_Hm().format(now)),
              style: text.bodyLarge!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
            ),
            Wrap(
              spacing: KafzaSpacing.sm,
              runSpacing: KafzaSpacing.sm,
              children: [
                for (final (label, by) in [
                  (l10n.demoAdd15m, const Duration(minutes: 15)),
                  (l10n.demoAdd1h, const Duration(hours: 1)),
                  (l10n.demoAdd24h, const Duration(hours: 24)),
                ])
                  OutlinedButton(onPressed: () => ref.read(clockProvider.notifier).advance(by), child: Text(label)),
              ],
            ),
          ]),

          section(l10n.demoCourier, [
            if (courierOrders.isEmpty) Text(l10n.demoCourierEmpty, style: secondary),
            for (final o in courierOrders)
              row(
                '${o.id} · ${l10n.orderTitle(o)}',
                '${state.store(o.storeId).name} · ${l10n.status(o.status)}',
                o.status == OrderStatus.ready
                    ? [OutlinedButton(onPressed: () => engine.pickedUp(o.id), child: Text(l10n.statusPickedUp))]
                    : [
                        OutlinedButton(onPressed: () => engine.delivered(o.id), child: Text(l10n.statusDelivered)),
                        TextButton(
                          style: destructive,
                          onPressed: () => engine.deliveryFailed(o.id),
                          child: Text(l10n.statusDeliveryFailed),
                        ),
                      ],
              ),
          ]),

          section(l10n.demoStoreReview, [
            if (pendingStores.isEmpty) Text(l10n.demoStoreReviewEmpty, style: secondary),
            for (final s in pendingStores)
              row(s.name, s.commune, [
                OutlinedButton(
                  onPressed: () => engine.reviewStore(s.id, approve: true),
                  child: Text(l10n.demoApprove),
                ),
                TextButton(
                  style: destructive,
                  onPressed: () => engine.reviewStore(s.id, approve: false),
                  child: Text(l10n.demoReject),
                ),
              ]),
          ]),

          section(l10n.demoBalance, [
            Text(l10n.demoBalanceNow(isolate(client.name), formatPrice(context, client.balance)), style: secondary),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: KafzaSpacing.sm,
              children: [
                Expanded(
                  child: TextField(
                    controller: _balance,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(7)],
                    decoration: InputDecoration(labelText: l10n.demoBalanceField, suffixText: l10n.currency),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: FilledButton.tonal(
                    onPressed: newBalance == null
                        ? null
                        : () {
                            engine.setBalance(demoClientId, newBalance);
                            _balance.clear();
                            setState(() {});
                          },
                    child: Text(l10n.demoBalanceSet),
                  ),
                ),
              ],
            ),
          ]),

          section(l10n.demoReset, [
            Text(l10n.demoResetHint, style: secondary),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.error,
                  side: BorderSide(color: scheme.error),
                ),
                icon: const Icon(IconsaxPlusLinear.rotate_left),
                label: Text(l10n.demoReset),
                onPressed: () => _confirmReset(context, l10n),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, AppLocalizations l10n) async {
    final ok = await showKafzaDialog(
      context,
      title: l10n.demoResetConfirm,
      body: l10n.demoResetBody,
      cancel: l10n.cancel,
      confirm: l10n.demoReset,
      destructive: true,
    );
    if (ok) ref.read(orderEngineProvider.notifier).reset();
  }
}
