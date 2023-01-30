// Traffic Lights 
//Bruno Neemias 

//ARRAY PARA DEFINIR AS PORTAS QUE SERÃO USADAS. 
int I_O[8] = {6,7,8,9,10,11,12,13};

void setup()
{
  for(int nP = 0; nP<9; nP++){
    pinMode(I_O[nP], OUTPUT); 
  }
}

void loop(){
//PEDESTRE 
//SINAL VERMELHO ATIVO
  digitalWrite(I_O[1], HIGH); 
 
//VEICULOS 
//SINAL VERDE ENTRADA
  digitalWrite(I_O[2], HIGH); 
  digitalWrite(I_O[5], HIGH);
  delay(5000); 
//SAÍDA 
  digitalWrite(I_O[2], LOW); 
  digitalWrite(I_O[5], LOW);
  
// SINAL AMARELO ENTRADA  
  digitalWrite(I_O[3], HIGH); 
  digitalWrite(I_O[6], HIGH);
  delay(2000); 
//SAÍDA
  digitalWrite(I_O[3], LOW); 
  digitalWrite(I_O[6], LOW);

  
//VERMELHO VEICULOS ENTRADA 
  digitalWrite(I_O[4], HIGH); 
  digitalWrite(I_O[7], HIGH);
  
//PEDESTRE SAÍDA DO VERMELHO E ENTRADA DO VERDE.    
  digitalWrite(I_O[1], LOW);
  digitalWrite(I_O[0], HIGH);
  delay(4000); 

//AVISO PARA O PEDESTRE QUE O SINAL DE VEICULOS IRÁ ABRIR. 
 digitalWrite(I_O[0], LOW);
  for (int i=0; i<5; i++) {
    digitalWrite(I_O[1], HIGH);
    delay(250);
    digitalWrite(I_O[1], LOW);
    delay(250);
          }
  //VERMELHO VEICULOS SAIDA 
  digitalWrite(I_O[4], LOW); 
  digitalWrite(I_O[7], LOW);

  
          }
