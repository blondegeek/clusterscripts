for i in $(seq $1 $2); do grep "band $i" -A2 PROCAR | head -n 3 >> procarsummary; grep "band $i" -A51 PROCAR | head -n 52 | tail -n 1 >> procarsummary; done
