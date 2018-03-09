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
import static javax.swing.JOptionPane.*;

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
boolean firstRun = false;
boolean selected_port = false;
boolean trigger_servo = false;
boolean debug = true;
byte out[] = new byte[6];
String COMx, COMlist = "";
int page = 0;
PrintWriter conf;
String[] setting;
int button_width, button_height;
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

  setting = loadStrings("configuration.txt");
  for (int i =0 ;i <=8; i++)
    setup_theta[i%3][i/3] = float(setting[i]);
     
  serial_select();
  low_zlimit = -1000.0;
  positionZ = 100.0;
}

void draw() {
  if (selected_port == true) { 
    if (page == 0 ) {
      start_page();
    }
    if (page == 1) {
      main_page();
    }
    if (page == 2) {
      setting_page();
    }
  }
}