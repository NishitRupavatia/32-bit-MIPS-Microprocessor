`timescale 1ns / 1ps



module test3_mips32;

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
       
       mips.Mem[0] = 32'h280a00c8; //ADDI R10,R0,200
       mips.Mem[1] = 32'h28020001; //ADDI R2,R0,1
       mips.Mem[2] = 32'h0e94a000; //OR   R20,R20,R20 --Dummy Instruction
       mips.Mem[3] = 32'h81430000; //LW   R3,0(R10)
       mips.Mem[4] = 32'h0e94a000; //OR   R20,R20,R20 --Dummy Instruction
       mips.Mem[5] = 32'h14431000;  //LOOP: MUL R2,R2,R3
       mips.Mem[6] = 32'h0e94a000; //OR   R20,R20,R20 --Dummy Instruction
       mips.Mem[7] = 32'h2c630001; //SUBI  R3,R3,1
       mips.Mem[8] = 32'h0e94a000; //OR   R20,R20,R20 --Dummy Instruction
       mips.Mem[9] = 32'h3460fffb; //BNEQZ R3,Loop(i.e -4 offset)
       mips.Mem[10] = 32'h8542fffe; //SW  R2,-2(R10)
       mips.Mem[11] = 32'hfc000000; //HLT
       
       mips.Mem[200] = 7; //factorial of 7
       
       mips.PC=0;
       mips.HALTED=0;
       mips.TAKEN_BRANCH=0;
       
       #900 $display ("Mem[200] = %2d, Mem[198] = %6d", mips.Mem[200], mips.Mem[198]);
       end
       
       initial 
   begin
     $dumpfile ("mips.vcd");
     $dumpvars (0,test3_mips32);
     $monitor("Time=%0t | R2 = %d", $time, mips.Reg[2]);
     $monitor("Time=%0t | R3 = %d", $time, mips.Reg[3]);
    
     #900 $finish;
   end
endmodule