#include <Adafruit_GFX.h>
#include <Adafruit_ST7789.h>
#include <SPI.h>
#include <SoftwareSerial.h>
#include <TinyGPS++.h>

// GPS and GSM setup
TinyGPSPlus gps;

// GPS serial on pins 4 (RX) and 5 (TX)
SoftwareSerial gpsSerial(4, 5);  

// GSM serial on hardware serial (pins 0,1) — WARNING: conflicts with Serial Monitor on many boards
SoftwareSerial gsmSerial(0, 1);  

// TFT display pins
#define TFT_CS   10
#define TFT_RST  9 
#define TFT_DC   8

Adafruit_ST7789 tft = Adafruit_ST7789(TFT_CS, TFT_DC, TFT_RST);

void setup() {
  gpsSerial.begin(9600);        // Start GPS
  Serial.begin(9600);           // Debug serial
  gsmSerial.begin(9600);        // GSM communication

  // Initialize TFT display
  tft.init(135, 240);
  tft.setRotation(3); 
  tft.fillScreen(ST77XX_RED);
  tft.setTextSize(2.5);
  tft.setTextColor(ST77XX_WHITE);
  tft.setCursor(10, 10);
  tft.println("Waiting for GPS...");

  // Initialize GSM
  Serial.println("Initializing GSM...");
  gsmSerial.println("AT");
  delay(1000);
  gsmSerial.println("AT+CMGF=1");  // Set SMS to text mode
  delay(1000);
  gsmSerial.println("AT+CNMI=1,2,0,0,0"); // Auto-show new SMS
  delay(1000);
  Serial.println("GSM Initialization Complete");
}

void loop() {
  // Read GPS data
  while (gpsSerial.available()) {
    gps.encode(gpsSerial.read());
    // Check for incoming SMS while reading GPS
  }

  // Display and log GPS data when new location is available
  if (gps.location.isUpdated()) {
    double lat = gps.location.lat();
    double lng = gps.location.lng();
    double alt = gps.altitude.meters();
    int sats = gps.satellites.value();

    // TFT Display Output
    tft.fillScreen(ST77XX_RED);
    tft.setCursor(15, 10);
    tft.print("Lat: ");
    tft.println(lat, 5);
    tft.println(" ");
    tft.print("Lng: ");
    tft.println(lng, 5);
    tft.println(" ");
    tft.print("Alt: ");
    tft.print(alt, 1);
    tft.println(" m");
    tft.println(" ");
    tft.print("Sats: ");
    tft.println(sats);
    tft.println(" ");

    // Serial Monitor Output
    Serial.println("------ GPS Data ------");
    Serial.print("Latitude: ");
    Serial.println(lat, 6);
    Serial.print("Longitude: ");
    Serial.println(lng, 6);
    Serial.print("Altitude: ");
    Serial.print(alt, 1);
    Serial.println(" m");
    Serial.print("Satellites: ");
    Serial.println(sats);

    String googleMapsUrl = "https://www.google.com/maps?q=" + String(lat, 6) + "," + String(lng, 6);
    Serial.println("Google Maps Link:");
    Serial.println(googleMapsUrl);
    Serial.println("----------------------");
  }
  checkIncomingSMS();  
}

void checkIncomingSMS() {
  static String smsBuffer = "";

  while (gsmSerial.available()) {  // Read from GSM
    char c = gsmSerial.read();
    smsBuffer += c;

    if (c == '\n') {
      // Debug print SMS content
      Serial.print("Received SMS: ");
      Serial.println(smsBuffer);

      // Check for GETLOC command
      if (smsBuffer.indexOf("GETLOC") >= 0) {
        double lat = gps.location.lat();
        double lng = gps.location.lng();
        if (gps.location.isValid()) {
          String locationUrl = "https://www.google.com/maps?q=" + String(lat, 6) + "," + String(lng, 6);
          sendSMS(locationUrl);
        } else {
          sendSMS("Location not available yet.");
        }
        smsBuffer = "";  // Clear buffer after handling
        return;
      }
      if (smsBuffer.length() > 200) {
        smsBuffer = "";  // Prevent overflow
      }
    }
  }
}

void sendSMS(String message) {
  Serial.println("Sending SMS...");
  gsmSerial.println("AT+CMGF=1");  
  delay(500);
  gsmSerial.println("AT+CMGS=\"+201020065576\"");  // Replace with desired number
  delay(500);
  gsmSerial.print(message);  
  delay(500);
  gsmSerial.write(26);  // Ctrl+Z to send
  delay(1000);
  Serial.println("SMS Sent");
}
