void fullColor() {
  
      float volume = constrain((myAudioData[0]*8)/100,0,5);
      int activeLeds = (int)volume;
      
      //red
      for(int i = 0; i < totalLedsPerUnit; i+=2){
        
        if(i < activeLeds) {
          unit1.sendValue(dmxChanRed[i],red);
          unit2.sendValue(dmxChanRed[i],red);
          unit3.sendValue(dmxChanRed[i],red);
          unit4.sendValue(dmxChanRed[i],red);
          
        } else {
          
          unit1.sendValue(dmxChanRed[i],0);
          unit2.sendValue(dmxChanRed[i],0);
          unit3.sendValue(dmxChanRed[i],0);
          unit4.sendValue(dmxChanRed[i],0);
        }
      }
      
      
      //blue
       for(int i = 4; i > 0; i-=2){
        if(i > activeLeds) {
          unit1.sendValue(dmxChanBlue[int(random(i))],blue);
          unit2.sendValue(dmxChanBlue[i],255);
          unit3.sendValue(dmxChanBlue[int(random(i))],blue);
          unit4.sendValue(dmxChanBlue[i],255);
          
        } else {
          
          unit1.sendValue(dmxChanBlue[i],0);
          unit2.sendValue(dmxChanBlue[i],0);
          unit3.sendValue(dmxChanBlue[i],0);
          unit4.sendValue(dmxChanBlue[i],0);
          
        }
      }
      
      //green
       for(int i = 4; i > 0; i--){
        if(i > activeLeds) {
          unit1.sendValue(dmxChanGreen[i],0);
          unit2.sendValue(dmxChanGreen[int(random(i))],255);
          unit3.sendValue(dmxChanGreen[i],0);
          unit4.sendValue(dmxChanGreen[int(random(i))],255);
        } else {
          unit1.sendValue(dmxChanGreen[i],0);
          unit2.sendValue(dmxChanGreen[i],0);
          unit3.sendValue(dmxChanGreen[i],0);
          unit4.sendValue(dmxChanGreen[i],0);
        }
      }
}

//void fullColor() {
  
//      if(p == 1) {
//        ///////////////////////unit1 on ////////////////////
//        unit1.sendValue(rChan,red);
//        unit1.sendValue(bChan,255-red);
        
//        ///////////////////////unit1 off///////////////////////
//        for(int i = rChan+chanInterval; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
//        for(int i = gChan; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
      
//        /////////////////////unit2 on /////////////////////
//        unit2.sendValue(gChan,green);
//        //unit2.sendValue(bChan,255-red);
        
//        ////////////////////unit2 off///////////////////////
//        for(int i = rChan; i<20; i+=4){
//          unit2.sendValue(i,0);
//        }
        
//        for(int i = bChan; i<20; i+=4){
//          unit2.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval; i<20; i+=4){
//          unit2.sendValue(i,0);
//        }       
        
//        //////////////////unit3 on //////////////////
//        unit3.sendValue(rChan,red);
//        unit3.sendValue(bChan,255-red);
        
//        //////////////////unit3 off////////////////////
//        for(int i = rChan+chanInterval; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
//        for(int i = gChan; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
      
//        //////////////////////unit4 on //////////////////////
//        unit4.sendValue(gChan,green);
//        //unit1.sendValue(bChan,255-red);
        
//        /////////////////////////unit4 off////////////////////////
//        for(int i = rChan; i<20; i+=4){
//          unit4.sendValue(i,0);
//        }
        
//        for(int i = bChan; i<20; i+=4){
//          unit4.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval; i<20; i+=4){
//          unit4.sendValue(i,0);
//        }
      
//      } else if (p == 2) {
        
//        ///////////////////////unit1 on ////////////////////
//        unit1.sendValue(rChan,red);
//        unit1.sendValue(bChan,255-red);
        
//        unit1.sendValue(gChan+chanInterval,green);
//        //unit1.sendValue(bChan+chanInterval,255-green);
//        unit1.sendValue(bChan+chanInterval,blue);
        
//        ///////////////////////unit1 off///////////////////////
//        for(int i = rChan+chanInterval; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval*2; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval*2; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
      
//        /////////////////////unit2 on /////////////////////
//        unit2.sendValue(gChan,green);
        
//        //unit2.sendValue(bChan+chanInterval,255-green);
//        unit2.sendValue(bChan+chanInterval,blue*bP4);
        
//        ////////////////////unit2 off///////////////////////
//        for(int i = rChan; i<20; i+=4){
//          unit2.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval*2; i<20; i+=4){
//          unit2.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval; i<20; i+=4){
//          unit2.sendValue(i,0);
//        }       
        
