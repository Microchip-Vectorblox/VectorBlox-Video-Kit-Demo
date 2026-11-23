# Building with Libero SoC Setup Guide

This guide describes how to build the PolarFire® Non-SoC Video Kit VectorBlox demo from source. Use it if you need to modify the Libero project, the SPI flash contents, the Mi-V application, or generate a custom job file. To run the demo without building, use the prebuilt job file described in the [Getting Started Guide](./getting_started_guide.md).

## Table of Contents

- [Licensing](#licensing)
- [Build Overview](#build-overview)
- [Step 1: Add the Model Hex Files](#step-1-add-the-model-hex-files)
- [Step 2: Generate the SPI Flash Configuration](#step-2-generate-the-spi-flash-configuration)
- [Step 3: Build the Mi-V Application](#step-3-build-the-mi-v-application)
- [Step 4: Using the VectorBlox Design Generation Tcl Script](#step-4-using-the-vectorblox-design-generation-tcl-script)
- [Programming the FPGA](#programming-the-fpga)
- [Next Steps](#next-steps)

## Licensing

If building the Video Kit VectorBlox Design in Libero, two free licenses are required: `Libero SoC Silver License` and `Libero SoC VectorBlox License`. Licensing information is available on the Microchip website [here](https://www.microchip.com/en-us/products/fpgas-and-plds/fpga-and-soc-design-tools/fpga/licensing).

## Build Overview

The SPI flash on the video kit holds the neural network models, the on-screen font, and the Mi-V application. Libero reads all of them when it generates the programming data, so they must be ready **before** the Tcl script is run with `GENERATE_PROGRAMMING_DATA`:

| File | Created In | Used For |
| :--- | :--------- | :------- |
| `hex/*.hex` | [Step 1](#step-1-add-the-model-hex-files) (prebuilt download or VectorBlox SDK) | Model and font data stored in the SPI flash |
| `hex/spiflash.cfg` | [Step 2](#step-2-generate-the-spi-flash-configuration) (included in the prebuilt download) | SPI flash client list and start addresses, loaded by the Tcl script with `configure_spiflash` |
| `softconsole/Videokit/Release/Videokit.hex` | [Step 3](#step-3-build-the-mi-v-application) | Mi-V application, loaded into fabric RAM at power-up (configured in `script_support/RAM.cfg`) |

All paths in this guide are relative to the directory that contains `MPF_VIDEO_KIT_VECTORBLOX_DESIGN.tcl`.

| Tool | Requirement |
| :--- | :---------- |
| Libero SoC | v2026.1. The Tcl script checks the version and stops if another version is used. |
| SoftConsole | Required to build the Mi-V application. On Linux, `riscv64-unknown-elf-gcc` (installed with SoftConsole) must be in your `$PATH`. |
| Python 3 | Required to generate the SPI flash configuration. The script also uses the GNU `size` utility. |

> **Note (Windows):** Libero checks that the project path is shorter than 90 characters. Clone the repository into a short path, such as `C:\vbx\`.

---

## Step 1: Add the Model Hex Files

The `hex/` directory must be next to the Tcl script and contain the following files. **The file names must match exactly.**

### Option A: Download the Prebuilt Hex Files (Recommended)

Rather than generating the hex files with the VectorBlox SDK, download the prebuilt [hex_V1000_3.2.zip](https://github.com/Microchip-Vectorblox/assets/releases/download/assets/hex_V1000_3.2.zip). It contains all three hex files compiled for this release, **plus a `hex/spiflash.cfg` that is already configured** for them.

Extract the archive in the directory that contains the Tcl script. The archive already includes the `hex/` folder:

```bash
wget https://github.com/Microchip-Vectorblox/assets/releases/download/assets/hex_V1000_3.2.zip
unzip hex_V1000_3.2.zip
```

> **Note:** Because `hex/spiflash.cfg` is included and `softconsole/Videokit/main.c` already contains the matching start addresses, you can skip [Step 2](#step-2-generate-the-spi-flash-configuration).

### Option B: Generate the Hex Files with the VectorBlox SDK

Use this option if you want to compile the models yourself. Create a `hex/` directory next to the Tcl script and place the following files in it:

```text
.
├── MPF_VIDEO_KIT_VECTORBLOX_DESIGN.tcl
├── Makefile
├── hex/
│   ├── ascii_characters.hex
│   ├── mobilenet-v2.hex
│   └── yolov8n_512x288_argmax.hex
├── script_support/
└── softconsole/
```

| File | Contents | Source |
| :--- | :------- | :----- |
| `ascii_characters.hex` | On-screen font used to draw labels | `example/soc-video-c/frameDrawing/ascii_characters.hex` in the [VectorBlox SDK](https://github.com/Microchip-Vectorblox/VectorBlox-SDK). A copy is also included at `softconsole/Videokit/frameDrawing/ascii_characters.hex`. |
| `mobilenet-v2.hex` | MobileNet V2 classifier | Output of the SDK tutorial [`tutorials/openvino/mobilenet-v2`](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/tree/master/tutorials/openvino/mobilenet-v2) (`mobilenet-v2_V1000_ncomp.hex`), renamed |
| `yolov8n_512x288_argmax.hex` | YOLOv8n object detector | Output of the SDK tutorial [`tutorials/ultralytics/yolov8n_512x288_argmax`](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/tree/master/tutorials/ultralytics/yolov8n_512x288_argmax) (`yolov8n_512x288_argmax_V1000_ncomp.hex`), renamed |



> **Important:** Compile models with the VectorBlox 3.2 SDK using the `V1000` size and `ncomp` compression options (`vnnx_compile -s V1000 -c ncomp`). These match the CoreVectorBlox configuration in this design. In addition to the `.vnnx` file, `vnnx_compile` outputs the `.hex` file used by this demo. Models compiled with a different SDK release fail with a `MODEL VERSION MISMATCH` error.

---

## Step 2: Generate the SPI Flash Configuration

This step creates `hex/spiflash.cfg` and writes the SPI flash start address of each file into `softconsole/Videokit/main.c`.

> **Note:** If you downloaded `hex_V1000_3.2.zip` in [Step 1](#option-a-download-the-prebuilt-hex-files-recommended), skip this step. `hex/spiflash.cfg` is already provided, and `main.c` already contains the matching start addresses. This step is only needed if you add, remove, or replace hex files.

### Linux OS

Run the following command from the directory that contains the Tcl script:

```bash
make spi
```

### Windows OS

`make` is not required, but the scripts need Python 3 and the GNU `size` utility. Run the following commands from the directory that contains the Tcl script, for example in WSL:

```bash
python3 script_support/gen_spi_cfg.py -o hex/spiflash.cfg -d ../hex hex/ascii_characters.hex hex/mobilenet-v2.hex hex/yolov8n_512x288_argmax.hex
python3 script_support/set_model_size.py hex/spiflash.cfg softconsole/Videokit/main.c
```

### What This Step Does

1. `script_support/gen_spi_cfg.py` writes `hex/spiflash.cfg`. The design initialization client is placed at address `0x400`, and each hex file is placed directly after the previous one, in the order the files are listed.
2. `script_support/set_model_size.py` reads the start addresses from `hex/spiflash.cfg` and updates the `models[]` array and `CHAR_SPI_OFFSET` in `softconsole/Videokit/main.c`.

> **Important:** `make spi` does not regenerate `hex/spiflash.cfg` if it already exists. If you add, remove, or replace any hex file, delete `hex/spiflash.cfg` and run this step again. Otherwise, the SPI flash addresses will not match the files, and the models will fail to load.

---

## Step 3: Build the Mi-V Application

The Mi-V application must be built in the `Release` configuration so that `softconsole/Videokit/Release/Videokit.hex` exists. Build it after Step 2, because Step 2 updates `main.c`.

### Windows OS

Open the `softconsole/Videokit` project in SoftConsole, set the build configuration to `Release`, and build the project. For detailed instructions, see [modifying_mi-v_software.md](./modifying_mi-v_software.md).

### Linux OS

Ensure `riscv64-unknown-elf-gcc` is in your `$PATH`, then run:

```bash
make -C softconsole/Videokit/Release all
```

This step is also run automatically by `make bitstream` (see [Step 4](#linux-os-build-with-make)).

---

## Step 4: Using the VectorBlox Design Generation Tcl Script

### Standard Design Generation

To generate the VectorBlox demo design, the following flow can be used:

1. Complete Steps 1 to 3
2. Open Libero SoC v2026.1
3. Open the execute script dialog (CTRL + U) from the Welcome Page
4. Execute the "MPF_VIDEO_KIT_VECTORBLOX_DESIGN.tcl" script with the `GENERATE_PROGRAMMING_DATA` argument
5. Configure the design if required
6. Run the Libero SoC design flow to program a device

> **Note:** You may be prompted to update Libero SoC or individual IP cores. Ignore these prompts.

### Arguments Supported

If you want to build the SmartDesign in a Libero project without compiling it (synthesis, place and route, etc.), do not specify any arguments for the Tcl script. The following arguments are supported to modify or configure aspects of the design flow that will be run. Multiple arguments can be combined with `+`, for example `GENERATE_PROGRAMMING_DATA+EXPORT_FPE`.

| Argument                  | Description                                                                                              |
| :------------------------ | :------------------------------------------------------------------------------------------------------- |
| SYNTHESIZE                | Runs the synthesis step after design generation has completed                                            |
| PLACEROUTE                | Runs the synthesis and place and route steps after design generation has completed                       |
| VERIFY_TIMING             | Runs the synthesis, place and route, and timing verification steps after design generation has completed |
| GENERATE_PROGRAMMING_DATA | Generates the files required to program a device, including the SPI flash image built from `hex/spiflash.cfg` and `Videokit.hex` |
| EXPORT_FPE                | Exports a FlashPro Express job file (`VIDEO_KIT_TOP.job`) to the local directory. Use together with `GENERATE_PROGRAMMING_DATA` |

### Linux OS: Build with Make

On Linux, after Steps 1 and 2, you can build the Mi-V application and run the Tcl script with one command. Ensure `libero` and `riscv64-unknown-elf-gcc` are in your `$PATH`:

```bash
make bitstream
```

This builds the Mi-V application, then runs Libero with the `SYNTHESIZE`, `GENERATE_PROGRAMMING_DATA`, and `EXPORT_FPE` arguments to create the Libero project and the `VIDEO_KIT_TOP.job` file.

---

## Programming the FPGA

After the script completes, you can further configure the design and run the Libero SoC design flow by double-clicking any stage in the design flow panel (left side of Libero). Selecting a stage that requires previous steps will automatically run the complete flow up to that point.

The fabric and the SPI flash are programmed in two separate steps. Ensure the J12 USB cable is connected and the board is powered on, then:

1. In the Design Flow window, double-click **Run PROGRAM Action** to program the FPGA fabric.
2. Double-click **Run PROGRAM_SPI_IMAGE Action** to program the SPI flash, and wait. This takes some time.
   - On Windows, you might be prompted with a firewall pop-up.
   - Ignore any warnings about misaligned sectors.
3. Power-cycle the board with `SW4`.

When you use these Libero actions, the device is programmed directly, eliminating the need for a separate job file.

---

## Next Steps

**If you programmed the device using Libero:**

Complete Steps 1, 2, and 4 in the [Getting Started Guide](./getting_started_guide.md), **skipping "Step 3: Program the Video Kit"** (your device is already programmed).

**If you plan to program the device with the .job file generated from Libero:**

1. Click "Export FlashPro Express Job" in Libero, or run the Tcl script with `GENERATE_PROGRAMMING_DATA+EXPORT_FPE`, to generate a job file
2. Complete all steps in the [Getting Started Guide](./getting_started_guide.md)
3. Use the generated job file from Libero in "Step 3: Program the Video Kit"
