#include <Adafruit_SleepyDog.h>
#include <SoftwareSerial.h>
#include "Adafruit_FONA.h"
#include "Adafruit_MQTT.h"
#include "Adafruit_MQTT_FONA.h"

#define FONA_RX  11
#define FONA_TX  10
#define FONA_RST 4
SoftwareSerial fonaSS = SoftwareSerial(FONA_TX, FONA_RX);

Adafruit_FONA fona = Adafruit_FONA(FONA_RST);

#define FONA_APN       "internet"
#define FONA_USERNAME  ""
#define FONA_PASSWORD  ""
#define AIO_SERVER      "92.205.30.28"
#define AIO_SERVERPORT  1883

Adafruit_MQTT_FONA mqtt(&fona, AIO_SERVER, AIO_SERVERPORT);
#define halt(s) { Serial.println(F( s )); while(1);  }
boolean FONAconnect(const __FlashStringHelper *apn, const __FlashStringHelper *username, const __FlashStringHelper *password);

Adafruit_MQTT_Subscribe loc = Adafruit_MQTT_Subscribe(&mqtt, "1-house");

uint8_t txfailures = 0;
#define MAXTXFAILURES 3

const int motorPin1 = 5;
const int motorPin2 = 6;
const int motorPin3 = 7;
const int motorPin4 = 8;
int motorDelay = 2;

void setup() {
  pinMode(motorPin1, OUTPUT);
  pinMode(motorPin2, OUTPUT);
  pinMode(motorPin3, OUTPUT);
  pinMode(motorPin4, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(A0, INPUT);

  Serial.begin(9600);
  Serial.println(F("System started."));
  mqtt.subscribe(&loc);

  Watchdog.reset();
  delay(5000);
  Watchdog.reset();

  while (! FONAconnect(F(FONA_APN), F(FONA_USERNAME), F(FONA_PASSWORD))) {
    Serial.println("Retrying FONA");
  }
  Serial.println(F("Connected to Cellular!"));
  Watchdog.reset();
  delay(5000);
  Watchdog.reset();
}

uint32_t x = 0;

void loop() {

  Watchdog.reset();
  MQTT_connect();

  Watchdog.reset();

  Adafruit_MQTT_Subscribe *subscription;
  while ((subscription = mqtt.readSubscription(1000))) {
    if (subscription == &loc) {
      Serial.print(F("------------------------------------------------Got: "));
      String gelenVeri = String((char *)loc.lastread);
      Serial.println(gelenVeri);
      if (gelenVeri == "open") {
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        Serial.print(F("OPEN "));
        digitalWrite(12, LOW);
        digitalWrite(13, HIGH);
        turn180Forward();
      }
      else if (gelenVeri == "lock") {
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        Serial.print(F("LOCK "));
        digitalWrite(12, HIGH);
        digitalWrite(13, LOW);
        turn180Backward();
      }
      else {
        Serial.print(F("------------------------------------------------ELSE: "));
      }
    }
  }

  /*
    if (!mqtt.ping()) {
      Serial.println(F("MQTT Ping failed."));
    }
  */
}

void MQTT_connect() {
  int8_t ret;
  if (mqtt.connected()) {
    return;
  }
  Serial.print("Connecting to MQTT... ");
  while ((ret = mqtt.connect()) != 0) {
    Serial.println(mqtt.connectErrorString(ret));
    Serial.println("Retrying MQTT connection in 5 seconds...");
    mqtt.disconnect();
    delay(5000);
  }
  Serial.println("MQTT Connected!");
  digitalWrite(12, HIGH);
  digitalWrite(13, LOW);
}


void step1(){
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, LOW);
  delay(motorDelay);
}

void step2(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, LOW);
  delay(motorDelay);
}


void step3(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, HIGH);
  digitalWrite(motorPin4, LOW);
  delay(motorDelay);
}

void step4(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, HIGH);
  delay(motorDelay);
}

void turn180Forward(){
  for(int i = 0; i<2048; i++){
    step1();
    step2();
    step3();
    step4();
  }
}

void turn180Backward(){
  for(int i = 0; i<2048; i++){
    step4();
    step3();
    step2();
    step1();
  }
}