//        //////////////////unit3 on //////////////////
//        unit3.sendValue(rChan,red);
//        unit3.sendValue(bChan,255-red);
        
//        unit3.sendValue(gChan+chanInterval,green);
//        unit3.sendValue(bChan+chanInterval,255-green);
        
//        //////////////////unit3 off////////////////////
//        for(int i = rChan+chanInterval; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval*2; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval*2; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
      
//        /////////////////////unit4 on /////////////////////
//        unit4.sendValue(gChan,green);
        
//        unit4.sendValue(bChan+chanInterval,255-green);
        
//        ////////////////////unit4 off///////////////////////
//        for(int i = rChan; i<20; i+=4){
//          unit4.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval*2; i<20; i+=4){
//          unit4.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval; i<20; i+=4){
//          unit4.sendValue(i,0);
//        }
      
      
//      } else if (p == 3) {
        
//        ///////////////////////unit1 on ////////////////////
//        unit1.sendValue(rChan,red);
//        unit1.sendValue(bChan,255-red);
        
//        unit1.sendValue(gChan+chanInterval,green);
//        unit1.sendValue(bChan+chanInterval,blue*bP3);
        
//        unit1.sendValue(gChan+chanInterval*2,green);
//        unit1.sendValue(rChan+chanInterval*2,red*rP3);
        
//        ///////////////////////unit1 off///////////////////////
//        for(int i = rChan+chanInterval*3; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval*2; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval*3; i<20; i+=4){
//          unit1.sendValue(i,0);
//        }
        
      
//        /////////////////////unit2 on /////////////////////
//        unit2.sendValue(gChan,green);
        
//        unit2.sendValue(bChan+chanInterval,255-green);
        
//        unit2.sendValue(rChan+chanInterval*2, red*rP2);
//        unit2.sendValue(bChan+chanInterval*2, blue);
        
//        ////////////////////unit2 off///////////////////////
        
//          unit2.sendValue(rChan,0);
//          unit2.sendValue(rChan+chanInterval,0);
//          unit2.sendValue(rChan+chanInterval*3,0);
//          unit2.sendValue(rChan+chanInterval*4,0);  
          
//          unit2.sendValue(bChan,0);
//          unit2.sendValue(bChan+chanInterval*3,0);
//          unit2.sendValue(bChan+chanInterval*4,0); 
          
//          unit2.sendValue(gChan+chanInterval,0);
//          unit2.sendValue(gChan+chanInterval*2,0);
//          unit2.sendValue(gChan+chanInterval*3,0); 
//          unit2.sendValue(gChan+chanInterval*4,0); 
          
//        ///////////////////////unit3 on ////////////////////
//        unit3.sendValue(rChan,red);
//        unit3.sendValue(bChan,255-red);
        
//        unit3.sendValue(gChan+chanInterval,green);
//        unit3.sendValue(bChan+chanInterval,255-green);
        
//        unit3.sendValue(gChan+chanInterval*2,green);
//        unit3.sendValue(rChan+chanInterval*2,red*rP2);
        
//        ///////////////////////unit3 off///////////////////////
//        for(int i = rChan+chanInterval*3; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
//        for(int i = bChan+chanInterval*2; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
//        for(int i = gChan+chanInterval*3; i<20; i+=4){
//          unit3.sendValue(i,0);
//        }
        
      
//        /////////////////////unit4 on /////////////////////
//        unit4.sendValue(gChan,green);
        
//        unit4.sendValue(bChan+chanInterval,255-green);
        
//        unit4.sendValue(rChan+chanInterval*2, red);
//        unit4.sendValue(bChan+chanInterval*2, blue);
        
//        ////////////////////unit4 off///////////////////////
        
//          unit4.sendValue(rChan,0);
//          unit4.sendValue(rChan+chanInterval,0);
//          unit4.sendValue(rChan+chanInterval*3,0);
//          unit4.sendValue(rChan+chanInterval*4,0);  
          
//          unit4.sendValue(bChan,0);
//          unit4.sendValue(bChan+chanInterval*3,0);
//          unit4.sendValue(bChan+chanInterval*4,0); 
          
//          unit4.sendValue(gChan+chanInterval,0);
//          unit4.sendValue(gChan+chanInterval*2,0);
//          unit4.sendValue(gChan+chanInterval*3,0); 
//          unit4.sendValue(gChan+chanInterval*4,0);         
      
//      } else if (p == 4) {
        
//        ///////////////////////unit1 on ////////////////////
//        unit1.sendValue(rChan,red);
//        unit1.sendValue(bChan,255-red);
        
//        unit1.sendValue(gChan+chanInterval,green);
//        unit1.sendValue(bChan+chanInterval,blue*bP2);
        
