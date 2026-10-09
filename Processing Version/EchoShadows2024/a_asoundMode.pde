void soundMode() {
  
     println("Sound-Reactive Mode is on.");

    if (myAudioData[0] >th && myAudioData[1] >10 && myAudioData[0] > myAudioData[1] && (myAudioData[0] - myAudioData[1])>0 ){

    // p = int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])*3.5,0,4));
    // p = int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])*2.5,4,0));
    p = int(random(map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1])*32.5, 1, 6),6));
    //p = int(map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1])*2.5, 1, 7));
    red = constrain(int(map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1])/510, 42, 255)),-80,325);
    green =constrain( int(map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1])/510, 72, 255)),-70,325);
    blue = constrain(int(map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1])/510, 255, 72)),325,-50);

    //red = constrain(int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])/3.5,42,250)),0,255);
    //green = constrain(int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])/1.5,200,34)),255,0);
    //blue = constrain(int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])/2.7,42,127)),0,255);

    println("ST1");
    println("ST1 period: " + p);
    println("ST1 Red: " + red);
    println("ST1 Green: " + green);
    println("ST1 Blue: " + blue);
       
  } else if((myAudioData[0] - myAudioData[1])==0 && (myAudioData[0] - myAudioData[2]>0)){
    
    // p = int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])*3.5,0,4));
    // p = int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])*2.5,4,0));
    p = int(random(map(myAudioData[0]- myAudioData[2], 0, (myAudioData[0]- myAudioData[2])*32.5, 1, 7),7));
    //p = int(map(myAudioData[0]- myAudioData[1], 0, (myAudioData[0]- myAudioData[1])*2.5, 1, 7));
    red = constrain(int(map(myAudioData[0]- myAudioData[2], 0, (myAudioData[0]- myAudioData[2])/510, 42, 255)),-60,325);
    green =constrain( int(map(myAudioData[0]- myAudioData[2], 0, (myAudioData[0]- myAudioData[2])/510, 72, 255)),-70,325);
    blue = constrain(int(map(myAudioData[0]- myAudioData[2], 0, (myAudioData[0]- myAudioData[2])/510, 255, 72)),325,-50);

    //red = constrain(int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])/3.5,42,250)),0,255);
    //green = constrain(int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])/1.5,200,34)),255,0);
    //blue = constrain(int(map(myAudioData[0]- myAudioData[1],0,(myAudioData[0]- myAudioData[1])/2.7,42,127)),0,255);

    println("ST2");
    println("ST2 period: " + p);
    println("ST2 Red: " + red);
    println("ST2 Green: " + green);
    println("ST2 Blue: " + blue);
    
  
  }else {

    p = int(map(myAudioData[0], 0, 100*1.5, 1, 7));
    red = int(map(myAudioData[0], 0, 100, 127, 255));
    green = int(map(myAudioData[1], 0, 100*0.60, 82, 255));
    blue = int(map(myAudioData[0], 0, 100, 255, 120));
    println("NORMAl");
    println("Nor period: " + p);
    println("Nor Red: " + red);
    println("Nor Green: " + green);
    println("Nor Blue: " + blue);
    
  }
  
  switchTime = int(map(myAudioData[0],0,100,maxSwitTime,minSwitTime));
  println("Switch time: " + switchTime/1000+"s");
  
  //set timer to make more change, switching petterns
   if(millis() - lastSwitchTime > switchTime) {
     
         switchIndex = int(random(10));
         
         switch (switchIndex){
           case 0:
           sw=1;
           break;
           
           case 1:
           sw=2;
           break;
           
           case 2:
           sw=3;
           break;
           
           case 3:
           sw=4;
           break;
           
           case 4:
           sw=5;
           break;
           
           case 5:
           sw=6;
           break;
           
           case 6:
           sw=7;
           break;     
           
           case 7:
           sw=8;
           break;  
           
           case 8:
           sw=9;
           break;  
           
           case 9:
           sw=10;
           break;   
           
         }
     
     // switchIndex++;
          lastSwitchTime = millis();
      
     }
   
  /*set up different petterns(QUESTION here: if putting the defined functions into swtich function,
  it wouldn't function appropriately, so trying to assign a new variable to track the switch,and put
  the defined functions into, and it works! ???)
  */
  if(sw ==1) {
    
        redPer (); 
        greenPer();
        bluePer();
        
        for(int i = rChan; i<lightChannels; i++){
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
          
        }
        
        pattern = "full color, Unit 1 & 2";
        
    }else if(sw==2){
      
        redPer2();
        greenPer2();
        bluePer2();
        
        for(int i = rChan; i<lightChannels; i++) {
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
        }
        
         pattern = "Full color, Unit 3 & 4";
        
    } else if(sw==3){
      
        redPer (); 
         //redPer2();
         
         for(int i=rChan; i<lightChannels; i+=chanInterval){
          //unit1.sendValue(i,0);
          //unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
         
         
        //don't use any green and blue          
         for(int i=gChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        for(int i=bChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }

        
         pattern = "Pure Red unit 1 & 2";
        
    }else if(sw==4){
      
          greenPer();
          //greenPer2();
          //pureGreen();
          redPer2();
          greenPer2();
          bluePer2();
    
         for(int i=rChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
        }
 
         for(int i=bChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
        }
        
        pattern = "Green for Unit 1 & 2, Full color for Unit 3 & 4)";
  
    }else if(sw==5){
          redPer();
      
          bluePer();
          bluePer2();
          
        //off unit3 & 4 red channels
         for(int i=rChan; i<lightChannels; i+=chanInterval){
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        //off unit1 & 2 blue channels
        // for(int i=bChan; i<lightChannels; i+=chanInterval){
        //  unit1.sendValue(i,0);
        //  unit2.sendValue(i,0);
        //}
 
         //off all units green channels
         for(int i=gChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        pattern = "Pure Blue + red";
        
    } else if(sw == 6){
      
          //redPer();
          greenPer();
          bluePer();
          
          redPer2();
        // greenPer2();
          bluePer2();
          
          //fullColor();
          
         for(int i=rChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          //unit3.sendValue(i,0);
          //unit4.sendValue(i,0);
        }
        
        for(int i=gChan; i<lightChannels; i+=chanInterval){
         // unit1.sendValue(i,0);
          //unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
          
          pattern = "Full color, all units";

  } else if(sw == 7){
        greenPer();
        
        //off all units red channnel
        for(int i=rChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        for(int i=bChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
         for(int i=gChan; i<lightChannels; i+=chanInterval){
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
         pattern = "Green, unit: 1 & 2";
  
    } else if (sw == 8) {
        greenPer2();
        
        //off all units red channnel
        for(int i=rChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        //off all units blue channel
        for(int i=bChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        //off unit 1 & 2 green channel
         for(int i=gChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
        }
        
         pattern = "Green, unit: 3 & 4";
        
        
    } else if( sw == 9) {
        
         redPer2();
         
         for(int i=rChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
  
        }
         
         
        //don't use any green and blue          
         for(int i=gChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        for(int i=bChan; i<lightChannels; i+=chanInterval){
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }

        
         pattern = "Pure Red unit 3 & 4";
        
    } else {
        //bluePer();
        bluePer2();
        
        //Off unit 1 & 2 blue channels
        for(int i = bChan; i < lightChannels; i+= chanInterval) {
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);

        }
        //Off all units red channels
        for(int i = rChan; i < lightChannels; i+= chanInterval) {
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        //Off all units green channels
        for(int i = gChan; i < lightChannels; i+= chanInterval) {
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
          unit3.sendValue(i,0);
          unit4.sendValue(i,0);
        }
        
        pattern = "Pure Blue unit 3 & 4";

    }
      println("Switch Mode: " + sw + ", " + "Patten: " + pattern);
        
    
}
