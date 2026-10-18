import 'dart:async';

import 'package:flutter/material.dart';

/// Filled (primary) or outlined button. While the Future from [onPressed] runs, a spinner
/// replaces the label and taps do nothing, so a money button never fires twice.
class KafzaButton extends StatefulWidget {
  const KafzaButton(this.label, {super.key, required this.onPressed}) : outline = false;

  const KafzaButton.outline(this.label, {super.key, required this.onPressed}) : outline = true;

  final String label;

  /// Null disables the button.
  final FutureOr<void> Function()? onPressed;
  final bool outline;

  @override
  State<KafzaButton> createState() => _KafzaButtonState();
}

class _KafzaButtonState extends State<KafzaButton> {
  bool _busy = false;

  Future<void> _run() async {
    setState(() => _busy = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onPressed = widget.onPressed == null ? null : (_busy ? () {} : _run);
    final child = _busy
        ? Semantics(
            label: widget.label,
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: widget.outline ? scheme.primary : scheme.onPrimary,
              ),
            ),
          )
        : Text(widget.label, textAlign: TextAlign.center);
    return widget.outline
        ? OutlinedButton(onPressed: onPressed, child: child)
        : FilledButton(onPressed: onPressed, child: child);
  }
}