//        unit1.sendValue(gChan+chanInterval*2,green*gP3);
//        unit1.sendValue(rChan+chanInterval*2,red);
        
//        unit1.sendValue(rChan+chanInterval*3,red);
//        unit1.sendValue(gChan+chanInterval*3,green*gP2);
//        unit1.sendValue(bChan+chanInterval*3,blue*bP4);
        
//        ///////////////////////unit1 off///////////////////////
//        unit1.sendValue(rChan+chanInterval*1,0);
//        unit1.sendValue(rChan+chanInterval*4,0);
        
//        unit1.sendValue(gChan,0);
//        unit1.sendValue(rChan+chanInterval*4,0);
        
//        unit1.sendValue(bChan+chanInterval*2,0);
//        unit1.sendValue(bChan+chanInterval*4,0);
      
//        /////////////////////unit2 on /////////////////////
//        unit2.sendValue(gChan,green);
        
//        unit2.sendValue(bChan+chanInterval,255-green);
        
//        unit2.sendValue(rChan+chanInterval*2, red*rP4);
//        unit2.sendValue(gChan+chanInterval*2, green);
        
//        unit2.sendValue(bChan+chanInterval*3, blue);
//        unit2.sendValue(rChan+chanInterval*3, red);
        
//        ////////////////////unit2 off///////////////////////
        
//          unit2.sendValue(rChan,0);
//          unit2.sendValue(rChan+chanInterval,0);
//          unit2.sendValue(rChan+chanInterval*4,0);  
          
//          unit2.sendValue(bChan,0);
//          unit2.sendValue(bChan+chanInterval*2,0);
//          unit2.sendValue(bChan+chanInterval*4,0); 
          
//          unit2.sendValue(gChan+chanInterval,0);
//          unit2.sendValue(gChan+chanInterval*3,0); 
//          unit2.sendValue(gChan+chanInterval*4,0); 
          
//        ///////////////////////unit3 on ////////////////////
//        unit3.sendValue(rChan,red);
//        unit3.sendValue(bChan,255-red);
        
//        unit3.sendValue(gChan+chanInterval,green);
//        unit3.sendValue(bChan+chanInterval,255-green);
        
//        unit3.sendValue(gChan+chanInterval*2,green);
//        unit3.sendValue(rChan+chanInterval*2,red);
        
//        unit3.sendValue(rChan+chanInterval*3,red);
//        unit3.sendValue(gChan+chanInterval*3,green);
//        unit3.sendValue(bChan+chanInterval*3,blue);
        
//        ///////////////////////unit3 off///////////////////////
//        unit3.sendValue(rChan+chanInterval*1,0);
//        unit3.sendValue(rChan+chanInterval*4,0);
        
//        unit3.sendValue(gChan,0);
//        unit3.sendValue(rChan+chanInterval*4,0);
        
//        unit3.sendValue(bChan+chanInterval*2,0);
//        unit3.sendValue(bChan+chanInterval*4,0);
      
//        /////////////////////unit4 on /////////////////////
//        unit4.sendValue(gChan,green);
        
//        unit4.sendValue(bChan+chanInterval,255-green);
        
//        unit4.sendValue(rChan+chanInterval*2, red);
//        unit4.sendValue(gChan+chanInterval*2, green);
        
//        unit4.sendValue(bChan+chanInterval*3, blue);
//        unit4.sendValue(rChan+chanInterval*3, red);
        
//        ////////////////////unit4 off///////////////////////
        
//          unit4.sendValue(rChan,0);
//          unit4.sendValue(rChan+chanInterval,0);
//          unit4.sendValue(rChan+chanInterval*4,0);  
          
//          unit4.sendValue(bChan,0);
//          unit4.sendValue(bChan+chanInterval*2,0);
//          unit4.sendValue(bChan+chanInterval*4,0); 
          
//          unit4.sendValue(gChan+chanInterval,0);
//          unit4.sendValue(gChan+chanInterval*3,0); 
//          unit4.sendValue(gChan+chanInterval*4,0);   
          
//      } else if (p == 5) {
        
//        ///////////////////////unit1 on ////////////////////
//        unit1.sendValue(rChan,red);
//        unit1.sendValue(bChan,255-red);
        
//        unit1.sendValue(gChan+chanInterval,green);
//        unit1.sendValue(bChan+chanInterval,255-green);
        
//        unit1.sendValue(gChan+chanInterval*2,green);
//        unit1.sendValue(rChan+chanInterval*2,red);
        
//        unit1.sendValue(gChan+chanInterval*3,green);
//        unit1.sendValue(bChan+chanInterval*3,blue);
        
