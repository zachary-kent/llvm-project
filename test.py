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

REPEAT=1

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

  # perf_cmd = ["perf", "stat", "-e", "instructions,cycles", "--"] + run_cmd
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
    # "type",
    # "xdp",
    # "name",
    # "xdp_bench",
    # "sec",
    # SEC,
  ])
  print("DONE LOADING PROGRAM")

PIN_PATH = "/sys/fs/bpf/xdp_bench_prog"

def initialize_maps(pin_path, initial_entries):
  # sudo bpftool prog show pinned /sys/fs/bpf/xdp_bench_prog --json --pretty
  result = subprocess.run([
    "bpftool",
    "prog",
    "show",
    "pinned",
    pin_path,
    "--json",
    "--pretty"
  ], capture_output=True, text=True, check=True)
  ids = dict()
  for id in json.loads(result.stdout)["map_ids"]:
    result = subprocess.run([
      "bpftool",
      "map",
      "show",
      "id",
      str(id),
      "--json"
    ], capture_output=True, text=True, check=True)
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
          result = subprocess.run([
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

PCAP_PATH = "../warp-artifacts/use_cases/l2_acl/l2acl.pcap"
ENTRIES_PATH = "entries.json"

os.makedirs(os.path.dirname(PIN_PATH), exist_ok=True)
load_prog(PROG_PATH, PIN_PATH)
initialize_maps(PIN_PATH, ENTRIES_PATH)

for i, pkt in enumerate(rdpcap(PCAP_PATH)):
  os.makedirs(os.path.dirname("./packets"), exist_ok=True)
  PACKET_FILE_NAME = f"./packets/packet{i}"
  data = bytes(pkt).hex()
  with open(PACKET_FILE_NAME, "w") as f:
    f.write(data)
  run_prog(PIN_PATH, PACKET_FILE_NAME)
# os.remove(PIN_PATH)
