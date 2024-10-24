import 'package:cosmic_beacon/data/constants/regex.dart';

extension StringExtension on String {
  List<Uri> extractUris() {
    List<Uri> uris = [];
    RegExp regExp = RegExp(urlRegex);
    List<RegExpMatch> matches = regExp.allMatches(this).toList();
    for (var element in matches) {
      if (element.group(0) != null) {
        uris.add(Uri.parse(element.group(0)!));
      }
    }
    return uris;
  }
}
