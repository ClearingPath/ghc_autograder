#!/bin/bash

init	() {
	ulimit -n 2 * 1024 *1024;
	echo "Offline Autograder V.0.1.0 for Haskell"
	echo "Created by Jonathan Sudibya"
}

grade	() {
	filename="$1"
	input="$2"
	output="$3"
	score="$4"
	run_result=$(runghc $filename < $input)
	if [ "$run_result" = "$(cat $output)" ]
		then
		return $(cat $score)
	else
		return 0
	fi
}

grade_direct	() {
	filename="$1"
	input="$2"
	output="$3"
	score="$4"
	run_result=`timeout 3s ghci $filename < $input | grep -oP "\*Main>\s+\K(\w+|\-\w+)" | head -n 1`
	answer="$(echo -e "$(cat $output)" | tr -d '[[:space:]]')"
	if [ "$run_result" == "$answer" ]
		then
		return `echo -e "$(cat $score)" | tr -d '[[:space:]]'`
	else
		return 0
	fi
}

create_csv	() {
	csv_file="$1"
	column="name;"
	for tc_num in "$2"/*
	do
		column="$column$(basename $tc_num);"
	done
	column="$column""total;"
	echo "$column" > "$csv_file"
}

init
if [ $# -ne 2 ]
	then
		echo "[ Error ] Incorrect parameter !"
		echo "[ Notes ] Usage : $0 [tc_folder] [src_folder]"
		exit
fi
tc_folder="$1"
src_folder="$2"
csv_filename="$(basename "$src_folder")"".csv"
create_csv "$csv_filename" "$tc_folder"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for name in "$src_folder"/*
do
	q_no=0
	total_grade=0
	csv_write="$(basename $name);"
	for question in "$name"/*
	do
		q_no=$((q_no+1))
		locate_tc=`find "$tc_folder" -name "$q_no"`
		if [ "$locate_tc" != "" ]
			then
			grade_sum=0
			for file in `ls -1 "$question"/*.hs | tail -n 1`
			do
				num_tc=`ls "$locate_tc" | wc -l`
				num_tc=$((num_tc/3))
				for i in `seq 1 $num_tc`
				do
					grade_direct "$file" "$locate_tc"/"$i.in" "$locate_tc"/"$i.out" "$locate_tc"/"$i.score"
					nilai=$?
					grade_sum=$((grade_sum+$nilai))
				done
				echo "[ Log ] $(basename $name) $(basename $question) = $grade_sum"
			done
			total_grade=$((total_grade+$grade_sum))
			csv_write="$csv_write$grade_sum;"
		fi
	done
	csv_write="$csv_write$total_grade;"
	echo "$csv_write" >> "$csv_filename"
done
IFS=$SAVEIFS