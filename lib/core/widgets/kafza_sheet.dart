import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/kafza_theme.dart';

/// Context of the open app's root Navigator, for modals that must cover its navigation bar.
/// `useRootNavigator` would reach past it to the launcher's Navigator: the modal would cover
/// both phones in side-by-side, and closing it would tell Android the app can't handle Back.
/// Outside the apps (demo panel) the launcher's Navigator is the right one.
BuildContext appRootContext(BuildContext context) =>
    GoRouter.maybeOf(context)?.routerDelegate.navigatorKey.currentContext ??
    Navigator.of(context, rootNavigator: true).context;

/// `onNavigationNotification` for the launcher and both apps. Flutter's default tells Android
/// the app can't handle Back whenever a Navigator is at its root, and Android then quits over
/// an open Kafza app (wiping the demo state). Flutter keeps every Back instead: the apps'
/// routers first, then the launcher (back to its menu), and closes the app itself from there.
bool keepBackInFlutter(NavigationNotification _) {
  SystemNavigator.setFrameworkHandlesBack(true);
  return true;
}

/// The app's bottom sheet: scroll-controlled, drag handle, radius 24 (from the theme).
Future<T?> showKafzaSheet<T>(BuildContext context, WidgetBuilder builder) =>
    showModalBottomSheet<T>(
      context: appRootContext(context),
      isScrollControlled: true,
      useSafeArea: true,
      builder: builder,
    );

/// The app's decision dialog (radius 20 from the theme). True only when [confirm] is tapped;
/// without [confirm] it is a notice with a single [cancel] button. [destructive] paints
/// [confirm] in the error colour. [content] goes under [body] (live data, like a countdown).
Future<bool> showKafzaDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String cancel,
  String? confirm,
  bool destructive = false,
  Widget? content,
}) async {
  final ok = await showDialog<bool>(
    context: appRootContext(context),
    useRootNavigator: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: KafzaSpacing.md,
        children: [Text(body), ?content],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancel)),
        if (confirm != null)
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: destructive ? TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error) : null,
            child: Text(confirm),
          ),
      ],
    ),
  );
  return ok ?? false;
}
