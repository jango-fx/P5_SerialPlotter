import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
Chart plotter;
ScrollableList baudDropdown;
ScrollableList portDropdown;

int windowWidth, windowHeight;

Serial port;
int baudRate=115200;
String[] baudRates = {"300", "600", "1200", "2400", "4800", "9600", "14400", "19200", "28800", "31250", "38400", "57600", "115200"};

@ControlElement (x=10, y=50, properties = {"width=70", "value=#", "isLock=true"})
  public String lineHeaderPattern="#";
@ControlElement (x=10, y=90, properties = {"width=70", "value=, ;"})
  public String valueNamePattern=", ;:";
@ControlElement (x=10, y=150, properties = { "value=5.0", "min=-255", "max=255", "type=numberbox"})
  public float maxVal;
@ControlElement (x=10, y=190, properties = { "value=-1.0", "min=-255", "max=255", "type=numberbox"})
  public float minVal;

/* // DROPDOWN ANNOTATION EXAMPLE
@ControlElement (properties = { "width=200", "type=dropdown", "items=hello,world,how,is it,going"}, x=100, y=150, label="Track")
 public void setTrack(int val) {
 println("track : " + val);
 }
*/

public void settings() {
  size(600, 400);
}

public void setup () {
  cp5 = new ControlP5(this);
  cp5.addControllersFor(this);
  plotter = cp5.addChart("Serial Plotter");
  portDropdown = cp5.addScrollableList("serialPorts");
  baudDropdown = cp5.addScrollableList("baudRate");
  // TODO: implement line headers
  cp5.getController("lineHeaderPattern").setColorForeground(color(255,50));
  cp5.getController("lineHeaderPattern").setColorBackground(color(255,20));
  cp5.getController("lineHeaderPattern").setColorLabel(color(50,50));
  cp5.getController("lineHeaderPattern").setColorValue(color(50,50));
  cp5.getController("lineHeaderPattern").lock(); 

  updateUI();

  surface.setResizable(true);
  registerMethod("pre", this);

  printArray(Serial.list());
  //try {
  //  port = new Serial(this, Serial.list()[7], baudRate);  //
  //}
  //catch(Exception e)
  //{
  //  println(e);
  //}
}

void updateUI()
{
  baudDropdown
    .setPosition(10, 10)
    .setSize(200, 100)
    .setItems(java.util.Arrays.asList(baudRates))
    .setValue(12)
    ;

  portDropdown
    .setPosition(10, 25)
    .setSize(200, 100)
    .setBarHeight(15)
    //.setItemHeight(20)
    .setItems(java.util.Arrays.asList(Serial.list()))
    .setValue(Serial.list().length-1)
    .close()
    ;

  plotter
    .setPosition(110, 10)
    .setSize(width-120, height-20)
    .setRange(minVal, maxVal)
    .setView(Chart.LINE)
    .setStrokeWeight(1.5f)
    .setColorCaptionLabel(color(40))
    .setColorBackground(color(120, 200, 255, 50))
    ;

  //delimiter = ", ;";
}

void pre() {
  if (windowWidth != width || windowHeight != height) {
    // Sketch window has resized
    windowWidth = width;
    windowHeight = height;
    updateUI();
  }
}

public void draw () {
  background(0);
}

void serialPorts(int n)
{
  try {
    port = new Serial(this, Serial.list()[n], baudRate);
  }
  catch(Exception e)
  {
    println(e);
  }
}

void baudRate(int n)
{
  baudRate = int(baudRates[n]);
}

public void serialEvent (Serial thePort) {
  String inString = thePort.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);              // trim off whitespaces.
    String[] subStrings = splitTokens(inString, valueNamePattern);
    //String[] subStrings = inString.split("\\s|;|,");                 // TODO: search for ':' as name-markes

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
