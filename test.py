# /// script
# dependencies = [
#   "scapy",
# ]
# ///
import sys
import os
import subprocess
import argparse
import json
from scapy.all import Ether, IP, UDP, Raw, rdpcap

parser = argparse.ArgumentParser(
    description="CLI"
)

parser.add_argument("-i", dest="input",required=True)
parser.add_argument("-p", dest="pcap",required=True)
parser.add_argument("-r", dest="repeat",required=True)
parser.add_argument("-e", dest="entries",required=True)

args = parser.parse_args()

PROG_PATH = args.input
PCAP_PATH = args.pcap
REPEAT = int(args.repeat)
ENTRIES_PATH = args.entries


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

  perf_cmd = ["perf", "stat", "-e", "instructions,cycles", "--"] + run_cmd
  subprocess.run(perf_cmd)

def load_prog(prog_path, pin_path):
  print("LOADING PROGRAM")
  try:
    os.remove(pin_path)
  except OSError:
    pass
  cmd = [
    "bpftool", 
    "prog",
    "load",
    prog_path,
    pin_path,
  ]
  print(" ".join(cmd))
  subprocess.run(cmd)
  print("DONE LOADING PROGRAM")

PIN_PATH = "/sys/fs/bpf/xdp_bench_prog"

def initialize_maps(pin_path, initial_entries):
  # sudo bpftool prog show pinned /sys/fs/bpf/xdp_bench_prog --json --pretty
  cmd = [
    "bpftool",
    "prog",
    "show",
    "pinned",
    pin_path,
    "--json",
    "--pretty"
  ]
  print(" ".join(cmd))
  result = subprocess.run(cmd, capture_output=True, text=True, check=True)
  print(result)
  ids = dict()
  for id in json.loads(result.stdout)["map_ids"]:
    cmd = [
      "bpftool",
      "map",
      "show",
      "id",
      str(id),
      "--json"
    ]
    print(" ".join(cmd))
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    map_info = json.loads(result.stdout)
    name = map_info["name"]
    ids[name] = id
    # subprocess.run([
    #   "bpftool",
    #   "map",
    #   "pin",
    #   "id",
    #   id,
    #   f"{PIN_PATH}_{name}"
    # ])
  with open(initial_entries, 'r') as f:
    for name, entries in json.load(f).items():
        for entry in entries:
          cmd = [
            "bpftool",
            "map",
            "update",
            "id",
            str(ids[name]),
            "key",
            "hex",
            *entry["key"].split(),
            "value",
            "hex",
            *entry["value"].split()
          ]
      
          print(" ".join(cmd))

          result = subprocess.run(cmd)
        

PIN_PATH = "/sys/fs/bpf/xdp_bench_prog"
# PIN_PATH = "/home/otso/llvm-project/xdp_bench_prog"
# PROG_PATH = "build/bin/prog.o"


# PROG_PATH = "../warp-artifacts/use_cases/l2_acl/l2acl.o"
# PCAP_PATH = "../warp-artifacts/use_cases/l2_acl/l2acl.pcap"


os.makedirs(os.path.dirname(PIN_PATH), exist_ok=True)
load_prog(PROG_PATH, PIN_PATH)
initialize_maps(PIN_PATH, ENTRIES_PATH)

# profiling = run_profiling(PIN_PATH)

for i, pkt in enumerate(rdpcap(PCAP_PATH)):
  os.makedirs(os.path.dirname("./packets"), exist_ok=True)
  PACKET_FILE_NAME = f"./packets/packet{i}"
  data = bytes(pkt).hex()
  with open(PACKET_FILE_NAME, "w") as f:
    f.write(data)
  run_prog(PIN_PATH, PACKET_FILE_NAME)

# profiling.send_signal(sig=2)
# os.remove(PIN_PATH)
