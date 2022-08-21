// ignore_for_file: prefer_const_constructors
import 'package:{{repository_name.snakeCase()}}_api/{{repository_name.snakeCase()}}_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class Mock{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api extends Mock implements {{#pascalCase}}{{repository_name}}{{/pascalCase}}Api {} 

void main() {
  group('Test{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api', () {
    test('can be instantiated', () {
      expect(Mock{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api(), isNotNull);
    });
  });
}
