import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/contact_check.dart';
import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/kafza_text_field.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

/// S13: standing, strikes and appeals (STR-37). Suspended: products hidden, accepted orders
/// still handled as usual.
class StrikesScreen extends ConsumerWidget {
  const StrikesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final secondary = text.bodySmall!.copyWith(color: scheme.onSurfaceVariant);
    final store = ref.watch(currentStoreProvider)!;
    final strikes = ref.watch(orderEngineProvider.select((s) => s.strikes.where((x) => x.storeId == store.id).toList()));
    final now = ref.watch(clockProvider);
    final suspended = store.suspendedAt(now);
    final standing = strikes.length % strikesBeforeSuspension;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.strikesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg).aboveGestureBar(context),
        children: [
          if (suspended)
            InfoBanner(icon: IconsaxPlusLinear.forbidden_2, text: l10n.suspendedBanner(formatDateTime(l10n, store.suspendedUntil!)), warning: true)
          else ...[
            Text(l10n.strikeStanding(standing, strikesBeforeSuspension), style: text.titleMedium),
            const SizedBox(height: KafzaSpacing.sm),
            Row(
              spacing: KafzaSpacing.xs,
              children: [
                for (var i = 0; i < strikesBeforeSuspension; i++)
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: i < standing ? context.kafza.warning : context.kafza.muted,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: KafzaSpacing.md),
          Text(l10n.strikesHow, style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: KafzaSpacing.xl),
          Text(l10n.strikesListTitle, style: text.titleMedium),
          if (strikes.isEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.sm),
              child: Text(l10n.noStrikes, style: secondary),
            ),
          for (final s in strikes) ...[
            const Divider(height: KafzaSpacing.xl),
            Row(
              spacing: KafzaSpacing.sm,
              children: [
                Expanded(child: Text(l10n.orderNumber(ltr(s.orderId)), style: text.labelLarge)),
                Text(formatDateTime(l10n, s.time), style: secondary),
              ],
            ),
            Text(isolate(s.reason), style: text.bodyMedium),
            const SizedBox(height: KafzaSpacing.xs),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: s.appeal == null
                  ? OutlinedButton(
                      onPressed: () => showKafzaSheet<void>(context, (_) => _AppealSheet(s.orderId)),
                      child: Text(l10n.appeal),
                    )
                  : KafzaBadge(l10n.appealSent, icon: IconsaxPlusLinear.timer_1),
            ),
          ],
        ],
      ),
    );
  }
}

class _AppealSheet extends ConsumerStatefulWidget {
  const _AppealSheet(this.orderId);

  final String orderId;

  @override
  ConsumerState<_AppealSheet> createState() => _AppealSheetState();
}

class _AppealSheetState extends ConsumerState<_AppealSheet> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final ok = _text.trim().isNotEmpty && contactCheck(_text) == null;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: KafzaSpacing.lg,
          children: [
            Text(l10n.appealTitle, style: text.titleLarge),
            Text(l10n.appealBody, style: text.bodyMedium),
            KafzaTextField(
              label: l10n.appealText,
              value: _text,
              maxLength: 500,
              maxLines: 5,
              onChanged: (v) => setState(() => _text = v),
            ),
            // ponytail: attachments are a placeholder; the prototype has no file picker.
            Container(
              height: 72,
              decoration: BoxDecoration(color: context.kafza.muted, borderRadius: BorderRadius.circular(KafzaRadius.input)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: KafzaSpacing.sm,
                children: [
                  Icon(IconsaxPlusLinear.paperclip_2, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  Flexible(child: Text(l10n.appealAttachment, style: text.bodyMedium)),
                ],
              ),
            ),
            FilledButton(
              onPressed: ok
                  ? () {
                      try {
                        ref.read(orderEngineProvider.notifier).appealStrike(widget.orderId, _text);
                        snack(context, l10n.appealDone);
                        Navigator.pop(context);
                      } on OrderException catch (e) {
                        snack(context, l10n.orderError(e.error));
                      }
                    }
                  : null,
              child: Text(l10n.sendAppeal),
            ),
          ],
        ),
      ),
    );
  }
}
