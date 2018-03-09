void serial_select() {
  
  try {
    if (debug) printArray(Serial.list());
    int i = Serial.list().length;
    if (i != 0) {
      if (i >= 2) {
        // need to check which port the inst uses -
        // for now we'll just let the user decide
        for (int j = 0; j < i; ) {
          COMlist += char(j+'0') + " = " + Serial.list()[j];
          if (++j < i) COMlist += ",  ";
        }
        COMx = showInputDialog("Which COM port is correct? (0,1,..):\n"+COMlist);
        if (COMx == null) exit();
        if (COMx.isEmpty()) exit();
        i = int(COMx.toLowerCase().charAt(0) - '0') + 1;
      }
      String portName = Serial.list()[i-1];
      if (debug) println(portName);
      myPort = new Serial(this, portName, 115200); // change baud rate to your liking
      myPort.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
      selected_port = true;  
  } else {
      showMessageDialog(frame, "Device is not connected to the PC");
      exit();
    }
  }
  catch (Exception e)
  { //Print the type of error
    showMessageDialog(frame, "COM port is not available (may\nbe in use by another program)");
    println("Error:", e);
    exit();
  }
}


void serialEvent(Serial myPort) {
  //  println("I received");
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    println(myString);

    int data[] = int(split(myString, ','));

    if (!trigger_servo && data[0] != 250) {
      fill(#FF0000);
      textAlign(CENTER, CENTER);
      text("ERROR!!!!", width/2, height/2);
    }

    for (byte i = 0; i <= 2; i++) {
      if (trigger_servo)
        myPort.write(out[i]);
      else 
      myPort.write(250+i);
    }
  }
}