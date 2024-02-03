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
sudo docker pull intel/intel-extension-for-tensorflow:xpu
```

# 4. Run some test script
```
sudo docker run -it -p 8888:8888 --rm --device /dev/dri --name xpu -v /dev/dri/by-path:/dev/dri/by-path -v /home/vagrant:/mnt -e https_proxy="" -e http_proxy="" intel/intel-extension-for-tensorflow:xpu
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

# 5. Fine-Tuning
```
apt update
apt install openjdk-8-jdk-headless -qq -y
pip install pyspark pyarrow scikit-learn fastparquet transformers ipywidgets widgetsnbextension pandas-profiling matplotlib==3.7.3
```
```
git clone https://github.com/developer-onizuka/IntelGPUonWSL
cd IntelGPUonWSL
```
```
python3 amazon_reviews_parquet_small.py /mnt
```
```
python3 BERT-embedding-from-text_small.py /mnt
```
```
python3 Fine-Tuning_small_ARC.py /mnt
```
The Intel Extension for TensorFlow uses a device called “XPU” and selects it automatically if an Arc GPU is accessible. The TF output will contain something like:
```
2024-01-28 01:32:30.748607: I tensorflow/core/grappler/optimizers/custom_graph_optimizer_registry.cc:114] Plugin optimizer for device_type XPU is enabled.
Epoch 1/128
32/32 [==============================] - 111s 3s/step - loss: 1.6260 - accuracy: 0.2539 - val_loss: 1.5417 - val_accuracy: 0.3008
Epoch 2/128
32/32 [==============================] - 95s 3s/step - loss: 1.5453 - accuracy: 0.3047 - val_loss: 1.4596 - val_accuracy: 0.3789
Epoch 3/128
32/32 [==============================] - 102s 3s/step - loss: 1.4813 - accuracy: 0.3242 - val_loss: 1.4418 - val_accuracy: 0.4062
Epoch 4/128
32/32 [==============================] - 105s 3s/step - loss: 1.3898 - accuracy: 0.3789 - val_loss: 1.3872 - val_accuracy: 0.4414
```

# 6. Test the trained model

