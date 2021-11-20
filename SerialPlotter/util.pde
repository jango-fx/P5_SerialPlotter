String[] matchRegex(String string, String regex) {
  final java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(regex);
  final java.util.regex.Matcher matcher = pattern.matcher(string);

  ArrayList<String> matches = new ArrayList<String>();
  while (matcher.find()) {
    if (matcher.group(0).length() > 0)
      matches.add(matcher.group(0));

    for (int i = 1; i <= matcher.groupCount(); i++) {
      matches.add(matcher.group(i));
    }
  }
  return matches.toArray(new String[0]);
}
