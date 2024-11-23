/*In this mode, using fixture unit 3 and 4,20channel mode 
(red start from add 1and starting address increase by 4)
*/


void redPer2() {
  
      if(p==1)
      {
               
        unit3.sendValue(rChan+chanInterval*0,red);
        unit4.sendValue(rChan+chanInterval*0,red);

        unit3.sendValue(rChan+chanInterval*1,0);
        unit4.sendValue(rChan+chanInterval*1,0);
        
        unit3.sendValue(rChan+chanInterval*2,0);
        unit4.sendValue(rChan+chanInterval*2,0);
        
        unit3.sendValue(rChan+chanInterval*3,0);
        unit4.sendValue(rChan+chanInterval*3,0);
        
        unit3.sendValue(rChan+chanInterval*4,0);
        unit4.sendValue(rChan+chanInterval*4,0);
        

      } else if (p==2){
              
        unit3.sendValue(rChan+chanInterval*0,red);
        unit4.sendValue(rChan+chanInterval*0,red);

        unit3.sendValue(rChan+chanInterval*1,0);
        unit4.sendValue(rChan+chanInterval*1,0);
        
        unit3.sendValue(rChan+chanInterval*2,0);
        unit4.sendValue(rChan+chanInterval*2,0);
        
        unit3.sendValue(rChan+chanInterval*3,0);
        unit4.sendValue(rChan+chanInterval*3,0);
        
        unit3.sendValue(rChan+chanInterval*4,0);
        unit4.sendValue(rChan+chanInterval*4,0);
          
      }else if (p==3){
        
        unit3.sendValue(rChan+chanInterval*0,red);
        unit4.sendValue(rChan+chanInterval*0,red);

        unit3.sendValue(rChan+chanInterval*1,0);
        unit4.sendValue(rChan+chanInterval*1,0);
        
        unit3.sendValue(rChan+chanInterval*2,red);
        unit4.sendValue(rChan+chanInterval*2,red);
        
        unit3.sendValue(rChan+chanInterval*3,0);
        unit4.sendValue(rChan+chanInterval*3,0);
        
        unit3.sendValue(rChan+chanInterval*4,0);
        unit4.sendValue(rChan+chanInterval*4,0);
         
          
      } else if (p==4){

        unit3.sendValue(rChan+chanInterval*0,red*0.85);
        unit4.sendValue(rChan+chanInterval*0,red*0.85);

        unit3.sendValue(rChan+chanInterval*1,0);
        unit4.sendValue(rChan+chanInterval*1,0);
        
        unit3.sendValue(rChan+chanInterval*2,red*0.65);
        unit4.sendValue(rChan+chanInterval*2,red*0.65);
        
        unit3.sendValue(rChan+chanInterval*3,0);
        unit4.sendValue(rChan+chanInterval*3,0);
        
        unit3.sendValue(rChan+chanInterval*4,0);
        unit4.sendValue(rChan+chanInterval*4,0);
        
      }else if(p==5) {
                
        unit3.sendValue(rChan+chanInterval*0,red*0.85);
        unit4.sendValue(rChan+chanInterval*0,red*0.85);

        unit3.sendValue(rChan+chanInterval*1,0);
        unit4.sendValue(rChan+chanInterval*1,0);
        
        unit3.sendValue(rChan+chanInterval*2,red*0.65);
        unit4.sendValue(rChan+chanInterval*2,red*0.65);
        
        unit3.sendValue(rChan+chanInterval*3,0);
        unit4.sendValue(rChan+chanInterval*3,0);
        
        unit3.sendValue(rChan+chanInterval*4,red*0.5);
        unit4.sendValue(rChan+chanInterval*4,red*0.5);
      
      } else {
        unit3.sendValue(rChan+chanInterval*0,red);
        unit3.sendValue(rChan+chanInterval*1,0);
        unit3.sendValue(rChan+chanInterval*2,0);
        unit3.sendValue(rChan+chanInterval*3,0);
        unit3.sendValue(rChan+chanInterval*4,red);
        
        unit4.sendValue(rChan+chanInterval*0,0);
        unit4.sendValue(rChan+chanInterval*1,red);
        unit4.sendValue(rChan+chanInterval*2,0);
        unit4.sendValue(rChan+chanInterval*3,red);
        unit4.sendValue(rChan+chanInterval*4,0);
       
          
          }
      

      
    }
