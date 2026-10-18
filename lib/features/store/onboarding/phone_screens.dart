import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/kafza_button.dart';
import '../store_widgets.dart';

/// Demo OTP (brief Prompt 5).
const demoOtp = '123456';
const _resendAfter = Duration(seconds: 60);

/// "+213 5 55 12 34 56" from the 9 digits after the country code.
String formatPhone(String digits) => ltr('+213 ${digits.replaceAllMapped(RegExp(r'^(\d)(\d{2})(\d{2})(\d{2})(\d{2})$'), (m) => '${m[1]} ${m[2]} ${m[3]} ${m[4]} ${m[5]}')}');

/// Phone → Code → Card → Selfie, with the current step in primary.
class OnboardingSteps extends StatelessWidget {
  const OnboardingSteps(this.current, {super.key});

  final int current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final labels = [l10n.stepPhone, l10n.stepCode, l10n.stepCard, l10n.stepSelfie];
    return Semantics(
      label: l10n.stepOf(current + 1, labels.length, labels[current]),
      excludeSemantics: true,
      child: Row(
        spacing: KafzaSpacing.xs,
        children: [
          for (final (i, label) in labels.indexed)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KafzaSpacing.xs,
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= current ? scheme.primary : scheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: i == current ? scheme.primary : scheme.onSurfaceVariant,
                          fontWeight: i == current ? FontWeight.w600 : null,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Step indicator, title and body: the top of every onboarding page.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, required this.step, required this.title, required this.body});

  final int step;
  final String title, body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingSteps(step),
        const SizedBox(height: KafzaSpacing.xl),
        Text(title, style: text.titleLarge),
        const SizedBox(height: KafzaSpacing.xs),
        Text(body, style: text.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: KafzaSpacing.xl),
      ],
    );
  }
}

/// S2: phone number with the +213 prefix (STR-01).
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  String _phone = '';

  /// The 9 digits after +213 (a leading 0 is dropped), or null when it isn't a mobile number.
  String? get _digits {
    final d = _phone.startsWith('0') ? _phone.substring(1) : _phone;
    return RegExp(r'^[567]\d{8}$').hasMatch(d) ? d : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final digits = _digits;
    final complete = _phone.length >= (_phone.startsWith('0') ? 10 : 9);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          OnboardingHeader(step: 0, title: l10n.phoneTitle, body: l10n.phoneBody),
          NumberField(
            label: l10n.phoneLabel,
            value: _phone,
            maxLength: 10,
            autofocus: true,
            // No-break space: a plain trailing one is dropped at the edge of the slot.
            prefix: ltr('+213 '),
            helper: l10n.phoneHelper,
            error: complete && digits == null ? l10n.phoneInvalid : null,
            onChanged: (v) => setState(() => _phone = v),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        children: [
          KafzaButton(
            l10n.sendCode,
            onPressed: digits == null
                ? null
                : () async {
                    await ref.read(fakeDelayProvider)();
                    if (context.mounted) context.push('/otp', extra: digits);
                  },
          ),
        ],
      ),
    );
  }
}

/// S2: 6-digit code, demo code 123456, resend after 60 s.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phone});

  /// The 9 digits after +213.
  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  final _focus = FocusNode();
  late DateTime _sentAt = ref.read(clockProvider);
  bool _wrong = false, _checking = false;

  @override
  void dispose() {
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _check(String code) async {
    setState(() {
      _wrong = false;
      _checking = code.length == demoOtp.length;
    });
    if (!_checking) return;
    await ref.read(fakeDelayProvider)();
    if (!mounted) return;
    setState(() => _checking = false);
    if (code == demoOtp) {
      context.push('/verify', extra: widget.phone);
    } else {
      _code.clear();
      setState(() => _wrong = true);
      // The field was disabled while checking, which dropped focus and the keyboard. Refocus
      // once it is enabled again, after this rebuild.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focus.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final left = _resendAfter - ref.watch(clockProvider).difference(_sentAt);
    final code = _code.text;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          OnboardingHeader(step: 1, title: l10n.otpTitle, body: l10n.otpBody(formatPhone(widget.phone))),
          InfoBanner(icon: IconsaxPlusLinear.info_circle, text: l10n.otpDemo(ltr(demoOtp))),
          const SizedBox(height: KafzaSpacing.xl),
          // Six boxes drawn over one invisible field: typing, paste and backspace just work.
          Semantics(
            label: l10n.otpLabel,
            child: Stack(
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: KafzaSpacing.sm,
                  children: [
                    for (var i = 0; i < demoOtp.length; i++)
                      Container(
                        width: 44,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(KafzaRadius.input),
                          border: Border.all(
                            color: _wrong
                                ? scheme.error
                                : (i == code.length && _focus.hasFocus ? scheme.primary : scheme.outline),
                            width: i == code.length && _focus.hasFocus ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          i < code.length ? code[i] : '',
                          style: text.titleLarge!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                        ),
                      ),
                  ],
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: 0,
                    alwaysIncludeSemantics: true,
                    child: TextField(
                      controller: _code,
                      focusNode: _focus,
                      autofocus: true,
                      enabled: !_checking,
                      showCursor: false,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(demoOtp.length),
                      ],
                      decoration: const InputDecoration(border: InputBorder.none, filled: false),
                      onTap: () => setState(() {}),
                      onChanged: _check,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: KafzaSpacing.md),
          if (_checking)
            const Center(child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2)))
          else if (_wrong)
            Semantics(
              liveRegion: true,
              child: Text(l10n.otpWrong, textAlign: TextAlign.center, style: text.bodyMedium!.copyWith(color: scheme.error)),
            ),
          const SizedBox(height: KafzaSpacing.lg),
          Center(
            child: left > Duration.zero
                ? Text(
                    l10n.resendIn(ltr('0:${left.inSeconds.toString().padLeft(2, '0')}')),
                    style: text.bodyMedium!.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() => _sentAt = ref.read(clockProvider));
                      snack(context, l10n.codeSent);
                    },
                    child: Text(l10n.resendCode),
                  ),
          ),
        ],
      ),
    );
  }
}
