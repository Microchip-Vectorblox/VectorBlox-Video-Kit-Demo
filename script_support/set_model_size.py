import argparse
import re

hex_files = {
        "SCRFD": 'hex/scrfd_500m_bnkps.hex',
        "ArcFace": 'hex/mobilefacenet-arcface.hex',
        "GenderAge": 'hex/genderage.hex',
        "MobileNet V2": 'hex/mobilenet-v2.hex',
        "LPD": 'hex/lpd_eu_v42.hex',
        "LPR": 'hex/lpr_eu_v3.hex',
        "Yolo V5 Nano": 'hex/ultralytics.yolov5n.relu.hex',
        "Tiny Yolo V4 COCO": 'hex/yolo-v4-tiny-tf.hex',
        "CHAR_SPI_OFFSET": 'hex/ascii_characters.hex',
        "firmware_flash_offset": 'hex/firmware.hex',
}


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('config')
    parser.add_argument('code')
    args = parser.parse_args()

    with open(args.config) as f:
        config = f.readlines()

    sizes = {}
    for key in hex_files:
        lines = [l for l, line in enumerate(config) if hex_files[key] in line]
        assert(len(lines) == 1)
        line = lines[0] + 1
        size = config[line].strip().split('start_address')[-1].split()[0]
        sizes[key] = hex(int(size))

    correct_lines = []
    with open(args.code, 'r') as f:
        for line in f.readlines():
            for key in sizes:
                if key in line and '0x' in line and not 'printf' in line:
                    split = re.split(r"0x\w+",line)
                    assert(len(split) == 2)
                    line = ''.join([split[0], sizes[key], split[1]])
                    break

            correct_lines.append(line)

    with open(args.code, 'w') as f:
        f.writelines(correct_lines)
