Sucirata
Tunnel
l2_acl


# l2acl
python test.py -i bench/opt/l2acl/prog.o -p ../warp-artifacts/use_cases/l2_acl/l2acl.pcap -e entries.json -r 100000000

python test.py -i bench/baseline/l2acl/prog.o -p ../warp-artifacts/use_cases/l2_acl/l2acl.pcap -e entries.json -r 100000000

# Tunnel

python test.py -i bench/opt/suricata/tunnel.o  -p ../warp-artifacts/use_cases/suricata/suricata.pcap -e suricata_entries.json -r 100000000

python test.py -i bench/ablation/suricata/tunnel_baseline.o -p ../warp-artifacts/use_cases/suricata/suricata.pcap -e suricata_entries.json -r 100000000



[
	{
		"comment": "ipv6|udp|no-vlan", 
		"map_id": 1, "key": "11 11 00 00 00 00 00 00 00 00 00 00 00 00 11 11 22 22 00 00 00 00 00 00 00 00 00 00 00 00 22 22 aa aa bb bb 00 00 00 00", 
 		"value": "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
 	},
 	{
		"comment": "ipv6|tcp|no-vlan", 
		"map_id": 1, "key": "11 11 00 00 00 00 00 00 00 00 00 00 00 00 11 11 22 22 00 00 00 00 00 00 00 00 00 00 00 00 22 22 aa aa bb bb 01 00 00 00", 
 		"value": "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
 	},
 	{
		"comment": "ipv4|udp|no-vlan", 
		"map_id": 0, "key": "01 01 01 01 02 02 02 02 aa aa bb bb 00 00 00 00", 
 		"value": "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
 	},
 	{
		"comment": "ipv4|tcp|no-vlan", 
		"map_id": 0, "key": "01 01 01 01 02 02 02 02 aa aa bb bb 01 00 00 00", 
 		"value": "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
 	}
]




100_000_000










Suricata has this:

226:       79 01 00 00 00 00 00 00 r1 = *(u64 *)(r0 + 0x0)
227:       07 01 00 00 01 00 00 00 r1 += 0x1
228:       7b 10 00 00 00 00 00 00 *(u64 *)(r0 + 0x0) = r1


Data alignment:
Suricata:
- Doing 32-bit loads
__builtin_memcpy
190:       61 61 10 00 00 00 00 00 w1 = *(u32 *)(r6 + 0x10)
191:       61 63 14 00 00 00 00 00 w3 = *(u32 *)(r6 + 0x14)              
192:       67 03 00 00 20 00 00 00 r3 <<= 0x20
193:       4f 13 00 00 00 00 00 00 r3 |= r1                           
<!-- 194:       69 61 2a 00 00 00 00 00 w1 = *(u16 *)(r6 + 0x2a) -->
<!-- 195:       69 62 28 00 00 00 00 00 w2 = *(u16 *)(r6 + 0x28) -->
196:       7b 3a e0 ff 00 00 00 00 *(u64 *)(r10 - 0x20) = r3 

This COULD instead be a single 64-bit read and write



Alignment working:

Suricata: xdp_hashfilter

Original:
6:       71 81 0c 00 00 00 00 00 w1 = *(u8 *)(r8 + 0xc)
7:       71 82 0d 00 00 00 00 00 w2 = *(u8 *)(r8 + 0xd)
8:       64 02 00 00 08 00 00 00 w2 <<= 0x8
9:       4c 12 00 00 00 00 00 00 w2 |= w1

New

6:       69 82 0c 00 00 00 00 00 w2 = *(u16 *)(r8 + 0xc) 


This reduces verifier load and results in better instruction selectios. Additionally, less memory access reduces load on the cache hierachy.


Suricata xdp_filter.bpf from 306 to 283 instructions


