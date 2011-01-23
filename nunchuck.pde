#include <string.h>
#include <stdio.h>
#include <Wire.h>
#include "nunchuck.h"

void setup() {
  Serial.begin(9600);
  Serial.print("Finished setup\n");
  nunchuck_init();
}

void loop() {
  nunchuck_request();
  delay(5);
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

