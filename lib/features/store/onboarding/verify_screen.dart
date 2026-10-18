import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/catalog.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/kafza_button.dart';
import '../../../core/widgets/mock_camera.dart';
import '../store_providers.dart';
import '../store_widgets.dart';
import 'phone_screens.dart';

enum _Step { front, back, details, selfie }

/// S3: auto-entrepreneur card front and back, card number and activity, then a live selfie
/// (STR-02/03). [phone] is set for a new store; null resubmits the logged-in store (S4).
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key, this.phone});

  final String? phone;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  _Step _step = _Step.front;
  bool _front = false, _back = false, _selfie = false;
  String _card = '';
  Service? _activity;

  bool get _cardValid => _card.length >= 8;

  bool get _done => switch (_step) {
        _Step.front => _front,
        _Step.back => _back,
        _Step.details => _cardValid && _activity != null,
        _Step.selfie => _selfie,
      };

  Future<void> _next() async {
    if (_step != _Step.selfie) return setState(() => _step = _Step.values[_step.index + 1]);
    final name = AppLocalizations.of(context).newStoreName;
    await ref.read(fakeDelayProvider)();
    final engine = ref.read(orderEngineProvider.notifier);
    if (widget.phone case final phone?) {
      final id = engine.registerStore(
        name: name,
        phone: phone,
        cardNumber: _card,
        activity: _activity!,
      );
      ref.read(storeSessionProvider.notifier).logIn(id);
    } else {
      engine.resubmitStore(ref.read(currentStoreProvider)!.id, cardNumber: _card, activity: _activity!);
    }
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final (title, body) = switch (_step) {
      _Step.front => (l10n.cardFrontTitle, l10n.cardPhotoBody),
      _Step.back => (l10n.cardBackTitle, l10n.cardPhotoBody),
      _Step.details => (l10n.cardDetailsTitle, l10n.cardDetailsBody),
      _Step.selfie => (l10n.selfieTitle, l10n.selfieBody),
    };

    return PopScope(
      canPop: _step == _Step.front,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step = _Step.values[_step.index - 1]);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          children: [
            OnboardingHeader(step: _step == _Step.selfie ? 3 : 2, title: title, body: body),
            switch (_step) {
              _Step.front => MockCamera(
                  key: const ValueKey(_Step.front),
                  face: false,
                  captured: _front,
                  onChanged: (v) => setState(() => _front = v),
                ),
              _Step.back => MockCamera(
                  key: const ValueKey(_Step.back),
                  face: false,
                  captured: _back,
                  onChanged: (v) => setState(() => _back = v),
                ),
              _Step.details => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NumberField(
                      label: l10n.cardNumber,
                      value: _card,
                      maxLength: 20,
                      helper: l10n.cardNumberHelper,
                      error: _card.isNotEmpty && !_cardValid ? l10n.cardNumberInvalid : null,
                      onChanged: (v) => setState(() => _card = v),
                    ),
                    const SizedBox(height: KafzaSpacing.xl),
                    Text(l10n.activity, style: text.titleMedium),
                    const SizedBox(height: KafzaSpacing.sm),
                    Wrap(
                      spacing: KafzaSpacing.sm,
                      runSpacing: KafzaSpacing.sm,
                      children: [
                        for (final s in Service.values)
                          ChoiceChip(
                            label: Text(l10n.service(s)),
                            selected: _activity == s,
                            onSelected: (_) => setState(() => _activity = s),
                          ),
                      ],
                    ),
                  ],
                ),
              _Step.selfie => MockCamera(face: true, captured: _selfie, onChanged: (v) => setState(() => _selfie = v)),
            },
          ],
        ),
        bottomNavigationBar: BottomBar(
          children: [
            KafzaButton(
              _step == _Step.selfie ? l10n.sendForReview : l10n.continueLabel,
              onPressed: _done ? _next : null,
            ),
          ],
        ),
      ),
    );
  }
}
