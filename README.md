![](media/demo.gif)

# PolarFire&reg; Non-SoC Video Kit VectorBlox 3.2 Demo

This repository generates a VectorBlox demo using the [PolarFire&reg; Video Kit](https://www.microchip.com/en-us/development-tool/MPF300-VIDEO-KIT-NS). A Libero SoC Tcl script generates the design and contains the device-specific I/O constraints.  

The demo runs CoreVectorBlox neural network acceleration on the PolarFire MPF300T FPGA. It’s a bare-metal application running on a Mi-V RISC-V soft processor. Video is sourced from either the dual-camera sensor or an HDMI source; the selected neural network runs, and the results are drawn on an HDMI monitor. No OS is required, as the neural network models and the Mi-V application are both stored in the on-board SPI flash and loaded at power-up.

This repository supports Libero SoC v2026.1, which is available for download [here](https://www.microchip.com/en-us/products/fpgas-and-plds/fpga-and-soc-design-tools/fpga/libero-software-later-versions#downloads).

The Mi-V application was built and tested with SoftConsole v2022.2. Newer versions of SoftConsole should also work.



## Table of Contents

- [Getting Started Guide](#getting-started-guide)
- [Building with Libero Setup Guide](#building-with-libero-setup-guide)
- [Controlling the VectorBlox Demo](#controlling-the-vectorblox-demo)
- [Additional Information](#additional-information)
- [Version Compatibility](#version-compatibility)
- [Legal](#legal)

## Getting Started Guide

The Getting Started Guide is recommended for most users. Use the Building with Libero Setup Guide only if you need to modify the Libero project, SPI flash contents, or Mi-V application.

To run the demo on the PolarFire Video Kit without building, using the prebuilt job file, **please refer to the [Getting Started Guide](docs/getting_started_guide.md).**

## Building with Libero Setup Guide

For instructions on building the project with a Tcl script in Libero SoC v2026.1, generating the SPI flash configuration, building the Mi-V application, or creating a custom job file, refer to the [Building with Libero Setup Guide](docs/building_with_libero.md).

## Controlling the VectorBlox Demo

The demo consists of the following by default:

| Model                        | Task             | Post-Processing Type |
| :--------------------------- | :--------------- | :------------------- |
| MobileNet V2                 | Classification   | `CLASSIFY`           |
| YOLOv8n (512x288, argmax)    | Object detection | `OBJECT_DETECT`      |

The models are listed in the `models[]` array in `softconsole/Videokit/main.c` and are stored in the SPI flash. Refer to [adding_models.md](docs/adding_models.md) for instructions on adding models generated with the VectorBlox SDK.

To interact with the demo, use the two red push buttons, `SW1` and `SW2`, located next to the HDMI connectors:

- Press `SW1` to open the model menu.
- Press `SW2` to move the highlight down the model menu.
- Press `SW1` again to load the highlighted model.

The video source is selected automatically. An HDMI source connected to HDMI 2.0 RX (J35) takes priority over the dual camera sensor. If no HDMI cable is connected to J35, the camera sensor is used.

## Additional Information

- [Adding Additional Models](docs/adding_models.md) - Explains how to add models generated with the VectorBlox SDK to the SPI flash and the demo application.
- [Modifying the Mi-V Software](docs/modifying_mi-v_software.md) - Explains how to build, run, and save changes to the Mi-V demo application using SoftConsole.
- [VectorBlox SDK](https://github.com/Microchip-Vectorblox/VectorBlox-SDK) - Provides instructions for compiling models for target hardware. The SDK tutorials generate the `.hex` model files used by this demo.
- [Resource Utilization](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/blob/master/docs/resource_utilization.md) - Refer to this for FPGA resource utilization numbers for the VBX core.
- [CoreVectorBlox IP Handbook](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/blob/master/docs/CoreVectorBlox_IP_Handbook.pdf) - Please refer to the CoreVectorBlox IP Handbook PDF in our SDK docs folder for more information about the VectorBlox core, including error codes.
- [VectorBlox Video Kit Demo Guide PDF](docs/VectorBlox_Video_Kit_Demo_Guide.pdf) - Describes the system design and data flow of the demo.

## Version Compatibility

Refer to the following table for previous version compatibility information for the VBX Non-SoC Video Kit Demo:

| VBX Video Kit Demo Release Tags                                                                 | VBX SDK Release Tags                                                                             | .job File                                                                                          | Libero Version     | SoftConsole Version | FlashPro Version  |
| :---------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- | :----------------- | :------------------ | :---------------- |
| [demo-release-v2.0.3](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/tree/v2.0.3)     | [sdk-release-v2.0.3](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/tree/release-v2.0.3) | [v2.0.3 release assets](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/releases/tag/v2.0.3)     | Libero SoC v2024.2 | SoftConsole v2021.1 | FPExpress v2024.2 |
| [demo-release-v1.4.4.1](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/tree/v1.4.4.1) | [sdk-release-v1.4.4](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/tree/release-v1.4.4) | [v1.4.4.1 release assets](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/releases/tag/v1.4.4.1) | Libero SoC v2023.1 | SoftConsole v2021.1 | FPExpress v2023.1 |
| [demo-release-v1.4.4](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/tree/v1.4.4)     | [sdk-release-v1.4.4](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/tree/release-v1.4.4) | [v1.4.4 release assets](https://github.com/Microchip-Vectorblox/VectorBlox-Video-Kit-Demo/releases/tag/v1.4.4)     | Libero SoC v2023.1 | SoftConsole v2021.1 | FPExpress v2023.1 |

## Legal

Copyright (c) 2020-2026 Microchip Technology Inc. All rights reserved.

For detailed license information, see [LICENSE.md](LICENSE.md).