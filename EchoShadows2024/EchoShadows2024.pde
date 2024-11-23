/*
v19 
Change 3 booster button in TouchOSC to control different booster levels

*/


/*
v18 
Boost the amp more and lower the fading rate in laptop moede 
change the demo mode unit 4 to 5 color in each led
*/

/*
v17 constrain mapping data to avoid too fickering, and constrain different color to different ranges.
Will test in the real space to see if use v16 or v17
*/

/*
v16 Add a control interface by using TouchOSC.
different input setting
*/

/*
V15 tested in 103B(4/13), it looks like good to go! keep the setting.(Use some props, it looks so good.)
*/

/* 
V14 4/10
*/

/*
- V11 to v13 tested some new combinnation of 4 fixtures 
and using for loop to mapping the myAudioData[0] data to 
control the 5 indivdual LED for each unit. (It's not super obviously changing over the music.
need to test out the color combinnation to make the shadows more colorful or clear to see.)

- Pure Red pattern is too bright and too fast, can not see the shadows well.

*/

/*v9+10 3/31
-used 4 fixtures 
-made a timer to switch different patterns(ex: two at a time, four at a time,
                                                        pure red, etc)
-mapping the [0] sound level to control thr pattern switching time.

*/

//v8 3/28, used random to control period and map the vaule out off the range to see what will happend,
//also test how many gain need to be applied for line in to get fft data as same as possible with playback in laptop

//v6 made by mar 27 trying to mapping data in different range.

//v5 made by mar 25 trying to fix the mapping data error.

//v4 made by mar 24 2024 tested different value to make be more responsive

//v2 made by mar 23 2024 tested different pos and color

//v1 made by mar 21 2024

//Testing in 12/18/2023 with 20 channel mode of the wash light, control the light bulls individually.

import processing.serial.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import com.jaysonh.dmx4artists.*;

import processing.net.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
OscMessage theMessage;
NetAddress receiveAddr;
//make a array to store the OSC addresses of faders and buttons, TouchOSC be able to receive the message from Processing///////
String[] oscAddr = {"/soundMode","/demoMode",
                    "/unit1", "/unit2","/unit3", "/unit4",
                    "/NORBOOSTER","/BOOSTER+", "/BOOSTER++", "/threshold", "/red", "/green", "/blue"};


//4 lights as a whole
//DMXControl dmx;
//DMXFixture fixture;
//int numDmxChannels = 256; // number of channels we will use
//int lightAddress = 1;
//int lightChannels = 80;
//int channel;

DMXControl dmx;
DMXFixture unit1;
DMXFixture unit2;
DMXFixture unit3;
DMXFixture unit4;

int numDmxChannels = 511; // total channels can be used
int lightChannels = 20;
int unit1Address = 1;
int unit2Address = 21;
int unit3Address = 41;
int unit4Address = 61;

int rChan = 1;
int gChan = 2;
int bChan = 3;
int wChan = 4;
int chanInterval = 4;

int totalLedsPerUnit = 5;
int[] dmxChanRed   = {1,5,9,13,17};
int[] dmxChanGreen = {2,6,10,14,18};
int[] dmxChanBlue  = {3,7,11,15,19};


Minim minim;
AudioInput myAudio;
FFT myAudioFFT;

//2024/04/13 Data is coming from the audio interface with loopback throught laptop(use this setting)
int myAudioRange = 15;
int myAudioMax = 100;//100
float myAudioAmp = 15; //15
float myAudioIndex = 0.415;  //0.451,0.435,0.415
float myAudioIndexAmp = myAudioIndex;
float myAudioIndexStep = 0.215;//0.214
float[] myAudioData = new float[myAudioRange];

////2024/04/13 Data is coming from the audio interface with line in 1, use gain(gain about 44-48dB)
//int myAudioRange = 15;
//int myAudioMax = 100;//100
//float myAudioAmp = 25; //24,23.75(47dB), 25(45dB)
//float myAudioIndex = 0.457;  //0.1,0.2，0.15
//float myAudioIndexAmp = myAudioIndex;
//float myAudioIndexStep = 0.36;//0.15
//float[] myAudioData = new float[myAudioRange];


