//////////////////////////////////////////////////////////////////////////////////
//  Module   : top_lfsr.v
//  Parent   : none
//  Children : debounce.v, toggle.v, lfsr.v, refresh.v, Seven_Seg_Display_Control.v 
//  Description:
//     This is the top module for the lfsr project on a basys3 board
//  Parameters:
//     None
///////////////////////////////////////////////////////////////////////////////////
//`include "timescale.v"

/////////////////////////////Basys 3 FPGA   ///////////////////////////////////////
module top_lfsr (
   CLK100MHZ,
   btnU,         // manual reset\
   //
   cath_out,     // cathode active low
   enable,       // anode active active high  clk1
   led
  );
  
  // list external pins by name in XDC file
  input CLK100MHZ;
  input btnU;        // use as manual reset
  //
  output [2:0] led;
  output [6:0] cath_out;  // 7-seg display
  output [3:0] enable;    // 7-seg enable  
  
  // internal wires and reg
  wire [6:0]  out;
  wire refresh_rate;       //~120Hz
  wire [15:0] register;
  wire [15:0] word;
  wire DONE;
  
  reg  Led;
  reg btnU_1;
  reg btnU_2;
  reg btnU_3;
  
  // instaniate clock wizard
 
  // input CLK100MHZ
  // output 5Mhz
  clk_wiz_0 clk_wiz_0 (
     .clk_in1   (CLK100MHZ),
     .clk_out1  (clock_5Mhz),  
     .locked    (DONE) ); 
  
  // instantiate modules
  div_by_N #(.N(32967), .Nb(16)) div_by_N_1 (
    .reset       (btnU),
    .clk_in      (clock_5Mhz),
    //  
    .Q_out       (clock_120hz) );  
    
  div_by_N  #(.N(5000000), .Nb(23)) div_by_N_2 (
    .reset       (btnU),
    .clk_in      (clock_5Mhz),
    //  
    .Q_out       (update_1Hz));  
 
  // instaniate modules
  // reset
  reset_gen reset_gen_1 (
   .clk       (sys_clk),
   .inp       (pulse),     // btnU 
   .rst_n     (rst_n) );    // active low reset
  // debounce button logic
  debounce debounce_1 (
   .clk         (clock_5Mhz),    // 5Mhz
   .btn         (btnU_3),        // reset active high
   //
   .outp        (pulse) );       // debounced output
   
  // linear feedback shift register (pseudorandom generator)
  lfsr lfsr_1 (
    .rst_n  (rst_n),
    .clk    (clock_5Mhz),
    .pulse  (update_1Hz),                     // (update_1Hz),        // update every 1 sec   // debug !!!!
    //
    .word   (register) );
  
  // 7-segment display 
  Seven_Seg_Display_Control Seven_Seg_Display_Control_1 (
    .clk1          (sys_clk),
    .reset         (~rst_n),
    .refresh       (refresh_rate),
    .word          (word),
    //
    .cath_out      (out),       // cathode signals
    .anode         (enable) );  // anode enable
   
   // clk boundary crossing on btnU to remove instability
  always @(posedge sys_clk) begin
    btnU_1 <= btnU;
    btnU_2 <= btnU_1;
    btnU_3 <= btnU_2;
  end
   
  always @(posedge sys_clk ) begin    // sys_clk must be a clock source
     Led <= rst_n && !Led && update_1Hz;
  end
 
  
  assign word = register;
  assign led[0] = Led;          // led[0] used for display
  assign led[1] = 0;
  assign led[2] = 0;
  assign cath_out = out;
  assign sys_clk = clock_5Mhz;
  assign refresh_rate = clock_120hz;
   
endmodule