# /// script
# dependencies = [
#   "scapy",
# ]
# ///
import sys
import os
import subprocess
import argparse
from scapy.all import Ether, IP, UDP, Raw


parser = argparse.ArgumentParser(
    description="CLI"
)

parser.add_argument("-i", dest="input",required=True)

args = parser.parse_args()

PROG_PATH = args.input

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

data = mk_packet(100)
SEC = "xdp"

REPEAT=2_000_000_000
REPEAT=9_000_000

def run_profiling(pin_path) -> subprocess.Popen:
    cmd = [
        "bpftool",
        "prog",
        "profile",
        "pinned",
        pin_path,
        "cycles",
        "instructions",
        "llc_misses",
    ]

    print("RUNNING PROFILING")
    print(" ".join(cmd))


    return subprocess.Popen(
        cmd,
    )

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

#   perf_cmd = ["perf", "stat", "-e", "instructions,cycles", "--"] + run_cmd
  subprocess.run(run_cmd)

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
  ])

  print("LOADED PROGRAM")

PIN_PATH = "/sys/fs/bpf/xdp_bench_prog"

os.makedirs(os.path.dirname(PIN_PATH), exist_ok=True)
load_prog(PROG_PATH, PIN_PATH)


PACKET_FILE_NAME = "packet.bin"
with open(PACKET_FILE_NAME,"w") as f:
  f.write(data)

profiling = run_profiling(PIN_PATH)
run_prog(PIN_PATH, PACKET_FILE_NAME)

profiling.send_signal(sig=2)
# os.remove(PIN_PATH)
