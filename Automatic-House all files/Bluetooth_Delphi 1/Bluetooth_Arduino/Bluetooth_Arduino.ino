#include <SoftwareSerial.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

Adafruit_SSD1306 display;  
SoftwareSerial mySerial(0,1);

String veri;                     //Bluetooth üzerinden okuduğumuz değişken.
String oncekiveri;               //Bluetooth üzerinden okuduğumuz değişken.
int kirmiziPin = 8;              //RGB Ledin kırmızı bacağının takılacağı pin
int yesilPin = 10;               //RGB Ledin yeşil bacağının takılacağı pin       
int maviPin = 11;                //RGB Ledin mavi bacağının takılacağı pin
#define neopixel 12
Adafruit_NeoPixel strip = Adafruit_NeoPixel(12, neopixel, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(9600);               //Seri haberleşmeyi başlatıyoruz.
  pinMode(kirmiziPin,OUTPUT);       //Kırmızı pinini OUTPUT olarak ayarlıyoruz.
  pinMode(yesilPin,OUTPUT);         //Yeşl pinini OUTPUT olarak ayarlıyoruz.
  pinMode(maviPin,OUTPUT);          //Mavi pinini OUTPUT olarak ayarlıyoruz.

  setColor(255, 0, 0);
  delay(500);
  setColor(0, 255, 0);
  delay(500);
  setColor(0, 0, 255);
  delay(500);
  setColor(255, 255, 255);  

  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  Wire.begin();
  display.clearDisplay();
  display.setTextColor(WHITE);
  display.setTextSize(1);
  display.setCursor(2,1);
  display.print("Gelen Deger");
  display.display();
  oncekiveri = "";
  #if defined (__AVR_ATtiny85__)
  if (F_CPU == 16000000) clock_prescale_set(clock_div_1);
  #endif
  // End of trinket special code
  strip.begin();
  strip.setBrightness(50);
  strip.show(); // Initialize all pixels to 'off'

}

void loop() 
{
  if(Serial.available()>0)
  {         //Seri haberleşmeden veri gelmesini bekliyoruz.
    veri = Serial.readString();           //Seri haberleşmeden gelen veriyi okuyoruz.
  }
  if (veri != oncekiveri) 
  {
     display.clearDisplay();
     display.setTextColor(WHITE);
     display.setTextSize(1);
     display.setCursor(2,1);
     display.print("Gelen Deger");
     
     display.setTextSize(2);
     display.setCursor(1,12);
     display.print(veri);
     display.display();
  }
  if (veri == '&ABC-123')
  {             //Seri haberleşmeden m harfi geldiğinde bu kısım çalışır.
    digitalWrite(maviPin,LOW);
    digitalWrite(yesilPin,HIGH);
    digitalWrite(kirmiziPin,LOW);
  }
  else if (String(veri).indexOf("%$") >=0) // HEXA RENK ALGILAMASI
  {
    String veristr = String(veri).substring(4,12);
    long number = (long) strtol( &veristr[0], NULL, 16);
    long r = number >> 16;
    long g = number >> 8 & 0xFF;
    long b = number & 0xFF;

    if (veri != oncekiveri) 
    {
     display.clearDisplay();
     display.setTextColor(WHITE);
     display.setTextSize(1);
     display.setCursor(2,1);
     display.print(veristr);
     
     display.setTextSize(1);
     display.setCursor(1,12);

     display.print("r:"+String(r)+" g:"+String(g)+" b:"+String(b));
     display.display();
     setColor(r,g,b);
     colorWipe(strip.Color(r, g, b), 50); // Red
    } 
  }
  oncekiveri = veri;
}

void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
  }
}

void setColor(int red, int green, int blue)
{
  analogWrite(kirmiziPin, red);
  analogWrite(yesilPin, green);
  analogWrite(maviPin, blue);
}
