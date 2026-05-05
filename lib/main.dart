import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RadixConverterApp());
}

class RadixConverterApp extends StatelessWidget {
  const RadixConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'baseshift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Avenir',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A9D8),
          brightness: Brightness.light,
        ),
      ),
      home: const ConverterScreen(),
    );
  }
}

enum NumberBase {
  binary('Binary', 2, '101101'),
  decimal('Decimal', 10, '45'),
  octal('Octal', 8, '55'),
  hexadecimal('Hexadecimal', 16, '2D');

  const NumberBase(this.label, this.radix, this.example);

  final String label;
  final int radix;
  final String example;
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  NumberBase _inputBase = NumberBase.decimal;
  NumberBase _outputBase = NumberBase.binary;
  String _convertedValue = '0';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _convert();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _convert() {
    final rawValue = _inputController.text.trim().replaceAll(' ', '');

    if (rawValue.isEmpty || rawValue == '-' || rawValue == '+') {
      setState(() {
        _convertedValue = '0';
        _errorText = null;
      });
      return;
    }

    final parseableValue = rawValue.startsWith('+')
        ? rawValue.substring(1)
        : rawValue;

    try {
      final decimalValue = BigInt.parse(
        parseableValue,
        radix: _inputBase.radix,
      );
      setState(() {
        _convertedValue = decimalValue
            .toRadixString(_outputBase.radix)
            .toUpperCase();
        _errorText = null;
      });
    } on FormatException {
      setState(() {
        _convertedValue = 'Invalid input';
        _errorText = _inputErrorText(_inputBase);
      });
    }
  }

  String _inputErrorText(NumberBase base) {
    return switch (base) {
      NumberBase.binary => 'Binary accepts digits 0 and 1 only.',
      NumberBase.decimal => 'Decimal accepts digits 0-9 only.',
      NumberBase.octal => 'Octal accepts digits 0-7 only.',
      NumberBase.hexadecimal =>
        'Hexadecimal accepts digits 0-9 and letters A-F only.',
    };
  }

  void _swapBases() {
    setState(() {
      final previousInput = _inputBase;
      _inputBase = _outputBase;
      _outputBase = previousInput;

      if (_errorText == null && _convertedValue != '0') {
        _inputController.text = _convertedValue;
        _inputController.selection = TextSelection.collapsed(
          offset: _inputController.text.length,
        );
      }
    });
    _convert();
  }

  void _clear() {
    _inputController.clear();
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            const _AeroBackdrop(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 36,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _GlassPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _BaseSelectorRow(
                                  inputBase: _inputBase,
                                  outputBase: _outputBase,
                                  onInputChanged: (base) {
                                    if (base == null) return;
                                    setState(() => _inputBase = base);
                                    _convert();
                                  },
                                  onOutputChanged: (base) {
                                    if (base == null) return;
                                    setState(() => _outputBase = base);
                                    _convert();
                                  },
                                  onSwap: _swapBases,
                                ),
                                const SizedBox(height: 22),
                                _LabeledControl(
                                  label: 'Input',
                                  child: TextField(
                                    key: const ValueKey('number-input'),
                                    controller: _inputController,
                                    onChanged: (_) => _convert(),
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    style: const TextStyle(
                                      color: Color(0xFF06324A),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0',
                                      hintStyle: TextStyle(
                                        color: const Color(
                                          0xFF06324A,
                                        ).withValues(alpha: 0.22),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0,
                                      ),
                                      errorText: _errorText,
                                      filled: true,
                                      fillColor: Colors.white.withValues(
                                        alpha: 0.82,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 18,
                                          ),
                                      border: _fieldBorder(
                                        const Color(0x6689E9FF),
                                      ),
                                      enabledBorder: _fieldBorder(
                                        const Color(0x6689E9FF),
                                      ),
                                      focusedBorder: _fieldBorder(
                                        const Color(0xFF00A9D8),
                                      ),
                                      errorBorder: _fieldBorder(
                                        const Color(0xFFDE4B6B),
                                      ),
                                      suffixIcon: IconButton(
                                        tooltip: 'Clear',
                                        onPressed: _clear,
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                _OutputCapsule(
                                  base: _outputBase,
                                  value: _convertedValue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _fieldBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(color: color, width: 1.4),
    );
  }
}

class _BaseSelectorRow extends StatelessWidget {
  const _BaseSelectorRow({
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
            child: _LabeledControl(
              label: 'From',
              child: _BaseDropdown(value: inputBase, onChanged: onInputChanged),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 0 : 12,
              vertical: isNarrow ? 12 : 20,
            ),
            child: _SwapButton(
              tooltip: 'Swap bases',
              onPressed: onSwap,
              icon: Icons.swap_vert_rounded,
            ),
          ),
          Expanded(
            child: _LabeledControl(
              label: 'To',
              child: _BaseDropdown(
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

class _LabeledControl extends StatelessWidget {
  const _LabeledControl({required this.label, required this.child});

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

class _BaseDropdown extends StatelessWidget {
  const _BaseDropdown({required this.value, required this.onChanged});

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

class _OutputCapsule extends StatelessWidget {
  const _OutputCapsule({required this.base, required this.value});

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

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

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

class _SwapButton extends StatelessWidget {
  const _SwapButton({
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

class _AeroBackdrop extends StatelessWidget {
  const _AeroBackdrop();

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
