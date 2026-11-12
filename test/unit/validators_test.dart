import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/core/utils/validators.dart';

void main() {
  test('email validator', () {
    expect(Validators.email(''), isNotNull);
    expect(Validators.email('not-an-email'), isNotNull);
    expect(Validators.email('user@example.com'), isNull);
  });

  test('password validator', () {
    expect(Validators.password('12345'), isNotNull);
    expect(Validators.password('123456'), isNull);
  });

  test('confirm password validator', () {
    expect(Validators.confirmPassword('abc', 'abcd'), isNotNull);
    expect(Validators.confirmPassword('abcd', 'abcd'), isNull);
  });

  test('phone validator', () {
    expect(Validators.phone('123'), isNotNull);
    expect(Validators.phone('0300 1234567'), isNull);
  });
}
