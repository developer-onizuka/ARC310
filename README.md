# ARC310

# 1. Direct Path through for Intel ARC A310
```
$ cat /etc/default/grub |grep GRUB_CMDLINE
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on vfio_iommu_type1.allow_unsafe_interrupts=1 iommu=pt vfio-pci.ids=8086:56a6,8086:4f92"
```
```
$ dmesg |grep -i vfio
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.15.0-92-generic root=UUID=42d21df6-ae41-42b0-b9d6-9c173055ce2c ro quiet splash intel_iommu=on vfio_iommu_type1.allow_unsafe_interrupts=1 iommu=pt vfio-pci.ids=8086:56a6,8086:4f92
[    0.056298] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-5.15.0-92-generic root=UUID=42d21df6-ae41-42b0-b9d6-9c173055ce2c ro quiet splash intel_iommu=on vfio_iommu_type1.allow_unsafe_interrupts=1 iommu=pt vfio-pci.ids=8086:56a6,8086:4f92
[    0.446551] VFIO - User Level meta-driver version: 0.3
[    0.446634] vfio-pci 0000:03:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none
[    0.464498] vfio_pci: add [8086:56a6[ffffffff:ffffffff]] class 0x000000/00000000
[    0.484461] vfio_pci: add [8086:4f92[ffffffff:ffffffff]] class 0x000000/00000000
[    1.617502] vfio-pci 0000:03:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none
```
```
$ lspci -nnk -d 8086:56a6
03:00.0 VGA compatible controller [0300]: Intel Corporation Device [8086:56a6] (rev 05)
	Subsystem: Device [172f:4019]
	Kernel driver in use: vfio-pci

$ lspci -nnk -d 8086:4f92
04:00.0 Audio device [0403]: Intel Corporation Device [8086:4f92]
	Subsystem: Device [172f:4019]
	Kernel driver in use: vfio-pci
	Kernel modules: snd_hda_intel
```

# 2. i915 driver
You don't need any installation if you use Ubuntu 23.04. So as you can see my Vagrantfile in this repo, I use the "generic/ubuntu2304". See also below: <br>
>https://www.intel.com/content/www/us/en/products/sku/227958/intel-arc-a310-graphics/downloads.html

# 3. Pull intel-extension-for-tensorflow (itex) for GPU 
```
sudo docker pull intel/intel-extension-for-tensorflow:gpu
```

# 4. Run some test script
```
sudo docker run -it -p 8888:8888 --rm --device /dev/dri -v /dev/dri/by-path:/dev/dri/by-path -v /home/vagrant:/mnt intel/intel-extension-for-tensorflow:gpu
```
The ITEX plugin is automatically discovered during the importing of the TensorFlow package. If an Intel GPU is present, it is automatically set to the default device (using the Intel® oneAPI Level Zero layer) as shown in the output messages above. <br>
>https://www.isus.jp/wp-content/uploads/pdf/TheParallelUniverse_Issue_54_02.pdf
```
# python test.py 
2024-01-27 13:55:10.137018: I tensorflow/tsl/cuda/cudart_stub.cc:28] Could not find cuda drivers on your machine, GPU will not be used.
2024-01-27 13:55:10.183170: I tensorflow/tsl/cuda/cudart_stub.cc:28] Could not find cuda drivers on your machine, GPU will not be used.
2024-01-27 13:55:10.183849: I tensorflow/core/platform/cpu_feature_guard.cc:182] This TensorFlow binary is optimized to use available CPU instructions in performance-critical operations.
To enable the following instructions: AVX2 FMA, in other operations, rebuild TensorFlow with the appropriate compiler flags.
2024-01-27 13:55:10.797231: W tensorflow/compiler/tf2tensorrt/utils/py_utils.cc:38] TF-TRT Warning: Could not find TensorRT
2024-01-27 13:55:11.756946: I itex/core/devices/gpu/itex_gpu_runtime.cc:129] Selected platform: Intel(R) Level-Zero
2024-01-27 13:55:11.757001: I itex/core/devices/gpu/itex_gpu_runtime.cc:154] number of sub-devices is zero, expose root device.
2024-01-27 13:55:12.004395: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:306] Could not identify NUMA node of platform XPU ID 0, defaulting to 0. Your kernel may not have been built with NUMA support.
2024-01-27 13:55:12.004455: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:272] Created TensorFlow device (/job:localhost/replica:0/task:0/device:XPU:0 with 0 MB memory) -> physical PluggableDevice (device: 0, name: XPU, pci bus id: <undefined>)
tf.Tensor(
[[[[2.4288254  1.6071651  4.160842  ]
   [2.3239868  1.9569926  4.1524506 ]
   [1.3343697  1.9060627  3.3896272 ]
   [1.7925851  1.2400331  3.2897902 ]
   [0.9840651  1.0225242  2.5739768 ]]

  [[2.8291523  2.1308055  4.6921287 ]
   [2.4214551  1.4522581  4.077746  ]
   [2.4531744  1.0858644  3.2898579 ]
   [1.73563    1.5694746  3.4352214 ]
   [0.83082247 1.113043   2.470703  ]]

  [[2.2082546  1.8807235  4.0792527 ]
   [2.8148086  1.7728728  4.2751637 ]
   [2.5970109  1.467006   3.7412815 ]
   [2.2978141  1.3321489  3.517546  ]
   [1.0182698  0.80626297 2.35744   ]]

  [[2.4049745  1.6391747  3.8093147 ]
   [2.4278307  1.7987546  4.1346793 ]
   [1.9272163  1.8471761  3.4685442 ]
   [2.1061587  1.5528398  3.5838213 ]
   [0.8827013  0.8944724  2.6237857 ]]

  [[0.6540353  1.5484432  2.3842103 ]
   [0.92551357 1.7745185  2.6447213 ]
   [0.96523017 0.80884    1.9552104 ]
   [0.80397767 0.8604274  2.0334346 ]
   [0.2765956  0.9734486  1.795816  ]]]], shape=(1, 5, 5, 3), dtype=float32)
Finished
```
