public int getRainbowColor(int i)
{
  int red           = color(235, 50, 35);
  int redorange     = color(238, 110, 45);
  int orange        = color(240, 151, 55);
  int yelloworange  = color(247, 200, 68);
  int yellow        = color(255, 255, 84);
  int yellowgreen   = color(153, 195, 60);
  int green         = color(78, 168, 48);
  int bluegreen     = color(70, 160, 190);
  int blue          = color(37, 97, 175);
  int blueviolet    = color(0, 27, 158);
  int violet        = color(88, 24, 158);
  int redviolet     = color(180, 40, 121);

  //color[] rainbow = {red, redorange, orange, yelloworange, yellow, yellowgreen, green, bluegreen, blue, blueviolet, violet, redviolet};
  int[] rainbow = {red, green, blue, yellow, bluegreen, orange, redorange, yelloworange, yellowgreen, blueviolet, violet, redviolet};
  return rainbow[i%12];
}

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
