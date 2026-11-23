# Adding Additional Models

By default, the demo uses a predefined set of models listed in the `models[]` array in `softconsole/Videokit/main.c`. This document explains how to add a new model from the VectorBlox SDK tutorials.

The Non-SoC Video Kit does not have a file system. Each model is stored as a `.hex` file in the on-board SPI flash, and the Mi-V application copies it from a fixed SPI flash address to DDR memory at start-up. To add a model, make the following three changes:

1. Compile the model to a `.hex` file with the VectorBlox SDK.
2. Add the `.hex` file to the SPI flash configuration.
3. Add the model, with its SPI flash start address, to the `models[]` array in `main.c`.

The demo application provides post-processing routines for classification (`CLASSIFY`) and object detection (`OBJECT_DETECT`), which the default models use. To support other models, you must write or modify existing post-processing code as needed.

Adding a model requires building from source. Before you begin, complete the [Building with Libero Setup Guide](./building_with_libero.md) at least once.

## Table of Contents

- [Obtaining the Model File](#obtaining-the-model-file)
- [Option A: Add the Model with the Build Scripts (Recommended)](#option-a-add-the-model-with-the-build-scripts-recommended)
- [Option B: Add the Model in Libero](#option-b-add-the-model-in-libero)
- [The models\[\] Array](#the-models-array)

## Obtaining the Model File

To obtain the new model file, use the [VectorBlox SDK](https://github.com/Microchip-Vectorblox/VectorBlox-SDK) to compile the model into a VectorBlox-compatible binary file. For this guide, assume the new model is `yolov8n-cls`. Generate the model file using the tutorial at [VectorBlox-SDK/tree/master/tutorials/ultralytics/yolov8n-cls](https://github.com/Microchip-Vectorblox/VectorBlox-SDK/tree/master/tutorials/ultralytics/yolov8n-cls).

Running the tutorial generates `yolov8n-cls_V1000_ncomp.vnnx` and `yolov8n-cls_V1000_ncomp.hex`. **The Non-SoC Video Kit uses the `.hex` file.**

> **Important:** Before adding the model to the `hex/` directory, please remove `_V1000_ncomp` from the model name. This will avoid error messages from exceeding the character limit.  

---

## Option A: Add the Model with the Build Scripts (Recommended)

This option uses the same scripts that generate the default SPI flash configuration, so SPI flash addresses in `main.c` are calculated automatically. All paths are relative to the directory containing  `MPF_VIDEO_KIT_VECTORBLOX_DESIGN.tcl`.

1. Copy the model file into the `hex/` directory and give it a short name, for example, `hex/yolov8n-cls.hex`.

2. Add the file to the end of `HEX_FILES` in `Makefile`. Adding it to the end keeps the addresses of the existing files unchanged.

   ```make
   HEX_FILES:=ascii_characters.hex \
       mobilenet-v2.hex \
       yolov8n_512x288_argmax.hex \
       yolov8n-cls.hex
   ```


3. Add the model to the `hex_files` dictionary in `script_support/set_model_size.py`. The key is the display name you will use in `main.c`, and the value is the hex file path.

   ```python
   hex_files = {
           "MobileNet V2": 'hex/mobilenet-v2.hex',
           "Yolo V8n_argmax": 'hex/yolov8n_512x288_argmax.hex',
           "CHAR_SPI_OFFSET": 'hex/ascii_characters.hex',
           "Yolo v8n Classifier": 'hex/yolov8n-cls.hex',
   }
   ```

4. Add the model to the `models[]` array in `softconsole/Videokit/main.c`. Use `0x0` as a placeholder address; the script replaces it in the next step.

   ```c
   struct model_descr_t models[] = {
   {"MobileNet V2","",0x218a80, "CLASSIFY"},
   {"Yolo V8n_argmax","",0x8a15fc, "OBJECT_DETECT"},
   {"Yolo v8n Classifier","",0x0, "CLASSIFY"},
   };
   ```

5. Regenerate the SPI flash configuration. On Windows, run the commands shown in [Step 2 of the Building with Libero Setup Guide](./building_with_libero.md#step-2-generate-the-spi-flash-configuration) instead, and add `hex/yolov8n-cls.hex` to the end of the `gen_spi_cfg.py` file list.

   ```bash
   rm hex/spiflash.cfg
   make spi
   ```

   Verify that the `0x0` placeholder in `main.c` has been replaced with an address.

6. Rebuild the Mi-V application, regenerate the programming data, and program the board. Follow Steps 3 and 4 and the [Programming the FPGA](./building_with_libero.md#programming-the-fpga) section in the [Building with Libero Setup Guide](./building_with_libero.md). Reprogram both the FPGA fabric and the SPI flash.

> **Notes:**
>
> - The display name used as the key in `set_model_size.py` must appear on exactly one line in `main.c` containing a `0x` address. Avoid using a name that is part of another model’s name.
> - The SPI flash is 128 MB. The total size of all files must fit in the SPI flash.

---

## Option B: Add the Model in Libero

You can also add the model directly in Libero. Changes made this way are not saved to `hex/spiflash.cfg`, and they are replaced the next time the Tcl script is run with `GENERATE_PROGRAMMING_DATA`.

1. Open the Libero project and invoke the **Configure Design Initialization Data and Memories** tool in the Libero Design Flow.
2. To view all the SPI flash clients, click the **SPI Flash** tab at the top of the tool.
3. To add the new model, click **Add** and select **Add Data Storage Client**. Set the path to the model `.hex` file and assign a start address that does not overlap with other clients in flash memory. Record the start address.
4. Click **Apply**.
5. Add the model to the `models[]` array in `softconsole/Videokit/main.c`, using the start address from step 3. Rebuild the Mi-V application and update the Fabric RAM content, as described in [modifying_mi-v_software.md](./modifying_mi-v_software.md#option-b-store-the-application-in-the-spi-flash).
6. In the Design Flow window, double-click **Run PROGRAM_SPI_IMAGE Action**. Click **Yes** to ignore warnings about memory alignment.
7. After SPI programming is complete, power-cycle the board using `SW4`.

---

## The models[] Array

Below is the default `models[]` array in `softconsole/Videokit/main.c`. The addresses are written by `set_model_size.py` and may vary.

```c
struct model_descr_t models[] = {
{"MobileNet V2","",0x218a80, "CLASSIFY"},
{"Yolo V8n_argmax","",0x8a15fc, "OBJECT_DETECT"},
};
```

Each entry contains the following fields:

| Field | Example | Description |
| :---- | :------ | :---------- |
| Display name | `"MobileNet V2"` | Name shown in the on-screen model menu. Also used by `set_model_size.py` to find the line to update. |
| File name | `""` | Not used on the Non-SoC Video Kit; leave empty. |
| SPI flash address | `0x218a80` | Start address of the model in the SPI flash. Must match `hex/spiflash.cfg`. |
| Post-processing type | `"CLASSIFY"` | Post-processing routine used to display the network output. |

If you added the generated model file as `hex/yolov8n-cls.hex`, update the code as follows. The address of the new model is set by `set_model_size.py`.

```c
struct model_descr_t models[] = {
{"MobileNet V2","",0x218a80, "CLASSIFY"},
{"Yolo V8n_argmax","",0x8a15fc, "OBJECT_DETECT"},
{"Yolo v8n Classifier","",0x0, "CLASSIFY"},
};
```

After the network is loaded from SPI flash for the first time, it will not reload until the board is power-cycled.  