import argparse
import os
import tempfile
import subprocess


header_template="""\
set_auto_update_mode 0
set_spi_flash_memory_size 134217728
set_client \\
	 -client_name    INIT_STAGE_3_SPI_CLIENT \\
	 -client_type    INIT \\
	 -content_type   MEMORY_FILE \\
	 -content_file   designer/VIDEO_KIT_TOP/VIDEO_KIT_TOP_uic.bin \\
	 -start_address  {start} \\
	 -client_size    {size} \\
	 -program        1
"""

client_template="""\
set_client \\
	 -client_name    {name} \\
	 -client_type    FILE_DATA_STORAGE_INTELHEX \\
	 -content_type   MEMORY_FILE \\
	 -content_file   {path} \\
	 -start_address  {start_address} \\
	 -client_size    {client_size} \\
	 -program        1
"""

def get_hex_size(hex_file):
    output=subprocess.check_output(['size','-d',hex_file]).decode()
    return int(output.split('\n')[1].split()[1])

def generate_client(file_name,dir_name,start_addr):
    client_size=get_hex_size(file_name)
    name = os.path.splitext(os.path.basename(file_name))[0]
    fname = os.path.join(dir_name, os.path.basename(file_name))
    client_string = client_template.format(name=name,
                                           client_size = client_size,
                                           path=fname,
                                           start_address=start_addr)
    return client_string,client_size
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--output", default='spiflash.cfg')
    parser.add_argument("-d", "--dir", default='hex')
    parser.add_argument("-s", "--size",type=int, default=512000)
    parser.add_argument("hex_files",nargs='*')
    args = parser.parse_args()
    out_string = ""
    size=args.size
    init_size = args.size 
    path = 'VKPF_VECTORBLOX/designer/VIDEO_KIT_TOP/VIDEO_KIT_TOP_uic.bin'
    if os.path.isfile(path):
        init_size = int(subprocess.check_output(['stat', '-c %s','VKPF_VECTORBLOX/designer/VIDEO_KIT_TOP/VIDEO_KIT_TOP_uic.bin']).decode())
        if init_size<args.size:
            init_size = args.size
        print(int(init_size))
    start_address = 1024+init_size
    for f in args.hex_files:
        client_string,size=generate_client(f, args.dir, start_address)
        start_address+=size
        out_string+=(client_string)
    
    
    with open(args.output,"w") as of:
        of.write(header_template.format(start=1024, size=init_size))
        of.write(out_string)