//2024/03/28 Data is coming from the audio interface with line in 1, use auto gain(gain about 30dB)
//int myAudioRange = 15;
//int myAudioMax = 100;//100
//float myAudioAmp = 46; //24
//float myAudioIndex = 0.540;  //0.1,0.2，0.15
//float myAudioIndexAmp = myAudioIndex;
//float myAudioIndexStep = 0.255;//0.15
//float[] myAudioData = new float[myAudioRange];


float fade = 0.0;
float fadeDefault;
float fadeNorBooster;
float fadeBoosterPlus;
float fadeBoosterPlus2;


int red;
int green;
int blue;

int p; //use it to control how many Led in one unit to lit up

float rP1=0.25;
float rP2=0.45;
float rP3=0.65;
float rP4=0.85;

float gP1=0.35;
float gP2=0.45;
float gP3=0.55;
float gP4=0.65;

float bP1=0.3;
float bP2=0.5;
float bP3=0.7;
float bP4=0.9;

float th = 69.0; //Determine what point to switch to another mapping setting 
//int lightChan = 20;

int maxSwitTime = 9000;
int minSwitTime = 1000;
int switchTime  = maxSwitTime;
int lastSwitchTime = 0;
//boolean swithFixture = false;
//int fixtureSwitchIndex = 0;
int switchIndex;
int sw = 6;
String pattern;

//int chanIntervalCoe;
//float redPro;
//float greenPro;
//float bluePro;


//////////////////////for TouchOSC//////////////////////////////
float soundModeButton;
float demoModeButton;
float unit1Button;
float unit2Button;
float unit3Button;
float unit4Button;
float norBoosterButton;
float boosterPlusButton;
float boosterPlus2Button;
float resetButton; 
//float thresholdOSC;
float redOSC;
float greenOSC;
float blueOSC;
float redDemo=255.0;
float greenDemo=255.0;
float blueDemo=255.0;
float resetB;


void setup() {
  size(400, 400);
  //fullScreen();
  
  //noCursor();

  minim = new Minim(this);
  myAudio = minim.getLineIn();

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  //myAudioFFT.window(FFT.GAUSS);
  myAudioFFT.window(FFT.HAMMING);
  //myAudioFFT.window(FFT.HANN);
   //myAudioFFT.window(FFT.LANCZOS);
  //myAudioFFT.window(FFT.NONE);

  dmx = new DMXControl( 0, numDmxChannels );
  dmx.setFixtureFade( true );
  //dmx.setFixtureFadeRate(fade);

  //fixture = new DMXFixture( this, lightAddress, lightChannels );
  //dmx.addFixture( fixture );
  
  unit1 = new DMXFixture(this, unit1Address, lightChannels);
  unit2 = new DMXFixture(this, unit2Address, lightChannels);
  unit3 = new DMXFixture(this, unit3Address, lightChannels);
  unit4 = new DMXFixture(this, unit4Address, lightChannels);
  
  dmx.addFixture(unit1);
  dmx.addFixture(unit2);
  dmx.addFixture(unit3);
  dmx.addFixture(unit4);
  
    //set send OSC port
   oscP5 = new OscP5(this,9100);
   
   /*set OSC receive port and ip address
     set the receive port to 12000, the ip address will be the ip address for the control device,
     if using the computer to run the UI, the ip address will be the computer ip,
     if using iPad, the ip will be the iPad ip
   */
   receiveAddr = new NetAddress("127.0.0.1", 12000);
   //receiveAddr = new NetAddress("192.168.50.94", 12000);
  
    
}


