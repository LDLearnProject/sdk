// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/dart/error/syntactic_errors.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'recovery_test_support.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(ListLiteralTest);
    defineReflectiveTests(MapLiteralTest);
    defineReflectiveTests(MissingCodeTest);
    defineReflectiveTests(ParameterListTest);
  });
}

/**
 * Test how well the parser recovers when tokens are missing in a list literal.
 */
@reflectiveTest
class ListLiteralTest extends AbstractRecoveryTest {
  void test_extraComma() {
    testRecovery('''
f() => [a, , b];
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f() => [a, _s_, b];
''');
  }

  @failingTest
  void test_missingComma() {
    testRecovery('''
f() => [a, b c];
''', [ParserErrorCode.EXPECTED_TOKEN], '''
f() => [a, b, c];
''');
  }
}

/**
 * Test how well the parser recovers when tokens are missing in a map literal.
 */
@reflectiveTest
class MapLiteralTest extends AbstractRecoveryTest {
  void test_extraComma() {
    testRecovery('''
f() => {a: b, , c: d};
''', [
      ParserErrorCode.MISSING_IDENTIFIER,
      ParserErrorCode.EXPECTED_TOKEN,
      ParserErrorCode.MISSING_IDENTIFIER
    ], '''
f() => {a: b, _s_: _s_, c: d};
''');
  }

  void test_missingColonAndValue_last() {
    testRecovery('''
f() => {a };
''', [ParserErrorCode.EXPECTED_TOKEN, ParserErrorCode.MISSING_IDENTIFIER], '''
f() => {a: _s_};
''');
  }

  void test_missingComma() {
    testRecovery('''
f() => {a: b, c: d e: f};
''', [ParserErrorCode.EXPECTED_TOKEN], '''
f() => {a: b, c: d, e: f};
''');
  }

  void test_missingKey() {
    testRecovery('''
f() => {: b};
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f() => {_s_: b};
''');
  }

  void test_missingValue_last() {
    testRecovery('''
f() => {a: };
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f() => {a: _s_};
''');
  }

  void test_missingValue_notLast() {
    testRecovery('''
f() => {a: , b: c};
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f() => {a: _s_, b: c};
''');
  }
}

/**
 * Test how well the parser recovers when non-paired tokens are missing.
 */
@reflectiveTest
class MissingCodeTest extends AbstractRecoveryTest {
  void test_ampersand() {
    testBinaryExpression('&');
  }

  void test_ampersand_super() {
    testUserDefinableOperatorWithSuper('&');
  }

  @failingTest
  void test_asExpression_missingLeft() {
    testRecovery('''
convert(x) => as T;
''', [ParserErrorCode.EXPECTED_TYPE_NAME], '''
convert(x) => _s_ as T;
''');
  }

  void test_asExpression_missingRight() {
    testRecovery('''
convert(x) => x as ;
''', [ParserErrorCode.EXPECTED_TYPE_NAME], '''
convert(x) => x as _s_;
''');
  }

  void test_assignmentExpression() {
    testRecovery('''
f() {
  var x;
  x = 
}
''', [ParserErrorCode.MISSING_IDENTIFIER, ParserErrorCode.EXPECTED_TOKEN], '''
f() {
  var x;
  x = _s_;
}
''');
  }

  void test_bar() {
    testBinaryExpression('|');
  }

  void test_bar_super() {
    testUserDefinableOperatorWithSuper('|');
  }

  void test_cascade_missingRight() {
    testRecovery('''
f(x) {
  x..
}
''', [ParserErrorCode.MISSING_IDENTIFIER, ParserErrorCode.EXPECTED_TOKEN], '''
f(x) {
  x.. _s_;
}
''');
  }

  void test_classDeclaration_missingName() {
    testRecovery('''
class {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
class _s_ {}
''');
  }

  @failingTest
  void test_combinatorsBeforePrefix() {
    //Expected 1 errors of type ParserErrorCode.MISSING_PREFIX_IN_DEFERRED_IMPORT, found 0
    testRecovery('''
import 'bar.dart' deferred;
''', [ParserErrorCode.MISSING_PREFIX_IN_DEFERRED_IMPORT], '''
import 'bar.dart' deferred as _s_;
''');
  }

