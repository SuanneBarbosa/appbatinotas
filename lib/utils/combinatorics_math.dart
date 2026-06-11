class CombinatoricsMath {
  static BigInt powInt(int base, int exponent) {
    if (exponent < 0) throw ArgumentError('Expoente negativo não permitido.');
    BigInt result = BigInt.one;
    final BigInt b = BigInt.from(base);
    for (int i = 0; i < exponent; i++) {
      result *= b;
    }
    return result;
  }

  static BigInt factorial(int n) {
    if (n < 0) throw ArgumentError('Fatorial de número negativo não existe.');
    BigInt result = BigInt.one;
    for (int i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  static BigInt arrangementsWithoutRepetition(int n, int b) {
    if (b < 0) throw ArgumentError('Batidas negativas não são permitidas.');
    if (b > n) return BigInt.zero;
    BigInt result = BigInt.one;
    for (int i = 0; i < b; i++) {
      result *= BigInt.from(n - i);
    }
    return result;
  }

  static BigInt finiteFreeWithoutRepetitionTotal(int n) {
    BigInt total = BigInt.zero;
    for (int b = 1; b <= n; b++) {
      total += arrangementsWithoutRepetition(n, b);
    }
    return total;
  }

  static String formatBigInt(BigInt value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final remaining = s.length - i;
      buffer.write(s[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }
}
