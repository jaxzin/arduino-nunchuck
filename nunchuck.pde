#include <Wire.h>
#include <string.h>
#include <stdio.h>

void nunchuck_init() {
  Wire.begin();
  Wire.beginTransmission(0x52);
  Wire.send(0x40);
  Wire.endTransmission();
}

void nunchuck_request() {
  Wire.beginTransmission(0x52);
  Wire.send(0x00);
  Wire.endTransmission();
}

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
  *jx = outbuf[0];
  *jy = outbuf[1];
  int b = outbuf[5];
  *ax = outbuf[2] << 2 | ((b >> 2) & 3);
  *ay = outbuf[3] << 2 | ((b >> 4) & 3);
  *az = outbuf[4] << 2 | ((b >> 6) & 3);
  *bz = ((b >> 0) & 1) ^ 1;
  *bc = ((b >> 1) & 1) ^ 1;
  return 1;
}

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

