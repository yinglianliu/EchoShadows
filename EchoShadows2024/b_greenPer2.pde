/*In this mode, using fixture unit 3 and 4,addres from 2, 20channel mode 
(green start from add 2, starting address increase by 4)
*/

void greenPer2() {
  
      if(p==1)
      {
        
        unit3.sendValue(gChan+chanInterval*0,green);
        unit4.sendValue(gChan+chanInterval*0,green);
        
        unit3.sendValue(gChan+chanInterval*1,0);
        unit4.sendValue(gChan+chanInterval*1,0);
        
        unit3.sendValue(gChan+chanInterval*2,0);
        unit4.sendValue(gChan+chanInterval*2,0);
        
        unit3.sendValue(gChan+chanInterval*3,0);
        unit4.sendValue(gChan+chanInterval*3,0);
        
        unit3.sendValue(gChan+chanInterval*4,0);
        unit4.sendValue(gChan+chanInterval*4,0);
      
      } else if (p==2){
        
        unit3.sendValue(gChan+chanInterval*0,green);
        unit4.sendValue(gChan+chanInterval*0,green);
        
        unit3.sendValue(gChan+chanInterval*1,0);
        unit4.sendValue(gChan+chanInterval*1,0);
        
        unit3.sendValue(gChan+chanInterval*2,0);
        unit4.sendValue(gChan+chanInterval*2,0);
        
        unit3.sendValue(gChan+chanInterval*3,0);
        unit4.sendValue(gChan+chanInterval*3,0);
        
        unit3.sendValue(gChan+chanInterval*4,0);
        unit4.sendValue(gChan+chanInterval*4,0);

          
      }else if (p==3){
        
        unit3.sendValue(gChan+chanInterval*0,green);
        unit4.sendValue(gChan+chanInterval*0,green);
        
        unit3.sendValue(gChan+chanInterval*1,0);
        unit4.sendValue(gChan+chanInterval*1,0);
        
        unit3.sendValue(gChan+chanInterval*2,green);
        unit4.sendValue(gChan+chanInterval*2,green);
        
        unit3.sendValue(gChan+chanInterval*3,0);
        unit4.sendValue(gChan+chanInterval*3,0);
        
        unit3.sendValue(gChan+chanInterval*4,0);
        unit4.sendValue(gChan+chanInterval*4,0);
        
          
      } else if (p==4){
        
        unit3.sendValue(gChan+chanInterval*0,green);
        unit4.sendValue(gChan+chanInterval*0,green);
        
        unit3.sendValue(gChan+chanInterval*1,0);
        unit4.sendValue(gChan+chanInterval*1,0);
        
        unit3.sendValue(gChan+chanInterval*2,green);
        unit4.sendValue(gChan+chanInterval*2,green);
        
        unit3.sendValue(gChan+chanInterval*3,0);
        unit4.sendValue(gChan+chanInterval*3,0);
        
        unit3.sendValue(gChan+chanInterval*4,0);
        unit4.sendValue(gChan+chanInterval*4,0);
              
        
      } else if(p==5) {
        
        unit3.sendValue(gChan+chanInterval*0,green);
        unit4.sendValue(gChan+chanInterval*0,green);
        
        unit3.sendValue(gChan+chanInterval*1,0);
        unit4.sendValue(gChan+chanInterval*1,0);
        
        unit3.sendValue(gChan+chanInterval*2,green);
        unit4.sendValue(gChan+chanInterval*2,green);
        
        unit3.sendValue(gChan+chanInterval*3,0);
        unit4.sendValue(gChan+chanInterval*3,0);
        
        unit3.sendValue(gChan+chanInterval*4,green);
        unit4.sendValue(gChan+chanInterval*4,green);
        
      }else {
        
        //off
        for(int i = gChan; i<lightChannels; i+=chanInterval){
        
          unit3.sendValue(i,200);
          unit4.sendValue(i,200);
        
        }
        
      }
      
    }
