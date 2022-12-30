#!/bin/sh

echo "Most popular pair of heroes"
cut -f 1,2 hero-network.csv | awk -F '","' '{a[$1][$2]++} END {for (i in a) for (j in a[i]) print i"-"j"-"a[i][j]}' |  tr -d '"' | awk -F '-' '{if($1 != $2) print $0}' | sort -k3 -nr -t- | head -n 100 > input.txt

# this part is for summing rows that have inverted values. Eventually we will get duplicate rows but sorted correct values. At the end we just pick
# the first 
while read p; 
do
  IFS='-' read -r -a array <<< "$p"
  hero1="${array[0]}"
  hero2="${array[1]}"
  app="${array[2]}"
  awk -F '-' -v hero1="$hero1" -v hero2="$hero2" -v app="$app" '{if($1==hero2 && $2==hero1){app+=$3}} END{print hero1, hero2, app}' input.txt

done <input.txt | head -n 1


printf "\nNumber of comics per hero"
cut -d, -f 1 edges.csv | sort | uniq -c | sort -nr | head -n 5

printf "\nAverage heroes per comic"
cut -d, -f 1,2 edges.csv | awk -F, '{arr[$2]++} END {for (a in arr){total += arr[a]; print a, total/length(arr)}}'
