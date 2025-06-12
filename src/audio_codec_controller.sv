module  audio_codec_controller
  (
    input  logic  clk_50mhz_i,
    input  logic  clk_12mhz_i,
    input  logic  rst_ni,
    input  logic  en_i,

    input  logic  start_config_i,
    input  logic  load_aud_dat_i,
    input  logic  fpga_aud_adcdat_i,

    input  logic  [23:0]  data_to_lineout_i,
    output logic  [23:0]  sample_from_linein_o,

    output logic  done_config_o,
    output logic  clk_sample_o,
    output logic  fpga_aud_dacdat_o,
    output logic  fpga_aud_adc_lrck_o,
    output logic  fpga_aud_dac_lrck_o,
    output logic  fpga_aud_bclk_o,
    output logic  fpga_aud_xck_o,

    output logic  clk_i2c_o,
    output logic  fpga_i2c_sclk_o,
    inout  wire   fpga_i2c_sdat_io
  );
  
  setup_codec  CODEC_SETUP  (
                               .clk_50mhz ( clk_50mhz_i      ),
                               .rst_ni    ( rst_ni           ),
                               .en_i      ( en_i             ),
                               .start_cf_i( start_config_i   ),
                               .i2c_sdin_o( fpga_i2c_sdat_io ),
                               .i2c_sclk_o( fpga_i2c_sclk_o  ),
                               .cf_done_o ( done_config_o    ),
                               .clk_i2c_o ( clk_i2c_o        ));
  
  codec_digital_audio_interface  FPGA_CODEC_BUFFER  (
                               .clk_i               ( clk_12mhz_i          ),
                               .rst_ni              ( rst_ni               ),
                               .en_i                ( en_i                 ),
                               .load_i              ( load_aud_dat_i       ),
                               .data_to_lineout_i   ( data_to_lineout_i    ),
                               .sample_from_linein_o( sample_from_linein_o ),
                               .codec_aud_adc_dat_i ( fpga_aud_adcdat_i    ),
                               .codec_aud_dac_dat_o ( fpga_aud_dacdat_o    ),
                               .codec_bclk_o        ( fpga_aud_bclk_o      ),
                               .codec_xck_o         ( fpga_aud_xck_o       ),
                               .codec_adc_lrck_o    ( fpga_aud_adc_lrck_o  ),
                               .codec_dac_lrck_o    ( fpga_aud_dac_lrck_o  ),
                               .clk_sample_o        ( clk_sample_o         ));
  
endmodule
