/*In this mode, using fixture unit 3 and 4,addres from 3, 20channel mode 
(blue start from add 3, starting address increase by 4)
*/


void bluePer2() {

      if(p==1)
      {
        
        unit3.sendValue(bChan+chanInterval*0,blue);
        unit4.sendValue(bChan+chanInterval*0,0);
        
        unit3.sendValue(bChan+chanInterval*1,0);
        unit4.sendValue(bChan+chanInterval*1,0);
        
        unit3.sendValue(bChan+chanInterval*2,0);
        unit4.sendValue(bChan+chanInterval*2,0);
        
        unit3.sendValue(bChan+chanInterval*3,0);
        unit4.sendValue(bChan+chanInterval*3,0);
        
        unit3.sendValue(bChan+chanInterval*4,0);
        unit4.sendValue(bChan+chanInterval*4,0);
           
      } else if (p==2){
        
        unit3.sendValue(bChan+chanInterval*0,blue);
        unit4.sendValue(bChan+chanInterval*0,0);
        
        unit3.sendValue(bChan+chanInterval*1,0);
        unit4.sendValue(bChan+chanInterval*1,blue);
        
        unit3.sendValue(bChan+chanInterval*2,0);
        unit4.sendValue(bChan+chanInterval*2,0);
        
        unit3.sendValue(bChan+chanInterval*3,0);
        unit4.sendValue(bChan+chanInterval*3,0);
        
        unit3.sendValue(bChan+chanInterval*4,0);
        unit4.sendValue(bChan+chanInterval*4,0);
          
      }else if (p==3){
        
        unit3.sendValue(bChan+chanInterval*0,blue);
        unit4.sendValue(bChan+chanInterval*0,0);
        
        unit3.sendValue(bChan+chanInterval*1,0);
        unit4.sendValue(bChan+chanInterval*1,blue);
        
        unit3.sendValue(bChan+chanInterval*2,blue);
        unit4.sendValue(bChan+chanInterval*2,0);
        
        unit3.sendValue(bChan+chanInterval*3,0);
        unit4.sendValue(bChan+chanInterval*3,0);
        
        unit3.sendValue(bChan+chanInterval*4,0);
        unit4.sendValue(bChan+chanInterval*4,0);
          
      } else if (p==4){
        
        unit3.sendValue(bChan+chanInterval*0,blue);
        unit4.sendValue(bChan+chanInterval*0,0);
        
        unit3.sendValue(bChan+chanInterval*1,0);
        unit4.sendValue(bChan+chanInterval*1,blue);
        
        unit3.sendValue(bChan+chanInterval*2,blue);
        unit4.sendValue(bChan+chanInterval*2,0);
        
        unit3.sendValue(bChan+chanInterval*3,0);
        unit4.sendValue(bChan+chanInterval*3,blue);
        
        unit3.sendValue(bChan+chanInterval*4,0);
        unit4.sendValue(bChan+chanInterval*4,0);
        
      } else if(p==5) {

        unit3.sendValue(bChan+chanInterval*0,blue);
        unit4.sendValue(bChan+chanInterval*0,0);
        
        unit3.sendValue(bChan+chanInterval*1,0);
        unit4.sendValue(bChan+chanInterval*1,blue);
        
        unit3.sendValue(bChan+chanInterval*2,blue);
        unit4.sendValue(bChan+chanInterval*2,0);
        
        unit3.sendValue(bChan+chanInterval*3,0);
        unit4.sendValue(bChan+chanInterval*3,blue);
        
        unit3.sendValue(bChan+chanInterval*4,blue);
        unit4.sendValue(bChan+chanInterval*4,0);      
        
      } else {
        
          unit3.sendValue(bChan+chanInterval*0,127);
          unit3.sendValue(bChan+chanInterval*1,255);
          unit3.sendValue(bChan+chanInterval*2,127);
          unit3.sendValue(bChan+chanInterval*3,255);
          unit3.sendValue(bChan+chanInterval*4,127);
          
          unit4.sendValue(bChan+chanInterval*0,255);
          unit4.sendValue(bChan+chanInterval*1,127);
          unit4.sendValue(bChan+chanInterval*2,255);
          unit4.sendValue(bChan+chanInterval*3,127);
          unit4.sendValue(bChan+chanInterval*4,255);
          
      }
      
    }