  void test_conditionalExpression_else() {
    testRecovery('''
f() => x ? y : 
''', [ParserErrorCode.MISSING_IDENTIFIER, ParserErrorCode.EXPECTED_TOKEN], '''
f() => x ? y : _s_;
''');
  }

  void test_conditionalExpression_then() {
    testRecovery('''
f() => x ? : z
''', [ParserErrorCode.MISSING_IDENTIFIER, ParserErrorCode.EXPECTED_TOKEN], '''
f() => x ? _s_ : z;
''');
  }

  void test_equalEqual() {
    testBinaryExpression('==');
  }

  void test_equalEqual_super() {
    testUserDefinableOperatorWithSuper('==');
  }

  void test_greaterThan() {
    testBinaryExpression('>');
  }

  void test_greaterThan_super() {
    testUserDefinableOperatorWithSuper('>');
  }

  void test_greaterThanGreaterThan() {
    testBinaryExpression('>>');
  }

  void test_greaterThanGreaterThan_super() {
    testUserDefinableOperatorWithSuper('>>');
  }

  void test_greaterThanOrEqual() {
    testBinaryExpression('>=');
  }

  void test_greaterThanOrEqual_super() {
    testUserDefinableOperatorWithSuper('>=');
  }

  void test_hat() {
    testBinaryExpression('^');
  }

  void test_hat_super() {
    testUserDefinableOperatorWithSuper('^');
  }

  void test_isExpression_missingLeft() {
    testRecovery('''
f() {
  if (is String) {
  }
}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f() {
  if (_s_ is String) {
  }
}
''');
  }

  void test_isExpression_missingRight() {
    testRecovery('''
f(x) {
  if (x is ) {}
}
''', [ParserErrorCode.EXPECTED_TYPE_NAME], '''
f(x) {
  if (x is _s_) {}
}
''');
  }

  void test_lessThan() {
    testBinaryExpression('<');
  }

  void test_lessThan_super() {
    testUserDefinableOperatorWithSuper('<');
  }

  void test_lessThanLessThan() {
    testBinaryExpression('<<');
  }

  void test_lessThanLessThan_super() {
    testUserDefinableOperatorWithSuper('<<');
  }

  void test_lessThanOrEqual() {
    testBinaryExpression('<=');
  }

  void test_lessThanOrEqual_super() {
    testUserDefinableOperatorWithSuper('<=');
  }

  void test_minus() {
    testBinaryExpression('-');
  }

  void test_minus_super() {
    testUserDefinableOperatorWithSuper('-');
  }

  @failingTest
  void test_parameterList_leftParen() {
    // https://github.com/dart-lang/sdk/issues/22938
    testRecovery('''
int f int x, int y) {}
''', [ParserErrorCode.EXPECTED_TOKEN], '''
int f (int x, int y) {}
''');
  }

  @failingTest
  void test_parentheses_aroundThrow() {
    // https://github.com/dart-lang/sdk/issues/24892
    testRecovery('''
f(x) => x ?? throw 0;
''', [ParserErrorCode.EXPECTED_TOKEN, ParserErrorCode.EXPECTED_TOKEN], '''
f(x) => x ?? (throw 0);
''');
  }

  void test_percent() {
    testBinaryExpression('%');
  }

  void test_percent_super() {
    testUserDefinableOperatorWithSuper('%');
  }

  void test_plus() {
    testBinaryExpression('+');
  }

  void test_plus_super() {
    testUserDefinableOperatorWithSuper('+');
  }

  void test_prefixedIdentifier() {
    testRecovery('''
f() {
  var v = 'String';
  v.
}
''', [ParserErrorCode.MISSING_IDENTIFIER, ParserErrorCode.EXPECTED_TOKEN], '''
f() {
  var v = 'String';
  v._s_;
}
''');
  }

  void test_slash() {
    testBinaryExpression('/');
  }

  void test_slash_super() {
    testUserDefinableOperatorWithSuper('/');
  }

  void test_star() {
    testBinaryExpression('*');
  }

