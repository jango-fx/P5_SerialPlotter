import toxi.color.*;


ArrayList<ColorList> createRainbowRanges(int n, int m)
{
  ColorList list = createRainbow(n);
  return createColorRanges(list, ColorRange.FRESH, m);
}

color getRainbowColor(int i, int n)
{
  return createRainbow(n).get(i).toARGB();
}

ArrayList<ColorList> createColorRanges(ColorList list, ColorRange range, int n)
{
  //range = ColorRange.FRESH;
  ArrayList<ColorList> rainbowLists = new ArrayList<ColorList>();

  if (list.size() > 0)
    for (int i = 0; i < list.size(); i++)
    {
      ColorRange freshColors = ColorRange.FRESH;
      ColorList newColors = freshColors.getColors(list.get(i), n, 0.07);
      if (n>1)
        newColors.sortByDistance(new HSVDistanceProxy(), false);
      rainbowLists.add(newColors);
    }
  return rainbowLists;
}


ColorList createRainbow(int n)
{
  ColorList rainbow = new ColorList();
  for (int i = 0; i <n; i++)
  {
    float step = (1.0/n)*i;
    TColor c = TColor.newHSV(step, 1, 1);
    rainbow.add(c);
  }
  return rainbow;
}


/* deprecated */
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
