#include <string.h>
#include <stdio.h>
#include <Wire.h> // This seems redundant, but we need to declare this
                  // dependency in the pde file or else it won't be included
                  // in the build.
#include "nunchuck.h"

void setup() {
  Serial.begin(9600);
  Serial.print("Finished setup\n");
  nunchuck_init();
}

void loop() {
  nunchuck_request();
  delay(1); // give nunchuck time to respond
  int jx, jy, ax, ay, az, bz, bc;
  if (nunchuck_read(&jx, &jy, &ax, &ay, &az, &bz, &bc)) {
    Serial.print (jx, DEC);
    Serial.print ("\t");
    Serial.print (jy, DEC);
    Serial.print ("\t");
    Serial.print (ax, DEC);
    Serial.print ("\t");
    Serial.print (ay, DEC);
    Serial.print ("\t");
    Serial.print (az, DEC);
    Serial.print ("\t");
    Serial.print (bz, DEC);
    Serial.print ("\t");
    Serial.print (bc, DEC);
    Serial.print ("\n");
  }
  delay(100);
}
