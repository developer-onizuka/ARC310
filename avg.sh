cat cpu.log |grep "ms/step" |awk '{print $9}' |sed 's/ms\/step//g' > tmp.txt
x=0;i=0;for i in $(cat tmp.txt);do x=$(($x+$i));done
echo "avg: "$(($x/$(wc -l tmp.txt|awk '{print $1}')))"ms"

cat xpu.log |grep "ms/step" |awk '{print $9}' |sed 's/ms\/step//g' > tmp.txt
x=0;i=0;for i in $(cat tmp.txt);do x=$(($x+$i));done
echo "avg: "$(($x/$(wc -l tmp.txt|awk '{print $1}')))"ms"

cat bf16.log |grep "ms/step" |awk '{print $9}' |sed 's/ms\/step//g' > tmp.txt
x=0;i=0;for i in $(cat tmp.txt);do x=$(($x+$i));done
echo "avg: "$(($x/$(wc -l tmp.txt|awk '{print $1}')))"ms"
