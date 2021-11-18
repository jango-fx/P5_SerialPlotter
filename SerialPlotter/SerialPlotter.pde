import processing.serial.*;
import controlP5.*;


ControlP5 cp5;
Chart plotter;

Serial port;
@ControlElement (x=10, y=10, properties = { "value=5.0", "min=-255", "max=255", "type=numberbox"})
  public float maxVal;
@ControlElement (x=10, y=50, properties = { "value=-1.0", "min=-255", "max=255", "type=numberbox"})
  public float minVal;

public void maxVal()
{
  plotter.setRange(minVal, maxVal);
}
public void minVal()
{
  plotter.setRange(minVal, maxVal);
  println(minVal+" / "+maxVal);
}

public void settings() {
  size(600, 400);
}

public void setup () {
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[Serial.list().length-1], 115200);  //
  cp5 = new ControlP5(this);
  cp5.addControllersFor(this);

  plotter = cp5.addChart("Serial Plotter")
    .setPosition(110, 10)
    .setSize(480, 380)
    .setRange(minVal, maxVal)
    .setView(Chart.LINE)
    .setStrokeWeight(1.5f)
    .setColorCaptionLabel(color(40))
    .setColorBackground(color(120, 200, 255, 50))
    ;
}
public void draw () {
  background(0);
}

public void serialEvent (Serial thePort) {
  String inString = thePort.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);              // trim off whitespaces.
    String[] subStrings = inString.split("\\s|;|,");                 // TODO: search for ':' as name-markes

    for (int i = 0; i < subStrings.length; i++)
    {
      try {
        ChartDataSet set = plotter.getDataSet(Integer.toString(i));
        if (set != null)
        {
          plotter.push(Integer.toString(i), PApplet.parseFloat(subStrings[i]));
        } else
        {
          plotter.addDataSet(Integer.toString(i));
          plotter.setData(Integer.toString(i), new float[100]);
          plotter.setColors(Integer.toString(i), getRainbowColor(i));
          plotter.push(Integer.toString(i), PApplet.parseFloat(subStrings[i]));
        }
      }
      catch (Exception e) {
        println(e);
      }
    }

    println(">"+inString+"<");
    printArray(subStrings);
  }
}

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
