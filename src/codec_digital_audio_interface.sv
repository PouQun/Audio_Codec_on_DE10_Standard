module codec_digital_audio_interface
  (
    input  logic        clk_i, //12Mhz
    input  logic        rst_ni,
    input  logic        en_i,
    
    input  logic        load_i,
    
    input  logic [23:0] data_to_lineout_i,
    
    input  logic        codec_aud_adc_dat_i,
    output logic        codec_bclk_o,
    output logic        codec_dac_lrck_o,
    output logic        codec_adc_lrck_o,
    output logic        codec_xck_o,
    output logic        codec_aud_dac_dat_o,
    
    output logic        clk_sample_o,
    output logic [23:0] sample_from_linein_o
  );
  
  logic        clk_sample;
  logic [23:0] data_from_linein_t;
  logic [23:0] sample_to_lineout_t;
  
  audio_io_data_buffer_rjm_format
  FPGA_CODEC_BUFFER           (
                               .clk_i         ( clk_i     ),
                               .rst_ni        ( rst_ni    ),
                               .en_i          ( en_i      ),
                               .load_i        ( load_i    ),
                               .adc_serial_data_i  ( codec_aud_adc_dat_i  ),
                               .dac_parallel_data_i( sample_to_lineout_t  ),
                               .dac_serial_data_o  ( codec_aud_dac_dat_o  ),
                               .adc_parallel_data_o( data_from_linein_t   ),
                               .codec_xck_o        ( codec_xck_o          ),
                               .codec_bclk_o       ( codec_bclk_o         ),
                               .codec_lrck_o       ( codec_dac_lrck_o     ),
                               .sample_clk_o       ( clk_sample           ));
  
  assign codec_adc_lrck_o = codec_dac_lrck_o;
  assign clk_sample_o     = clk_sample;
  
  always_ff@( posedge clk_sample, negedge rst_ni ) begin:       SAMPLING_BUFFER
    if      ( ~rst_ni      )  begin
                                  sample_to_lineout_t  <= 'b0;
                                  sample_from_linein_o <= 'b0;
                              end
    else if ( load_i       )  begin
                                  sample_to_lineout_t  <= data_to_lineout_i;
                                  sample_from_linein_o <= data_from_linein_t;
                              end
    else                      begin
                                  sample_to_lineout_t  <= sample_to_lineout_t;
                                  sample_from_linein_o <= sample_from_linein_o;
                              end
  end
  
endmodule
