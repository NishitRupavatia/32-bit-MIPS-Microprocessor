`timescale 1ns / 1ps

module test2_mips32;

 reg clk1, clk2;
 integer k;
 
 pipe_MIPSS32 mips(clk1,clk2);
 
 initial
   begin
     clk1=0; clk2=0;
     repeat (50)         //generating 2 phase clock
       begin
         #5 clk1=1; #5 clk1=0;
         #5 clk2=1; #5 clk2=0;
       end
   end
   
 initial 
   begin
     for(k=0;k<31;k=k+1)
       mips.Reg[k]=k;
       
       mips.Mem[0] = 32'h28010078; //ADDI R1,R0,120
       mips.Mem[1] = 32'h0c631800; //OR   R3,R3,R3 -- Dummy Instruction
       mips.Mem[2] = 32'h80220000; //LW   R2,0(R1)
       mips.Mem[3] = 32'h0c631800; //OR   R3,R3,R3 -- Dummy Instruction
       mips.Mem[4] = 32'h2842002d; //ADDI R2,R2,45
       mips.Mem[5] = 32'h0c631800; //OR   R3,R3,R3 -- Dummy Instruction
       mips.Mem[6] = 32'h84220001; //SW   R2,1(R1)
       mips.Mem[7] = 32'hfc000000; //HLT
       
       mips.Mem[120] = 85; 
       
       mips.PC = 0;
          mips.HALTED = 0; 
          mips.TAKEN_BRANCH = 0;
          
          #500 $display("Mem[120]: %4d \nMem[121]: %4d", mips.Mem[120], mips.Mem[121]);
          
    end
    
    initial 
   begin
     $dumpfile ("mips.vcd");
     $dumpvars (0,test2_mips32);
    
     #600 $finish;
   end
endmodule
