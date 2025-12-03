#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <bpf/bpf_helpers.h>

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1024);
    __type(key, __u32);
    __type(value, __u64);
} counter_map SEC(".maps");

SEC("xdp")
int xdp_hash_complex(struct xdp_md *ctx) {
    void *data = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;

    if (data + sizeof(struct ethhdr) > data_end)
        return XDP_PASS;

    struct ethhdr *eth = data;
    if (eth->h_proto != __constant_htons(ETH_P_IP))
        return XDP_PASS;

    struct iphdr *ip = data + sizeof(struct ethhdr);
    if ((void*)ip + sizeof(struct iphdr) > data_end)
        return XDP_PASS;

    __u32 key = ip->saddr ^ ip->daddr;
    key = (key << 5) | (key >> 27);
    key ^= key >> 3;
    key = key * 0x45d9f3b;

    __u64 *value = bpf_map_lookup_elem(&counter_map, &key);
    if (!value) {
        __u64 init_val = 1;
        bpf_map_update_elem(&counter_map, &key, &init_val, BPF_ANY);
    } else {
        __u64 new_val = *value + 1;
        bpf_map_update_elem(&counter_map, &key, &new_val, BPF_ANY);
    }

    __u64 tmp = 0;
    for (int i = 0; i < 4; i++) {
        tmp += *value;
        tmp ^= key >> i;
    }

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
