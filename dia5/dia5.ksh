#!/bin/ksh93
# AoC 2k25, day 5 in KornShell 93.
# Question statement:
# "As the forklifts break through the wall, the Elves are
# delighted to discover that there was a cafeteria on the
# other side after all.
#
# You can hear a commotion coming from the kitchen. 'At
# this rate, we won't have any time left to put the
# wreaths up in the dining hall!'
# [...]
# The Elves in the kitchen explain the situation: because
# of their complicated new inventory management system,
# they can't figure out which of their ingredients are
# fresh and which are spoiled. When you ask how it works,
# they give you a copy of their database [...]
# The database operates on ingredient IDs. It consists
# of a list of fresh ingredient ID ranges, a blank line,
# and a list of available ingredient IDs.
# [...]
# The fresh ID ranges are inclusive: the range 3-5 means
# that ingredient IDs 3, 4, and 5 are all fresh. The
# ranges can also overlap; an ingredient ID is fresh if
# it is in any range.

function text_range_to_array_range {
	typeset -a range[2]
	r="$1"
	range[0]="${r%%-*}"
	range[1]="${r##*-}"
	print -C range
}

input="$1"
nranges=0
nids=0
IngredientIDSection=false
for ((;;)); do
	if read line; then
		if [[ "$line" == "" ]]; then
			IngredientIDSection=true
			continue
		fi
		if $IngredientIDSection; then
			eval ids[$nids]="$line"
			((nids+=1 ))
		else # Range section.
			# I could've done an algorithm for predicting
			# overlapping (ex.: (10, 14) and (16, 20) for
			# (12, 18)), but it would take some work that
			# I'm not willing to do right now and, since
			# we'll be deduplicating the ranges later at
			# a "hashmapoid", it shouldn't be a big
			# problem.
			eval ranges[$nranges]=$(text_range_to_array_range "$line")
			((nranges+=1 ))
		fi
	else
		break
	fi
done < "$input"

for ((j=0; j<${#ids[@]}; j++)); do
	for ((i=0; i < ${#ranges[@]}; i++)); do
		initialid="${ranges[i][0]}"
		lastid="${ranges[i][1]}"
		if (( ($initialid <= ${ids[j]}) && (${ids[j]} <= $lastid) )); then
			echo Fresco
		else
			echo Estragado
		fi
	done
done
