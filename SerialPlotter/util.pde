void checkSerial()
{
  String inString = port.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);
    if (verbose) println("[Serial]: "+inString+"");
    parseData(inString);
  }
}

void saveChartDataToFile(Chart theChart, String fileName)
{
  java.util.LinkedHashMap<java.lang.String, ChartDataSet> data = theChart.getDataSet();
  java.util.Set<String> keys = data.keySet();

  String[] lines = new String[data.size()];
  int i=0;
  for (String key : keys) {
    String name = key;
    ChartDataSet entry = data.get(key);
    float[] values = entry.getValues();

    lines[i] = name;
    for (int j = 0; j < values.length; j++)
    {
      lines[i] += ";" + values[j];
    }
    i++;
  }
  saveStrings(fileName, lines);
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

String getTime() {
  return new java.text.SimpleDateFormat("yyMMdd-HHmmss", java.util.Locale.GERMANY).format(new java.util.Date());
}

private static final java.text.DecimalFormat df = new java.text.DecimalFormat("0.00");