void draw() {
    //background(127);
    myAudioFFT.forward(myAudio.mix);
    myAudioDataUpdate();
    
    //infiniteRect();
    
    //fade = map(myAudioData[0],0,100,0.25,0.05);
   // fade = map(myAudioData[0], 0, 100, 0.25, 0.1);

     // //p = int(random(map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1])*12.5, 1, 6),6));
      
     //fadeDefault = map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1]), 0.05, 0.25);
     //fadeNorBooster = map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1]), 0.025, 0.195);
     //fadeBoosterPlus = map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1]), 0.020, 0.190);
     //fadeBoosterPlus2 = map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1]), 0.005, 0.175);
      
     fadeDefault = map(myAudioData[0],      0, 100, 0.05,  0.25);
     fadeNorBooster = map(myAudioData[0],   0, 100, 0.025, 0.195);
     fadeBoosterPlus = map(myAudioData[0],  0, 100, 0.020, 0.190);
     fadeBoosterPlus2 = map(myAudioData[0], 0, 100, 0.010, 0.175);
    //fade = map(myAudioData[0], 0, 100, 0.05, 0.3);
    dmx.setFixtureFadeRate(fade);  

    //chanIntervalCoe = int(map(myAudioData[0],0,100,0,5));
    //redPro = map(myAudioData[0],0,100,0.4,1);
    //greenPro = map(myAudioData[1],0,80,0.1,1);
    //bluePro = map(myAudioData[0],0,100,1,0.1);
    
    ////println("chanIntervalCoe: " + chanIntervalCoe);
    //println("redPro: " + redPro);
    //println("greenPro: " + greenPro);
    //println("bluePro: " + bluePro);
    
    //////If the Reset button in TouchOSC is pressed(momentary),set all the value back to 0//////
     if(resetB == 1) {
       for(int i=0; i<oscAddr.length;i++){
        OscMessage myMessage = new OscMessage(oscAddr[i]);
        myMessage.add(0.0);
        oscP5.send(myMessage, receiveAddr);
       }
       
     }
     
     
     redDemo   = map(redOSC,  0,1,0,255);
     greenDemo = map(greenOSC,0,1,0,255);
     blueDemo  = map(blueOSC, 0,1,0,255);
    
////////////////Using the TouchOSC Buttons to control different functions//////////////////            
       if (soundModeButton ==1
           && demoModeButton ==0 
           ){
             soundMode();
           
         } else if (soundModeButton ==0
                     && demoModeButton ==1 ) {
             
             demoMode();
             
             } else {
               
               for(int i = rChan; i<lightChannels; i++) {
                    unit1.sendValue(i, 0);
                    unit2.sendValue(i, 0);
                    unit3.sendValue(i, 0);
                    unit4.sendValue(i, 0);
                  }
                  
             }
             

        
/////////////assign different value for different sound source input////////////////////////////////

      if(boosterPlusButton == 1 && boosterPlus2Button == 0 && norBoosterButton == 0){
          myAudioRange = 15;
          myAudioMax = 100;
          myAudioAmp = 33; 
          myAudioIndex = 0.35;  
          myAudioIndexAmp = myAudioIndex;
          myAudioIndexStep = 0.475;
          
          println("Booste the data to BOOSTER+ mode."); 
          fade = fadeBoosterPlus;
          println("Fade rate (BOOSTER+): " + fade);

        } else if(boosterPlus2Button == 1 && boosterPlusButton ==0 && norBoosterButton == 0){
          //myAudioRange = 15;
          //myAudioMax = 100;//100
          //myAudioAmp = 25; // (about 20-23dB)
          //myAudioIndex = 0.457;  //0.1,0.2，0.15
          //myAudioIndexAmp = myAudioIndex;
          //myAudioIndexStep = 0.36;//0.15
                    
          //println("Data is coming from Line 2 input");//Using the usb-C to 3.5mm
          
          myAudioRange = 11;
          myAudioMax = 100;
          myAudioAmp = 44; 
          myAudioIndex = 0.357;  
          myAudioIndexAmp = myAudioIndex;
          myAudioIndexStep = 0.48;
                    
          println("Booste the data to BOOSTER++ mode.");
          
          fade = fadeBoosterPlus2;
          println("Fade rate (BOOSTER++): " + fade);

        } else if(norBoosterButton == 1 && boosterPlusButton == 0 && boosterPlus2Button ==0) {
          //myAudioRange = 15;
          //myAudioMax = 100;//100
          //myAudioAmp = 23; //15
          //myAudioIndex = 0.235;  //0.451,0.435,0.415
          //myAudioIndexAmp = myAudioIndex;
          //myAudioIndexStep = 0.471;//0.214
          
          myAudioRange = 15;
          myAudioMax = 100;//100
          myAudioAmp = 22.5; //
          myAudioIndex = 0.35;  //
          myAudioIndexAmp = myAudioIndex;
          myAudioIndexStep = 0.475;//
          
          println("Booste the data to NORMAL mode.");
          fade = fadeNorBooster;
          println("Fade rate (NORMAL BOOSTER): " + fade);
          
      } else {
          myAudioRange = 15;
          myAudioMax = 100;//100
          myAudioAmp = 15; //15
          myAudioIndex = 0.415;  //0.451,0.435,0.415
          myAudioIndexAmp = myAudioIndex;
          myAudioIndexStep = 0.225;//0.214
          
          println("Data is set to Default mode"); //Default setting
          fade = fadeDefault;
          println("Fade rate (Default BOOSTER): " + fade);
      }
      
      
///////////////////////////In DemoMode, set unit1 all 5 LEDS to red///////////////////////////////
      if(demoModeButton == 1 && unit1Button == 1) {
          
          for(int i = rChan; i< lightChannels; i+= chanInterval){
            unit1.sendValue(i,redDemo);
          }
          
      }else {
        
         for(int i = rChan; i< lightChannels; i+= chanInterval){
            unit1.sendValue(i,0);
          
               }       
            }
            
///////////////////////////In DemoMode, set unit2 all 5 LEDS to green///////////////////////////////       
       if(demoModeButton == 1 && unit2Button == 1) {
        
          for(int i = gChan; i< lightChannels; i+= chanInterval){
            unit2.sendValue(i,greenDemo);
          }
        
      }else {
        
          for(int i = gChan; i< lightChannels; i+= chanInterval){
            unit2.sendValue(i,0);
          
               }       
            }   
            
            
///////////////////////////In DemoMode, set unit3 all 5 LEDS to blue///////////////////////////////       
       if(demoModeButton == 1 && unit3Button == 1) {
        
          for(int i = bChan; i< lightChannels; i+= chanInterval){
            unit3.sendValue(i,blueDemo);
          }
        
      }else {
        
         for(int i = bChan; i< lightChannels; i+= chanInterval){
            unit3.sendValue(i,0);
          
               }       
            } 

///////////////////////////In DemoMode, set unit4 each LED to different colors///////////////////////////////   

       if(demoModeButton == 1 && unit4Button == 1) {
         
         //#1 led to be red
         unit4.sendValue(rChan,255);   
         //unit4.sendValue(gChan,255);  
         unit4.sendValue(bChan,255);  
         
         //#2 led to be green
         unit4.sendValue(rChan+chanInterval,255*0.95);   
         //unit4.sendValue(gChan+chanInterval,255*0.2); 
         unit4.sendValue(bChan+chanInterval,255*0.45); 
         
         //#3 led to be blue
         unit4.sendValue(rChan+chanInterval*2,255); 
         
         //#4 led to be cyan
         //unit4.sendValue(rChan+chanInterval*3,255*0.2);
         unit4.sendValue(gChan+chanInterval*3,255*0.85);
         unit4.sendValue(bChan+chanInterval*3,255*0.40);  
         
         //#5 led to be cyan
         //unit4.sendValue(rChan+chanInterval*4,255);
         unit4.sendValue(gChan+chanInterval*4,255);
         unit4.sendValue(bChan+chanInterval*4,255);
         
            } else {
              
         unit4.sendValue(rChan,0);                
         unit4.sendValue(gChan+chanInterval,0);   
         unit4.sendValue(bChan+chanInterval*2,0); 
         
         unit4.sendValue(rChan+chanInterval*3,0);
         unit4.sendValue(bChan+chanInterval*3,0);  
         
         unit4.sendValue(gChan+chanInterval*4,0);
         unit4.sendValue(bChan+chanInterval*4,0);
         
         }
         

      
      // if(demoModeButton == 1 && unit4Button == 1) {
        
      //  for(int i = wChan; i< lightChannels; i+= chanInterval){
      //  unit4.sendValue(i,255);
      //  }
        
      //}else {
        
      //   for(int i = wChan; i< lightChannels; i+= chanInterval){
      //  unit4.sendValue(i,0);
          
      //         }       
      //      }
            
                        
}


