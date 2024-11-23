/*In this mode, using fixture unit 1 and 2,20channel mode 
(red start from add 1 and starting address increase by 4)
*/

void redPer() {
  
      if(p==1)
      {
        
        unit1.sendValue(rChan+chanInterval*0,red);
        unit2.sendValue(rChan+chanInterval*0,0);
        
        unit1.sendValue(rChan+chanInterval*1,0);
        unit2.sendValue(rChan+chanInterval*1,0);
        
        unit1.sendValue(rChan+chanInterval*2,0);
        unit2.sendValue(rChan+chanInterval*2,0);
        
        unit1.sendValue(rChan+chanInterval*3,0);
        unit2.sendValue(rChan+chanInterval*3,0);
        
        unit1.sendValue(rChan+chanInterval*4,0);
        unit2.sendValue(rChan+chanInterval*4,0);
        
      } else if (p==2){
                    
        unit1.sendValue(rChan+chanInterval*0,red);
        unit2.sendValue(rChan+chanInterval*0,red*0.9);
        
        unit1.sendValue(rChan+chanInterval*1,0);
        unit2.sendValue(rChan+chanInterval*1,0);
        
        unit1.sendValue(rChan+chanInterval*2,0);
        unit2.sendValue(rChan+chanInterval*2,0);
        
        unit1.sendValue(rChan+chanInterval*3,0);
        unit2.sendValue(rChan+chanInterval*3,0);
        
        unit1.sendValue(rChan+chanInterval*4,0);
        unit2.sendValue(rChan+chanInterval*4,0);

          
      }else if (p==3){
        
        unit1.sendValue(rChan+chanInterval*0,red);
        unit2.sendValue(rChan+chanInterval*0,red*0.8);
        
        unit1.sendValue(rChan+chanInterval*1,0);
        unit2.sendValue(rChan+chanInterval*1,0);
        
        unit1.sendValue(rChan+chanInterval*2,red*0.65);
        unit2.sendValue(rChan+chanInterval*2,red*0.55);
        
        unit1.sendValue(rChan+chanInterval*3,0);
        unit2.sendValue(rChan+chanInterval*3,0);
        
        unit1.sendValue(rChan+chanInterval*4,0);
        unit2.sendValue(rChan+chanInterval*4,0);
         
          
      } else if (p==4){
        
        unit1.sendValue(rChan+chanInterval*0,red);
        unit2.sendValue(rChan+chanInterval*0,0);
        
        unit1.sendValue(rChan+chanInterval*1,0);
        unit2.sendValue(rChan+chanInterval*1,0);
        
        unit1.sendValue(rChan+chanInterval*2,red*0.75);
        unit2.sendValue(rChan+chanInterval*2,0);
        
        unit1.sendValue(rChan+chanInterval*3,0);
        unit2.sendValue(rChan+chanInterval*3,red*0.65);
        
        unit1.sendValue(rChan+chanInterval*4,0);
        unit2.sendValue(rChan+chanInterval*4,0);
            
      }else if(p==5) {
        
        unit1.sendValue(rChan+chanInterval*0,red);
        unit2.sendValue(rChan+chanInterval*0,0);
        
        unit1.sendValue(rChan+chanInterval*1,0);
        unit2.sendValue(rChan+chanInterval*1,red*0.85);
        
        unit1.sendValue(rChan+chanInterval*2,red*0.65);
        unit2.sendValue(rChan+chanInterval*2,0);
        
        unit1.sendValue(rChan+chanInterval*3,0);
        unit2.sendValue(rChan+chanInterval*3,red*0.5);
        
        unit1.sendValue(rChan+chanInterval*4,red*0.85);
        unit2.sendValue(rChan+chanInterval*4,0);       
      
      } else {
                    
           for(int i = rChan; i<lightChannels; i+=chanInterval*2){
            unit1.sendValue(i,0);
            unit2.sendValue(i,255);

            } 
          
          }
          
}
