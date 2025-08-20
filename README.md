![](media/demo.gif)

# PolarFire&reg; Video Kit VectorBlox Demo Generation Scripts

## Table of Contents

- [PolarFire&reg; Video Kit VectoBlox Demo Generation Scripts](#polarfire-video-kit-vectorblox-demo-generation-scripts)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Building the application and configuring the SPI](#demo-building)
  - [Using the Vectorblox design generation Tcl script](#using-the-reference-design-generation-tcl-script)
    - [Licensing](#licensing)
    - [Standard design generation](#standard-design-generation)
    - [Arguments supported](#arguments-supported)
  - [Programming the FPGA](#programming-the-fpga)
  - [Launching and controlling the demo](#demo-controlling)

<a name="description"></a>
## Description

This repository can be used to generate the VectorBlox demo using the PolarFire Video Kit. A Libero SoC Tcl script is provided to generate the design using Libero SoC along with device specific I/O constraints.

This repository supports Libero SoC v2024.2, which is available for download [here](https://www.microsemi.com/product-directory/design-resources/1750-libero-soc#downloads).

<a name="demo-building"></a>
## Building the application and configuring the SPI flash

Prior to running the design script:
  - Libero and SoftConsole installed on native OS
  - firmware and neural networks generated via the [VectorBlox SDK](https://github.com/Microchip-Vectorblox/VectorBlox-SDK) are downloaded
  - the SPI flash configuration is generated
  - the MiV bare-metal demo application is built
  

Alternatively, the provided `.job` file (found in the [releases](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/releases)) can be used to program the board via FlashPro Express. 



### Windows OS 
> - Clone this repo into a Windows accessible directory
> - Download the [hex_V1000_2.0.3.zip](https://github.com/Microchip-Vectorblox/assets/releases/download/assets/hex_V1000_2.0.3.zip) and extract the files into the same repo directory
> - Start SoftConsole in Windows and open the project via [Section 6](docs/VectorBlox_Video_Kit_Demo_Guide.pdf), set the `Build Configurations` to `Release` and build the project.
> - Start Libero in Windows and run the steps in [Standard design generation](#standard-design-generation) with the argument `GENERATE_PROGRAMMING_DATA` to generate the project
> - To program the board via Libero, follow steps in Section 5 of the [Demo Guide](docs/VectorBlox_Video_Kit_Demo_Guide.pdf)


### Linux OS
> - Ensure that `riscv64-unknown-elf-gcc` (through Softconsole), `libero`, and `shls`(SmartHLS-2024.2) are located in your `$PATH` variable
> - Download the [hex_V1000_2.0.3.zip] and extract the files into the same [repo directory](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/releases)
> - Run the command `make bitstream` to build the demo and subsequently generate the Libero project in order to create the `.job` file.


<a name="using-the-vectorblox-demo-generation-tcl-script"></a>
## Using the VectorBlox demo generation Tcl script

<a name="licensing"></a>
### Licensing

The Video Kit VectorBlox Design requires two free licences -- `Libero SoC Silver License` and `Libero Soc VectorBlox License`. Licensing information is available on the Microchip website [here](https://www.microchip.com/en-us/products/fpgas-and-plds/fpga-and-soc-design-tools/fpga/licensing).

<a name="standard-design-generation"></a>
### Standard design generation

To generate the Vectorblox demo design the following flow can be used:

1. Clone or download the repository
2. Open Libero v2024.2
3. Open the execute script dialog (CTRL + U)
4. Execute the "MPF_VIDEO_KIT_VECTORBLOX_DESIGN.tcl" script
5. Configure the design if required
6. Run the Libero SoC design flow to program a device

<a name="arguments-supported"></a>
### Arguments supported

Below arguments are supported to modify or configure aspects of the design flow that will be run. Supported arguments are:

| Argument                  | Description                                                                                                                                |
| :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------|
| SYNTHESIZE                | Runs the synthesis step after design generation has completed                                                         |
| PLACEROUTE                | Runs the synthesis and place and route steps after design generation has completed                                    |
| VERIFY_TIMING             | Runs the synthesis, place and route and timing verification steps after design generation has completed               |
| GENERATE_PROGRAMMING_DATA | Generates the files required to generate a bitstream for programming a device                                         |
| EXPORT_FPE                | Exports a FlashPro Express file to the local directory (run after generating programming data)                              |

<a name="programming-the-fpga"></a>
## Programming the FPGA

Once the script has completed the design can be configured further if needed and the Libero SoC design flow can be run by double clicking on a stage in the design flow on the left hand side of Libero. Selecting an option requiring previous steps to be completed will run the full flow, i.e double clicking "Run Program Action" will run any required steps, such as, "Synthesize", "Place and Route", etc and then program the device.


*In addition, plug in an HDMI input into J35, and an HDMI output into J2*


<a name="demo-controlling"></a>
## Launching and controlling the demo

- The demo consists of the following:
    - Classification (Mobilenetv2)
    - Object Detection (Yolov8)

- Use the two red buttons to switch between demos: `SW1` toggles the menu, where `SW2` can change the selected model. Pressing `SW1` again loads the selected model 

> Please refer to the [VectorBlox Video Kit Demo Guide](docs/VectorBlox_Video_Kit_Demo_Guide.pdf) for more information on available demos modes.