  void test_star_super() {
    testUserDefinableOperatorWithSuper('*');
  }

  void test_stringInterpolation_unclosed() {
    // https://github.com/dart-lang/sdk/issues/946
    // TODO(brianwilkerson) Try to recover better. Ideally there would be a
    // single error about an unterminated interpolation block.
    testRecovery(r'''
f() {
  print("${42");
}
''', [
      ParserErrorCode.EXPECTED_TOKEN,
      ParserErrorCode.EXPECTED_TOKEN,
      ScannerErrorCode.EXPECTED_TOKEN,
      ScannerErrorCode.EXPECTED_TOKEN,
      ScannerErrorCode.UNTERMINATED_STRING_LITERAL,
      ScannerErrorCode.UNTERMINATED_STRING_LITERAL
    ], r'''
f() {
  print("${42}");
}
''');
  }

  void test_tildeSlash() {
    testBinaryExpression('~/');
  }

  void test_tildeSlash_super() {
    testUserDefinableOperatorWithSuper('~/');
  }

  void testBinaryExpression(String operator) {
    testRecovery('''
f() => x $operator
''', [ParserErrorCode.MISSING_IDENTIFIER, ParserErrorCode.EXPECTED_TOKEN], '''
f() => x $operator _s_;
''');
  }

  void testUserDefinableOperatorWithSuper(String operator) {
    testRecovery('''
class C {
  int operator $operator(x) => super $operator
}
''', [ParserErrorCode.MISSING_IDENTIFIER, ParserErrorCode.EXPECTED_TOKEN], '''
class C {
  int operator $operator(x) => super $operator _s_;
}
''');
  }
}

/**
 * Test how well the parser recovers when tokens are missing in a parameter
 * list.
 */
@reflectiveTest
class ParameterListTest extends AbstractRecoveryTest {
  @failingTest
  void test_extraComma_named_last() {
    testRecovery('''
f({a, }) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f({a, _s_}) {}
''');
  }

  @failingTest
  void test_extraComma_named_noLast() {
    testRecovery('''
f({a, , b}) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f({a, _s_, b}) {}
''');
  }

  @failingTest
  void test_extraComma_positional_last() {
    testRecovery('''
f([a, ]) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f([a, _s_]) {}
''');
  }

  @failingTest
  void test_extraComma_positional_noLast() {
    testRecovery('''
f([a, , b]) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f([a, _s_, b]) {}
''');
  }

  @failingTest
  void test_extraComma_required_last() {
    testRecovery('''
f(a, ) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f(a, _s_) {}
''');
  }

  @failingTest
  void test_extraComma_required_noLast() {
    testRecovery('''
f(a, , b) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f(a, _s_, b) {}
''');
  }

  void test_fieldFormalParameter_noPeriod_last() {
    testRecovery('''
class C {
  int f;
  C(this);
}
''', [ParserErrorCode.EXPECTED_TOKEN, ParserErrorCode.MISSING_IDENTIFIER], '''
class C {
  int f;
  C(this._s_);
}
''');
  }

  void test_fieldFormalParameter_noPeriod_notLast() {
    testRecovery('''
class C {
  int f;
  C(this, p);
}
''', [ParserErrorCode.EXPECTED_TOKEN, ParserErrorCode.MISSING_IDENTIFIER], '''
class C {
  int f;
  C(this._s_, p);
}
''');
  }

  void test_fieldFormalParameter_period_last() {
    testRecovery('''
class C {
  int f;
  C(this.);
}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
class C {
  int f;
  C(this._s_);
}
''');
  }

  void test_fieldFormalParameter_period_notLast() {
    testRecovery('''
class C {
  int f;
  C(this., p);
}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
class C {
  int f;
  C(this._s_, p);
}
''');
  }

  @failingTest
  void test_incorrectlyTerminatedGroup_named_none() {
    testRecovery('''
f({a: 0) {}
''', [ParserErrorCode.MISSING_TERMINATOR_FOR_PARAMETER_GROUP], '''
f({a: 0}) {}
''');
  }

  @failingTest
  void test_incorrectlyTerminatedGroup_named_positional() {
    testRecovery('''
f({a: 0]) {}
''', [ParserErrorCode.WRONG_TERMINATOR_FOR_PARAMETER_GROUP], '''
f({a: 0}) {}
''');
  }

