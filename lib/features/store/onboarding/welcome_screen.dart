import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/seed.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/kafza_logo.dart';
import '../store_providers.dart';

/// S1: welcome, language, "Get started" (new store) or "I have a store" (the seeded account).
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(KafzaSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: KafzaSpacing.xxl),
                    const Center(child: KafzaLogo(height: 64)),
                    Text(
                      l10n.byYassir,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: text.titleMedium!.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const Spacer(),
                    Text(l10n.welcomeTitle, style: text.titleLarge),
                    const SizedBox(height: KafzaSpacing.sm),
                    Text(l10n.welcomeBody, style: text.bodyLarge!.copyWith(color: scheme.onSurfaceVariant)),
                    const SizedBox(height: KafzaSpacing.xl),
                    Wrap(
                      spacing: KafzaSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(l10n.language, style: text.labelLarge),
                        for (final (code, label) in [('ar', l10n.langAr), ('fr', l10n.langFr)])
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text(label),
                            selected: locale.languageCode == code,
                            onSelected: (_) => ref.read(localeProvider.notifier).set(Locale(code)),
                          ),
                      ],
                    ),
                    const Spacer(),
                    FilledButton(onPressed: () => context.push('/phone'), child: Text(l10n.getStarted)),
                    const SizedBox(height: KafzaSpacing.sm),
                    OutlinedButton(
                      onPressed: () {
                        ref.read(storeSessionProvider.notifier).logIn(demoStoreId);
                        context.go('/home');
                      },
                      child: Text(l10n.haveStore),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
