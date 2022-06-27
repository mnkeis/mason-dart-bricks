// ignore_for_file: prefer_const_constructors
import 'package:{{repository_name.snakeCase()}}_api/{{repository_name.snakeCase()}}_api.dart';
import 'package:test/test.dart';

class Test{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api implements {{#pascalCase}}{{repository_name}}{{/pascalCase}}Api {
  Test{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api();

  {{#methods}}
  @override
  {{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}}({{#hasParameters}}{ {{#parameters}}
    {{^isNullable}}required {{/isNullable}}{{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}},{{/parameters}}
  }{{/hasParameters}}){
    throw UnimplementedError();
  }{{/methods}}
} 

void main() {
  group('Test{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api', () {
    test('can be instantiated', () {
      expect(Test{{#pascalCase}}{{repository_name}}{{/pascalCase}}Api(), isNotNull);
    });
  });
}
