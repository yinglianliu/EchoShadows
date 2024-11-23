/*In this mode, using fixture unit 1 and 2,addres from 2, 20channel mode 
(green start from add 2 and increasing by 4)
*/

void greenPer() {
  
      if(p==1)
      {
        
        unit1.sendValue(gChan+chanInterval*0,green);
        unit2.sendValue(gChan+chanInterval*0,0);
        
        unit1.sendValue(gChan+chanInterval*1,0);
        unit2.sendValue(gChan+chanInterval*1,0);
        
        unit1.sendValue(gChan+chanInterval*2,0);
        unit2.sendValue(gChan+chanInterval*2,0);
        
        unit1.sendValue(gChan+chanInterval*3,0);
        unit2.sendValue(gChan+chanInterval*3,0);
        
        unit1.sendValue(gChan+chanInterval*4,0);
        unit2.sendValue(gChan+chanInterval*4,0);
      
      } else if (p==2){
        
        unit1.sendValue(gChan+chanInterval*0,green);
        unit2.sendValue(gChan+chanInterval*0,0);
        
        unit1.sendValue(gChan+chanInterval*1,0);
        unit2.sendValue(gChan+chanInterval*1,green);
        
        unit1.sendValue(gChan+chanInterval*2,0);
        unit2.sendValue(gChan+chanInterval*2,0);
        
        unit1.sendValue(gChan+chanInterval*3,0);
        unit2.sendValue(gChan+chanInterval*3,0);
        
        unit1.sendValue(gChan+chanInterval*4,0);
        unit2.sendValue(gChan+chanInterval*4,0);

          
      }else if (p==3){
        
        unit1.sendValue(gChan+chanInterval*0,green);
        unit2.sendValue(gChan+chanInterval*0,0);
        
        unit1.sendValue(gChan+chanInterval*1,0);
        unit2.sendValue(gChan+chanInterval*1,green);
        
        unit1.sendValue(gChan+chanInterval*2,green);
        unit2.sendValue(gChan+chanInterval*2,0);
        
        unit1.sendValue(gChan+chanInterval*3,0);
        unit2.sendValue(gChan+chanInterval*3,0);
        
        unit1.sendValue(gChan+chanInterval*4,0);
        unit2.sendValue(gChan+chanInterval*4,0);
               
      } else if (p==4){
        
        unit1.sendValue(gChan+chanInterval*0,green);
        unit2.sendValue(gChan+chanInterval*0,0);
        
        unit1.sendValue(gChan+chanInterval*1,0);
        unit2.sendValue(gChan+chanInterval*1,green);
        
        unit1.sendValue(gChan+chanInterval*2,green);
        unit2.sendValue(gChan+chanInterval*2,0);
        
        unit1.sendValue(gChan+chanInterval*3,0);
        unit2.sendValue(gChan+chanInterval*3,green);
        
        unit1.sendValue(gChan+chanInterval*4,0);
        unit2.sendValue(gChan+chanInterval*4,0);           
        
      } else if(p==5) {
        
        unit1.sendValue(gChan+chanInterval*0,green);
        unit2.sendValue(gChan+chanInterval*0,0);
        
        unit1.sendValue(gChan+chanInterval*1,0);
        unit2.sendValue(gChan+chanInterval*1,green);
        
        unit1.sendValue(gChan+chanInterval*2,green);
        unit2.sendValue(gChan+chanInterval*2,0);
        
        unit1.sendValue(gChan+chanInterval*3,0);
        unit2.sendValue(gChan+chanInterval*3,green);
        
        unit1.sendValue(gChan+chanInterval*4,green);
        unit2.sendValue(gChan+chanInterval*4,0);   
    
       
      }else {
        
        //off
        for(int i = gChan; i<lightChannels; i+=chanInterval){
        
          unit1.sendValue(i,0);
          unit2.sendValue(i,0);
        
        }
        
      }
      
    }
