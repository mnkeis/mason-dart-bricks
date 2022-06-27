import 'models/models.dart';

/// {@template {{repository_name.snakeCase()}}_api}
/// API interface for {{repository_name.snakeCase()}}
/// {@endtemplate}
abstract class {{#pascalCase}}{{repository_name}}{{/pascalCase}}Api {
  /// {@macro {{repository_name.snakeCase()}}_api}
  const {{#pascalCase}}{{repository_name}}{{/pascalCase}}Api();
{{#methods}}
  /// A description for method {{name}}
  {{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}}({{#hasParameters}}{ {{#parameters}}
    {{^isNullable}}required {{/isNullable}}{{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}},{{/parameters}}
  }{{/hasParameters}});{{/methods}}
}
