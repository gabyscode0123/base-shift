import 'package:flutter/material.dart';

import '../models/number_base.dart';

class BaseSelectorRow extends StatelessWidget {
  const BaseSelectorRow({
    super.key,
    required this.inputBase,
    required this.outputBase,
    required this.onInputChanged,
    required this.onOutputChanged,
    required this.onSwap,
  });

  final NumberBase inputBase;
  final NumberBase outputBase;
  final ValueChanged<NumberBase?> onInputChanged;
  final ValueChanged<NumberBase?> onOutputChanged;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 430;
        final selectors = [
          Expanded(
            child: LabeledControl(
              label: 'From',
              child: BaseDropdown(value: inputBase, onChanged: onInputChanged),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 0 : 12,
              vertical: isNarrow ? 12 : 20,
            ),
            child: SwapButton(
              tooltip: 'Swap bases',
              onPressed: onSwap,
              icon: Icons.swap_vert_rounded,
            ),
          ),
          Expanded(
            child: LabeledControl(
              label: 'To',
              child: BaseDropdown(
                value: outputBase,
                onChanged: onOutputChanged,
              ),
            ),
          ),
        ];

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: selectors
                .map(
                  (widget) => widget is Expanded
                      ? Padding(padding: EdgeInsets.zero, child: widget.child)
                      : Center(child: widget),
                )
                .toList(),
          );
        }

        return Row(children: selectors);
      },
    );
  }
}

class LabeledControl extends StatelessWidget {
  const LabeledControl({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 7),
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF06324A).withValues(alpha: 0.68),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class BaseDropdown extends StatelessWidget {
  const BaseDropdown({super.key, required this.value, required this.onChanged});

  final NumberBase value;
  final ValueChanged<NumberBase?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<NumberBase>(
      initialValue: value,
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      borderRadius: BorderRadius.circular(20),
      dropdownColor: const Color(0xFFF3FDFF),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.76),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0x6689E9FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0x6689E9FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFF00A9D8), width: 1.5),
        ),
      ),
      items: NumberBase.values
          .map(
            (base) => DropdownMenuItem<NumberBase>(
              value: base,
              child: Text(
                base.label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF06324A),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class OutputCapsule extends StatelessWidget {
  const OutputCapsule({super.key, required this.base, required this.value});

  final NumberBase base;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isError = value == 'Invalid input';

    return Container(
      constraints: const BoxConstraints(minHeight: 190),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isError
            ? const Color(0xFFFFEEF2).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.72),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0076A6).withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${base.label} output',
            style: TextStyle(
              color: const Color(0xFF06324A).withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 12),
          SelectableText(
            value,
            key: const ValueKey('converted-output'),
            style: TextStyle(
              color: isError
                  ? const Color(0xFF9F1734)
                  : const Color(0xFF032C43),
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.08,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.82),
            Colors.white.withValues(alpha: 0.48),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.72),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0076A6).withValues(alpha: 0.2),
            blurRadius: 36,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SwapButton extends StatelessWidget {
  const SwapButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.72),
        elevation: 0,
        shadowColor: const Color(0xFF0076A6).withValues(alpha: 0.12),
        shape: const StadiumBorder(
          side: BorderSide(color: Color(0x6689E9FF), width: 1.4),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: SizedBox(
            width: 66,
            height: 42,
            child: Icon(icon, color: const Color(0xFF06445E), size: 28),
          ),
        ),
      ),
    );
  }
}

class AeroBackdrop extends StatelessWidget {
  const AeroBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF4A8),
            Color(0xFFC8F47A),
            Color(0xFF72DEA4),
            Color(0xFF7DE7FF),
            Color(0xFF4EB4F5),
          ],
          stops: [0, 0.24, 0.5, 0.76, 1],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
