import processing.serial.*;
import controlP5.*;

int windowWidth, windowHeight;
public boolean verbose = false;


ControlP5 cp5;
Chart plotter;
ScrollableList baudDropdown;
ScrollableList portDropdown;
ScrollableList dataSets;


Serial port;
public boolean parallel = false;
int baudRate=115200;
String[] baudRates = {"300", "600", "1200", "2400", "4800", "9600", "14400", "19200", "28800", "31250", "38400", "57600", "115200"};

// IMU data example:   
//   IM1#OR:0.667,-0.258,-0.687,0.124
//   IAL1#OR:0.724,-0.115,0.259,0.629
//   IAL2#OR:0.772,0.356,-0.176,-0.497
//   IAL3#OR:0.686,0.397,-0.422,-0.440

public String lineHeaderPattern=".*(?=:)";               // IMUs ".*(?=:)";
Textfield lineHeaderPatternField;
public String lineDataNamePattern="";
Textfield lineDataNamePatternField;
public String lineDataPattern="-?\\d+\\.?\\d*";          // IMUs "(?!#|,|$)-?\\d.\\d{3}"
Textfield lineDataPatternField;

public float maxVal=5.0;
public float minVal=-1.0;
public int dataBuffer=1000;

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

  if ( !parallel && port != null && port.available() > 0) {
    checkSerial();
  }
}

void checkSerial()
{
  String inString = port.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);
    parseSerial(inString);
    if (verbose)
      println("[Serial]: "+inString+"");
  }
}

void parseSerial(String input)
{
  try {
    String lineHeader = matchRegex(input, lineHeaderPattern)[0];
    input = input.replace(lineHeader, "");
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
  if (parallel)
    checkSerial();
}
