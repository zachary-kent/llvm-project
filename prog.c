#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>

#define BE_ETH_P_IP 8
#define BE_ETH_P_IPV6 56710

struct bpf_map_def {
      unsigned int type;
      unsigned int key_size;
      unsigned int value_size;
      unsigned int max_entries;
      unsigned int map_flags;
};

// struct bpf_map_def SEC("maps") map = {
//   .type = BPF_MAP_TYPE_HASH,
//   .key_size = 6,
//   .value_size = sizeof(__u32),
//   .max_entries = 256,
// };

struct {
	__uint(type, BPF_MAP_TYPE_HASH);
	__uint(max_entries, 256);
	__type(key, int);
	__type(value, int);
} map SEC(".maps");

SEC("xdp")
int toy_example(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    void *lookup_res = NULL; 
    __u32 proto, nh_off;
    struct ethhdr *eth = data;
    __u8 key[6] = {0};
    
    nh_off = sizeof(struct ethhdr);
    if (data + nh_off > data_end) {
        return XDP_DROP;
    }
    
    proto = eth->h_proto;
    if (proto == BE_ETH_P_IP) {
        __builtin_memcpy(key, eth->h_source, 6);
        lookup_res = bpf_map_lookup_elem(&map, &key);

        if (lookup_res) {
            return XDP_PASS;
        } else {
            return XDP_DROP;
        }
    } else if (proto == BE_ETH_P_IPV6) {
        return XDP_DROP;
    } else {
        return XDP_PASS;
    }

}

char _license[] SEC("license") = "GPL";