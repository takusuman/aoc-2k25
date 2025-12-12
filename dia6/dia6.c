/*
 * AoC 2k25, day 6 pt. 1 in C99.
 * Question statement: "After helping the Elves in the
 * kitchen, you were taking a break and helping them
 * re-enact a movie scene when you
 * over-enthusiastically jumped into the garbage chute!
 * [...]
 * As you try to find a way out, you are approached by
 * a family of cephalopods! [...] they're curious if
 * you can help the youngest cephalopod with her math
 * homework.
 *
 * Cephalopod math doesn't look that different from
 * normal math. [...] consists of a list of problems;
 * each problem has a group of numbers that need to
 * be either added (+) or multiplied (*) together.
 * However, the problems are arranged a little
 * strangely; they seem to be presented next to each
 * other in a very long horizontal list. [...]
 * Each problem's numbers are arranged vertically; at
 * the bottom of the problem is the symbol for the
 * operation that needs to be performed. Problems are
 * separated by a full column of only spaces. The
 * left/right alignment of numbers within each problem
 * can be ignored. [...]
 * To check their work, cephalopod students are given
 * the grand total of adding together all of the
 * answers to the individual problems."
 */

int main(int argc, char *argv[]) {
/*
 * Prototype of the parser in KornShell 93:
 * nelem=0                      
 * onspace=false
 * unset tarray
 * for ((i=0; i<${#t}; i++)); do
 * 	chr="${t:$i:1}"
 * 	case "$chr" in
 * 	' ') if $onspace; then
 * 		continue
 * 	     else
 * 		nelem=$((nelem + 1))
 * 	     fi
 * 	     onspace=true ;;
 * 	*) onspace=false
 * 	     tarray[nelem]+="$chr" ;;
 * 	esac
 * done
 */
	return 0;
}