//        unit1.sendValue(rChan+chanInterval*4,red);
//        unit1.sendValue(gChan+chanInterval*4,green);
//        unit1.sendValue(bChan+chanInterval*4,blue);
        
//        ///////////////////////unit1 off///////////////////////
//        unit1.sendValue(rChan+chanInterval*1,0);
//        unit1.sendValue(rChan+chanInterval*3,0);
       
        
//        unit1.sendValue(gChan,0);     
        
//        unit1.sendValue(bChan+chanInterval*2,0);
      
//        /////////////////////unit2 on /////////////////////
//        unit2.sendValue(gChan,green);
        
//        unit2.sendValue(bChan+chanInterval,255-green);
        
//        unit2.sendValue(rChan+chanInterval*2, red);
//        unit2.sendValue(gChan+chanInterval*2, green);
        
//        unit2.sendValue(bChan+chanInterval*3, blue);
//        unit2.sendValue(rChan+chanInterval*3, red);
        
//        unit2.sendValue(gChan+chanInterval*4, green);
        
        
//        ////////////////////unit2 off///////////////////////
        
//          unit2.sendValue(rChan,0);
//          unit2.sendValue(rChan+chanInterval,0);
//          unit2.sendValue(rChan+chanInterval*4,0);  
          
//          unit2.sendValue(bChan,0);
//          unit2.sendValue(bChan+chanInterval*2,0);
//          unit2.sendValue(bChan+chanInterval*4,0); 
          
//          unit2.sendValue(gChan+chanInterval,0);
//          unit2.sendValue(gChan+chanInterval*3,0);           
      
      
//        ///////////////////////unit3 on ////////////////////
//        unit3.sendValue(rChan,red);
//        unit3.sendValue(bChan,255-red);
        
//        unit3.sendValue(gChan+chanInterval,green);
//        unit3.sendValue(bChan+chanInterval,255-green);
        
//        unit3.sendValue(gChan+chanInterval*2,green);
//        unit3.sendValue(rChan+chanInterval*2,red);
        
//        unit3.sendValue(gChan+chanInterval*3,green);
//        unit3.sendValue(bChan+chanInterval*3,blue);
        
//        unit3.sendValue(rChan+chanInterval*4,red);
//        unit3.sendValue(gChan+chanInterval*4,green);
//        unit3.sendValue(bChan+chanInterval*4,blue);
        
//        ///////////////////////unit3 off///////////////////////
//        unit3.sendValue(rChan+chanInterval*1,0);
//        unit3.sendValue(rChan+chanInterval*3,0);
       
        
//        unit3.sendValue(gChan,0);     
        
//        unit3.sendValue(bChan+chanInterval*2,0);
      
//        /////////////////////unit4 on /////////////////////
//        unit4.sendValue(gChan,green);
        
//        unit4.sendValue(bChan+chanInterval,255-green);
        
//        unit4.sendValue(rChan+chanInterval*2, red);
//        unit4.sendValue(gChan+chanInterval*2, green);
        
//        unit4.sendValue(bChan+chanInterval*3, blue);
//        unit4.sendValue(rChan+chanInterval*3, red);
        
//        unit4.sendValue(gChan+chanInterval*4, green);
        
        
//        ////////////////////unit4 off///////////////////////
        
//          unit4.sendValue(rChan,0);
//          unit4.sendValue(rChan+chanInterval,0);
//          unit4.sendValue(rChan+chanInterval*4,0);  
          
//          unit4.sendValue(bChan,0);
//          unit4.sendValue(bChan+chanInterval*2,0);
//          unit4.sendValue(bChan+chanInterval*4,0); 
          
//          unit4.sendValue(gChan+chanInterval,0);
//          unit4.sendValue(gChan+chanInterval*3,0);        
      
//      }else{
        
//        for(int i = rChan; i<lightChannels; i+=chanInterval) {
//          unit1.sendValue(i, red*rP4);
//          unit2.sendValue(i, red*rP3);
//          unit3.sendValue(i, red*rP3);
//          unit4.sendValue(i, red*rP3);
//        }
        
//         for(int i = gChan; i<lightChannels; i+=chanInterval) {
//          unit1.sendValue(i, green);
//          unit2.sendValue(i, green);
//          unit3.sendValue(i, green);
//          unit4.sendValue(i, green);
//        }
        
//         for(int i = bChan; i<lightChannels; i+=chanInterval) {
//          unit1.sendValue(i, blue);
//          unit2.sendValue(i, blue);
//          unit3.sendValue(i, blue);
//          unit4.sendValue(i, blue);
//        }
      
//      }
  
//}
   