void stop() {
  
  myAudio.close();
  minim.stop();
  super.stop();
  
}


//////////////////////Set up different faders, buttons in TouchOSC///////////////////////////////////////////////

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  // // Integer, float, etc.
  println(" typetag: "+theOscMessage.typetag());


  // Using if statements // checkAddrPattern returns a boolean
  
  //button soundMode in TouchOSC
  if(theOscMessage.checkAddrPattern("/soundMode") == true){
    soundModeButton = theOscMessage.get(0).floatValue();
    if(soundModeButton == 1) {
    println("Sound Mode is on.");
    } 
  }
  
    //button demoMode in TouchOSC
    if(theOscMessage.checkAddrPattern("/demoMode") == true){
    demoModeButton = theOscMessage.get(0).floatValue();
    if(demoModeButton == 1) {
    println("Demo Mode is on.");
    } 
  }
    
    //button unit1 in TouchOSC
    if(theOscMessage.checkAddrPattern("/unit1") == true){
    unit1Button = theOscMessage.get(0).floatValue();
    if(unit1Button == 1) {
    println("Unit1 is ready.");
    } 
  }
  
    //button unit2 in TouchOSC
    if(theOscMessage.checkAddrPattern("/unit2") == true){
    unit2Button = theOscMessage.get(0).floatValue();
    if(unit2Button == 1) {
    println("Unit2 is ready. is on.");
    } 
  }
  
    //button unit3 in TouchOSC
    if(theOscMessage.checkAddrPattern("/unit3") == true){
    unit3Button = theOscMessage.get(0).floatValue();
    if(unit3Button == 1) {
    println("Unit3 is ready.");
    } 
  }
    
    //button unit4 in TouchOSC
    if(theOscMessage.checkAddrPattern("/unit4") == true){
    unit4Button = theOscMessage.get(0).floatValue();
    if(unit4Button == 1) {
    println("Unit4 is ready.");
    } 
  }
    
    //button NORBOOSTER in TouchOSC
    if(theOscMessage.checkAddrPattern("/NORBOOSTER") == true){
    norBoosterButton= theOscMessage.get(0).floatValue();
    if(norBoosterButton == 1) {
    println("Booste the data to normal mode.");
    } 
  }
  
    //button BOOSTER+ in TouchOSC
    if(theOscMessage.checkAddrPattern("/BOOSTER+") == true){
      boosterPlusButton = theOscMessage.get(0).floatValue();
      if(boosterPlusButton == 1) {
      println("Booste the data to BOOSTER+ mode.");
      } 
    }
    
    //button BOOSTER++ in TouchOSC
    if(theOscMessage.checkAddrPattern("/BOOSTER++") == true){
      boosterPlus2Button = theOscMessage.get(0).floatValue();
      if(boosterPlus2Button == 1) {
        println("Booste the data to BOOSTER++ mode.");
      } 
    }   
    
     if(theOscMessage.checkAddrPattern("/resetButton") == true){
      resetB = theOscMessage.get(0).floatValue();
      if(resetB == 1) {
        println("All set.");
      } 
    }
    
   //Using a switch to isolate and assign the values through the addrPattern
  switch(theOscMessage.addrPattern()){
    //case "/threshold": 
    //  thresholdOSC = theOscMessage.get(0).floatValue();
    //  println("Threshold: "+ thresholdOSC);
    //  break;
      
   case "/red": 
      redOSC = theOscMessage.get(0).floatValue();
      println("Red Level: "+ redDemo);
      break;
      
  case "/green": 
      greenOSC = theOscMessage.get(0).floatValue();
      println("Green Level: "+ greenDemo);
      break;
      
  case "/blue": 
      blueOSC = theOscMessage.get(0).floatValue();
      println("Blue Level: "+ blueDemo);
      break;
    
 }
}
