import 'package:flutter_test/flutter_test.dart';
import 'package:calling/main.dart';

void main() {
  group('extractPhoneNumbers', () {
    test('extracts numbers with + prefix', () {
      final result = extractPhoneNumbers('+554888000514');
      expect(result, ['+554888000514']);
    });

    test('extracts numbers from tab-separated contacts file', () {
      final text = 'undefined\t+554888000514\nundefined\t+554888056486\nundefined\t+554891328890';
      final result = extractPhoneNumbers(text);
      expect(result, ['+554888000514', '+554888056486', '+554891328890']);
    });

    test('extracts Brazilian number without + (10 digits, landline)', () {
      final result = extractPhoneNumbers('1132244555');
      expect(result, ['+551132244555']);
    });

    test('injects 9th digit for Brazilian mobile (10 digits, 3rd digit >= 6)', () {
      final result = extractPhoneNumbers('6188377338');
      expect(result, ['+5561988377338']);
    });

    test('handles Brazilian number with 11 digits (already has 9)', () {
      final result = extractPhoneNumbers('11999999999');
      expect(result, ['+5511999999999']);
    });

    test('handles non-Brazil numbers (US)', () {
      final result = extractPhoneNumbers('+15135328138');
      expect(result, ['+15135328138']);
    });

    test('handles non-Brazil numbers (UK)', () {
      final result = extractPhoneNumbers('+447846895276');
      expect(result, ['+447846895276']);
    });

    test('handles non-Brazil numbers (Peru)', () {
      final result = extractPhoneNumbers('+51974374502');
      expect(result, ['+51974374502']);
    });

    test('strips formatting (spaces, dashes, parens)', () {
      final result = extractPhoneNumbers('+55 (48) 8800-0514');
      expect(result, ['+554888000514']);
    });

    test('handles 12-digit number without + (starts with 55)', () {
      final result = extractPhoneNumbers('554888000514');
      expect(result, ['+554888000514']);
    });

    test('handles 13-digit number without + (starts with 55)', () {
      final result = extractPhoneNumbers('5519995499571');
      expect(result, ['+5519995499571']);
    });

    test('rejects empty input', () {
      final result = extractPhoneNumbers('');
      expect(result, isEmpty);
    });

    test('rejects short numbers (< 10 digits)', () {
      final result = extractPhoneNumbers('123456789');
      expect(result, isEmpty);
    });

    test('rejects text without numbers', () {
      final result = extractPhoneNumbers('no numbers here');
      expect(result, isEmpty);
    });

    test('handles mixed content on lines', () {
      final result = extractPhoneNumbers('Name\t+554891345678\nName2\t+554899876543');
      expect(result, ['+554891345678', '+554899876543']);
    });

    test('extracts all numbers from the 425-line contacts file format', () {
      final buf = StringBuffer();
      for (var i = 0; i < 425; i++) {
        final raw = 554888000514 + i;
        buf.writeln('undefined\t+$raw');
      }
      final result = extractPhoneNumbers(buf.toString());
      expect(result.length, 425);
    });

    test('does not inject 9 for landline (3rd digit < 6)', () {
      final result = extractPhoneNumbers('2132244555');
      expect(result, ['+552132244555']);
    });

    test('handles multiple lines with blank lines', () {
      final text = '+554888000514\n\n\n+554891328890\n';
      final result = extractPhoneNumbers(text);
      expect(result, ['+554888000514', '+554891328890']);
    });
  });
}
