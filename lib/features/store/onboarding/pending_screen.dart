import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/store.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/kafza_logo.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

/// S4: the Home tab until Kafza approves the store (STR-04/06). Pending: what she can do now
/// and what unlocks later. Rejected: the reason and Resubmit. Approval comes from the demo panel.
class PendingScreen extends ConsumerWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final store = ref.watch(currentStoreProvider)!;
    final rejected = store.status == StoreStatus.rejected;

    Widget line(IconData icon, String label, {bool locked = false}) => Padding(
      padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: KafzaSpacing.md,
        children: [
          Icon(icon, size: 20, color: locked ? scheme.onSurfaceVariant : scheme.primary),
          Expanded(child: Text(label, style: text.bodyLarge)),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const KafzaLogo()),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Icon(
              rejected ? IconsaxPlusLinear.danger : IconsaxPlusLinear.timer_1,
              size: 48,
              color: rejected ? scheme.error : scheme.primary,
            ),
          ),
          const SizedBox(height: KafzaSpacing.lg),
          Text(rejected ? l10n.rejectedTitle : l10n.pendingTitle, style: text.titleLarge),
          const SizedBox(height: KafzaSpacing.xs),
          Text(
            rejected ? l10n.rejectedBody : l10n.pendingBody,
            style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
          ),
          if (rejected) ...[
            const SizedBox(height: KafzaSpacing.lg),
            Container(
              padding: const EdgeInsets.all(KafzaSpacing.lg),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(KafzaRadius.input),
              ),
              child: Text(l10n.rejectedReason, style: text.bodyMedium),
            ),
          ] else ...[
            const SizedBox(height: KafzaSpacing.xl),
            Text(l10n.pendingCanDo, style: text.titleMedium),
            line(IconsaxPlusLinear.tick_circle, l10n.pendingCanProfile),
            line(IconsaxPlusLinear.tick_circle, l10n.pendingCanProducts),
            const SizedBox(height: KafzaSpacing.xl),
            Text(l10n.pendingLocked, style: text.titleMedium),
            line(IconsaxPlusLinear.lock, l10n.pendingLockedPublish, locked: true),
            line(IconsaxPlusLinear.lock, l10n.pendingLockedOrders, locked: true),
          ],
        ],
      ),
      bottomNavigationBar: BottomBar(
        children: rejected
            ? [FilledButton(onPressed: () => context.push('/verify'), child: Text(l10n.resubmit))]
            : [
                FilledButton(onPressed: () => context.push('/editor'), child: Text(l10n.addProduct)),
                OutlinedButton(onPressed: () => context.push('/profile'), child: Text(l10n.setUpStore)),
              ],
      ),
    );
  }
}
