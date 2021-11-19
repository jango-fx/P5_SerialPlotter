import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
Chart plotter;
ScrollableList baudDropdown;
ScrollableList portDropdown;
ScrollableList dataSets;

int windowWidth, windowHeight;

Serial port;
int baudRate=115200;
String[] baudRates = {"300", "600", "1200", "2400", "4800", "9600", "14400", "19200", "28800", "31250", "38400", "57600", "115200"};

public String lineHeaderPattern="#";
Textfield lineHeaderPatternField;
@ControlElement (x=10, y=90, properties = {"width=70", "value=, ;\t"})
  public String valueNamePattern=", ;:\t";
Textfield valueNamePatternField;

@ControlElement (x=10, y=150, properties = { "value=5.0", "min=-255", "max=255", "type=numberbox"})
  public float maxVal;
@ControlElement (x=10, y=190, properties = { "value=-1.0", "min=-255", "max=255", "type=numberbox"})
  public float minVal;

public void settings() {
  size(600, 400);
}

public void setup () {
  initGUI();
  createGUI();
  updateGUI();

  surface.setResizable(true);
  registerMethod("pre", this);
}

void pre() {
  if (windowWidth != width || windowHeight != height) {
    // Sketch window has resized
    windowWidth = width;
    windowHeight = height;
    updateGUI();
  }
}

public void draw () {
  println("minVal: "+minVal);
  background(0);
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
          dataSets.addItem(Integer.toString(i), 0);
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