  @failingTest
  void test_incorrectlyTerminatedGroup_none_named() {
    testRecovery('''
f(a}) {}
''', [ParserErrorCode.UNEXPECTED_TERMINATOR_FOR_PARAMETER_GROUP], '''
f(a) {}
''');
  }

  @failingTest
  void test_incorrectlyTerminatedGroup_none_positional() {
    testRecovery('''
f(a]) {}
''', [ParserErrorCode.UNEXPECTED_TERMINATOR_FOR_PARAMETER_GROUP], '''
f(a) {}
''');
  }

  @failingTest
  void test_incorrectlyTerminatedGroup_positional_named() {
    testRecovery('''
f([a = 0}) {}
''', [ParserErrorCode.WRONG_TERMINATOR_FOR_PARAMETER_GROUP], '''
f([a = 0]) {}
''');
  }

  @failingTest
  void test_incorrectlyTerminatedGroup_positional_none() {
    // Maybe put in paired_tokens_test.dart.
    testRecovery('''
f([a = 0) {}
''', [ParserErrorCode.MISSING_TERMINATOR_FOR_PARAMETER_GROUP], '''
f([a = 0]) {}
''');
  }

  void test_missingComma() {
    // https://github.com/dart-lang/sdk/issues/22074
    testRecovery('''
g(a, b, c) {}
h(v1, v2, v) {
  g(v1 == v2 || v1 == v 3, true);
}
''', [ParserErrorCode.EXPECTED_TOKEN], '''
g(a, b, c) {}
h(v1, v2, v) {
  g(v1 == v2 || v1 == v, 3, true);
}
''');
  }

  void test_missingDefault_named_last() {
    testRecovery('''
f({a: }) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f({a: _s_}) {}
''');
  }

  void test_missingDefault_named_notLast() {
    testRecovery('''
f({a: , b}) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f({a: _s_, b}) {}
''');
  }

  void test_missingDefault_positional_last() {
    testRecovery('''
f([a = ]) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f([a = _s_]) {}
''');
  }

  void test_missingDefault_positional_notLast() {
    testRecovery('''
f([a = , b]) {}
''', [ParserErrorCode.MISSING_IDENTIFIER], '''
f([a = _s_, b]) {}
''');
  }

  @failingTest
  void test_multipleGroups_mixed() {
    // TODO(brianwilkerson) Figure out the best way to recover from this.
    testRecovery('''
f([a = 0], {b: 1}) {}
''', [ParserErrorCode.MIXED_PARAMETER_GROUPS], '''
f([a = 0]) {}
''');
  }

  @failingTest
  void test_multipleGroups_mixedAndMultiple() {
    // TODO(brianwilkerson) Figure out the best way to recover from this.
    testRecovery('''
f([a = 0], {b: 1}, [c = 2]) {}
''', [ParserErrorCode.MIXED_PARAMETER_GROUPS], '''
f([a = 0, c = 2]) {}
''');
  }

  @failingTest
  void test_multipleGroups_named() {
    testRecovery('''
f({a: 0}, {b: 1}) {}
''', [ParserErrorCode.MULTIPLE_NAMED_PARAMETER_GROUPS], '''
f({a: 0, b: 1}) {}
''');
  }

  @failingTest
  void test_multipleGroups_positional() {
    testRecovery('''
f([a = 0], [b = 1]) {}
''', [ParserErrorCode.MULTIPLE_POSITIONAL_PARAMETER_GROUPS], '''
f([a = 0, b = 1]) {}
''');
  }

  @failingTest
  void test_namedOutsideGroup() {
    testRecovery('''
f(a: 0) {}
''', [ParserErrorCode.NAMED_PARAMETER_OUTSIDE_GROUP], '''
f({a: 0}) {}
''');
  }

  @failingTest
  void test_positionalOutsideGroup() {
    testRecovery('''
f(a = 0) {}
''', [ParserErrorCode.POSITIONAL_PARAMETER_OUTSIDE_GROUP], '''
f([a = 0]) {}
''');
  }
}
