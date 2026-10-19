import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/order.dart';
import '../../../core/models/store.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_button.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

/// "•••• 7842": the CCP account, masked.
String _masked(String ccp) => ltr('•••• ${ccp.substring(ccp.length - 4)}');

/// S10: available, on hold, per-order breakdown, withdraw, withdrawal history (STR-33…35).
class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final store = ref.watch(currentStoreProvider)!;
    final state = ref.watch(orderEngineProvider);
    final mine = state.orders.where((o) => o.storeId == store.id).toList();
    final onHold = mine.where((o) => o.money == Money.held).fold(0, (s, o) => s + o.earnings);
    final paid = mine.where((o) => o.money == Money.paid).toList();
    final withdrawals = state.withdrawals.where((w) => w.storeId == store.id).toList();
    final canWithdraw = store.ccp.isNotEmpty && store.balance >= minWithdrawal;

    Widget heading(String title) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl, bottom: KafzaSpacing.sm),
          child: Text(title, style: text.titleMedium),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabEarnings)),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          Text(l10n.availableBalance, style: text.bodyMedium),
          Text(formatPrice(context, store.balance), style: text.headlineMedium!.copyWith(fontFeatures: tabular)),
          const SizedBox(height: KafzaSpacing.xs),
          Text(l10n.onHold(formatPrice(context, onHold)), style: text.bodyMedium),
          Text(l10n.onHoldHint, style: secondary),
          const SizedBox(height: KafzaSpacing.lg),
          if (store.ccp.isEmpty)
            InfoBanner(icon: IconsaxPlusLinear.bank, text: l10n.addCcpFirst, onTap: () => context.push('/profile'))
          else if (store.balance < minWithdrawal)
            Text(l10n.withdrawMinimum(formatPrice(context, minWithdrawal)), style: secondary)
          else
            Text(l10n.withdrawTo(_masked(store.ccp)), style: secondary),
          heading(l10n.perOrderTitle),
          if (paid.isEmpty) Text(l10n.noEarningsYet, style: secondary),
          for (final o in paid)
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsetsDirectional.only(bottom: KafzaSpacing.lg),
              shape: const Border(),
              title: Text(l10n.orderTitle(o), style: text.bodyLarge),
              subtitle: Text('${ltr(o.id)} · ${formatDateTime(l10n, o.history.last.time)}', style: secondary),
              trailing: Text(formatPrice(context, o.earnings), style: text.labelLarge!.copyWith(fontFeatures: tabular)),
              children: [EarningsBreakdown(o)],
            ),
          heading(l10n.withdrawalsTitle),
          if (withdrawals.isEmpty) Text(l10n.noWithdrawals, style: secondary),
          for (final w in withdrawals)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(formatPrice(context, w.amount), style: text.bodyLarge!.copyWith(fontFeatures: tabular)),
              subtitle: Text(formatDateTime(l10n, w.time), style: secondary),
              trailing: switch (w.status) {
                WithdrawalStatus.requested => KafzaBadge(l10n.withdrawalRequested),
                WithdrawalStatus.sent => KafzaBadge(l10n.withdrawalSent, tone: BadgeTone.success, icon: IconsaxPlusBold.tick_circle),
                WithdrawalStatus.failed => KafzaBadge(l10n.withdrawalFailed, tone: BadgeTone.warning),
              },
            ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        children: [
          FilledButton(
            onPressed: canWithdraw ? () => showKafzaSheet<void>(context, (_) => const _WithdrawSheet()) : null,
            child: Text(l10n.withdraw),
          ),
        ],
      ),
    );
  }
}

class _WithdrawSheet extends ConsumerStatefulWidget {
  const _WithdrawSheet();

  @override
  ConsumerState<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends ConsumerState<_WithdrawSheet> {
  late String _amount = '${ref.read(currentStoreProvider)!.balance}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final store = ref.watch(currentStoreProvider);
    if (store == null) return const SizedBox.shrink();
    final amount = int.tryParse(_amount) ?? 0;
    final error = amount < minWithdrawal
        ? l10n.withdrawMinimum(formatPrice(context, minWithdrawal))
        : amount > store.balance
            ? l10n.withdrawMax(formatPrice(context, store.balance))
            : null;

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: KafzaSpacing.lg,
          children: [
            Text(l10n.withdraw, style: text.titleLarge),
            Text(l10n.withdrawTo(_masked(store.ccp)), style: text.bodyMedium),
            NumberField(
              label: l10n.withdrawAmount,
              value: _amount,
              suffix: l10n.currency,
              helper: l10n.availableAmount(formatPrice(context, store.balance)),
              error: _amount.isEmpty ? null : error,
              onChanged: (v) => setState(() => _amount = v),
            ),
            KafzaButton(
              l10n.withdrawConfirm(formatPrice(context, amount)),
              onPressed: error != null
                  ? null
                  : () async {
                      try {
                        await ref.read(orderEngineProvider.notifier).withdraw(store.id, amount);
                        if (!context.mounted) return;
                        snack(context, l10n.withdrawDone(formatPrice(context, amount)));
                        Navigator.pop(context);
                      } on OrderException catch (e) {
                        if (context.mounted) snack(context, l10n.orderError(e.error));
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
