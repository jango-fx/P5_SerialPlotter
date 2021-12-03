import processing.serial.*;
import controlP5.*;

int windowWidth, windowHeight;
public boolean verbose = false;
public boolean globalShortcutsEnabled = false;

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

Textfield lineHeadPatternField;
Textfield dataNamePatternField;
Textfield lineDataPatternField;
public String lineHeadPattern = "^\\w*";
public String dataNamePattern = "\\w+(?=:)"
public String lineDataPattern = "-?\\d+\\.?\\d+";

Textlabel zeroAxis;
Textlabel[] axisLabels = new Textlabel[7];

public float maxVal=1.0;
public float minVal=-1.0;
public int dataBuffer=1000;
public boolean autoscale=false;

public void settings() {
  size(800, 500);
}

public void setup () {
  initGUI();
  createGUI();
  updateGUI();

  surface.setResizable(true);
  registerMethod("pre", this);

  GlobalKeyListener.begin();
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
    println(GlobalKeyListener.keyCode);
    if (GlobalKeyListener.key == "S") saveData();
    if (GlobalKeyListener.keyCode == 57) resetData();
    GlobalKeyListener.pressed = false;
  }
}

void keyReleased()
{
  if (!globalShortcutsEnabled)
  {
    if (key == 's') saveData();
    if (key == 'r') resetData();
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
  java.util.LinkedHashMap<java.lang.String, ChartDataSet> data = plotter.getDataSet();
  java.util.Set<String> keys = data.keySet();
  for (String key : keys) {
    ChartDataSet entry = data.get(key);
    float[] values = entry.getValues();
    plotter.setData(key, new float[dataBuffer]);
  }
  println("reset data");
}

void parseData(String input)
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
        if (verbose) println("new Header: "+lineHeader+"("+lines.size()+")");
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

      float newDatum = parseFloat(lineData[i]);

      if (autoscale)                                                              // auto scale
      {
        cp5.getController("maxVal").setValue( max(maxVal, newDatum) );
        cp5.getController("minVal").setValue( min(minVal, newDatum) );
      }

      if (set != null)                                                             // add to existing DataSet
      {
        plotter.push(dataName, newDatum);
      } else                                                                       // create new DataSet
      {
        plotter.addDataSet(dataName);
        dataSets.addItem(dataName, 0);
        plotter.setData(dataName, new float[dataBuffer]);
        plotter.push(dataName, newDatum);

        /* UPDATE COLORS */
        /*   colormapping:
         lineHead1: value=1, value=2 -> rainbow 1.1, 1.2
         lineHead2: value=1, value=2 -> rainbow 2.1, 2.2
         
         value=1, value=2            -> rainbow 1.1, 2.1
         */

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
