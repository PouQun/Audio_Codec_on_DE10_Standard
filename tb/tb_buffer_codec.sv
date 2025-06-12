module tb_buffer_codec;

  parameter int WD = 24;

  logic clk, clk_sample;
  logic rst_n;
  logic en, load;
  logic [WD-1:0] s2p_pdata;
  logic [WD-1:0] p2s_pdata;
  logic          p2s_sdata;
  reg            s2p_sdata;
  logic bclk, lrck, xck;
  logic sending_debug;
  assign   sending_debug = DUT_AUDIO_IO_BUFFER.sending;

  audio_io_data_buffer_rjm_format  DUT_AUDIO_IO_BUFFER  (
                               .clk_i              ( clk         ),
                               .rst_ni             ( rst_n       ),
                               .en_i               ( en          ),
                               .load_i             ( load        ),
                               .adc_serial_data_i  ( s2p_sdata   ),
                               .dac_parallel_data_i( p2s_pdata   ),
                               .dac_serial_data_o  ( p2s_sdata   ),
                               .adc_parallel_data_o( s2p_pdata   ),
                               .codec_xck_o        ( xck         ),
                               .codec_bclk_o       ( bclk        ),
                               .codec_lrck_o       ( lrck        ),
                               .sample_clk_o       ( clk_sample  ));

  always #5 clk = ~clk;

  reg [23:0] text;
  reg [23:0] text_shift;

  
  always_ff@ (posedge lrck) begin
    text <= text >> 4;
  end

  always_ff@ (negedge bclk) begin
    text_shift <= (~sending_debug) ? text :text_shift >> 1;
  end  
  
  assign s2p_sdata = (sending_debug) ? text_shift[0] : 1'b1;
  assign p2s_pdata = s2p_pdata * 2;

  initial begin
    clk   = 0;
    rst_n = 0;
    en    = 0;
    load  = 0;
    text = 24'hFFF000;
    #15 rst_n = 1;
    #20 en = 1;
    #30 load = 1;
    #200;
    text = 24'hF0F0F0;
    #30000 $stop;
  end

endmodule
