/*
  Name: robot arm mouse processing
  
  Description:
    A processing program that use mouse to control a 4dof UARM like robot
    ----***** should use a robot_arm_mouse_arduino firmware
  
  Author: Ao Ieong Kin Kei, Vong Hou Lam, Lok Chon Mou
  
  Notes: MG995 servo, connect to D8, D9, D10, UARM like robot arm
  
  Last Change: 2017-04-20
*/

import processing.serial.*;
Serial myPort;  

//Dim variables
//--------------------------------------------
float last_mouseX, last_mouseY, positionX, positionY, positionZ;
float theta_1_before, theta_2_before;
String s1, s2, coordinates;
float x, y;
float targetX, targetY;
float max_rad, min_rad, y_rad;
float up_zlimit, low_zlimit, low_ylimit, low_ylimit_2, up_ylimit_2, left_xlimit, right_xlimit;
int[] rtheta = new int[6];
int rpositionX, rpositionY, rpositionZ;

boolean firstContact = false;
boolean first_run = false;
boolean selected_port = false;
boolean trigger_servo = false;

byte out[] = new byte[6];

//setup ( set length of arm )
//--------------------------------------------
float linkage[] = {50.0, 148.0, 160.0};
// servo angle [min     center     max    direction]
float[][]  setup_theta = {
  {
    0, 90, 170, 1      //shoulder_yaw
  }
  , 
  {
    15, 76, 96, 0      //shoulder_pitch
  }
  , 
  {
    45, 54, 163, 0      //Elbow 手肘
  }
};
float[] theta = {
  setup_theta[0][1], setup_theta[1][1], setup_theta[2][1]
};
float easing = 0.01;

