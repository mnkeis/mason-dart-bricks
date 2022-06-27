import 'package:{{repository_name.snakeCase()}}_api/{{repository_name.snakeCase()}}_api.dart';

/// {@template {{implementation_prefix.snakeCase()}}_{{repository_name.snakeCase()}}_api}
/// Implementation for {{repository_name.snakeCase()}}_api
/// {@endtemplate}
class {{#pascalCase}}{{implementation_prefix}}_{{repository_name}}{{/pascalCase}}Api implements {{#pascalCase}}{{repository_name}}Api{{/pascalCase}} {
  /// {@macro {{implementation_prefix.snakeCase()}}_{{repository_name.snakeCase()}}_api}
  const {{#pascalCase}}{{implementation_prefix}}_{{repository_name}}{{/pascalCase}}Api();
  {{#methods}}
  @override
  {{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}}({{#hasParameters}}{ {{#parameters}}
    {{^isNullable}}required {{/isNullable}}{{#hasSpecial}}{{{type}}}{{/hasSpecial}}{{^hasSpecial}}{{type}}{{/hasSpecial}} {{name.camelCase()}},{{/parameters}}
  }{{/hasParameters}}) {{#isFuture}}async {{/isFuture}}{{#isStream}}async* {{/isStream}}{
    // Write your implementation here
    throw UnimplementedError();
  }
  {{/methods}}
}
