# PolarFire&reg; Video Kit VectorBlox Demo Generation Tcl Scripts - Libero&reg; SoC v2023.1+

## Table of Contents

- [PolarFire&reg; Video Kit VectoBlox Demo Generation Tcl Scripts - Libero&reg; SoC v2023.1+](#polarfire-video-kit-vectorblox-demo-generation-tcl-scripts---libero-soc-v20231)
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

This repository can be used to generate a VectorBlox demo using the PolarFire Video Kit. The demo can be used to accelerate VNNX neural networks on PolarFire, including a full video pipeline. A Libero SoC Tcl script is provided to generate the design using Libero SoC along with device specific I/O constraints.

This repository supports Libero SoC v2022.3, which is available for download [here](https://www.microsemi.com/product-directory/design-resources/1750-libero-soc#downloads).

<a name="demo-building"></a>
## Building the application and configuring the SPI flash

Prior to running the design:
  - VNNX firmware and neural networks are downloaded
  - the bare-metal demo application is built
  - the SPI flash configuration is generated

This can be automated from the command line via `make spi`. Further detail in regards to changing and compiling the application in SoftConsole and changing networks can be found in our demo guide.


<a name="using-the-vectorblox-demo-generation-tcl-script"></a>
## Using the VectorBlox demo generation Tcl script

<a name="licensing"></a>
### Licensing

The Video Kit VectorBlox Design can be generated using any of the free or paid Libero licenses. Licensing information is available on the Microchip website [here](https://www.microchip.com/en-us/products/fpgas-and-plds/fpga-and-soc-design-tools/fpga/licensing).

<a name="standard-design-generation"></a>
### Standard design generation

To generate the Vectorblox demo design the following flow can be used:

1. Clone or download the repository
2. Open Libero v2023.1
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
| EXPORT_FPE                | Runs the full design flow after generating a design and exports a FlashPro Express file to the local directory                              |

<a name="programming-the-fpga"></a>
## Programming the FPGA

Once the script has completed the design can be configured further if needed and the Libero SoC design flow can be run by double clicking on a stage in the design flow on the left hand side of Libero. Selecting an option requiring previous steps to be completed will run the full flow, i.e double clicking "Run Program Action" will run any required steps, such as, "Synthesize", "Place and Route", etc and then program the device.

*In addition, plug in an HDMI input into J13, and an HDMI output into J14*


<a name="demo-controlling"></a>
## Launching and controlling the demo

To program the devide and SPI, the user can use FlashPro Express using the job files, or may open the complete Libero design and double click "Run Program Action" followed by "RUN SPI Program Action". Once programmed, power cycle the board and the demo will automatically run.

The red buttons are used to switch between demos. The first button toggles the menu, and the seconds button selects the mode. For more details on programming or running the demo, please refer to the demo guide.
