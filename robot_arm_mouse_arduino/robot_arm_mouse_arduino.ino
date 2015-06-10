#include <Servo.h>

#define E1 5
#define M1 4
#define E2 6
#define M2 7

byte currentValue = 0;
byte values[6];
Servo servo[6];

void setup() {
  Serial.begin(115200);
  pinMode(M1, OUTPUT);
  pinMode(M2, OUTPUT);
  establishContact();
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
          if (servo[i].attached() == LOW)  servo[i].attach(13 - i);
          servo[i].write(values[i]);
          if (i == 4)  {
            if (values[i] > 90 && values[i] <= 180) {
              digitalWrite(M1, HIGH);
              analogWrite(E1, values[i] - 90);
            }
            else if (values[i] > 0 && values[i] <= 90) {
              digitalWrite(M1, LOW);
              analogWrite(E1, 90 - values[i]);
            }
          }
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

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println();   // send an initial string
    delay(300);
  }
}
