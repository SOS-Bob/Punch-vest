/*
 * Created by Peacebob - 2022-03-10
 * 
 * This sketch delivers the punch calls from Arduino to a set of relays.
 * 
 * Once this is uploaded to the Arduino, open the Serial Monitor by pressing ctrl+shift+M
 * 
 * In the Serial Monitor, Set the baud rate to 9600 and select "No line ending"
 * 
 * Now type "on" to turn the built-in LED on or type "off" to turn the built-in LED off
 * 
 * Additionally, once connected, this sketch will send "Button Pressed!" to the Serial port when the button on pin 12 is pressed
 * 
 */

String readString;
char buff[100];               //100 character buffer
const int buttonPin = 12;    // the number of the pushbutton pin. The other pin of the button goes to ground
int buttonState = 0;         // variable for reading the pushbutton status
const int Pin1 = 1;    // the number of the pin.
int Pin1State = 0;         // variable for reading the pin status
const int Pin2 = 2;
int Pin2State = 0;
const int Pin3 = 3;
int Pin3State = 0;
const int Pin4 = 4;
int Pin4State = 0;
const int Pin5 = 5;
int Pin5State = 0;
const int Pin6 = 6;
int Pin6State = 0;
const int Pin7 = 7;
int Pin7State = 0;
const int Pin8 = 8;
int Pin8State = 0;

void setup() 
{

  // Set encoder pins 
  pinMode(LED_BUILTIN, OUTPUT);       //Most Arduinos should have an LED_BUILTIN. Tested with Uno
  pinMode(buttonPin, INPUT_PULLUP); 
  
  pinMode(Pin1, OUTPUT);       
  pinMode(Pin2, OUTPUT); 
  pinMode(Pin3, OUTPUT);
  pinMode(Pin4, OUTPUT); 
  pinMode(Pin5, OUTPUT);
  pinMode(Pin6, OUTPUT);
  pinMode(Pin7, OUTPUT);
  pinMode(Pin8, OUTPUT);
  
  digitalWrite(LED_BUILTIN, LOW);     //Turn the LED off by default
  
  digitalWrite(Pin1, LOW);     //Turn the pin off by default
  digitalWrite(Pin2, LOW);
  digitalWrite(Pin3, LOW);
  digitalWrite(Pin4, LOW); 
  digitalWrite(Pin5, LOW);   
  digitalWrite(Pin6, LOW);   
  digitalWrite(Pin7, LOW);
  digitalWrite(Pin8, LOW);
  


  // Setup Serial Monitor
  Serial.begin(9600);
}

void loop() 
{
  //========== Button press ===========================
  buttonState = !(digitalRead(buttonPin));  //The ! character inverts the input. This is important since we're using INPUT_PULLUP as the pinMode
  Pin1State = !(digitalRead(Pin1));
  
  if (buttonState == HIGH) {
    Serial.println("Button pressed!");
    delay(300);
  }
    if (Pin1State == HIGH) {
    Serial.println("Valve1 open");
    delay(300);
  }
      if (Pin2State == HIGH) {
    Serial.println("Valve2 open");
    delay(300);
  }
      if (Pin3State == HIGH) {
    Serial.println("Valve3 open");
    delay(300);
  }
      if (Pin4State == HIGH) {
    Serial.println("Valve4 open");
    delay(300);
  }
      if (Pin5State == HIGH) {
    Serial.println("Valve5 open");
    delay(300);
  }
      if (Pin6State == HIGH) {
    Serial.println("Valve6 open");
    delay(300);
  }
      if (Pin7State == HIGH) {
    Serial.println("Valve7 open");
    delay(300);
  }
      if (Pin8State == HIGH) {
    Serial.println("Valve8 open");
    delay(300);
  }
  
  //========== Handle serial input ====================
  while (Serial.available()) 
    {
      char c = Serial.read();  //gets one byte from serial buffer
      readString += c; //makes the string readString
      delay(2);  //slow looping to allow buffer to fill with next character
    }

    if (readString.length() >0) 
    {
      readString.toLowerCase();   //Set the input to all lower case

      Serial.println(readString); //Echo the typed input back to the serial monitor

      if(readString == "on") 
      {
        digitalWrite(LED_BUILTIN, HIGH);  //Turn the LED on
      }
          if(readString == "off") 
      {
        digitalWrite(LED_BUILTIN, LOW);   //Turn the LED off
      }
    
          if(readString == "1") 
      {
        digitalWrite(Pin1, HIGH);  //Open valve 1
    delay(100);
    digitalWrite(Pin1, LOW);  //Close valve 1
      }
    
          if(readString == "2") 
    {
        digitalWrite(Pin2, HIGH);  //Open valve 2
    delay(100);
    digitalWrite(Pin2, LOW);  //Close valve 2
      }
    
              if(readString == "3") 
    {
        digitalWrite(Pin3, HIGH);  //Open valve 3
    delay(100);
    digitalWrite(Pin3, LOW);  //Close valve 3
      }
    
        
              if(readString == "4") 
    {
        digitalWrite(Pin4, HIGH);  //Open valve 4
    delay(100);
    digitalWrite(Pin4, LOW);  //Close valve 4
      }

              if(readString == "5") 
    {
        digitalWrite(Pin5, HIGH);  //Open valve 5
    delay(100);
    digitalWrite(Pin5, LOW);  //Close valve 5
      }
       
              if(readString == "6") 
    {
        digitalWrite(Pin6, HIGH);  //Open valve 6
    delay(100);
    digitalWrite(Pin6, LOW);  //Close valve 6
      }
            
       
              if(readString == "7") 
    {
        digitalWrite(Pin7, HIGH);  //Open valve 7
    delay(100);
    digitalWrite(Pin7, LOW);  //Close valve 7
      }
          
              if(readString == "8") 
    {
        digitalWrite(Pin8, HIGH);  //Open valve 8
    delay(100);
    digitalWrite(Pin8, LOW);  //Close valve 8
      }
                
    }  
    readString = "";      //Clear the readString variable so it doens't just constantly grow
}
