#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>
#include <string.h>
#include "HX711.h"

#define FIREBASE_HOST "catcatcat-d877b.firebaseio.com"
//資料庫網址 勿包含”http://"和"/"
#define FIREBASE_AUTH "5SCBZYN5bQf2GyeRwVQmJz3PWtbewElYEm0Nvafu" // 資料庫密鑰
#define WIFI_SSID "Kuo's iPhone"     //wifi ssid
#define WIFI_PASSWORD "b06901023" //wifi password
#define THRESHOLD .1
//define pin
#define analog_wei   D0//DT
#define digital_wei   A0//SCK
#define MOTOR_A D5
#define MOTOR_B D6
#define MOTOR_C D7
#define MOTOR_D D8

//HX711
HX711 scale1;
//#include "MotorCtrl.h"  


// Functions are defined after setup() and loop()

FirebaseData firebaseData;

//參數
long weight = 0;
int pre_weight = 0;
int weight_diff = 0;
int count = 0; // positive number for consecutive positive weight difference, and vice versa
int requestFromDevice = -1;
int messageFromApps = -1;
String eventTime = "201903030303";
int eventId = -1;
int eventFoodMass = -1;
bool idle = false; // idle: not to send request
float threshold = 0.1;
// int foodInBowl = 0;

/*---------- 硬體相關 -----------*/
void motorturn(int speeds, int turns)
{
  for(int j=0; j<turns; j++)
    {
      for(int i=0; i< 512; i++)
        {
          digitalWrite(MOTOR_A,1);
          digitalWrite(MOTOR_B,0);
          digitalWrite(MOTOR_C,0);
          digitalWrite(MOTOR_D,0);
          delay(speeds);

            digitalWrite(MOTOR_A,1);
          digitalWrite(MOTOR_B,0);
          digitalWrite(MOTOR_C,0);
          digitalWrite(MOTOR_D,1);
          delay(speeds);

            digitalWrite(MOTOR_A,0);
          digitalWrite(MOTOR_B,0);
          digitalWrite(MOTOR_C,0);
          digitalWrite(MOTOR_D,1);
          delay(speeds);

           digitalWrite(MOTOR_A,0);
          digitalWrite(MOTOR_B,0);
          digitalWrite(MOTOR_C,1);
          digitalWrite(MOTOR_D,1);
          delay(speeds);

           digitalWrite(MOTOR_A,0);
          digitalWrite(MOTOR_B,0);
          digitalWrite(MOTOR_C,1);
          digitalWrite(MOTOR_D,0);
          delay(speeds);

           digitalWrite(MOTOR_A,0);
          digitalWrite(MOTOR_B,1);
          digitalWrite(MOTOR_C,1);
          digitalWrite(MOTOR_D,0);
          delay(speeds);

          digitalWrite(MOTOR_A,0);
          digitalWrite(MOTOR_B,1);
          digitalWrite(MOTOR_C,0);
          digitalWrite(MOTOR_D,0);
          delay(speeds);
          
          
          digitalWrite(MOTOR_A,1);
          digitalWrite(MOTOR_B,1);
          digitalWrite(MOTOR_C,0);
          digitalWrite(MOTOR_D,0);
          delay(speeds);
          

       
        }
    }
          digitalWrite(MOTOR_A,0);
          digitalWrite(MOTOR_B,0);
          digitalWrite(MOTOR_C,0);
          digitalWrite(MOTOR_D,0);
          
}

/// TODO: Get data from weight sensor 
long getBodyWeight(){
  long i=0;
  i=analogRead(digital_wei);
return i;
}

/// TODO: Get catId from detected weight
int getIdFromWeight(int weight){
  return 1;
}

/// TODO: release food of certain amount
bool releaseFood(int mass){
  switch(mass){
    case 1:
    motorturn(1,1);break;
    case 2:
    motorturn(2,2);break;
    case 3:
    motorturn(3,3);break;
    
    
  }
  return true;
}


/*---------- 程式使用 -----------*/

// set /cache/event, argument(firebaseData, time, id, massFood)
bool setEvent(FirebaseData fbd, String time = "", int id = -1, int foodMass = -1){
  bool good = true;
  if (!Firebase.setString(fbd, "/cache/event/time", time)) !good;
  if (!Firebase.setInt(fbd, "/cache/event/id", id)) !good;
  if (!Firebase.setInt(fbd, "/cache/event/foodMass", foodMass)) !good;
  return good;
}
bool resetEvent(FirebaseData fbd){
  return setEvent(fbd, "", -1, -1);
}


// set & reset /cache/requestFromDevice
bool setRequestFromDevice(FirebaseData fbd, int requestFromDevice){
  return Firebase.setInt(fbd, "/cache/requestFromDevice", requestFromDevice);
}
bool resetRequestFromDevice(FirebaseData fbd){
  return setRequestFromDevice(fbd, -1);
}


// set & reset /cache/messageFromApps
bool setMessageFromApps(FirebaseData fbd, int messageFromApps){
  return Firebase.setInt(fbd, "/cache/messageFromApps", messageFromApps);
}
bool resetMessageFromApps(FirebaseData fbd){
  return setMessageFromApps(fbd, -1);
}


// write history of cat's meal and update /data/cat?/latestMealTime
bool writeHistory(FirebaseData fbd, int catId, int foodMass, String time){
  String path = "/data/cat"+String(catId)+"/history";
  String jsonString = "{\"foodMass\":\"" + String(foodMass) + "\",\"time\":\"" + time + "\"}";
  return Firebase.pushJSON(fbd, path, jsonString);
}

