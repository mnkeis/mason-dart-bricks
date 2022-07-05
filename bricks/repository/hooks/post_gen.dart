import 'dart:io';

import 'package:mason/mason.dart';
import 'package:recase/recase.dart';

final dataTypes = [
  'void',
  'String',
  'num',
  'int',
  'double',
  'bool',
  'List',
  'Map',
  'dynamic',
  'Set',
  'DateTime',
];

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final modelGenerator = await MasonGenerator.fromBundle(modelBundle);
  final types = Set<String>();

  final repository_name = context.vars['repository_name'] as String;

  if (context.vars.containsKey('methods') &&
      context.vars['methods'] is Iterable) {
    final methods = context.vars['methods'] as Iterable;

    for (final method in methods) {
      if (method is Map<String, dynamic> && method.containsKey('type')) {
        final type = method['type'] as String;
        _addType(types: types, type: type);
        if (method.containsKey('parameters') &&
            method['parameters'] is Iterable) {
          final parameters = method['parameters'] as Iterable;
          for (final parameter in parameters) {
            if (parameter is Map<String, dynamic> &&
                parameter.containsKey('type')) {
              final type = parameter['type'] as String;
              _addType(types: types, type: type);
            }
          }
        }
      }
    }
  }

  final modelsDirectory = Directory.fromUri(Uri.directory(
      '${Directory.current.path}/${repository_name.snakeCase}_api/lib/src/models'));
  final barrelFile = File.fromUri(
    Uri.file('${modelsDirectory.path}/models.dart'),
  );
  types.forEach((element) async {
    if (!dataTypes.contains(element)) {
      logger
          .alert(lightYellow.wrap('You are using a custom dataType $element'));
      if (logger.confirm(
        '? Do you want to create its model?',
        defaultValue: true,
      )) {
        logger.alert('Creating model class for $element');
        try {
          var vars = <String, dynamic>{
            'model_name': element,
            'use_copywith': true,
            'use_equatable': true,
            'use_json': true,
          };
          await modelGenerator.hooks.preGen(
            vars: vars,
            onVarsChanged: (v) => vars = v,
          );
          await modelGenerator.generate(
            DirectoryGeneratorTarget(modelsDirectory),
            vars: vars,
            logger: logger,
          );
          await barrelFile.writeAsString(
            'export \'${element.snakeCase}.dart\';',
            mode: FileMode.append,
          );
        } catch (e) {
          logger.err(e.toString());
        }
      }
    }
  });
}

void _addType({required Set<String> types, required String type}) {
  final primitive = type.contains('<') || type.contains('>')
      ? type.substring(type.lastIndexOf('<') + 1, type.indexOf('>'))
      : type;
  types.add(primitive.replaceAll('?', '').trim());
}