# (1) CPU
```
$ python3 load_model_small_ARC_sameSample.py /mnt | tee cpu.log
---
cat cpu.log |grep "ms/step" |awk '{print $9}' |sed 's/ms\/step//g' > tmp.txt
x=0;i=0;for i in $(cat tmp.txt);do x=$(($x+$i));done
echo "avg: "$(($x/$(wc -l tmp.txt|awk '{print $1}')))"ms"
avg: 477ms
```
# (2) XPU (implicitly FP32)
```
$ python3 load_model_small_ARC_sameSample.py /mnt xpu | tee xpu.log
---
cat xpu.log |grep "ms/step" |awk '{print $9}' |sed 's/ms\/step//g' > tmp.txt
x=0;i=0;for i in $(cat tmp.txt);do x=$(($x+$i));done
echo "avg: "$(($x/$(wc -l tmp.txt|awk '{print $1}')))"ms"
avg: 155ms
```
# (3) XPU with BF16
```
$ python3 load_model_small_ARC_sameSample.py /mnt bf16 | tee bf16.log
---
cat bf16.log |grep "ms/step" |awk '{print $9}' |sed 's/ms\/step//g' > tmp.txt
x=0;i=0;for i in $(cat tmp.txt);do x=$(($x+$i));done
echo "avg: "$(($x/$(wc -l tmp.txt|awk '{print $1}')))"ms"
avg: 169ms
```
# (4) XPU with FP16
```
$ python3 load_model_small_ARC_sameSample.py /mnt fp16 | tee fp16.log
---
cat fp16.log |grep "ms/step" |awk '{print $9}' |sed 's/ms\/step//g' > tmp.txt
x=0;i=0;for i in $(cat tmp.txt);do x=$(($x+$i));done
echo "avg: "$(($x/$(wc -l tmp.txt|awk '{print $1}')))"ms"
avg: 164ms
```
```
root@d82fd0e75162:/IntelGPUonWSL# tail -n 12 cpu.log 
     1   2   3   4    5
1  134  29  20   5   12
2   63  64  50   9   14
3   35  38  74  25   28
4    9  14  40  63   74
5    8   2  14  20  156
       1      2     3      4     5
1  0.670  0.145  0.10  0.025  0.06
2  0.315  0.320  0.25  0.045  0.07
3  0.175  0.190  0.37  0.125  0.14
4  0.045  0.070  0.20  0.315  0.37
5  0.040  0.010  0.07  0.100  0.78

root@d82fd0e75162:/IntelGPUonWSL# tail -n 12 xpu.log 
     1   2   3   4    5
1  134  29  20   5   12
2   63  64  50   9   14
3   35  38  74  25   28
4    9  14  40  63   74
5    8   2  14  20  156
       1      2     3      4     5
1  0.670  0.145  0.10  0.025  0.06
2  0.315  0.320  0.25  0.045  0.07
3  0.175  0.190  0.37  0.125  0.14
4  0.045  0.070  0.20  0.315  0.37
5  0.040  0.010  0.07  0.100  0.78

root@d82fd0e75162:/IntelGPUonWSL# tail -n 12 bf16.log 
     1   2   3   4    5
1  135  28  20   5   12
2   63  64  50   9   14
3   34  40  72  25   29
4   10  13  39  64   74
5    8   2  14  20  156
       1      2      3      4      5
1  0.675  0.140  0.100  0.025  0.060
2  0.315  0.320  0.250  0.045  0.070
3  0.170  0.200  0.360  0.125  0.145
4  0.050  0.065  0.195  0.320  0.370
5  0.040  0.010  0.070  0.100  0.780

root@d82fd0e75162:/IntelGPUonWSL# tail -n 12 fp16.log
     1   2   3   4    5
1  134  29  20   5   12
2   63  64  50   9   14
3   35  38  74  25   28
4    9  14  40  63   74
5    8   2  14  20  156
       1      2     3      4     5
1  0.670  0.145  0.10  0.025  0.06
2  0.315  0.320  0.25  0.045  0.07
3  0.175  0.190  0.37  0.125  0.14
4  0.045  0.070  0.20  0.315  0.37
5  0.040  0.010  0.07  0.100  0.78
```

# 7. intel-gpu-tools for monitoring
```
apt install intel-gpu-tools
```

# Appendix 1. Speed up Inference of Inception v4 by Advanced Automatic Mixed Precision on Intel CPU and GPU via Docker Container
> https://intel.github.io/intel-extension-for-tensorflow/v2.13.0.0/examples/infer_inception_v4_amp/README.html

```
root@d82fd0e75162:/# git clone https://github.com/intel/intel-extension-for-tensorflow
root@d82fd0e75162:/# cd examples/infer_inception_v4_amp
root@d82fd0e75162:/# ./set_env_gpu.sh
root@d82fd0e75162:/# wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/inceptionv4_fp32_pretrained_model.pb
root@d82fd0e75162:/# python3 infer_fp32_vs_amp.py gpu fp16
...
Benchmark is done!

Model                           FP32                    FP16                    
Latency (s)                     0.02352728843688965     0.014947474002838135    
Throughputs (FPS) BS=128        74.3650018675194        343.66051824112714      

Model                           FP32                    FP16                    
Latency Normalized              1                       0.6353249777565195      
Throughputs Normalized          1                       4.621266854176315       
Finished

root@d82fd0e75162:/# python3 infer_fp32_vs_amp.py gpu bf16
...
Benchmark is done!

Model                           FP32                    BF16                    
Latency (s)                     0.023784714937210082    0.014566195011138917    
Throughputs (FPS) BS=128        73.9774514391001        345.3883354868735       

Model                           FP32                    BF16                    
Latency Normalized              1                       0.6124183135931043      
Throughputs Normalized          1                       4.668832580305972       
Finished
```


