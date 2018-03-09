//Mouse, keyboard function
//--------------------------------------------
void mouseWheel(MouseEvent event) {
  if (page == 1) {
    float e = event.getAmount();
    positionZ -= e;
  } else if (page == 2) {
    float e = event.getAmount();
    for (byte i = 0; i <= 5; i++) {  
      if (mouseX >= (width)*(i+1)/7 - 25 && mouseX <= (width)*(i+1)/7 + 25 && inControl[i] == 1 && selected_port == true) {
        servoangle[i] -= e;
        servoangle[i] = constrain(servoangle[i], 0, 180);
      }
    }
    if (selected_port) draw_bar();
  }
}

void keyPressed() {
  if (page ==1 )
    if (key == ENTER)
      trigger_servo =!trigger_servo;
}


void mousePressed() {
  if (page == 0) {
    if (overRect(width/2, int((float)height*.7), button_width, button_height)) page =1;
    if (overRect(width/2, int((float)height*.8), button_width, button_height)) page =2;
  } else if (page == 2) {
    for (byte i = 0; i <= 2; i++) {  
      if (mouseX >= (width)*(i+1)/7 - 25 && mouseX <= (width)*(i+1)/7 + 25 &&  selected_port == true) {
        if (inControl[i] == 0) inControl[i] = 1;
        else if (inControl[i] == 1) inControl[i] = 0;
      }
    }
    if (overRect(int((float)width*.9), int((float)height*.5), button_width, button_height)) {
      for (int i =0; i<=2; i++)
        if (inControl[i] == 1)
          setup_theta[i][0] = servoangle[i];
    }
    if (overRect(int((float)width*.9), int((float)height*.6), button_width, button_height)) {
      for (int i =0; i<=2; i++)
        if (inControl[i] == 1)
          setup_theta[i][1] = servoangle[i];
    }
    if (overRect(int((float)width*.9), int((float)height*.7), button_width, button_height)) {
      for (int i =0; i<=2; i++)
        if (inControl[i] == 1)
          setup_theta[i][2] = servoangle[i];
    }
    if (overRect(int((float)width*.9), int((float)height*.8), button_width, button_height)) {
      conf = createWriter("configuration.txt");
      for (int j=0; j<=2; j++)
        for (int i=0; i<=2; i++)
          conf.println(setup_theta[i][j]);
      conf.flush();
      conf.close();
      page = 0;
    }
    if (selected_port) draw_bar();
  }
}