final modelBundle = MasonBundle.fromJson(<String, dynamic>{
  "files": [
    {
      "path": "{{#use_json}}{{model_name.snakeCase()}}.g.dart{{\\use_json}}",
      "data":
          "cGFydCBvZiAne3ttb2RlbF9uYW1lLnNuYWtlQ2FzZSgpfX0uZGFydCc7DQoNCnt7bW9kZWxfbmFtZS5wYXNjYWxDYXNlKCl9fSBfJHt7bW9kZWxfbmFtZS5wYXNjYWxDYXNlKCl9fUZyb21Kc29uKE1hcDxTdHJpbmcsIGR5bmFtaWM+IGpzb24pID0+IHt7bW9kZWxfbmFtZS5wYXNjYWxDYXNlKCl9fSh7eyNwcm9wZXJ0aWVzfX0NCiAgICAgIHt7bmFtZX19OiB7eyNpc0N1c3RvbUxpc3R9fShqc29uWyd7e25hbWV9fSddIGFzIExpc3Q8ZHluYW1pYz4pLm1hcCgoZHluYW1pYyBlKSA9PiB7e2N1c3RvbUxpc3RUeXBlfX0uZnJvbUpzb24oZSBhcyBNYXA8U3RyaW5nLCBkeW5hbWljPikpLnRvTGlzdCgpe3svaXNDdXN0b21MaXN0fX17e15pc0N1c3RvbUxpc3R9fXt7I2lzQ3VzdG9tRGF0YVR5cGV9fXt7dHlwZX19LmZyb21Kc29uKGpzb25bJ3t7bmFtZX19J10gYXMgTWFwPFN0cmluZywgZHluYW1pYz4pe3svaXNDdXN0b21EYXRhVHlwZX19e3teaXNDdXN0b21EYXRhVHlwZX19anNvblsne3tuYW1lfX0nXSBhcyB7eyNoYXNTcGVjaWFsfX17e3t0eXBlfX19e3svaGFzU3BlY2lhbH19e3teaGFzU3BlY2lhbH19e3t0eXBlfX17ey9oYXNTcGVjaWFsfX17ey9pc0N1c3RvbURhdGFUeXBlfX17ey9pc0N1c3RvbUxpc3R9fSx7ey9wcm9wZXJ0aWVzfX0NCiAgICApOw0KDQpNYXA8U3RyaW5nLCBkeW5hbWljPiBfJHt7bW9kZWxfbmFtZS5wYXNjYWxDYXNlKCl9fVRvSnNvbih7e21vZGVsX25hbWUucGFzY2FsQ2FzZSgpfX0gaW5zdGFuY2UpID0+IDxTdHJpbmcsIGR5bmFtaWM+eyB7eyNwcm9wZXJ0aWVzfX0NCiAgICAgICd7e25hbWV9fSc6IGluc3RhbmNlLnt7bmFtZX19LHt7L3Byb3BlcnRpZXN9fQ0KICAgIH07",
      "type": "text"
    },
    {
      "path": "{{model_name.snakeCase()}}.dart",
      "data":
          "e3sjdXNlX2VxdWF0YWJsZX19aW1wb3J0ICdwYWNrYWdlOmVxdWF0YWJsZS9lcXVhdGFibGUuZGFydCc7e3svdXNlX2VxdWF0YWJsZX19e3sjdXNlX2pzb259fQ0KDQpwYXJ0ICd7e21vZGVsX25hbWUuc25ha2VDYXNlKCl9fS5nLmRhcnQnO3t7L3VzZV9qc29ufX0NCg0KLy8vIHtAdGVtcGxhdGUge3t7bW9kZWxfbmFtZS5zbmFrZUNhc2UoKX19fX0NCi8vLyB7e21vZGVsX25hbWUucGFzY2FsQ2FzZSgpfX0gZGVzY3JpcHRpb24NCi8vLyB7QGVuZHRlbXBsYXRlfQ0KY2xhc3Mge3ttb2RlbF9uYW1lLnBhc2NhbENhc2UoKX19e3sjdXNlX2VxdWF0YWJsZX19IGV4dGVuZHMgRXF1YXRhYmxle3svdXNlX2VxdWF0YWJsZX19IHsNCiAgLy8vIHtAbWFjcm8ge3t7bW9kZWxfbmFtZS5zbmFrZUNhc2UoKX19fX0NCiAgY29uc3Qge3ttb2RlbF9uYW1lLnBhc2NhbENhc2UoKX19KHt7I2hhc1Byb3BlcnRpZXN9fXsge3sjcHJvcGVydGllc319DQogICAgcmVxdWlyZWQgdGhpcy57e25hbWV9fSx7ey9wcm9wZXJ0aWVzfX0NCiAgfXt7L2hhc1Byb3BlcnRpZXN9fSk7e3sjdXNlX2pzb259fQ0KDQogIC8vLyBDcmVhdGVzIGEge3ttb2RlbF9uYW1lLnBhc2NhbENhc2UoKX19IGZyb20gSnNvbiBtYXANCiAgZmFjdG9yeSB7e21vZGVsX25hbWUucGFzY2FsQ2FzZSgpfX0uZnJvbUpzb24oTWFwPFN0cmluZywgZHluYW1pYz4gZGF0YSkgPT4gXyR7e21vZGVsX25hbWUucGFzY2FsQ2FzZSgpfX1Gcm9tSnNvbihkYXRhKTt7ey91c2VfanNvbn19DQp7eyNwcm9wZXJ0aWVzfX0NCiAgLy8vIEEgZGVzY3JpcHRpb24gZm9yIHt7bmFtZX19DQogIGZpbmFsIHt7I2hhc1NwZWNpYWx9fXt7e3R5cGV9fX17ey9oYXNTcGVjaWFsfX17e15oYXNTcGVjaWFsfX17e3R5cGV9fXt7L2hhc1NwZWNpYWx9fSB7e25hbWV9fTt7ey9wcm9wZXJ0aWVzfX0NCnt7I3VzZV9jb3B5d2l0aH19DQogIC8vLyBDcmVhdGVzIGEgY29weSBvZiB0aGUgY3VycmVudCB7e21vZGVsX25hbWUucGFzY2FsQ2FzZSgpfX0gd2l0aCBwcm9wZXJ0eSBjaGFuZ2VzDQogIHt7bW9kZWxfbmFtZS5wYXNjYWxDYXNlKCl9fSBjb3B5V2l0aCh7eyNoYXNQcm9wZXJ0aWVzfX17IHt7I3Byb3BlcnRpZXN9fQ0KICAgIHt7I2hhc1NwZWNpYWx9fXt7e3R5cGV9fX17ey9oYXNTcGVjaWFsfX17e15oYXNTcGVjaWFsfX17e3R5cGV9fXt7L2hhc1NwZWNpYWx9fT8ge3tuYW1lfX0se3svcHJvcGVydGllc319DQogIH17ey9oYXNQcm9wZXJ0aWVzfX0pIHsNCiAgICByZXR1cm4ge3ttb2RlbF9uYW1lLnBhc2NhbENhc2UoKX19KHt7I3Byb3BlcnRpZXN9fQ0KICAgICAge3tuYW1lfX06IHt7bmFtZX19ID8/IHRoaXMue3tuYW1lfX0se3svcHJvcGVydGllc319DQogICAgKTsNCiAgfXt7L3VzZV9jb3B5d2l0aH19DQogIHt7I3VzZV9lcXVhdGFibGV9fQ0KICBAb3ZlcnJpZGUNCiAgTGlzdDxPYmplY3Q/PiBnZXQgcHJvcHMgPT4gW3t7I3Byb3BlcnRpZXN9fQ0KICAgICAgICB7e25hbWV9fSx7ey9wcm9wZXJ0aWVzfX0NCiAgICAgIF07DQp7ey91c2VfZXF1YXRhYmxlfX17eyN1c2VfanNvbn19DQogIC8vLyBDcmVhdGVzIGEgSnNvbiBtYXAgZnJvbSBhIHt7bW9kZWxfbmFtZS5wYXNjYWxDYXNlKCl9fQ0KICBNYXA8U3RyaW5nLCBkeW5hbWljPiB0b0pzb24oKSA9PiBfJHt7bW9kZWxfbmFtZS5wYXNjYWxDYXNlKCl9fVRvSnNvbih0aGlzKTt7ey91c2VfanNvbn19DQp9DQo=",
      "type": "text"
    }
  ],
  "hooks": [
    {
      "path": "pre_gen.dart",
      "data":
          "aW1wb3J0ICdwYWNrYWdlOm1hc29uL21hc29uLmRhcnQnOwoKZmluYWwgZGF0YVR5cGVzID0gWwogICdTdHJpbmcnLAogICdudW0nLAogICdpbnQnLAogICdkb3VibGUnLAogICdib29sJywKICAnTGlzdCcsCiAgJ01hcCcsCiAgJ2R5bmFtaWMnLAogICdTZXQnLAogICdEYXRlVGltZScsCl07Cgp2b2lkIHJ1bihIb29rQ29udGV4dCBjb250ZXh0KSB7CiAgZmluYWwgbG9nZ2VyID0gY29udGV4dC5sb2dnZXI7CgogIGlmICghbG9nZ2VyLmNvbmZpcm0oCiAgICAnPyBEbyB5b3Ugd2FudCB0byBhZGQgcHJvcGVydGllcyB0byB5b3VyIG1vZGVsPycsCiAgICBkZWZhdWx0VmFsdWU6IHRydWUsCiAgKSkgewogICAgY29udGV4dC52YXJzID0gewogICAgICAuLi5jb250ZXh0LnZhcnMsCiAgICAgICdoYXNQcm9wZXJ0aWVzJzogZmFsc2UsCiAgICB9OwogICAgcmV0dXJuOwogIH0KCiAgbG9nZ2VyLmFsZXJ0KGxpZ2h0WWVsbG93LndyYXAoJ2VudGVyICJlIiB0byBleGl0IGFkZGluZyBwcm9wZXJ0aWVzJykpOwogIGxvZ2dlci5hbGVydCgnRm9ybWF0OiBkYXRhVHlwZSBwcm9wZXJ0eU5hbWUgZS5nLCBTdHJpbmcgbXlQcm9wZXJ0eTonKTsKICBmaW5hbCBwcm9wZXJ0aWVzID0gPE1hcDxTdHJpbmcsIGR5bmFtaWM+PltdOwoKICB3aGlsZSAodHJ1ZSkgewogICAgZmluYWwgcHJvcGVydHkgPSBsb2dnZXIucHJvbXB0KCc6JykucmVwbGFjZUFsbChSZWdFeHAoJ1xccysnKSwgJyAnKS50cmltKCk7CiAgICBpZiAocHJvcGVydHkudG9Mb3dlckNhc2UoKSA9PSAnZScpIHsKICAgICAgYnJlYWs7CiAgICB9CgogICAgaWYgKCFwcm9wZXJ0eS5jb250YWlucygnICcpKSB7CiAgICAgIGxvZ2dlci5hbGVydCgKICAgICAgICAgICdUaGF0IHdhcyBub3QgYSB2YWxpZCBmb3JtYXQgLT4gZGF0YVR5cGUgcHJvcGVydHlOYW1lIGUuZywgU3RyaW5nIG15UHJvcGVydHknKTsKICAgICAgY29udGludWU7CiAgICB9CgogICAgaWYgKChwcm9wZXJ0eS5jb250YWlucygnPCcpICYmICFwcm9wZXJ0eS5jb250YWlucygnPicpKSB8fAogICAgICAgIChwcm9wZXJ0eS5jb250YWlucygnPicpICYmICFwcm9wZXJ0eS5jb250YWlucygnPCcpKSkgewogICAgICBsb2dnZXIuYWxlcnQoCiAgICAgICAgICAnSXQgc2VlbXMgeW91IGFyZSBtaXNzaW5nIGEgPCBvciA+LCBwbGVhc2UgcmV0eXBlIHRoaXMgcHJvcGVydHknKTsKICAgICAgY29udGludWU7CiAgICB9CgogICAgZmluYWwgc3BsaXRQcm9wZXJ0eSA9IHByb3BlcnR5LnNwbGl0KCcgJyk7CiAgICBmaW5hbCBwcm9wZXJ0eVR5cGUgPSBzcGxpdFByb3BlcnR5WzBdOwogICAgZmluYWwgcHJvcGVydHlOYW1lID0gc3BsaXRQcm9wZXJ0eVsxXTsKICAgIGZpbmFsIGhhc1NwZWNpYWwgPSBwcm9wZXJ0eVR5cGUudG9Mb3dlckNhc2UoKS5jb250YWlucygnPCcpIHx8CiAgICAgICAgcHJvcGVydHlUeXBlLnRvTG93ZXJDYXNlKCkuY29udGFpbnMoJz4nKTsKICAgIGZpbmFsIGxpc3RQcm9wZXJ0aWVzID0gX2dldEN1c3RvbUxpc3RQcm9wZXJ0aWVzKGhhc1NwZWNpYWwsIHByb3BlcnR5VHlwZSk7CiAgICBmaW5hbCBpc0N1c3RvbURhdGFUeXBlID0gIWRhdGFUeXBlcy5jb250YWlucyhwcm9wZXJ0eVR5cGUpICYmICFoYXNTcGVjaWFsOwogICAgcHJvcGVydGllcy5hZGQoewogICAgICAnbmFtZSc6IHByb3BlcnR5TmFtZSwKICAgICAgJ3R5cGUnOiBwcm9wZXJ0eVR5cGUsCiAgICAgICdoYXNTcGVjaWFsJzogaGFzU3BlY2lhbCwKICAgICAgJ2lzQ3VzdG9tRGF0YVR5cGUnOiBpc0N1c3RvbURhdGFUeXBlLAogICAgICAuLi5saXN0UHJvcGVydGllcywKICAgIH0pOwogIH0KICBjb250ZXh0LnZhcnMgPSB7CiAgICAuLi5jb250ZXh0LnZhcnMsCiAgICAncHJvcGVydGllcyc6IHByb3BlcnRpZXMsCiAgICAnaGFzUHJvcGVydGllcyc6IHByb3BlcnRpZXMuaXNOb3RFbXB0eSwKICB9Owp9CgpNYXA8U3RyaW5nLCBkeW5hbWljPiBfZ2V0Q3VzdG9tTGlzdFByb3BlcnRpZXMoCiAgYm9vbCBoYXNTcGVjaWFsLAogIFN0cmluZyBwcm9wZXJ0eVR5cGUsCikgewogIGlmICghaGFzU3BlY2lhbCB8fCAhcHJvcGVydHlUeXBlLmNvbnRhaW5zKCdMaXN0JykpIHsKICAgIHJldHVybiB7CiAgICAgICdpc0N1c3RvbUxpc3QnOiBmYWxzZSwKICAgIH07CiAgfQogIGZpbmFsIHN0YXJ0SW5kZXggPSBwcm9wZXJ0eVR5cGUuaW5kZXhPZignPCcpOwogIGZpbmFsIGVuZEluZGV4ID0gcHJvcGVydHlUeXBlLmluZGV4T2YoJz4nKTsKICBmaW5hbCBsaXN0VHlwZSA9IHByb3BlcnR5VHlwZS5zdWJzdHJpbmcoc3RhcnRJbmRleCArIDEsIGVuZEluZGV4KS50cmltKCk7CiAgaWYgKGRhdGFUeXBlcy5jb250YWlucyhsaXN0VHlwZSkpIHsKICAgIHJldHVybiB7CiAgICAgICdpc0N1c3RvbUxpc3QnOiBmYWxzZSwKICAgIH07CiAgfQogIHJldHVybiB7CiAgICAnaXNDdXN0b21MaXN0JzogdHJ1ZSwKICAgICdjdXN0b21MaXN0VHlwZSc6IGxpc3RUeXBlLAogIH07Cn0K",
      "type": "text"
    },
    {
      "path": "pubspec.yaml",
      "data":
          "bmFtZTogbW9kZWxfaG9va3MKCmVudmlyb25tZW50OgogIHNkazogIj49Mi4xMi4wIDwzLjAuMCIKCmRlcGVuZGVuY2llczoKICBtYXNvbjogXjAuMS4wLWRldgo=",
      "type": "text"
    }
  ],
  "name": "model",
  "description":
      "A brick to create your model with properties and all the supporting methods, copyWith, to/from json, equatable and more!",
  "version": "0.3.7",
  "environment": {"mason": "any"},
  "repository":
      "https://github.com/LukeMoody01/mason_bricks/tree/main/bricks/model",
  "readme": {
    "path": "README.md",
    "data":
        "IyBNb2RlbA0KDQpBIGJyaWNrIHRvIGNyZWF0ZSB5b3VyIG1vZGVsIHdpdGggcHJvcGVydGllcyBhbmQgYWxsIHRoZSBzdXBwb3J0aW5nIG1ldGhvZHMsIGNvcHlXaXRoLCB0by9mcm9tIGpzb24sIGVxdWF0YWJsZSBhbmQgbW9yZSENCg0KVGhpcyBicmljayBzdXBwb3J0cyBjdXN0b20gdHlwZXMgYW5kIGN1c3RvbSBsaXN0cyENCg0KIyMgSG93IHRvIHVzZSDwn5qADQoNCmBgYA0KbWFzb24gbWFrZSBtb2RlbCAtLW1vZGVsX25hbWUgdXNlciAtLXVzZV9jb3B5d2l0aCB0cnVlIC0tdXNlX2VxdWF0YWJsZSB0cnVlIC0tdXNlX2pzb24gdHJ1ZQ0KYGBgDQoNCiMjIFZhcmlhYmxlcyDinKgNCg0KfCBWYXJpYWJsZSAgICAgICAgIHwgRGVzY3JpcHRpb24gICAgICAgICAgICAgICAgICAgICAgfCBEZWZhdWx0IHwgVHlwZSAgICAgIHwNCnwgLS0tLS0tLS0tLS0tLS0tLSB8IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIHwgLS0tLS0tLSB8IC0tLS0tLS0tLSB8DQp8IGBtb2RlbF9uYW1lYCAgICAgfCBUaGUgbmFtZSBvZiB0aGUgbW9kZWwgICAgICAgICAgICB8IG1vZGVsICAgfCBgc3RyaW5nYCAgfA0KfCBgdXNlX2NvcHl3aXRoYCAgIHwgQ3JlYXRlIGNvcHlXaXRoIG1ldGhvZCAgICAgICAgICAgfCB0cnVlICAgIHwgYGJvb2xlYW5gIHwNCnwgYHVzZV9lcXVhdGFibGVgICB8IENyZWF0ZXMgdGhlIGVxdWF0YWJsZSBvdmVyaWRlICAgIHwgdHJ1ZSAgICB8IGBib29sZWFuYCB8DQp8IGB1c2VfanNvbmAgICAgICAgfCBDcmVhdGVzIHRoZSBmcm9tL3RvIGpzb24gbWV0aG9kcyB8IHRydWUgICAgfCBgYm9vbGVhbmAgfA0KfCBgYWRkX3Byb3BlcnRpZXNgIHwgQWRkIHByb3BlcnRpZXMgICAgICAgICAgICAgICAgICAgfCB0cnVlICAgIHwgYGJvb2xlYW5gIHwNCg0KIyMgT3V0cHV0cyDwn5OmDQoNCmBgYA0KLS1tb2RlbF9uYW1lIHVzZXIgLS11c2VfY29weXdpdGggdHJ1ZSAtLXVzZV9lcXVhdGFibGUgdHJ1ZSAtLXVzZV9qc29uIHRydWUNCuKUnOKUgOKUgCB1c2VyLmRhcnQNCuKUnOKUgOKUgCB1c2VyLmcuZGFydA0K4pSU4pSA4pSAIC4uLg0KYGBgDQoNCmBgYGRhcnQNCmltcG9ydCAncGFja2FnZTplcXVhdGFibGUvZXF1YXRhYmxlLmRhcnQnOw0KDQpwYXJ0ICd1c2VyLmcuZGFydCc7DQoNCi8vLyB7QHRlbXBsYXRlIHVzZXJ9DQovLy8gVXNlciBkZXNjcmlwdGlvbg0KLy8vIHtAZW5kdGVtcGxhdGV9DQpjbGFzcyBVc2VyIGV4dGVuZHMgRXF1YXRhYmxlIHsNCiAgLy8vIHtAbWFjcm8gdXNlcn0NCiAgY29uc3QgVXNlcih7DQogICAgcmVxdWlyZWQgdGhpcy5uYW1lLA0KICAgIHJlcXVpcmVkIHRoaXMuZmFtaWx5TWVtYmVycywNCiAgICByZXF1aXJlZCB0aGlzLmZhbWlseSwNCiAgfSk7DQoNCiAgLy8vIENyZWF0ZXMgYSBVc2VyIGZyb20gSnNvbiBtYXANCiAgZmFjdG9yeSBVc2VyLmZyb21Kc29uKE1hcDxTdHJpbmcsIGR5bmFtaWM+IGRhdGEpID0+IF8kVXNlckZyb21Kc29uKGRhdGEpOw0KDQogIC8vLyBBIGRlc2NyaXB0aW9uIGZvciBuYW1lDQogIGZpbmFsIFN0cmluZyBuYW1lOw0KDQogIC8vLyBBIGRlc2NyaXB0aW9uIGZvciBmYW1pbHlNZW1iZXJzDQogIGZpbmFsIExpc3Q8VXNlcj4gZmFtaWx5TWVtYmVyczsNCg0KICAvLy8gQSBkZXNjcmlwdGlvbiBmb3IgZmFtaWx5DQogIGZpbmFsIEZhbWlseSBmYW1pbHk7DQoNCiAgLy8vIENyZWF0ZXMgYSBjb3B5IG9mIHRoZSBjdXJyZW50IFVzZXIgd2l0aCBwcm9wZXJ0eSBjaGFuZ2VzDQogIFVzZXIgY29weVdpdGgoew0KICAgIFN0cmluZz8gbmFtZSwNCiAgICBMaXN0PFVzZXI+PyBmYW1pbHlNZW1iZXJzLA0KICAgIEZhbWlseT8gZmFtaWx5LA0KICB9KSB7DQogICAgcmV0dXJuIFVzZXIoDQogICAgICBuYW1lOiBuYW1lID8/IHRoaXMubmFtZSwNCiAgICAgIGZhbWlseU1lbWJlcnM6IGZhbWlseU1lbWJlcnMgPz8gdGhpcy5mYW1pbHlNZW1iZXJzLA0KICAgICAgZmFtaWx5OiBmYW1pbHkgPz8gdGhpcy5mYW1pbHksDQogICAgKTsNCiAgfQ0KDQogIEBvdmVycmlkZQ0KICBMaXN0PE9iamVjdD8+IGdldCBwcm9wcyA9PiBbDQogICAgICAgIG5hbWUsDQogICAgICAgIGZhbWlseU1lbWJlcnMsDQogICAgICAgIGZhbWlseSwNCiAgICAgIF07DQoNCiAgLy8vIENyZWF0ZXMgYSBKc29uIG1hcCBmcm9tIGEgVXNlcg0KICBNYXA8U3RyaW5nLCBkeW5hbWljPiB0b0pzb24oKSA9PiBfJFVzZXJUb0pzb24odGhpcyk7DQp9DQoNCi8vdXNlci5nLmRhcnQNCnBhcnQgb2YgJ3VzZXIuZGFydCc7DQoNClVzZXIgXyRVc2VyRnJvbUpzb24oTWFwPFN0cmluZywgZHluYW1pYz4ganNvbikgPT4gVXNlcigNCiAgICAgIG5hbWU6IGpzb25bJ25hbWUnXSBhcyBTdHJpbmcsDQogICAgICBmYW1pbHlNZW1iZXJzOiAoanNvblsnZmFtaWx5TWVtYmVycyddIGFzIExpc3Q8ZHluYW1pYz4pDQogICAgICAgICAgLm1hcCgoZSkgPT4gVXNlci5mcm9tSnNvbihlIGFzIE1hcDxTdHJpbmcsIGR5bmFtaWM+KSkNCiAgICAgICAgICAudG9MaXN0KCksDQogICAgICBmYW1pbHk6IEZhbWlseS5mcm9tSnNvbihqc29uWydmYW1pbHknXSBhcyBNYXA8U3RyaW5nLCBkeW5hbWljPiksDQogICAgKTsNCg0KTWFwPFN0cmluZywgZHluYW1pYz4gXyRVc2VyVG9Kc29uKFVzZXIgaW5zdGFuY2UpID0+IDxTdHJpbmcsIGR5bmFtaWM+ew0KICAgICAgJ25hbWUnOiBpbnN0YW5jZS5uYW1lLA0KICAgICAgJ2ZhbWlseU1lbWJlcnMnOiBpbnN0YW5jZS5mYW1pbHlNZW1iZXJzLA0KICAgICAgJ2ZhbWlseSc6IGluc3RhbmNlLmZhbWlseSwNCiAgICB9Ow0KDQpgYGANCg==",
    "type": "text"
  },
  "changelog": {
    "path": "CHANGELOG.md",
    "data":
        "IyAwLjMuNwoKLSBmZWF0OiBDaGFuZ2UgbW9kZWwgZm9ybWF0IHRvIHNwbGl0IG9uICcgJyBpbnN0ZWFkIG9mICcvJyBtYWtpbmcgaXQgZWFzaWVyIGZvciBkZXZlbG9wZXJzIHRvIHR5cGUgcHJvcGVydGllcwoKIyAwLjMuNgoKLSBjaG9yZTogQWRkIGRvY3VtZW50YXRpb24gdG8gcmVmbGVjdCBuZXcgbW9kZWwgZ2VuZXJhdGlvbgoKIyAwLjMuNQoKLSBmZWF0OiBBZGQgZG9jdW1lbnRhdGlvbiBmb3IgZ2VuZXJhdGVkIG1vZGVsCgojIDAuMy40CgotIGZpeDogQWxsb3cgbm8gcHJvcHJldGllcyB0byBiZSBhZGRlZCB3aXRob3V0IGVycm9ycwoKIyAwLjMuMwoKLSBjaG9yZTogU21hbGwgZG9jdW1lbnRhdGlvbiBjaGFuZ2VzCgojIDAuMy4yCgotIGNob3JlOiBVcGRhdGUgYWxlcnQgbWVzc2FnZSB0byByZWZsZWN0IG5ldyB0eXBlL25hbWUgY2hhbmdlcyAoTGFzdCB2ZXJzaW9uIGRpZCBub3QgdXBkYXRlKQoKIyAwLjMuMQoKLSBjaG9yZTogVXBkYXRlIGFsZXJ0IG1lc3NhZ2UgdG8gcmVmbGVjdCBuZXcgdHlwZS9uYW1lIGNoYW5nZXMKLSBjaG9yZTogU21hbGwgdXBkYXRlcyB0byBwcm9wZXJ0eSBjaGVja2luZwoKIyAwLjMuMAoKLSBmZWF0OiBTdXBwb3J0IEN1c3RvbSBMaXN0IFR5cGVzIGZvciB0by9mcm9tSnNvbgoKIyAwLjIuMQoKLSBmaXg6IFJlbW92ZSBleHRyYSAuZGFydCBzdWZmaXggb24gZ2VuZXJhdGVkIGZpbGUKCiMgMC4yLjAKCi0gZml4OiB0b0pzb24gdHlwbyBmaXhlZAotIGZlYXQ6IFN1cHBvcnQgY3VzdG9tIHR5cGVzIGluIHRvL2Zyb20gSnNvbgotIGZlYXQ6IFVwZGF0ZSBhbGwgcHJvcGVydGllcyB0byBiZSByZXF1aXJlZCBuYW1lcyBwYXJhbWV0ZXJzIGFzIHN0YW5kYXJkCgojIDAuMS4yCgotIGZlYXQ6IFN1cHBvcnQgdHlwZXMgd2l0aCBzb21lIHR5cGUgcGFyYW1ldGVycyB3aGVuIGNyZWF0aW5nIGEgbW9kZWwKLSBjaG9yZTogdXBkYXRlIHByZV9nZW4uZGFydCBmb3IgcmVhZGFiaWxpdHkKCiMgMC4xLjEKCi0gZml4OiBSZW1vdmUgZXh0cmEgLmRhcnQgc3VmZml4IG9uIGdlbmVyYXRlZCBmaWxlCgojIDAuMS4wCgotIGZlYXQ6IFN1cHBvcnQgTGlzdCB0eXBlcyB3aGVuIGNyZWF0aW5nIGEgbW9kZWwKLSBmZWF0OiBBbGxvdyB1bmxpbWl0ZWQgcHJvcGVydGllcyB0byBiZSBhZGRlZAotIGZlYXQ6IEFkZCBzaW1wbGUgZm9ybWF0IGNoZWNraW5nCi0gY2xlYW51cDogTWFqb3IgY2xlYW51cCBvbiBicmljawoKIyAwLjAuMwoKLSBVcGRhdGUgcHJvcGVydHkgbGltaXQgdG8gMTUKLSBVcGRhdGUgcm9hZG1hcCBkb2N1bWVudGF0aW9uCgojIDAuMC4yCgotIFVwZGF0ZSBkb2N1bWVudGF0aW9uCgojIDAuMC4xCgotIENyZWF0ZSBpbml0aWFsIE1vZGVsIEJyaWNrCg==",
    "type": "text"
  },
  "license": {
    "path": "LICENSE",
    "data":
        "TUlUIExpY2Vuc2UKCkNvcHlyaWdodCAoYykgMjAyMiBMdWtlIE1vb2R5CgpQZXJtaXNzaW9uIGlzIGhlcmVieSBncmFudGVkLCBmcmVlIG9mIGNoYXJnZSwgdG8gYW55IHBlcnNvbiBvYnRhaW5pbmcgYSBjb3B5Cm9mIHRoaXMgc29mdHdhcmUgYW5kIGFzc29jaWF0ZWQgZG9jdW1lbnRhdGlvbiBmaWxlcyAodGhlICJTb2Z0d2FyZSIpLCB0byBkZWFsCmluIHRoZSBTb2Z0d2FyZSB3aXRob3V0IHJlc3RyaWN0aW9uLCBpbmNsdWRpbmcgd2l0aG91dCBsaW1pdGF0aW9uIHRoZSByaWdodHMKdG8gdXNlLCBjb3B5LCBtb2RpZnksIG1lcmdlLCBwdWJsaXNoLCBkaXN0cmlidXRlLCBzdWJsaWNlbnNlLCBhbmQvb3Igc2VsbApjb3BpZXMgb2YgdGhlIFNvZnR3YXJlLCBhbmQgdG8gcGVybWl0IHBlcnNvbnMgdG8gd2hvbSB0aGUgU29mdHdhcmUgaXMKZnVybmlzaGVkIHRvIGRvIHNvLCBzdWJqZWN0IHRvIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoKClRoZSBhYm92ZSBjb3B5cmlnaHQgbm90aWNlIGFuZCB0aGlzIHBlcm1pc3Npb24gbm90aWNlIHNoYWxsIGJlIGluY2x1ZGVkIGluIGFsbApjb3BpZXMgb3Igc3Vic3RhbnRpYWwgcG9ydGlvbnMgb2YgdGhlIFNvZnR3YXJlLgoKVEhFIFNPRlRXQVJFIElTIFBST1ZJREVEICJBUyBJUyIsIFdJVEhPVVQgV0FSUkFOVFkgT0YgQU5ZIEtJTkQsIEVYUFJFU1MgT1IKSU1QTElFRCwgSU5DTFVESU5HIEJVVCBOT1QgTElNSVRFRCBUTyBUSEUgV0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFksCkZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFIEFORCBOT05JTkZSSU5HRU1FTlQuIElOIE5PIEVWRU5UIFNIQUxMIFRIRQpBVVRIT1JTIE9SIENPUFlSSUdIVCBIT0xERVJTIEJFIExJQUJMRSBGT1IgQU5ZIENMQUlNLCBEQU1BR0VTIE9SIE9USEVSCkxJQUJJTElUWSwgV0hFVEhFUiBJTiBBTiBBQ1RJT04gT0YgQ09OVFJBQ1QsIFRPUlQgT1IgT1RIRVJXSVNFLCBBUklTSU5HIEZST00sCk9VVCBPRiBPUiBJTiBDT05ORUNUSU9OIFdJVEggVEhFIFNPRlRXQVJFIE9SIFRIRSBVU0UgT1IgT1RIRVIgREVBTElOR1MgSU4gVEhFClNPRlRXQVJFLgo=",
    "type": "text"
  },
  "vars": {
    "model_name": {
      "type": "string",
      "description": "The model name",
      "default": "model",
      "prompt": "What is the models name?"
    },
    "use_copywith": {
      "type": "boolean",
      "description": "Has copyWith method",
      "default": true,
      "prompt": "Does this model have a copyWith method?"
    },
    "use_equatable": {
      "type": "boolean",
      "description": "Has equatable",
      "default": true,
      "prompt": "Does this model use equatable?"
    },
    "use_json": {
      "type": "boolean",
      "description": "Has Json methods",
      "default": true,
      "prompt": "Does this model use json?"
    }
  }
});
