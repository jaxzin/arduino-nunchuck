/* Copyright (c) 2011 Peter Brinkmann (peter.brinkmann@gmail.com)
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 */

#ifndef __NUNCHUCK_H__
#define __NUNCHUCK_H__

#include <WProgram.h>
#include <Wire.h>

/*
 * Initializes I2C communication with the nunchuck.  Call this in the setup
 * function.
 */
void nunchuck_init() {
  Wire.begin();  Wire.beginTransmission(0x52);
  Wire.send(0x40);
  Wire.send(0x00);
  Wire.endTransmission();
}

/*
 * Reads the current values from the nunchuck.
 *
 * jx/y:   Joystick, ranging from -128 to 127
 * ax/y/z: Acceleration, ranging from -512 to 511
 * bz/c:   Buttons; 1 means pressed, 0 means released
 *
 * Returns 1 on success, 0 on failure.
 */
int nunchuck_read(int *jx, int *jy,
                  int *ax, int *ay, int *az,
                  int *bz, int *bc) {
  Wire.beginTransmission(0x52); // Request new values from nunchuck.
  Wire.send(0x00);
  Wire.endTransmission();
  delayMicroseconds(200); // Give nunchuck time to respond.
  Wire.requestFrom(0x52, 6);
  byte buf[8];  // Allocate a few extra bytes just in case.
  int cnt = 0;
  while (Wire.available()) {
    buf[cnt++] = (Wire.receive() ^ 0x17) + 0x17;
  }
  if (cnt < 6) {
    return 0;
  }
  *jx = buf[0] - 128;
  *jy = buf[1] - 128;
  byte b = buf[5];
  *ax = ((buf[2] << 2) | ((b >> 2) & 3)) - 512;
  *ay = ((buf[3] << 2) | ((b >> 4) & 3)) - 512;
  *az = ((buf[4] << 2) | ((b >> 6) & 3)) - 512;
  *bz = (b & 1) ^ 1;
  *bc = ((b >> 1) & 1) ^ 1;
  return 1;
}

#endif
