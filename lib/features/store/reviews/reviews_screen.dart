import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/catalog.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/rating_stars.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

/// S12: rating per service and every review. No reply; Report sends it to Kafza (STR-36).
class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final id = ref.watch(currentStoreProvider.select((s) => s?.id));
    if (id == null) return const Scaffold();
    final state = ref.watch(orderEngineProvider);
    final reviews = state.reviews.where((r) => r.storeId == id).toList();
    final overall = state.rating(storeId: id);

    Future<void> report(String orderId) async {
      final ok = await showKafzaDialog(
        context,
        title: l10n.reportReviewTitle,
        body: l10n.reportReviewBody,
        cancel: l10n.cancel,
        confirm: l10n.reportReview,
      );
      if (!ok || !context.mounted) return;
      ref.read(orderEngineProvider.notifier).reportReview(orderId);
      snack(context, l10n.reviewReported);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewsTitle)),
      body: overall == null
          ? EmptyState(icon: IconsaxPlusLinear.star_1, title: l10n.noReviews, body: l10n.noReviewsHint)
          : ListView(
              padding: const EdgeInsets.all(KafzaSpacing.lg).aboveGestureBar(context),
              children: [
                Row(
                  spacing: KafzaSpacing.md,
                  children: [
                    Text(formatNumber(context, overall.stars, decimals: 1), style: text.headlineMedium),
                    RatingStars(overall.stars.round(), size: 20),
                    Expanded(child: Text(l10n.reviewCount(overall.count), style: secondary)),
                  ],
                ),
                const SizedBox(height: KafzaSpacing.sm),
                for (final s in Service.values)
                  if (state.rating(storeId: id, service: s) case final r?)
                    Text(l10n.serviceRating(l10n.service(s), formatNumber(context, r.stars, decimals: 1)), style: text.bodyMedium),
                const SizedBox(height: KafzaSpacing.lg),
                Text(l10n.reviewsNoReply, style: secondary),
                for (final r in reviews) ...[
                  const Divider(height: KafzaSpacing.xl),
                  Row(
                    spacing: KafzaSpacing.sm,
                    children: [
                      RatingStars(r.stars),
                      Expanded(child: Text(formatDateTime(l10n, r.time), style: secondary)),
                      if (r.reported)
                        KafzaBadge(l10n.reviewReportedBadge, tone: BadgeTone.neutral)
                      else
                        TextButton(onPressed: () => report(r.orderId), child: Text(l10n.reportReview)),
                    ],
                  ),
                  Text(
                    isolate(state.products.where((p) => p.id == r.productId).firstOrNull?.title ?? r.orderId),
                    style: text.labelLarge,
                  ),
                  if (r.comment.isNotEmpty) Text(isolate(r.comment), style: text.bodyMedium),
                ],
              ],
            ),
    );
  }
}
