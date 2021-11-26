void initGUI()
{
  cp5 = new ControlP5(this);
  cp5.addControllersFor(this);
  cp5.enableShortcuts();
  cp5.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      if (event.getAction()==ControlP5.ACTION_ENTER) {
        event.getController().bringToFront();
      }
    }
  }
  );
}

void createGUI()
{
  cp5.addToggle("verbose")
    .setPosition(10, 10)
    .setSize(40, 15)
    .setValue(verbose)
    ;
  cp5.addToggle("globalShortcutsEnabled")
    .setPosition(55, 10)
    .setSize(40, 15)
    .setLabel("global shortcuts")
    .setValue(globalShortcutsEnabled)
    ;
  plotter = cp5.addChart("Serial Plotter")
    .setPosition(190, 10)
    .setView(Chart.LINE)
    .setStrokeWeight(1.5f)
    .setColorCaptionLabel(color(40))
    .setColorBackground(color(120, 200, 255, 50))
    ;
  portDropdown = cp5.addScrollableList("setSerialPort")
    .setPosition(10, 45)
    .setSize(175, 100)
    .setBarHeight(15)
    //.setItemHeight(20)
    .setLabel("Serial Port")
    .setItems(java.util.Arrays.asList(Serial.list()))
    .close()
    ;
  baudDropdown = cp5.addScrollableList("setBaudRate")
    .setPosition(10, 65)
    .setSize(175, 100)
    .setItems(java.util.Arrays.asList(baudRates))
    .setValue(12)
    ;
  cp5.addToggle("parallel")
    .setPosition(10, 80)
    .setSize(40, 15)
    .setValue(parallel)
    .setLabel("multithread")
    ;
  lineHeadPatternField = cp5.addTextfield("lineHeadPattern")
    .setPosition(10, 125)
    .setSize(90, 15)
    .setLabel("line header regex")
    .setText(lineHeadPattern)
    ;
  dataNamePatternField = cp5.addTextfield("dataNamePattern")
    .setPosition(10, 160)
    .setSize(90, 15)
    .setLabel("data name regex")
    .setText(dataNamePattern)
    ;
  lineDataPatternField = cp5.addTextfield("lineDataPattern")
    .setPosition(10, 200)
    .setSize(90, 15)
    .setLabel("data regex")
    .setText(lineDataPattern)
    ;
  cp5.addNumberbox("minVal")
    .setPosition(10, 235)
    .setSize(40, 15)
    .setValue(minVal)
    .setMultiplier(-0.1)
    ;
  cp5.addNumberbox("maxVal")
    .setPosition(60, 235)
    .setSize(40, 15)
    .setValue(maxVal)
    .setMultiplier(-0.1)
    ;
  cp5.addNumberbox("dataBuffer")
    .setPosition(10, 275)
    .setSize(40, 15)
    .setValue(dataBuffer)
    .setRange(1, 1000)
    .setMultiplier(-1)
    .setLabel("buffer")
    ;
  cp5.addToggle("autoscale")
    .setPosition(55, 275)
    .setSize(40, 15)
    .setValue(autoscale)
    .setLabel("scale")
    ;

  cp5.addBang("resetData")
    .setPosition(100, 275)
    .setSize(40, 15)
    .setLabel("(r)eset")
    ;
  cp5.addBang("saveData")
    .setPosition(145, 275)
    .setSize(40, 15)
    .setLabel("(s)ave")
    ;
  dataSets = cp5.addScrollableList("dataSets")
    .setPosition(10, 315)
    .setSize(90, 250)
    //.setBarHeight(0)
    .setBarVisible(false)
    .lock()
    ;

  zeroAxis = cp5.addTextlabel("zeroAxis");

  for (int i = 0; i < axisLabels.length; i++)
    axisLabels[i] = cp5.addTextlabel("axisLabel"+i);
}

void updateGUI()
{
  portDropdown
    .setItems(java.util.Arrays.asList(Serial.list()))
    .close()
    ;

  minVal = (float) cp5.getController("minVal").getValue();
  maxVal = (float) cp5.getController("maxVal").getValue();
  dataBuffer = (int) cp5.getController("dataBuffer").getValue();

  plotter
    .setSize(width-195, height-15)
    .setRange(minVal, maxVal)
    .setResolution(100);
  ;

  dataSets.open();
  //dataSets.setBarVisible(false);

  zeroAxis
    .setText("< 0.00 >")
    .setPosition(195, map(0, minVal, maxVal, height-15, 10))
    .setVisible( !(minVal > 0 || maxVal < 0) )
    ;

  for (int i = 0; i < axisLabels.length; i++)
  {
    axisLabels[i]
      .setText("< "+df.format(map(i, 0, axisLabels.length-1, minVal, maxVal))+" >")
      .setPosition(195, map(i, 0, axisLabels.length-1, height-15, 10))
      ;
  }
}

void setBaudRate(int n)
{
  baudRate = int(baudRates[n]);
}

void setSerialPort(int n)
{
  try {
    port = new Serial(this, Serial.list()[n], baudRate);
  }
  catch(Exception e)
  {
    println(e);
  }
}

void controlEvent(ControlEvent theEvent) {
  try {
    updateGUI();

    //if (  theEvent.isFrom(cp5.getController("dataBuffer")) || theEvent.isFrom(cp5.getController("minVal")) || theEvent.isFrom(cp5.getController("maxVal")) )
    //{
    //  updateGUI();
    //}
  }
  catch(Exception e) {
    println(e);
  }
}
