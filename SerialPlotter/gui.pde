void createGUI()
{
    plotter = cp5.addChart("Serial Plotter")
    .setPosition(110, 10)
    .setView(Chart.LINE)
    .setStrokeWeight(1.5f)
    .setColorCaptionLabel(color(40))
    .setColorBackground(color(120, 200, 255, 50))
    ;
  baudDropdown = cp5.addScrollableList("setBaudRate")
    .setPosition(10, 10)
    .setSize(200, 100)
    .setItems(java.util.Arrays.asList(baudRates))
    .setValue(12)
    ;
  portDropdown = cp5.addScrollableList("setSerialPort")
    .setPosition(10, 25)
    .setSize(200, 100)
    .setBarHeight(15)
    //.setItemHeight(20)
    .setLabel("Serial Port")
    .setItems(java.util.Arrays.asList(Serial.list()))
    .close()
    ;
  lineHeaderPatternField = cp5.addTextfield("lineHeaderPattern")
    .setPosition(10, 50)
    .setSize(70, 20)
    .setText(lineHeaderPattern)
    .setColorForeground(color(255, 50))
    .setColorBackground(color(255, 20))
    .setColorLabel(color(50, 50))
    .setColorValue(color(50, 50))
    .lock()
    ;
  valueNamePatternField = cp5.addTextfield("valueNamePattern")
    .setPosition(10, 90)
    .setSize(70, 20)
    .setText(valueNamePattern)
    ;
  dataSets = cp5.addScrollableList("dataSets")
    .setPosition(10, 250)
    ;
}


void updateGUI()
{
  portDropdown
    .setItems(java.util.Arrays.asList(Serial.list()))
    .close()
    ;

  plotter
    .setSize(width-120, height-20)
    .setRange(minVal, maxVal)
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
