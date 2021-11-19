void createGUI()
{
  plotter = cp5.addChart("Serial Plotter")
    .setPosition(190, 10)
    .setView(Chart.LINE)
    .setStrokeWeight(1.5f)
    .setColorCaptionLabel(color(40))
    .setColorBackground(color(120, 200, 255, 50))
    ;
  baudDropdown = cp5.addScrollableList("setBaudRate")
    .setPosition(10, 10)
    .setSize(175, 100)
    .setItems(java.util.Arrays.asList(baudRates))
    .setValue(12)
    ;
  portDropdown = cp5.addScrollableList("setSerialPort")
    .setPosition(10, 25)
    .setSize(175, 100)
    .setBarHeight(15)
    //.setItemHeight(20)
    .setLabel("Serial Port")
    .setItems(java.util.Arrays.asList(Serial.list()))
    .close()
    ;
  lineHeaderPatternField = cp5.addTextfield("lineHeaderPattern")
    .setPosition(10, 50)
    .setSize(90, 15)
    .setText(lineHeaderPattern)
    ;
  lineDataNamePatternField = cp5.addTextfield("lineDataNamePattern")
    .setPosition(10, 85)
    .setSize(90, 15)
    .setText(lineDataNamePattern)
    ;
  lineDataPatternField = cp5.addTextfield("lineDataPattern")
    .setPosition(10, 120)
    .setSize(90, 15)
    .setText(lineDataPattern)
    ;
  cp5.addNumberbox("minVal")
    .setPosition(10, 160)
    .setSize(40, 15)
    .setValue(minVal)
    .setMultiplier(-0.1)
    ;
  cp5.addNumberbox("maxVal")
    .setPosition(60, 160)
    .setSize(40, 15)
    .setValue(maxVal)
    .setMultiplier(-0.1)
    ;
  cp5.addNumberbox("dataBuffer")
    .setPosition(10, 200)
    .setSize(40, 15)
    .setValue(dataBuffer)
    .setRange(1, 1000)
    .setMultiplier(-1)
    ;
  dataSets = cp5.addScrollableList("dataSets")
    .setPosition(10, 250)
    .setSize(90, 100)
    ;
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
    .setSize(width-195, height-20)
    .setRange(minVal, maxVal)
    .setResolution(100);
  ;
}

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
    if (  theEvent.isFrom(cp5.getController("dataBuffer")) || theEvent.isFrom(cp5.getController("minVal")) || theEvent.isFrom(cp5.getController("maxVal")) )
    {
      updateGUI();
    }
  }
  catch(Exception e) {
    println(e);
  }
}
