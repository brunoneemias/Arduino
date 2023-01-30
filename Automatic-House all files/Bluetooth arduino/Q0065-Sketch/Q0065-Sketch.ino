#include <SoftwareSerial.h>

SoftwareSerial serial1(10, 11); // RX, TX

int pinPortas[10] = {12,13,2,3,4,5,6,7,8,9};

void setup() {
  serial1.begin(9600);

  for (int nP=0; nP<10; nP++) {
      pinMode(pinPortas[nP], OUTPUT);

      byte byteEnviar = nP + 1;
      byteEnviar = bitSet(bitSet(byteEnviar, 6), 5);
      serial1.println(byteEnviar);
  }
}

void loop() {  
  if (serial1.available()) {
     byte byteRecebido = serial1.read();

     boolean acao  = bitRead(byteRecebido, 5); //Lê se o comando é para ligar ou desligar
     byte    porta = bitClear(bitClear(byteRecebido, 6), 5); 

     digitalWrite(pinPortas[porta - 1], !acao);
  }
}
