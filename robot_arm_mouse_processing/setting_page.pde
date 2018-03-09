int[] servoangle = { 
  90, 90, 90
};
byte[] inControl = {
  0, 0, 0
};

void setting_page() {
  background(230, 230, 230); 
  text("Servo Tester Ver1.1", width/2, 40);
  text("by AO IEONG KIN KEI & LOK CHON MOU \n Click on the bar to active servo", width/2, height-40);
  text("minimum = "+(int)setup_theta[0][0]+", "+(int)setup_theta[1][0]+", "+(int)setup_theta[2][0], width*.65, height*.5);
  text("center = "+(int)setup_theta[0][1]+", "+(int)setup_theta[1][1]+", "+(int)setup_theta[2][1], width*.65, height*.6);
  text("maximum = "+(int)setup_theta[0][2]+", "+(int)setup_theta[1][2]+", "+(int)setup_theta[2][2], width*.65, height*.7);
  draw_bar();
  
  button_width = 80; 
  button_height = 50;
  rectMode(CENTER);
  stroke(#89A3FF);
  strokeWeight(6);
  
  fill(overRect(int((float)width*.9), int((float)height*.5), button_width, button_height)?#D6CF49:color(#FFFCA7));
  rect(width*.9, (float)height*.5, button_width, button_height, 0, 10, 0, 10);

  textSize(14);
  fill(0);
  text("minimum", width*.9, (float)height*.5);
  
  fill(overRect(int((float)width*.9), int((float)height*.6), button_width, button_height)?#D6CF49:color(#FFFCA7));
  rect(width*.9, (float)height*.6, button_width, button_height, 0, 10, 0, 10);

  textSize(14);
  fill(0);
  text("center", width*.9, (float)height*.6);
  
   fill(overRect(int((float)width*.9), int((float)height*.7), button_width, button_height)?#D6CF49:color(#FFFCA7));
  rect(width*.9, (float)height*.7, button_width, button_height, 0, 10, 0, 10);

  textSize(14);
  fill(0);
  text("maximum", width*.9, (float)height*.7);
  
  fill(overRect(int((float)width*.9), int((float)height*.8), button_width, button_height)?#D6CF49:color(#FFFCA7));
  rect(width*.9, (float)height*.8, button_width, button_height, 0, 10, 0, 10);

  textSize(14);
  fill(0);
  text("BACK", width*.9, (float)height*.8);

}
void draw_bar() {
  strokeWeight(1);
  stroke(0);
  for (byte i = 0; i <= 2; i++) {  
    colorMode(RGB, 255);
    rectMode(CENTER);
    fill(255);
    stroke(0);
    rect((width)*(i+1)/7, height/2, 50, 360);

    colorMode(HSB, 100);
    rectMode(CORNER);
    fill(100*i*inControl[i]/6, 40*inControl[i], 90+ 70*inControl[i]);
    rect((width)*(i+1)/7 - 25, height/2 +180, 50, -  servoangle[i]*2); 

    colorMode(RGB, 255);
    fill(0);
    text("servo"+i, (width)*(i+1)/7, 75);
    text(servoangle[i], (width)*(i+1)/7, 15+ height/2 +( 90 - servoangle[i])*2);
  }
}