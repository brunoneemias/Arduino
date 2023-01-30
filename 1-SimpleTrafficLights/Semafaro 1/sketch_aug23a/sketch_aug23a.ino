//Traffic Lights
//Aluno: Bruno Neemias Alves Mota RA - 166739
//

int I_O[7] = {2,3,4,5,7,8,9};

void setup()
{
  for(int nP = 0; nP<7; nP++){
    pinMode(I_O[nP],OUTPUT); 
}
}

void loop()
{
  //Pedestrian
  digitalWrite(I_O[4],LOW);
  digitalWrite(I_O[0], LOW); 
  digitalWrite(I_O[1], HIGH);
  
  //Vehicles
  //GREEN
  digitalWrite(I_O[2], HIGH);
  delay(5000); // Wait for 5000 millisecond(s)
  
  //YELLOW
  digitalWrite(I_O[2],LOW); 
  digitalWrite(I_O[3], HIGH);
  delay(2000); // Wait for 2000 millisecond(s)
  
  //RED
  //Vehicles
  digitalWrite(I_O[3],LOW); 
  digitalWrite(I_O[4],HIGH);
  
  digitalWrite(I_O[1],LOW ); 
  digitalWrite(I_O[0], HIGH); 

  delay(4000); 
    digitalWrite(I_O[0], LOW); 
 for (int i=0; i<4; i++) {
      digitalWrite(I_O[1],HIGH); 
      delay(250);
      digitalWrite(I_O[1],LOW);
      delay(250);
      }
 
   
    
}
