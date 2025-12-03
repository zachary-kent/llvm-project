#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp_drop")
int xdp_drop_prog(struct xdp_md *ctx)
{
    ctx->data_meta = 120;
    return BPF_DROP;
}

char _license[] SEC("license") = "GPL";