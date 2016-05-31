#!/bin/bash
set -e
set -u

function get_row_for {
  if [ $1 -lt 6 ]; then
    echo $1
  else
    echo "12 - $1" | bc
  fi
}

function get_column_for {
  # This was fun to figure out
  # Next time, I'll try some sort of circle approximation
  if [[ $1 -lt 6 ]]; then
    if [[ $1 -lt 3 ]]; then
      echo "7 + (2 * ($1 % 4))" | bc
    else
      echo "7 + (2 * ((6 - $1) % 4))" | bc
    fi
  else
    if [[ $1 -gt 9 ]]; then
      echo "7 - (2 * ((12 - $1) % 4))" | bc
    else
      echo "7 - (2 * (($1 - 6) % 4))" | bc
    fi
  fi
}

function print_clock {
  for i in "${!line[@]}"; do
     echo "${line[$i]}"
  done
}

line=()
line[0]="      o      "
line[1]="    o   o    "
line[2]="  o       o  "
line[3]="o           o"
line[4]="  o       o  "
line[5]="    o   o    "
line[6]="      o      "

hours=${1:-`date +%H`}
minutes=${2:-`date +%M`} #There is a bug here, can you see it?
echo $hours:$minutes

hour_hand=`echo $hours % 12 | bc`
hour_column=`get_column_for $hour_hand`
hour_row=`get_row_for $hour_hand`
line[$hour_row]=`echo "${line[$hour_row]}" | sed "s|.|h|$hour_column"`

minute_hand=`echo $minutes / 5 | bc`
minute_column=`get_column_for $minute_hand`
minute_row=`get_row_for $minute_hand`

minute_symbol=m
if [[ "`echo "${line[minute_row]}" | head -c $minute_column | tail -c 1`" == "h" ]]; then
  minute_symbol=x
fi
line[$minute_row]=`echo "${line[$minute_row]}" | sed "s|.|$minute_symbol|$minute_column"`

print_clock
