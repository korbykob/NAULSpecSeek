#define _GNU_SOURCE

#include <sched.h>
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <system/hardware/CPU/affinity.h>

/// @brief pins the thread to a defined cpu core using its APIC core ID
/// @param apic_core_id target CPU core APIC ID
/// @return success 0/1
int cpu_set_affinity(int apic_core_id){
    #if defined(__linux__)
    cpu_set_t set;
    CPU_ZERO(&set);
    CPU_SET(apic_core_id, &set);
    return sched_setaffinity(0, sizeof(set), &set);
    #endif

    return 1;
}
