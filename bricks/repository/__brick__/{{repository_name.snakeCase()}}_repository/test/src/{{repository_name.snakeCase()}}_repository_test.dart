// ignore_for_file: prefer_const_constructors
import 'package:{{repository_name.snakeCase()}}_api/{{repository_name.snakeCase()}}_api.dart';
import 'package:{{repository_name.snakeCase()}}_repository/{{repository_name.snakeCase()}}_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class Mock{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api extends Mock implements {{#pascalCase}}{{repository_name}}{{/pascalCase}}Api {} 

void main() {
  final test{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api = Mock{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api();
  group('{{#pascalCase}}{{repository_name}}{{/pascalCase}}Repository', () {
    test('can be instantiated', () {
      expect({{#pascalCase}}{{repository_name}}{{/pascalCase}}Repository(test{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api), isNotNull);
    });
  });
}