void setup() {
  Serial.begin(57600);  //啟用通訊
  WiFi.begin(WIFI_SSID,WIFI_PASSWORD); //連線至wifi
  Serial.println();
  Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH); //連線至資料庫
  pinMode(D5,OUTPUT);
  pinMode(D6,OUTPUT);
  pinMode(D7,OUTPUT);
  pinMode(D8,OUTPUT);
  
}


void loop() {
  //Serial.println("-------------------------------");
  delay(500);
  bool success = true;

  // Check wifi connection
  while (WiFi.status()!=WL_CONNECTED){ //尚未連接成功
    Serial.print(".");
    delay(500);
  }
  //Serial.println("connected");
  
  // :)
  weight = getBodyWeight();
  //Serial.print("Weight:");
//  Serial.println(weight);
  weight_diff = weight - pre_weight;
//  Serial.print("Weightdiff:");
//  Serial.println(weight_diff);
//  Serial.print("count = ");
//  Serial.println(count);
//  Serial.println("- - - - - - - - - - - - - - -");

  //get data from Firebase
  /// TODO: make sure how to correctly read out String/float data

  if (Firebase.getInt(firebaseData, "/cache/requestFromDevice") && firebaseData.dataType() == "int") {
    requestFromDevice = firebaseData.intData();
//    Serial.print("RRRRequestFromDevice: ");
//    Serial.println(requestFromDevice);
  }
  
  if (Firebase.getInt(firebaseData, "/cache/messageFromApps") && firebaseData.dataType() == "int") {
    messageFromApps = firebaseData.intData();
//    Serial.print("MMMMessageFromApps: ");
//    Serial.println(messageFromApps);
  }
  if (Firebase.getInt(firebaseData, "/cache/event/id") && firebaseData.dataType() == "int") {
    eventId = firebaseData.intData();
//    Serial.print("EEEEventId: ");
//    Serial.println(eventId);
  }
  if (Firebase.getString(firebaseData, "/cache/event/time") && firebaseData.dataType() == "String") {
    eventTime = firebaseData.jsonData();
//    Serial.print("EEEEventTime: ");
//    Serial.println(eventTime);
  }
  if (Firebase.getInt(firebaseData, "/cache/event/foodMass") && firebaseData.dataType() == "int") {
    eventFoodMass = firebaseData.intData();
//    Serial.print("EEEEventFoodMass: ");
//    Serial.println(eventFoodMass);
  }


  // Message from apps is non-zero
  if (messageFromApps > 0){
//    Serial.print("messageFromApps > 0: = ");
//    Serial.println(messageFromApps);
    releaseFood(messageFromApps);
    resetRequestFromDevice(firebaseData);
    resetMessageFromApps(firebaseData);
    setEvent(firebaseData, eventTime, eventId, messageFromApps);
    idle = true;
    !success;
  }

  // modify THRESHOLD:
  count == 0 ? threshold = -THRESHOLD : threshold = THRESHOLD;

  // Detect increasing weight (i.e. cat comes)
  if (weight_diff > -threshold && success){

    //Change of weight difference is larger than -THRESHOLD for 2 seconds -> cat walks on 
    if(count < 0){
      count = 0;
      success=false;
    } else {
      count += 1;
      if (count < 1) success=false;
    }
    if(success) Serial.println("Cat Comes");
    int catId = getIdFromWeight(weight);
//    Serial.print("Cat id = ");
//    Serial.println(catId);
    
    // No request, no foodMass in /cache/event: send request, update /cache/event/id
    if (requestFromDevice == -1 && eventFoodMass == -1 && !idle){
//      Serial.println("Case 1 (send req)");
      setRequestFromDevice(firebaseData, catId);
      setEvent(firebaseData, eventTime, catId, eventFoodMass);
      success=false;
    } 

    // No request, with message from apps: (should be in and) remain idle, update /cache/event/id
    // 反正他是來吃飯的
    if (requestFromDevice == -1 && eventFoodMass > 0 && idle){
//      Serial.println("Case 2(nothing special");
      setEvent(firebaseData, eventTime, catId, eventFoodMass);
      success=false;
    }

    // Othewise, save current catId to /cache/event/id 
    setEvent(firebaseData, eventTime, catId, eventFoodMass);
    success=false;
  }



  // Detect decreasing weight (i.e. cat leaves)
  if (weight_diff < +threshold && success){ 

    

    //Change of weight difference is larger than -THRESHOLD for 2 seconds -> cat walks on 
    if(count > 0){
      count = 0;
      success=false;
    } else {
      count -= 1;
      if (count > -1) success=false;
    }
//    if(success) Serial.println("Cat goes");
    // When cat leaves, it must have walked on -> cache/event/id is not -1
    int catId = eventId;

    // cache/event/foodMass > 0: Assume it eats all food and leaves
    // 反正他吃完了
    if (eventFoodMass > 0){
//      Serial.println("finish, write history");
      resetRequestFromDevice(firebaseData);
      resetMessageFromApps(firebaseData);
      writeHistory(firebaseData, catId, eventFoodMass, eventTime);
      idle = false;
      success=false;
    } 

    // 不管怎樣 event 都會重設
    if (success){
      resetEvent(firebaseData);
//                 Serial.println("Event reset");
    }
  }

  pre_weight = weight;
}
