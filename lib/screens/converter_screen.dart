import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/number_base.dart';
import '../widgets/converter_widgets.dart';

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
            const AeroBackdrop(),
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
                          GlassPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                BaseSelectorRow(
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
                                LabeledControl(
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
                                OutputCapsule(
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
