import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/contact_check.dart';
import '../../../core/data/seed.dart';
import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/kafza_button.dart';
import '../../../core/widgets/kafza_text_field.dart';

/// C12: FAQ + contact Kafza support (CLT-32).
class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  String? _orderId;
  String _message = '';

  /// Bumped after sending, so the text field starts empty again.
  int _sent = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final orders = ref.watch(orderEngineProvider.select((s) => s.orders.where((o) => o.clientId == demoClientId).toList()));
    final ok = _message.trim().isNotEmpty && contactCheck(_message) == null;
    final faq = [
      (l10n.faqPaymentQ, l10n.faqPaymentA),
      (l10n.faqCancelQ, l10n.faqCancelA),
      (l10n.faqDeliveryQ, l10n.faqDeliveryA),
      (l10n.faqMessageQ, l10n.faqMessageA),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.help)),
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(vertical: KafzaSpacing.lg),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg),
            child: Text(l10n.faqTitle, style: text.titleMedium),
          ),
          for (final (q, a) in faq)
            ExpansionTile(
              title: Text(q, style: text.bodyLarge),
              tilePadding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg),
              childrenPadding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              shape: const Border(),
              children: [Text(a, style: text.bodyMedium)],
            ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.xl, KafzaSpacing.lg, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: KafzaSpacing.md,
              children: [
                Text(l10n.contactSupport, style: text.titleMedium),
                Text(l10n.contactSupportHint, style: text.bodyMedium),
                DropdownButtonFormField<String?>(
                  key: ValueKey('order-$_sent'),
                  initialValue: _orderId,
                  isExpanded: true,
                  style: text.bodyLarge,
                  decoration: InputDecoration(labelText: l10n.supportAbout),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.supportNoOrder)),
                    for (final o in orders)
                      DropdownMenuItem(
                        value: o.id,
                        child: Text('${ltr(o.id)} · ${isolate(o.productTitle)}', overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (v) => setState(() => _orderId = v),
                ),
                KafzaTextField(
                  key: ValueKey('message-$_sent'),
                  label: l10n.supportMessage,
                  value: _message,
                  maxLength: 500,
                  maxLines: 5,
                  onChanged: (v) => setState(() => _message = v),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: KafzaButton(
            l10n.supportSend,
            onPressed: ok
                ? () async {
                    // ponytail: support tickets go nowhere; the back-office is out of scope.
                    await ref.read(fakeDelayProvider)();
                    if (!context.mounted) return;
                    setState(() {
                      _message = '';
                      _orderId = null;
                      _sent++;
                    });
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(l10n.supportSent)));
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
