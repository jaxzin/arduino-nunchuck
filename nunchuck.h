#ifndef __NUNCHUCK_H__
#define __NUNCHUCK_H__

#include <Wire.h>

/*
 * Initializes I2C communication with the nunchuck.  Call this in the setup
 * function.
 */
void nunchuck_init() {
  Wire.begin();
  Wire.beginTransmission(0x52);
  Wire.send(0x40);
  Wire.send(0x00);
  Wire.endTransmission();
}

/*
 * Requests new values from the nunchuck.  Call this before reading nunchuck
 * values, and give the nunchuck a millisecond or so to respond.
 */
void nunchuck_request() {
  Wire.beginTransmission(0x52);
  Wire.send(0x00);
  Wire.endTransmission();
}

/*
 * Reads the current values from the nunchuck.  Make sure that
 * nunchuck_request() is before every call to this function, and make sure
 * to wait at least a millisecond or so before reading values.
 */
int nunchuck_read(int *jx, int *jy,
                  int *ax, int *ay, int *az,
                  int *bz, int *bc) {
  int outbuf[6];
  int cnt = 0;
  Wire.requestFrom(0x52, 6);
  while (Wire.available()) {
    outbuf[cnt++] = (Wire.receive() ^ 0x17) + 0x17;
  }
  if (cnt < 6) {
    return 0;
  }
  *jx = outbuf[0] - 128;
  *jy = outbuf[1] - 128;
  int b = outbuf[5];
  *ax = (outbuf[2] << 2 | ((b >> 2) & 3)) - 512;
  *ay = (outbuf[3] << 2 | ((b >> 4) & 3)) - 512;
  *az = (outbuf[4] << 2 | ((b >> 6) & 3)) - 512;
  *bz = ((b >> 0) & 1) ^ 1;
  *bc = ((b >> 1) & 1) ^ 1;
  return 1;
}

#endif
