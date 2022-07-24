#include <utils/types.h>

using namespace simple_os::utils;

typedef void (*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;
extern "C" void callConstructors()
{
    for (constructor *i = &start_ctors; i != &end_ctors; i++)
        (*i)();
}

extern "C" void kernel_main(uint32_t multiBootInfoAddress, uint32_t magic)
{

}