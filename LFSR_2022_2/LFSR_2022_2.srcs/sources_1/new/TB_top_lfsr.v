`include "timescale.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2023 10:23:24 AM
// Design Name: 
// Module Name: TB_top_lfsr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module  TB_top_lfsr;

// testbemch requirements
// inputs
  reg CLK100MHZ;
  reg reset;
 //======================

 // internal wires and reg
  // wire sys_clk;
 
  top_lfsr top_lfsr_1(
    // inputs
    .CLK100MHZ   (CLK100MHZ),
    .btnU        (reset),      // active hihj reset
    // outputs
    .cath_out    (out),
    .enable      (enable),
    .led         (led0)
  );
  
    
always begin
 #5 CLK100MHZ = !CLK100MHZ;   // ~100Mhz
end  

    
initial begin                                 
   CLK100MHZ = 0;
   reset = 0;
end


initial begin
// start bench test
#20 CLK100MHZ = 0;
#50_000    reset = 1;
#50_000    reset = 0;
#50_000    reset = 1;
#500_000   reset = 0;
#50_000    reset = 1;
#50_000    reset = 0;

//#4_000_000 $finish;
#1_100_000_000 $finish ;
end

endmodule
