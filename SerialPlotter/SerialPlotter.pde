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

public String lineHeaderPattern=".*(?=:)";
Textfield lineHeaderPatternField;
public String lineDataNamePattern="";
Textfield lineDataNamePatternField;
public String lineDataPattern="(?!#|,|$)-?\\d.\\d{3}";
Textfield lineDataPatternField;

public float maxVal=5.0;
public float minVal=-1.0;
public int dataBuffer=100;

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
    windowWidth = width;
    windowHeight = height;
    updateGUI();
  }
}

public void draw () {
  background(0);
  //float res = cp5.get(Chart.class, "Serial Plotter").getResolution();
  //println(res);
}

void parseSerial(String input)
{
  try {
    String lineHeader = matchRegex(input, lineHeaderPattern)[0];
    String[] lineData = matchRegex(input, lineDataPattern);
    String[] dataNames = matchRegex(input, lineDataNamePattern);
    for (int i = 0; i < lineData.length; ++i)
    {
      String dataName = "";
      if (lineData.length == dataNames.length)
      {
        dataName = lineHeader+"/"+dataNames[i];
      } else
      {
        dataName = lineHeader+"/"+i;
      }
      ChartDataSet set = plotter.getDataSet(dataName);
      if (set != null)
      {
        plotter.push(dataName, parseFloat(lineData[i]));
      } else
      {
        plotter.addDataSet(dataName);
        dataSets.addItem(dataName, 0);
        plotter.setData(dataName, new float[dataBuffer]);
        plotter.setColors(dataName, getRainbowColor(i));
        plotter.push(dataName, parseFloat(lineData[i]));
      }
    }
  }
  catch (Exception e) {
    println(e);
  }
}

public void serialEvent (Serial thePort) {
  String inString = thePort.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);
    parseSerial(inString);
    //println("[Serial]: "+inString+"");
  }
}
