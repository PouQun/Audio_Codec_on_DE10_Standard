# Audio_Codec_on_DE10_Standard
A simple controller for controlling the Audio Codec WM8731 on DE10-Standard kit.

## Design
### Passive configuration via I2C interface:
- I2C interface:

  ![2-Wire_Interface [by ref](ref/WolfsonWM8731.pdf)](doc/pics/2-wire_serial_interface.png)

  * With I2C Address: 0x34 ( write only )

- Register setup:
  * Configuration Sequence:
  
    ![ SETUP_SEQUENCE [by ref](ref/WolfsonWM8731.pdf)](doc/pics/PowerUD_Sequence.png)

  * Registers are set up passively by sequence:
    
| `Reg`  | `Data config (hex)` | `Target` |
| :--- | :---------------: | :----- |
| R15  | 1E00              | Set 00000000 to `RESET`      : Reset CODEC |
| R6   | 0C10              | Set        0 to `PDOUT`      : Power up all except Outputs_PowerDown |
| R2   | 0579              | Set  1111001 to `LHPVOL`     : 0dB Left  LineOut volume |
| R3   | 0779              | Set  1111001 to `RHPVOL`     : 0dB Right LineOut volume |
| R0   | 0017              | Set    10111 to `LINVOL`     : 0dB Left  LineIn  volume |
| R1   | 0217              | Set    10111 to `RINVOL`     : 0dB Right LineIn  volume |
| R4   | 0810              | Set        0 to `INSEL`      : Select LineIn to ADC <br> Set        1 to `MUTEMIC`    : Enable mute MicIn <br> Set        1 to `DACSEL`     : Select DAC to LineOut <br> Set        0 to `BYPASS`     : Disable ByPass switch <br> Set        0 to `SIDETONE`   : Disable SideTone switch |
| R5   | 0A00              | Set        0 to `DACMU`      : Disable DAC softmute |
| R7   | 0E08              | Set       00 to `FORMAT`     : Select Right Justified mode for audio data format 
                        <br> Set       10 to `IWL`        : 24-bit input audio data length |
| R8   | 1001              | Set        1 to `USB/NORMAL` : Select USB-mode
                        <br> Set        0 to `BOSR`       : 250fs 
                        <br> Set     0000 to `SR`         : Select 48kHz for sampling frequency for both ADC and DAC |
| R9   | 1201              | Set        1 to `ACTIVE`     : Active CODEC |
| R6   | 0C02              | Set        0 to `PDOUT`      : Power up Outputs  |

   For more detail, have a look in [WM8731_Datasheet](ref/WolfsonWM8731.pdf)
  
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




