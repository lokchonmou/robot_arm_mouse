#include <Servo.h>


byte currentValue = 0;
byte values[6];
Servo servo[6];

void setup() {
  Serial.begin(115200);
   while (Serial.available() <= 0) {
    Serial.println('a');   // send an initial string
    delay(300);
  }
}

void loop() {
  if (Serial.available() > 0) {
    values[currentValue] = Serial.read();
    currentValue++;
    if (currentValue > 5) {
      currentValue = 0;
      for (byte i = 0; i <= 5; i++) {
        if (values[i] < 250 )
        {
          if (servo[i].attached() == LOW)  servo[i].attach(8 + i);
          servo[i].write(values[i]);
        }
        else {
          if (servo[i].attached() == HIGH)  servo[i].detach();
        }
        Serial.print(values[i]);
        Serial.print(',');
      }
      Serial.println();
    }
  }
}

