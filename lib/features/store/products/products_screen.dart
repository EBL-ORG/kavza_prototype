import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/product.dart';
import '../../../core/models/store.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/quantity_stepper.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

enum _Action { edit, pause, resume, stock, share, delete }

/// S8: the store's products with status and stock; pause/resume, stock, share, delete (STR-16…20).
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final store = ref.watch(currentStoreProvider)!;
    final products = ref.watch(orderEngineProvider.select((s) => s.products.where((p) => p.storeId == store.id).toList()));
    final banner = store.status != StoreStatus.approved
        ? InfoBanner(icon: IconsaxPlusLinear.timer_1, text: l10n.productsPendingBanner)
        : store.paused
            ? InfoBanner(icon: IconsaxPlusLinear.pause_circle, text: l10n.productsPausedBanner, warning: true)
            : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabProducts)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/editor'),
        icon: const Icon(IconsaxPlusLinear.add),
        label: Text(l10n.addProduct),
      ),
      body: products.isEmpty
          ? Column(
              children: [
                if (banner != null) Padding(padding: const EdgeInsets.all(KafzaSpacing.lg), child: banner),
                Expanded(
                  child: EmptyState(icon: IconsaxPlusLinear.box, title: l10n.noStoreProducts, body: l10n.noStoreProductsHint),
                ),
              ],
            )
          : ListView.separated(
              // Room under the last row for the FAB.
              padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.sm, bottom: 96),
              itemCount: products.length + (banner == null ? 0 : 1),
              // No rule between the banner and the first product.
              separatorBuilder: (_, i) => banner != null && i == 0
                  ? const SizedBox.shrink()
                  : const Divider(indent: KafzaSpacing.lg, endIndent: KafzaSpacing.lg),
              itemBuilder: (context, i) {
                if (banner != null && i == 0) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.sm),
                    child: banner,
                  );
                }
                return _ProductRow(products[i - (banner == null ? 0 : 1)]);
              },
            ),
    );
  }
}

class _ProductRow extends ConsumerWidget {
  const _ProductRow(this.p);

  final Product p;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final rm = p.readyMade;
    final engine = ref.read(orderEngineProvider.notifier);
    final hasPrice = rm != null || p.madeToOrder != null;

    final status = switch (p.status) {
      ProductStatus.live => KafzaBadge(l10n.productLive, tone: BadgeTone.success, icon: IconsaxPlusBold.record_circle),
      ProductStatus.paused => KafzaBadge(l10n.productPaused, tone: BadgeTone.neutral),
      ProductStatus.draft => KafzaBadge(l10n.productDraft, tone: BadgeTone.neutral, icon: IconsaxPlusLinear.edit_2),
    };
    final stock = rm == null
        ? null
        : rm.available <= 0
            ? KafzaBadge(l10n.outOfStock, tone: BadgeTone.warning)
            : rm.available <= rm.lowStockAlert
                ? KafzaBadge(l10n.lowStock(rm.available), tone: BadgeTone.warning)
                : KafzaBadge(l10n.stockCount(rm.available), tone: BadgeTone.neutral);

    Future<void> act(_Action a) async {
      try {
        switch (a) {
          case _Action.edit:
            context.push('/editor?id=${p.id}');
          case _Action.pause:
            engine.saveProduct(p.copyWith(status: ProductStatus.paused));
            snack(context, l10n.productPausedDone);
          case _Action.resume:
            engine.saveProduct(p.copyWith(status: ProductStatus.live));
            snack(context, l10n.productLiveDone);
          case _Action.stock:
            await showKafzaSheet<void>(context, (_) => _StockSheet(p.id));
          case _Action.share:
            await Clipboard.setData(ClipboardData(text: 'kafza://product/${p.id}'));
            if (context.mounted) snack(context, l10n.linkCopied);
          case _Action.delete:
            await _delete(context, ref);
        }
      } on OrderException catch (e) {
        if (context.mounted) {
          snack(context, e.error == OrderError.notAllowed ? l10n.publishLocked : l10n.orderError(e.error));
        }
      }
    }

