# ARC310
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
>https://www.intel.com/content/www/us/en/products/sku/227958/intel-arc-a310-graphics/downloads.html
```
$ uname -r
```
```
$ wget -qO - https://repositories.intel.com/gpu/intel-graphics.key |   sudo gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
$ echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy client" |   sudo tee /etc/apt/sources.list.d/intel-gpu-jammy.list
$ sudo apt update
$ sudo apt install -y   intel-opencl-icd intel-level-zero-gpu level-zero   intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2   libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri   libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm12 libxatracker2 mesa-va-drivers   mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all vainfo hwinfo clinfo
$ sudo apt install -y   libigc-dev intel-igc-cm libigdfcl-dev libigfxcmrt-dev level-zero-dev
$ sudo apt update && sudo apt install  -y --install-suggests  linux-generic-hwe-22.04 \
```
```
$ uname -r
6.5.0-15-generic
```
