float yoff = 0.0; 

void start_page() {
  background(200);

  fill(#1F8DFF);
  // We are going to draw a polygon out of the wave points
  beginShape(); 

  float xoff = 0;       // Option #1: 2D Noise
  // float xoff = yoff; // Option #2: 1D Noise

  // Iterate over horizontal pixels
  for (float x = 0; x <= width; x += 10) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, 200, 300); // Option #1: 2D Noise
    // float y = map(noise(xoff), 0, 1, 200,300);    // Option #2: 1D Noise

    // Set the vertex
    vertex(x, y); 
    // Increment x dimension for noise
    xoff += 0.05;
  }
  // increment y dimension for noise
  yoff += 0.01;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
  textAlign(CENTER, CENTER);
  textSize(36);
  fill(0);
  text("A 3DOF robot arm control UI \n with kinematics calculation", width/2, height/3);
  rectMode(CENTER);
  stroke(#89A3FF);
  strokeWeight(6);

  button_width = 150; 
  button_height = 50;
  fill(overRect(width/2, int((float)height*.7), button_width, button_height)?#D6CF49:color(#FFFCA7));
  rect(width/2, (float)height*.7, button_width, button_height, 0, 10, 0, 10);
  fill(overRect(width/2, int((float)height*.8), button_width, button_height)?#D6CF49:color(#FFFCA7));
  rect(width/2, (float)height*.8, button_width, button_height, 0, 10, 0, 10);

  textSize(14);
  fill(0);
  text("SETTING", width/2, (float)height*.8);
  text("START", width/2, (float)height*.7);
}


boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x-width/2 && mouseX <= x+width/2 && 
    mouseY >= y-height/2 && mouseY <= y+height/2) {
    return true;
  } else {
    return false;
  }
}