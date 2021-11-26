import processing.serial.*;
import controlP5.*;

int windowWidth, windowHeight;
public boolean verbose = false;
public boolean globalShortcutsEnabled = true;

ControlP5 cp5;
Chart plotter;
ScrollableList baudDropdown;
ScrollableList portDropdown;
ScrollableList dataSets;

ArrayList<String> lines = new ArrayList<String>();
java.util.LinkedHashSet<String> linesHash = new java.util.LinkedHashSet<String>();

Serial port;
public boolean parallel = false;
int baudRate=115200;
String[] baudRates = {"300", "600", "1200", "2400", "4800", "9600", "14400", "19200", "28800", "31250", "38400", "57600", "115200"};

// Example data #1
//   IM1#OR:0.667,-0.258,-0.687,0.124
//   IAL1#OR:0.724,-0.115,0.259,0.629
//   IAL2#OR:0.772,0.356,-0.176,-0.497
//   IAL3#OR:0.686,0.397,-0.422,-0.440
//
// lineHeadPattern = ".*(?=:)";
// lineDataPattern = "(?!#|,|$)-?\\d.\\d{3}" or "-?\\d+\\.?\\d*"
// dataNamePattern = ""

// Example Data #2
//   Accel  x:  0.11  y:  -0.03  z:  -0.06
//   Magnet  x:  -10.69  y:  -2.69  z:  -42.06
//   Temp  C:  25
//   Gravity  x:  -0.22  y:  1.06  z:  9.74
//   Quat  w:  -0.7639  x:  -0.0488  y:  0.0263  z:  0.6429
//
// lineHeadPattern = "^\\w*";
// lineDataPattern = "-?\\d+\\.?\\d+";
// dataNamePattern = ""\\w(?=:)""

public String lineHeadPattern = ".*(?=:)";
Textfield lineHeadPatternField;
public String dataNamePattern = "";
Textfield dataNamePatternField;
public String lineDataPattern = "-?\\d+\\.?\\d+";
Textfield lineDataPatternField;

Textlabel zeroAxis;
Textlabel[] axisLabels = new Textlabel[7];

public float maxVal=2.5;
public float minVal=-2.0;
public int dataBuffer=1000;

public void settings() {
  size(800, 500);
  GlobalKeyListener.begin();
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

  if ( !parallel && port != null && port.available() > 0) {
    checkSerial();
  }
  if (GlobalKeyListener.pressed && globalShortcutsEnabled) {
    if (GlobalKeyListener.key == "S") saveData();
    if (GlobalKeyListener.key == "R") resetData();
    GlobalKeyListener.pressed = false;
  }
}

void saveData()
{
  String portName = (String) portDropdown.getItem(int(portDropdown.getValue())).get("text");
  portName = portName.replaceAll(".*\\.", "");
  String fileName = getTime()+"-"+portName+"-data.csv";
  println("saved current data to >"+fileName+"<");

  saveChartDataToFile(plotter, fileName);
}

void resetData()
{
  println("reset Data");
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
    String lineHeader = matchRegex(input, lineHeadPattern)[0];
    input = input.replace(lineHeader, "");
    String[] lineData = matchRegex(input, lineDataPattern);
    String[] dataNames = matchRegex(input, dataNamePattern);



    for (int i = 0; i < lineData.length; ++i)
    {
      if (linesHash.add(lineHeader))
      {
        //println("new Header: "+lineHeader+"("+lines.size()+")");
        lines.add(lineHeader);
      }


      String dataName = "";
      if (lineData.length == dataNames.length)
      {
        dataName = lineHeader+": "+dataNames[i];
      } else
      {
        dataName = lineHeader+": "+i;
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
        plotter.push(dataName, parseFloat(lineData[i]));

        /* UPDATE COLORS */
        /*   colormapping:
         lineHead1: value=1, value=2 -> rainbow 1.1, 1.2
         lineHead2: value=1, value=2 -> rainbow 2.1, 2.2
         
         value=1, value=2            -> rainbow 1.1, 2.1
         */

        //color c = getRainbowColor(dataSets.getItems().size(), 17);
        //plotter.setColors(dataName, c);
        //CColor cc = new CColor().setBackground(color(red(c), green(c), blue(c), 200));
        //dataSets.getItem(dataName).put("color", cc);

        ArrayList<ColorList> rainbowRanges = createRainbowRanges(lines.size(), lineData.length);

        for (int n = 0; n < lines.size(); n++)
        {
          for (int m = 0; m < lineData.length; m++)
          {
            int ix = (m+n*lineData.length);
            int jx = (m*lines.size()+n);
            //println("numN: "+lines.size()+"   n: "+n+"   numM: "+lineData.length+"   m:"+m+"  -> "+ ix +" =? "+ jx );

            color c = rainbowRanges.get(m).get(n).toARGB();                                   // <-- call reorders part of dataSet map ??
            CColor cc = new CColor().setBackground(color(red(c), green(c), blue(c), 200));
            //java.util.Map dataSet = (java.util.Map) dataSets.getItems();                  // <-- call reorders dataSet map ??
            java.util.Map dataSet = (java.util.Map) dataSets.getItems().get(ix);
            dataSet.put("color", cc);
            dataName = (String) dataSet.get("name");
            plotter.setColors(dataName, c);
          }
        }

        dataSets.setSize(dataSets.getWidth(), 15*(dataSets.getItems().size()+1));
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
