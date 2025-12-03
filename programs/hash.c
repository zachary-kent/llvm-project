#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int xdp_hash_example(struct xdp_md *ctx) {
    void *data = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;

    uint32_t hash = 0;

    for (unsigned char *ptr = data; ptr < data_end; ptr++) {
        hash ^= *ptr;
        hash *= 31;
    }

    if (data + 4 <= data_end) {
        *(uint32_t *)data = hash;
    }

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";