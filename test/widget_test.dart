import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:baseshift/main.dart';

void main() {
  testWidgets('opens with an empty input and zero output', (tester) async {
    await tester.pumpWidget(const RadixConverterApp());

    final output = tester.widget<SelectableText>(
      find.byKey(const ValueKey('converted-output')),
    );

    expect(output.data, '0');
  });

  testWidgets('shows an error for invalid binary input', (tester) async {
    await tester.pumpWidget(const RadixConverterApp());

    await tester.tap(find.byType(DropdownButtonFormField<NumberBase>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Binary').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('number-input')), '102');
    await tester.pump();

    expect(find.text('Invalid input'), findsOneWidget);
    expect(find.text('Binary accepts digits 0 and 1 only.'), findsOneWidget);
  });
}
