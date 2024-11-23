/*In this mode, using fixture unit 1 and 2,addres from 3, 20channel mode 
(blue start from add 3, starting address increase by 4)
*/

void bluePer() {

      if(p==1)
      {
        unit1.sendValue(bChan+chanInterval*0,0);
        unit2.sendValue(bChan+chanInterval*0,0);
        
        unit1.sendValue(bChan+chanInterval*1,blue);
        unit2.sendValue(bChan+chanInterval*1,blue);
        
        unit1.sendValue(bChan+chanInterval*2,0);
        unit2.sendValue(bChan+chanInterval*2,0);
        
        unit1.sendValue(bChan+chanInterval*3,0);
        unit2.sendValue(bChan+chanInterval*3,0);
        
        unit1.sendValue(bChan+chanInterval*4,0);
        unit2.sendValue(bChan+chanInterval*4,0);
        
      } else if (p==2){
        
        unit1.sendValue(bChan+chanInterval*0,0);
        unit2.sendValue(bChan+chanInterval*0,0);
        
        unit1.sendValue(bChan+chanInterval*1,blue);
        unit2.sendValue(bChan+chanInterval*1,blue);
        
        unit1.sendValue(bChan+chanInterval*2,blue);
        unit2.sendValue(bChan+chanInterval*2,blue);
        
        unit1.sendValue(bChan+chanInterval*3,0);
        unit2.sendValue(bChan+chanInterval*3,0);
        
        unit1.sendValue(bChan+chanInterval*4,0);
        unit2.sendValue(bChan+chanInterval*4,0);
          
      }else if (p==3){
        
        unit1.sendValue(bChan+chanInterval*0,0);
        unit2.sendValue(bChan+chanInterval*0,0);
        
        unit1.sendValue(bChan+chanInterval*1,blue);
        unit2.sendValue(bChan+chanInterval*1,blue);
        
        unit1.sendValue(bChan+chanInterval*2,blue);
        unit2.sendValue(bChan+chanInterval*2,blue);
        
        unit1.sendValue(bChan+chanInterval*3,0);
        unit2.sendValue(bChan+chanInterval*3,0);
        
        unit1.sendValue(bChan+chanInterval*4,0);
        unit2.sendValue(bChan+chanInterval*4,0);
          
      } else if (p==4){
        
        unit1.sendValue(bChan+chanInterval*0,0);
        unit2.sendValue(bChan+chanInterval*0,0);
        
        unit1.sendValue(bChan+chanInterval*1,blue);
        unit2.sendValue(bChan+chanInterval*1,blue);
        
        unit1.sendValue(bChan+chanInterval*2,blue);
        unit2.sendValue(bChan+chanInterval*2,blue);
        
        unit1.sendValue(bChan+chanInterval*3,0);
        unit2.sendValue(bChan+chanInterval*3,0);
        
        unit1.sendValue(bChan+chanInterval*4,0);
        unit2.sendValue(bChan+chanInterval*4,0);
        
      } else if(p==5) {

        unit1.sendValue(bChan+chanInterval*0,0);
        unit2.sendValue(bChan+chanInterval*0,0);
        
        unit1.sendValue(bChan+chanInterval*1,blue);
        unit2.sendValue(bChan+chanInterval*1,blue);
        
        unit1.sendValue(bChan+chanInterval*2,blue);
        unit2.sendValue(bChan+chanInterval*2,blue);
        
        unit1.sendValue(bChan+chanInterval*3,0);
        unit2.sendValue(bChan+chanInterval*3,0);
        
        unit1.sendValue(bChan+chanInterval*4,blue);
        unit2.sendValue(bChan+chanInterval*4,blue);       
        
      } else {
          unit1.sendValue(bChan+chanInterval*0,127);
          unit1.sendValue(bChan+chanInterval*1,255);
          unit1.sendValue(bChan+chanInterval*2,127);
          unit1.sendValue(bChan+chanInterval*3,255);
          unit1.sendValue(bChan+chanInterval*4,127);
          
          unit2.sendValue(bChan+chanInterval*0,255);
          unit2.sendValue(bChan+chanInterval*1,127);
          unit2.sendValue(bChan+chanInterval*2,255);
          unit2.sendValue(bChan+chanInterval*3,127);
          unit2.sendValue(bChan+chanInterval*4,255);
      }
      
    }
