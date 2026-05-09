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
