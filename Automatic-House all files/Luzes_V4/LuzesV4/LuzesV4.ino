
//ILUMINAÇÃO - ESQUEMA
//(SALA)            PINO 0
//(COZINHA)         PINO 1
//(BANHEIRO 1)      PINO 2 
//(GARAGEM)         PINO 3
//ATRÁS GARAGEM)    PINO 4
//(QUARTO 1)        PINO 5
//(QUARTO 2)        PINO 6 
//(QUARTO 3)        PINO 7
//(BANHEIRO 2)      PINO 8
//(PORTA E VARANDA) PINO 9  

//BIBLIOTECAS 
 
#include<SoftwareSerial.h>; // Inclui a biblioteca do bluetooth
SoftwareSerial HC05(10,11);// declara os pinos 10 e 11 como RX e TX do módulo bluetooth
 
int Luzes[10] = {12,13,2,3,4,5,6,7,8,9}; //ARRAY PARA OS 10 LEDs 

int comando = 0; // Variavel que faz leitura dos comandos do celular para o módulo 
int LDR = A5; // Variavel para leitura da iluminação no ambiente 

void setup() {
  
 Serial.begin(9600); // Inicia a comunicação serial do arduino
 HC05.begin(38400); // = inicia a comunicação serial entre o módulo bluetooth e o arduino 

 // Laço para testar todos os leds ao iniciar o programa 
  for (int nP =0; nP<10; nP ++) {
    pinMode(Luzes[nP], OUTPUT);
    digitalWrite(Luzes[nP], HIGH);
    delay(500); 
    digitalWrite(Luzes[nP], LOW);
  }
  Serial.println("Setup finalizado!"); 
}

void loop() {
  int estado = analogRead(LDR); // Realiza a leitura do LDR. 

  // condição para ligar ou desligar a ilumincação externa
  if (estado > 700) { 
    digitalWrite(Luzes[9] and Luzes[8], HIGH);
    digitalWrite(Luzes[8], HIGH); 
  }else{ 
    digitalWrite(Luzes[9],LOW); 
    digitalWrite(Luzes[8],LOW); 
  }

  // Leitura do comando fornecido pelo app  e condições de acionamento dos LEDS  
  comando = HC05.read(); 
  if On_Off(
   

  

}
