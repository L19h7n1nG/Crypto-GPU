#include <helper_cuda.h>
#include <cstdint>
#include <device_context.cuh>

namespace ntt {

struct NttConfig {
    device_context::DeviceContext ctx;

    bool are_inputs_on_device;
    bool are_outputs_on_device;
    bool is_async;

    static NttConfig default_ntt_config() {
        auto ctx = device_context::get_default_device_context();
        return NttConfig{ctx, false, false, false};
    }
};

} // namespace ntt