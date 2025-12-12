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
#
# taks note: Compile this with shcomp, the mathematical
# operations will be somewhat faster.

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
			cruderanges[$nranges]="$line"
			((nranges+=1 ))
		fi
	else
		break
	fi
done < "$input"

# Sort numerically and then parse the
# ranges to a compound variable.
(for ((i=0; i < $nranges; i++)); do
	echo "${cruderanges[$i]}"
done | sort -n) |
for ((nranges=0; ; nranges++)); do
	if read line; then
		eval ranges[$nranges]=$(text_range_to_array_range "$line")
		if (( nranges == 0 )); then
			continue
		fi
		if ((  ${ranges[$nranges][0]} <= ${ranges[$((nranges - 1))][1]} )); then
			# Check for the actual largest
			# last value on the range.
			((newmax=${ranges[$nranges][1]}))
			if ((newmax < ${ranges[$((nranges - 1))][1]})); then
				((newmax=${ranges[$((nranges - 1))][1]}))
			fi
			# Replace the value and walk back past one.
			((ranges[$((nranges - 1))][1]=newmax))
			unset ranges[$nranges] newmax
			((nranges-=1))
		else
			continue
		fi
	else
		break;
	fi
done
unset cruderanges

printf 1>&2 "Faixas de IDs: %#B\n" ranges

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
