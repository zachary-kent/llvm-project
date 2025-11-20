# /// script
# dependencies = [
#   "scapy",
# ]
# ///
import os
import subprocess
import argparse
from scapy.all import Ether, IP, UDP, Raw

src_mac = "00:11:22:33:44:55"
dst_mac = "aa:bb:cc:dd:ee:ff"

src_ip = "10.0.0.1"
dst_ip = "10.0.0.2"

src_port = 1234
dst_port = 5678

def mk_packet(len):
  pkt = (
      Ether(src=src_mac, dst=dst_mac)
      / IP(src=src_ip, dst=dst_ip)
      / UDP(sport=src_port, dport=dst_port)
      / Raw(b"\x00" * len)
  )
  return bytes(pkt).hex()

SEC = "xdp"

REPEAT=1_000_000_000

def run_prog(pin_path, pkt, repeat=REPEAT):
  print("RUNNING PROGRAM")
  # Run the already pinned program
  run_cmd = [
    "bpftool",
    "prog",
    "run",
    "pinned",
    pin_path,
    "data_in",
    pkt,
    "repeat",
    str(repeat)
  ]

  perf_cmd = ["perf", "stat", "-e", "instructions,cycles", "--"] + run_cmd
  subprocess.run(perf_cmd)

def load_prog(prog_path, pin_path):
  print("LOADING PROGRAM")
  try:
    os.remove(pin_path)
  except OSError:
    pass
  subprocess.run([
    "bpftool", 
    "prog",
    "load",
    prog_path,
    pin_path,
    # "type",
    # "xdp",
    # "name",
    # "xdp_bench",
    # "sec",
    # SEC,
  ])

PIN_PATH = "/sys/fs/bpf/xdp_bench_prog"
# PIN_PATH = "/home/otso/llvm-project/xdp_bench_prog"
# PROG_PATH = "build/bin/prog.o"

parser = argparse.ArgumentParser(
    description="CLI"
)

parser.add_argument("-i", dest="input",required=True)

args = parser.parse_args()

PROG_PATH = args.input

os.makedirs(os.path.dirname(PIN_PATH), exist_ok=True)
load_prog(PROG_PATH, PIN_PATH)


PACKET_FILE_NAME = "packet.bin"
data = mk_packet(100)
with open(PACKET_FILE_NAME,"w") as f:
  f.write(data)

run_prog(PIN_PATH, PACKET_FILE_NAME)
# os.remove(PIN_PATH)
