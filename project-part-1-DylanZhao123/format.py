"""To display a help message for this script, run python format.py -h"""

from argparse import ArgumentParser
from pathlib import Path

__author__ = "Jesse Wei <jesse@cs.unc.edu>"

parser: ArgumentParser = ArgumentParser(
    description="""Given a file with MIPS instructions exported from MARS in hex format, converts the file to an Intel hex format loadable in Digital's ROM component. Also, three 0's are inserted between each instruction so that instructions are only at addresses that are multiples of 4."""
)
parser.add_argument(
    "mars_hexfile",
    help="File that contains MIPS instructions exported from MARS in hex format. To export in the proper format, run java -jar Mars4_5.jar nc mc CompactTextAtZero a dump .text HexText output_file.hex input_file.asm (use your own path to Mars4_5.jar).",
)
parser.add_argument("output_file", help="Path to output file")
parser.add_argument(
    "--test",
    action="store_true",
    help="Convert the hexfile contents to a string like: program(0xdeadbeef, 0xdeadc0c0, ...). This string can be used in Digital's Test case component to load the ROM component with data.",
)
args = parser.parse_args()

hexfile: Path = Path(args.mars_hexfile)
hexfile_contents: str = hexfile.read_text().strip()
hexfile_contents_zeros_inserted: str = "\n0\n0\n0\n".join(hexfile_contents.split("\n"))

if not args.test:
    output: str = "v2.0 raw\n" + hexfile_contents_zeros_inserted + "\n"
else:
    instructions: list[str] = [
        f"0x{instruction}" if instruction != "0" else instruction
        for instruction in hexfile_contents_zeros_inserted.split("\n")
    ]
    instructions_comma_delimited: str = ", ".join(instructions)
    output: str = f"program({instructions_comma_delimited})\n"

Path(args.output_file).write_text(output)
