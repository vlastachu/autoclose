final camelCaseRegex = RegExp('(?<=[a-z])[A-Z]');

String camelCaseToFriendlyCase(String camelCase) => camelCase.replaceAllMapped(
    camelCaseRegex, (m) => ' ${m.group(0)}'.toLowerCase());
String camelCaseToSnakeCase(String camelCase) => camelCase
    .replaceAllMapped(camelCaseRegex, (m) => '_${m.group(0)}')
    .toLowerCase();
