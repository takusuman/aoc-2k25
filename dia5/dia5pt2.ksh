#!/bin/ksh93
# AoC 2k25, day 5, pt. 2 in KornShell 93.
# Question statement:
# "The Elves start bringing their spoiled inventory to
# the trash chute at the back of the kitchen.
# [...] the Elves would like to know all of the IDs
# that the fresh ingredient ID ranges consider to be
# fresh. [...]
# Now, the second section of the database (the
# available ingredient IDs) is irrelevant."
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
IngredientIDSection=false
for ((;;)); do
	if read line; then
		if [[ "$line" == "" ]]; then
			IngredientIDSection=true
			continue
		fi
		# "Now, the second section of the
		#  database is irrelevant."
		if ! $IngredientIDSection; then
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

printf 1>&2 'Faixas de IDs: %#B\n' ranges

for ((i=0; i < ${#ranges[@]}; i++)); do
	initialid="${ranges[i][0]}"
	lastid="${ranges[i][1]}"
	# Work thinking in the amount of elements amid
	# two numbers of a range, so we think on
	# counting from the number before the initial
	# until the last one.
	((fresh+=  (((initialid - 1) - lastid) * (-1) ) ))
done

# Printing once is faster than 'grep -c'ing many.
#for ((j=0; j < $fresh; j++)); do
#	echo Fresco
#done

printf 1>&2 'Número de IDs considerados frescos: %d\n' $fresh