# Appendix 2. env_check.sh
```
vagrant@arc310:~$ sudo docker run -it -p 8888:8888 --rm --device /dev/dri --name xpu -v /dev/dri/by-path:/dev/dri/by-path -v /home/vagrant:/mnt -e https_proxy="" -e http_proxy="" intel/intel-extension-for-tensorflow:xpu
root@92b867ae96ab:/# export path_to_site_packages=`python -c "import site; print(site.getsitepackages()[0])"`
root@92b867ae96ab:/# echo $path_to_site_packages
/usr/local/lib/python3.10/dist-packages
root@92b867ae96ab:/# bash ${path_to_site_packages}/intel_extension_for_tensorflow/tools/env_check.sh

    Check Environment for Intel(R) Extension for TensorFlow*...


========================  Check Python  ========================

 python3.10 is installed. 

====================  Check Python Passed  =====================


==========================  Check OS  ==========================

 OS ubuntu:22.04 is Supported. 

======================  Check OS Passed  =======================


======================  Check Tensorflow  ======================

 Tensorflow2.14 is installed. 

==================  Check Tensorflow Passed  ===================


===================  Check Intel GPU Driver  ===================

 Intel(R) graphics runtime intel-level-zero-gpu-1.3.26918.50-736 is installed, but is not recommended . 
 Intel(R) graphics runtime intel-opencl-icd-23.30.26918.50-736 is installed, but is not recommended . 
 Intel(R) graphics runtime level-zero-1.13.1-719 is installed, but is not recommended . 
 Intel(R) graphics runtime libigc1-1.0.14828.26-736 is installed, but is not recommended . 
 Intel(R) graphics runtime libigdfcl1-1.0.14828.26-736 is installed, but is not recommended . 
 Intel(R) graphics runtime libigdgmm12-22.3.10-712 is installed, but is not recommended . 

===============  Check Intel GPU Driver Finshed  ================


=====================  Check Intel oneAPI  =====================

 Intel(R) oneAPI DPC++/C++ Compiler is installed. 
 Intel(R) oneAPI Math Kernel Library is installed. 

=================  Check Intel oneAPI Passed  ==================


==========================  Check Devices Availability  ==========================

2024-01-28 04:52:28.302733: I tensorflow/tsl/cuda/cudart_stub.cc:28] Could not find cuda drivers on your machine, GPU will not be used.
2024-01-28 04:52:28.339525: E tensorflow/compiler/xla/stream_executor/cuda/cuda_dnn.cc:9342] Unable to register cuDNN factory: Attempting to register factory for plugin cuDNN when one has already been registered
2024-01-28 04:52:28.339718: E tensorflow/compiler/xla/stream_executor/cuda/cuda_fft.cc:609] Unable to register cuFFT factory: Attempting to register factory for plugin cuFFT when one has already been registered
2024-01-28 04:52:28.339966: E tensorflow/compiler/xla/stream_executor/cuda/cuda_blas.cc:1518] Unable to register cuBLAS factory: Attempting to register factory for plugin cuBLAS when one has already been registered
2024-01-28 04:52:28.348205: I tensorflow/tsl/cuda/cudart_stub.cc:28] Could not find cuda drivers on your machine, GPU will not be used.
2024-01-28 04:52:28.348778: I tensorflow/core/platform/cpu_feature_guard.cc:182] This TensorFlow binary is optimized to use available CPU instructions in performance-critical operations.
To enable the following instructions: AVX2 FMA, in other operations, rebuild TensorFlow with the appropriate compiler flags.
2024-01-28 04:52:29.190213: W tensorflow/compiler/tf2tensorrt/utils/py_utils.cc:38] TF-TRT Warning: Could not find TensorRT
2024-01-28 04:52:30.045905: I itex/core/wrapper/itex_gpu_wrapper.cc:35] Intel Extension for Tensorflow* GPU backend is loaded.
2024-01-28 04:52:30.098070: I itex/core/wrapper/itex_cpu_wrapper.cc:70] Intel Extension for Tensorflow* AVX2 CPU backend is loaded.
2024-01-28 04:52:30.175371: I itex/core/devices/gpu/itex_gpu_runtime.cc:129] Selected platform: Intel(R) Level-Zero
2024-01-28 04:52:30.175480: I itex/core/devices/gpu/itex_gpu_runtime.cc:154] number of sub-devices is zero, expose root device.

======================  Check Devices Availability Passed  =======================

```
