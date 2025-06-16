# Audio_Codec_on_DE10_Standard
A simple controller for controlling the Audio Codec WM8731 on DE10-Standard kit.

## Design
### Passive configuration via I2C interface:
- I2C interface:

![2-Wire_Interface [by ref](ref/WolfsonWM8731.pdf)](doc/pics/2-wire_serial_interface.png)

- Register setup:
 * Configuration Sequence:

![2-Wire_Interface [by ref](ref/WolfsonWM8731.pdf)](doc/pics/PowerUD_Sequence.png)

 * Register:
    
Reg | Data config (hex) | Target 
;----|;-----------------;|;-------
 R15 | 1E00              |        
 R6  | 0C10              |        
 R2  | 0579              |        
 R3  | 0779              |        
 R0  | 0017              |        
 R1  | 0217              |        
 R4  | 0810              |        
 R5  | 0A00              |        
 R7  | 0E08              |        
 R8  | 1001              |        
 R9  | 1201              |        
 R6  | 0C02              |        

### I/O Digital audio interface:
- Digital audio signals waveform bases on Right Justified Mode audio format:
  
![Right Justified Mode [by ref](ref/WolfsonWM8731.pdf)](doc/pics/RJM_audio.png)

- Hardware diagram of digital audio interface:

![Digital audio dataflow](doc/pics/Datapath_through_Audio_Codec_Controller.png)

## Verify
### I2C Interface controller:
- Waveform of I2C_INTERFACE_CONTROLLER:

### Audio data buffer:
- Waveform of signals based on RJM-format:

![Testbench waveform of RJM digital interface signals](doc/pics/Waveform_RJM_format_Total.png)

  * Serial to Paralel: 1-bit ADCDAT to 24-bit SAMPLE_FROM_LINE_IN
    
![ADC](doc/pics/Waveform_RJM_format_L_zoom_ADC_SIPO.png)

  * Paralel to Serial: 24-bit SAMPLE_TO_LINE_OUT to 1-bit DACDAT

![DAC](doc/pics/Waveform_RJM_format_L_zoom_DAC_PISO.png)


## Implementation on DE10-Standard kit:




