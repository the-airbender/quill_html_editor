/// [hasValidUrl] to check if the given string is a valid url
bool hasValidUrl(String value) {
  String pattern =
      r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
