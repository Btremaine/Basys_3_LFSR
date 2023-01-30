//////////////////////////////////////////////////////////////////////////////////
//  Module   : div_by_N.v
//  Parent   : top_test.v
//  Children : none
//  Description:
//     This is the div_by_N for the test project on a basys3 board
//     Used for experimenting with Vivado with generated clocks
//  Parameters:
//     None
///////////////////////////////////////////////////////////////////////////////////
//`include "timescale.v"
`timescale 1ns/1ps

/////////////////////////////Basys 3 FPGA   ///////////////////////////////////////
module div_by_N  #(parameter N= 32967, parameter Nb= 16) (  // 32967 creates 3033Hz clock
   reset,
   clk_in,
   //
   Q_out );
  
  // list external pins by name in XDC file
  output Q_out;
  input wire clk_in;     // 100kHz
  input  reset;
  
  reg Q;
  reg q1 = 0;
  reg q2 = 0;
  reg [Nb-1:0] N_minus_1 = N-1;
  reg [Nb-1:0] N_half = N>>1;
 
  // internal wires and reg
  reg [Nb-1:0] count = 0;
  // ======================================================
  always @( posedge clk_in or posedge reset) begin
    if( reset) begin
      count <= 0;
      Q <= 0;
    end else begin
      count <= count + 1;
      if (count > N_minus_1) begin
         Q <= 0;
         count <= 0;
      end else begin 
         if (count > N_half) begin
            Q <= 1;
         end
      end   
    end
   end  
  
  assign Q_out = Q;
  
endmodule