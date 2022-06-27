// ignore_for_file: prefer_const_constructors
import 'package:{{implementation_prefix.snakeCase()}}_{{repository_name.snakeCase()}}_api/{{implementation_prefix.snakeCase()}}_{{repository_name.snakeCase()}}_api.dart';
import 'package:test/test.dart';

void main() {
  group('{{#pascalCase}}{{implementation_prefix}}_{{repository_name}}{{/pascalCase}}Api', () {
    test('can be instantiated', () {
      expect({{#pascalCase}}{{implementation_prefix}}_{{repository_name}}{{/pascalCase}}Api(), isNotNull);
    });
  });
}
