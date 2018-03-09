void main_page() {
  strokeWeight(1);
  if (firstRun == false) {
    frame.setSize(2* int(linkage[1]+linkage[2]), int(linkage[1]+linkage[2]+100));
    x = width/2;
    y = height;
    firstRun = true;
  } else if (firstRun) {

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