void setup() 
{
  size(600, 600);
  background(#E6E6E6);
  fill(#000000);
  textAlign(CENTER, CENTER);
  text("Choose the serial port from the list \n and then click anywhere to continue", width/2, 100); // display text to user

  int port_list_length = Serial.list().length;

  if (port_list_length==0) {
    println("There are no serial available.");
    exit();
  } else {
    for (int i=0; i< port_list_length; i++)
    {
      text(str(i+1)+". "+Serial.list()[i], width/2, 100+30*(i+1));  //Add each serial port found to the selection
    }
    frame.setResizable(true);
  }

  low_zlimit = -1000.0;
  positionZ = 100.0;
}

void draw() {
  if (selected_port == true) { 
    if (first_run == false) {

      frame.setSize(2* int(linkage[1]+linkage[2]), int(linkage[1]+linkage[2]+100));
      x = width/2;
      y = height;

      first_run = true;
    } else {

      positionX = -(width/2 - last_mouseX);
      positionY = height - last_mouseY;

      //Forward kinematics
      //--------------------------------------------
      forward_kinematics();
      //Inverse kinematics
      //--------------------------------------------
      inverse_kinematics();


      //rounding
      //--------------------------------------------
      rtheta[0] = round(theta[0]);
      rtheta[1] = round(theta[1]);
      rtheta[2] = round(180 - theta[1] -theta[2]);


      rpositionX = round(positionX);
      rpositionY = round(positionY);
      rpositionZ = round(positionZ);



      //x, y position
      //--------------------------------------------
      targetX= mouseX;
      targetY= mouseY;

      x += (targetX - x) * easing;
      if (x <= left_xlimit + (linkage[1]+linkage[2]) ) {
        x = left_xlimit + (linkage[1]+linkage[2]);
        y = height;
      }
      if (x >= right_xlimit + (linkage[1]+linkage[2]) ) {
        x = right_xlimit + (linkage[1]+linkage[2]);
        y = height;
      }

      y += (targetY - y) * easing;

      if (height- y <= low_ylimit) y = height- low_ylimit;
      if (height- y <= low_ylimit_2) y = height- low_ylimit_2;
      if (height- y >= up_ylimit_2) y = height- up_ylimit_2;

      background(#FFFFFF);    
      fill(#646464);
      ellipse(width/2, height, max_rad * 2, max_rad* 2);
      if (y_rad >0) {
        fill(#E6E6E6);
        ellipse(width/2, height, y_rad * 2, y_rad*2);
      }
      if (min_rad >0) {
        fill(#FFFFFF);
        ellipse(width/2, height, min_rad* 2, min_rad * 2);
      }

      //Drawing
      //--------------------------------------------
      drawing();

      //Send data to Arduino
      //--------------------------------------------
      for (int i = 0; i <=2; i++) {
        if (setup_theta[i][3] == 0)
          out[i] = byte(constrain(rtheta[i] + setup_theta[i][1]-90.0, setup_theta[i][0], setup_theta[i][2]));
        else if (setup_theta[i][3] == 1)
          out[i] = byte(constrain(180.0-(rtheta[i] + setup_theta[i][1]-90.0), setup_theta[i][0], setup_theta[i][2]));
      }
    }
  }
}

void forward_kinematics() {
  low_ylimit= -sin(radians(theta[0])) * ( linkage[1] + linkage[2] * sin(radians(theta[2])));
  y_rad = -linkage[1] - linkage[2] * sin(radians(theta[2]));
  if (positionY <= low_ylimit) positionY = low_ylimit;

  max_rad = sqrt(sq(linkage[1]) + sq(linkage[2]) - sq(positionZ) + 2 * linkage[1] * linkage[2] );
  min_rad = sqrt(sq(linkage[1]) + sq(linkage[2]) -( 2*cos(radians(10)) * linkage[1] * linkage[2] )- sq(positionZ));
  if (max_rad < 0) max_rad = 0;

  up_ylimit_2 = sqrt(sq(max_rad) - sq(positionX));
  low_ylimit_2 = sqrt(sq(min_rad) - sq(positionX));

  left_xlimit = -max_rad ;
  right_xlimit = max_rad ;

  if (positionX <= left_xlimit) positionX = left_xlimit;
  if (positionX >= right_xlimit) positionX = right_xlimit;

  if (up_ylimit_2 <= 0) up_ylimit_2 = 0;
  if (positionY >= up_ylimit_2) positionY = up_ylimit_2;
  if (positionY <= low_ylimit_2) positionY = low_ylimit_2;

  //println(up_zlimit);
  low_zlimit = - linkage[2] * cos (radians(theta[2]));
  if (positionZ <= low_zlimit) positionZ = low_zlimit;
  if (positionZ <= -80) positionZ = -80;
  if (positionZ >= linkage[1]+linkage[2]) positionZ = linkage[1] +linkage[2];
}

void inverse_kinematics() {
  theta[0] = atan(positionY/positionX);
  if (theta[0]>=0)
    theta[0] = degrees(theta[0]);
  else theta[0] = 180 +  degrees(theta[0]);
  if (theta[0] == 0) {
    if (positionX < 0) theta[0] = 180;
    else theta[0] = 0;
  }

  theta_1_before =(sq(linkage[1]) - sq(linkage[2]) + sq(positionX) + sq(positionY) + sq(positionZ))/(2 * linkage[1] * sqrt(sq(positionX) + sq(positionY) + sq(positionZ)));
  if (theta_1_before > 1) theta_1_before = 1;
  theta[1] = acos(theta_1_before)+ atan(positionZ/( sqrt(sq(positionX)+sq(positionY))));
  theta[1] = degrees(theta[1]);

  theta_2_before = (sq(positionX)+sq(positionY)+sq(positionZ)-sq(linkage[1])-sq(linkage[2]))/ ( 2* linkage[1] * linkage[2]);
  if (theta_2_before >= 1) theta_2_before =1 ;
  theta[2] = asin(theta_2_before);
  theta[2] = degrees(theta[2]);
  if (theta[2] >=90 )theta[2] = 90;
  if (theta[2] <=-90 )theta[2] = -90;
}

void drawing() { 
  stroke(0, 0, 0);
  fill(#FFFFFF);
  rect(width -50, height/2 + 80 /2, width-25, height/2 - (linkage[1]+linkage[2])/2);
  if (positionZ== linkage[1]+linkage[2] || positionZ == -80) fill (#FF0000);
  else fill (#C8C8C8);
  rectMode(CORNERS);
  rect(width -50, height/2, width - 25, height/2 - positionZ/2);

  textSize(15);
  textAlign(LEFT, CENTER);
  fill(#0000FF);
  text("0", width-15, height/2);
  line(width -50, height/2, width-22, height/2);
  textAlign(RIGHT, CENTER);
  fill(#000000);
  text(int(positionZ), width-55, height/2 - positionZ/2);

  stroke(#FF0000);
  line(width/2, 0, width/2, height);
  line(0, height-1, width, height-1);
  coordinates = "(" + rpositionX + "," + rpositionY + ")";
  fill(#000000);
  textSize(15);
  if (x <=width/2) {
    textAlign(RIGHT, TOP);
    text(coordinates, x+50, y-50);
  } else {
    textAlign(LEFT, TOP);
    text(coordinates, x-50, y-50);
  }
  stroke(0, 255, 0); 

  ellipse(x, y, 50, 50);
  line(x, y, width/2, height);
  last_mouseX = x;
  last_mouseY = y;

  s1 = "theta[0] =" + rtheta[0]+"    theta[1] ="+rtheta[1]+"    theta[2] ="+rtheta[2];
  s2 = "x = "+ rpositionX +", y = " + rpositionY +", z ="+ rpositionZ;
  textSize(22);
  textAlign(LEFT, TOP);
  fill(#000000);
  text(s1, 10, 10);
  text(s2, 10, 50);

  fill(#939191);
  textSize(12);
  textAlign(RIGHT, BOTTOM);
  text("using the mouse wheel to adjust Z", width, height);

  if (!trigger_servo) {
    fill(#AAAAAA, 200);
    noStroke();
    rect(0, 0, width, height);
    fill(#FF0000);
    textAlign(CENTER, CENTER);
    text("Press ENTER to start!!!!", width/2, height/2);
  }
}

//Mouse, keyboard function
//--------------------------------------------
void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  positionZ -= e;
}

void keyPressed() {
  if (selected_port == false) {
    myPort= new Serial(this, Serial.list()[int(str(key))-1], 115200);
    //remove(guiChoice); // remove drop-down list, otherwise it appears on top of the video feed
    selected_port= true;
  }
  else {
    trigger_servo =!trigger_servo;
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

    for (byte i = 0; i <= 5; i++) {
      if (trigger_servo)
        myPort.write(out[i]);
      else 
      myPort.write(250+i);
    }
  }
}
