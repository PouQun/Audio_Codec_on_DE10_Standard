`timescale 1ns / 1ps

module tb_setup_codec;

  // Testbench signals
  logic clk_50mhz, clk_i2c;
  logic rst_ni;
  logic en_i;
  logic start_cf_i;
  wire  i2c_sdin_o;
  logic i2c_sclk_o;
  logic cf_done_o;
  
  logic [ 3:0] fsm_check;
  logic [10:0] sclk_count;

  setup_codec_via_i2c DUT (
                   .clk_50mhz ( clk_50mhz    ),
                   .rst_ni    ( rst_ni       ),
                   .en_i      ( en_i         ),
                   .start_cf_i( start_cf_i   ),
                   .i2c_sdin_o( i2c_sdin_o   ),
                   .i2c_sclk_o( i2c_sclk_o   ),
                   .cf_done_o ( cf_done_o    ),
                   .clk_i2c_o ( clk_i2c      ));

  // Clock generation
  initial begin
    clk_50mhz = 0;
    forever begin
      #10 clk_50mhz = ~clk_50mhz;
    end
  end
  
  always_ff@(posedge i2c_sclk_o, negedge rst_ni) begin: COUNT_SCL_DEBUG
     if      (~rst_ni) begin
                                  sclk_count <= 0;
                          end
     else                 begin
                                  sclk_count <= sclk_count + 1;
                          end
  end
  
  assign fsm_check  = DUT.I2C_PROTOCOL.i2c_fsm;
  assign i2c_sdin_o = ( 
                        (fsm_check == 3) ||
                        (fsm_check == 5) ||
                        (fsm_check == 7)
                       )                          ? 1'b0 : 1'bz;

  // Test sequence
  initial begin
    rst_ni = 0;
    en_i = 0;
    start_cf_i = 0;

    #100   rst_ni = 1;
    #100   en_i =1;
    #50000 start_cf_i = 1;
    #20000 start_cf_i = 0;
  
    #5000000;
    $finish;
  end

endmodule