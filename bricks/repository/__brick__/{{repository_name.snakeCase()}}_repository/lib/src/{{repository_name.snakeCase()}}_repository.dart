import 'package:{{repository_name.snakeCase()}}_api/{{repository_name.snakeCase()}}_api.dart';

/// {@template {{repository_name.snakeCase()}}_repository}
/// {{repository_description}}
/// {@endtemplate}
class {{#pascalCase}}{{repository_name}}{{/pascalCase}}Repository {
  /// {@macro {{repository_name.snakeCase()}}_repository}
  const {{#pascalCase}}{{repository_name}}{{/pascalCase}}Repository(this.{{repository_name.camelCase()}}Api);

  /// API interface for this repository
  final {{repository_name.pascalCase()}}Api {{repository_name.camelCase()}}Api;

  {{#methods}}
  /// A description for method {{name}}
  {{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}}({{#hasParameters}}{ {{#parameters}}
    {{^isNullable}}required {{/isNullable}}{{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}},{{/parameters}}
  }{{/hasParameters}}) => {{repository_name.camelCase()}}Api.{{name.camelCase()}}({{#hasParameters}}{{#parameters}}
    {{name.camelCase()}}: {{name.camelCase()}},{{/parameters}}
  {{/hasParameters}});
  {{/methods}}
}
