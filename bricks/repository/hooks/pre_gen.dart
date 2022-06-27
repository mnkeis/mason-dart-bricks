import 'package:mason/mason.dart';

void run(HookContext context) {
  final logger = context.logger;

  if (!logger.confirm(
    '? Do you want to add methods to the API interface?',
    defaultValue: true,
  )) {
    return;
  }

  logger.alert(lightYellow.wrap('enter "e" to exit adding methods'));
  logger.alert('Format: returnType methodName e.g, String myMethod:');
  final methods = <Map<String, dynamic>>[];

  while (true) {
    final method = logger.prompt(':').replaceAll(RegExp('\\s+'), ' ').trim();
    if (method.toLowerCase() == 'e') {
      break;
    }

    if (!method.contains(' ')) {
      logger.alert(
          'That was not a valid format -> returnType methodName e.g, String myMethod');
      continue;
    }

    if ((method.contains('<') && !method.contains('>')) ||
        (method.contains('>') && !method.contains('<'))) {
      logger.alert(
          'It seems you are missing a < or >, please retype this method');
      continue;
    }

    final splitMethod = method.split(' ');
    final returnType = splitMethod[0];
    final methodName = splitMethod[1];
    final hasSpecial = returnType.toLowerCase().contains('<') ||
        returnType.toLowerCase().contains('>');
    final isFuture = returnType.toLowerCase().contains('future');
    final isStream = returnType.toLowerCase().contains('stream');

    final parameters = <Map<String, dynamic>>[];

    if (logger.confirm(
      '? Method has parameters?',
      defaultValue: true,
    )) {
      logger.alert(lightYellow.wrap('enter "e" to exit adding parameters'));
      logger.alert('Format: type parameterName e.g, String myParameter:');

      while (true) {
        final parameter =
            logger.prompt(':').replaceAll(RegExp('\\s+'), ' ').trim();
        if (parameter.toLowerCase() == 'e') {
          break;
        }

        if (!parameter.contains(' ')) {
          logger.alert(
              'That was not a valid format -> type parameterName e.g, String myParameter');
          continue;
        }

        if ((parameter.contains('<') && !parameter.contains('>')) ||
            (parameter.contains('>') && !parameter.contains('<'))) {
          logger.alert(
              'It seems you are missing a < or >, please retype this parameter');
          continue;
        }

        final splitParameter = parameter.split(' ');
        final parameterType = splitParameter[0];
        final parameterName = splitParameter[1];
        final hasSpecial = parameterType.toLowerCase().contains('<') ||
            returnType.toLowerCase().contains('>');
        final isNullable = parameterType.toLowerCase().endsWith('?');
        parameters.add({
          'name': parameterName,
          'type': parameterType,
          'hasSpecial': hasSpecial,
          'isNullable': isNullable,
        });
      }
    }

    methods.add({
      'name': methodName,
      'type': returnType,
      'hasSpecial': hasSpecial,
      'isFuture': isFuture,
      'isStream': isStream,
      'hasParameters': parameters.isNotEmpty,
      'parameters': parameters,
    });
    logger.alert('Continue adding methods: enter "e" to exit');
  }
  context.vars = {
    ...context.vars,
    'methods': methods,
  };
}