    return InkWell(
      onTap: () => act(_Action.edit),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.md, KafzaSpacing.xs, KafzaSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: KafzaSpacing.md,
          children: [
            SizedBox.square(dimension: 56, child: InitialImage(p.title, id: p.id)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KafzaSpacing.xs,
                children: [
                  Text(
                    p.title.isEmpty ? l10n.untitledProduct : isolate(p.title),
                    style: text.bodyLarge!.copyWith(color: p.title.isEmpty ? scheme.onSurfaceVariant : null),
                  ),
                  if (hasPrice)
                    Text(
                      l10n.pricePerUnit(formatPrice(context, p.displayPrice), l10n.unit(p.unit)),
                      style: text.labelLarge!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                    ),
                  Wrap(
                    spacing: KafzaSpacing.xs,
                    runSpacing: KafzaSpacing.xs,
                    children: [
                      status,
                      ?stock,
                      if (p.madeToOrder != null) KafzaBadge(l10n.madeToOrderTitle),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<_Action>(
              tooltip: l10n.productActions,
              onSelected: act,
              itemBuilder: (_) => [
                PopupMenuItem(value: _Action.edit, child: Text(l10n.edit)),
                if (p.status == ProductStatus.live) PopupMenuItem(value: _Action.pause, child: Text(l10n.pause)),
                if (p.status == ProductStatus.paused) PopupMenuItem(value: _Action.resume, child: Text(l10n.resume)),
                if (rm != null) PopupMenuItem(value: _Action.stock, child: Text(l10n.editStock)),
                if (p.status == ProductStatus.live) PopupMenuItem(value: _Action.share, child: Text(l10n.share)),
                PopupMenuItem(
                  value: _Action.delete,
                  child: Text(l10n.delete, style: TextStyle(color: scheme.error)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final busy = ref.read(orderEngineProvider).hasOpenOrder(p.id);
    final ok = await showKafzaDialog(
      context,
      title: busy ? l10n.deleteBlockedTitle : l10n.deleteTitle,
      body: busy ? l10n.deleteBlockedBody : l10n.deleteBody,
      cancel: busy ? l10n.ok : l10n.cancel,
      confirm: busy ? null : l10n.delete,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    ref.read(orderEngineProvider.notifier).deleteProduct(p.id);
    snack(context, l10n.productDeleted);
  }
}

/// Stock for the ready-made block. Never below what waiting orders hold.
class _StockSheet extends ConsumerStatefulWidget {
  const _StockSheet(this.productId);

  final String productId;

  @override
  ConsumerState<_StockSheet> createState() => _StockSheetState();
}

class _StockSheetState extends ConsumerState<_StockSheet> {
  late int _stock = ref.read(orderEngineProvider).product(widget.productId).readyMade!.stock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final p = ref.watch(orderEngineProvider.select((s) => s.product(widget.productId)));
    final rm = p.readyMade!;
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: KafzaSpacing.lg,
        children: [
          Text(l10n.editStock, style: text.titleLarge),
          Text(isolate(p.title), style: text.bodyLarge),
          Center(
            child: QuantityStepper(
              value: _stock,
              min: rm.reserved,
              label: l10n.qty(p.unit, _stock),
              onChanged: (v) => setState(() => _stock = v.toInt()),
            ),
          ),
          Text(
            [
              if (rm.reserved > 0) l10n.stockReserved(l10n.qty(p.unit, rm.reserved)),
              l10n.stockAlertAt(l10n.qty(p.unit, rm.lowStockAlert)),
            ].join('\n'),
            textAlign: TextAlign.center,
            style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          FilledButton(
            onPressed: _stock == rm.stock
                ? null
                : () {
                    ref.read(orderEngineProvider.notifier).setStock(p.id, _stock);
                    snack(context, l10n.stockSaved);
                    Navigator.pop(context);
                  },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
