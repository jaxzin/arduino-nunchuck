/* Copyright (c) 2011 Peter Brinkmann (peter.brinkmann@gmail.com)
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 */

#include <string.h>
#include <stdio.h>
#include <Wire.h> // This seems redundant, but we need to declare this
                  // dependency in the pde file or else it won't be included
                  // in the build.
#include "nunchuck.h"

void setup() {
  Serial.begin(115200);
  Serial.print("Finished setup\n");
  nunchuck_init();
}

void loop() {
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
