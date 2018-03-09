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