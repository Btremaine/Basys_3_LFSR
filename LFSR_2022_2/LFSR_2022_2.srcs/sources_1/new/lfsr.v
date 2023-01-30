//-----------------------------------------------------------------------------
//  Module   : lfsr.v
//  Parent   : lfst_top.v
//  Children : none
//  Description:
//     This implements a 13-bit maximal LFSR (Fibonacci)
//     p = x^13 + x^12 + x^11  + x^8 + 1
//  Parameters:
//     None
//-----------------------------------------------------------------------------
//`include "timescale.v"
module lfsr
    (input clk,                // system clock
     input rst_n,
     input pulse,              // input to advance lfsr
     //
     output [15:0] word );     // output of lfsr register
     
     // registers used
     reg [15:0] poly;
     reg Q1;
     reg Q2;
     
     //parameters
     parameter SEED = 16'h5EED;  // can't be 0 !!
     
     always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin
           Q1 <= 0;
           Q2 <= 0;
        end
        else begin
           Q1 <= pulse;
           Q2 <= Q1;
        end
    end   
     
     always@( posedge clk or negedge rst_n) begin  // pulse needs to be buffered, DRC warning in synthesis
         if( !rst_n )
            poly <= SEED;
         else if (Q1 && !Q2) begin
            poly[0]  <= poly[15] ^ poly[14] ^ poly[12] ^ poly[3];
            poly[1]  <= poly[0];
            poly[2]  <= poly[1];
            poly[3]  <= poly[2];
            poly[4]  <= poly[3];
            poly[5]  <= poly[4];
            poly[6]  <= poly[5];
            poly[7]  <= poly[6];
            poly[8]  <= poly[7];
            poly[9]  <= poly[8];
            poly[10] <= poly[9];
            poly[11] <= poly[10];
            poly[12] <= poly[11];   
            poly[13] <= poly[12];
            poly[14] <= poly[13];  
            poly[15] <= poly[14];   
         end // if
       
     end // always
     
     assign word = poly[15:0];
     
endmodule
