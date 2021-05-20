## ARM

```
$ sudo ethtool -l p0
Channel parameters for p0:
Pre-set maximums:
RX:             0
TX:             0
Other:          512
Combined:       8
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       8

$ sudo ethtool -l p1
Channel parameters for p1:
Pre-set maximums:
RX:             0
TX:             0
Other:          512
Combined:       8
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       8
```

```
$ ip route |wc -l
65031
```

```
$ lscpu
Architecture:                    aarch64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
CPU(s):                          8
On-line CPU(s) list:             0-7
Thread(s) per core:              1
Core(s) per socket:              8
Socket(s):                       1
NUMA node(s):                    1
Vendor ID:                       ARM
Model:                           0
Model name:                      Cortex-A72
Stepping:                        r1p0
BogoMIPS:                        400.00
L1d cache:                       256 KiB
L1i cache:                       384 KiB
L2 cache:                        4 MiB
L3 cache:                        6 MiB
NUMA node0 CPU(s):               0-7
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Spec store bypass: Not affected
Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
Vulnerability Spectre v2:        Not affected
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected
Flags:                           fp asimd evtstrm crc32 cpuid
```

## Intel/AMD

```
~$ ethtool -l enp6s0f0np0
Channel parameters for enp6s0f0np0:
Pre-set maximums:
RX:             0
TX:             0
Other:          0
Combined:       8
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       8

$ ethtool -l enp6s0f1np1
Channel parameters for enp6s0f1np1:
Pre-set maximums:
RX:             0
TX:             0
Other:          0
Combined:       8
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       8
```

```
$ ip route |wc -l
65031
```

```
~$ lscpu
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   48 bits physical, 48 bits virtual
CPU(s):                          8
On-line CPU(s) list:             0-7
Thread(s) per core:              1
Core(s) per socket:              8
Socket(s):                       1
NUMA node(s):                    1
Vendor ID:                       AuthenticAMD
CPU family:                      23
Model:                           1
Model name:                      AMD EPYC 3251 8-Core Processor
Stepping:                        2
Frequency boost:                 disabled
CPU MHz:                         1196.481
CPU max MHz:                     2500.0000
CPU min MHz:                     1200.0000
BogoMIPS:                        4999.69
Virtualization:                  AMD-V
L1d cache:                       256 KiB
L1i cache:                       512 KiB
L2 cache:                        4 MiB
L3 cache:                        16 MiB
NUMA node0 CPU(s):               0-7
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl and seccomp
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:        Mitigation; Full AMD retpoline, IBPB conditional, STIBP disabled, RSB filling
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf pni pclmulqdq monitor ss
                                 se3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb hw_pstate ssb
                                 d ibpb vmmcall fsgsbase bmi1 avx2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold 
                                 avic v_vmsave_vmload vgif overflow_recov succor smca
```
