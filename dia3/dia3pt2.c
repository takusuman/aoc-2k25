/*
 * AoC 2k25, day 3 pt. 2 in C99.
 * Question statement: "The escalator doesn't move.
 * The Elf explains that it probably needs more
 * joltage to overcome the static friction of the
 * system and hits the big red 'joltage limit safety
 * override' button.
 * [...]
 * Now, you need to make the largest joltage by
 * turning on exactly twelve batteries within each
 * bank.
 * The joltage output for the bank is still the
 * number formed by the digits of the batteries
 * you've turned on; the only difference is that
 * now there will be 12 digits in each bank's
 * joltage output instead of two."
 *
 * Pt. 1: "You cannot rearrange batteries."
 */

#include <math.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int8_t *getbatterybank(FILE *f);

int main(int argc, char *argv[]) {
	unsigned int banks = 0,
		     banklen = 0,
		     bufsiz = 5,
		     largest_pos = 0,
		     pos = 0,
		     i = 0,
		     j = 0,
		     k = 0;
        unsigned long int m = 0,
		      sum = 0,
		      *mostpowerfulofbank = NULL;
	int8_t battery = 0,
	       largest = 0,
	       batteries[12],
	       *bankbuf = NULL,
	       **totalbanks,
	       **newtotalbanks;
	char *input = NULL;
	FILE *inputfp = NULL;

	if (argc <= 1) return -1;
	input = argv[1];
	inputfp = fopen(input, "r");
	if (!inputfp) return -1;

	if ((totalbanks = malloc(bufsiz * sizeof(int *))) == NULL)
		return -1;

	for (banks = 0; (bankbuf = getbatterybank(inputfp)) != NULL; banks++) {
		if ((banks + 1)	> bufsiz) {
			bufsiz += 5;
			if ((newtotalbanks = realloc(totalbanks, (bufsiz * sizeof(int *)))) == NULL) {
				return -1;
			} else {
			        totalbanks = newtotalbanks;
			}
		}
		totalbanks[banks] = bankbuf;
	}

	if ((mostpowerfulofbank = malloc(banks * sizeof(unsigned long int))) == NULL)
		return -1;

	for (i = 0; i < banks; i++) {
		printf("Bank %d: ", i);
		for (banklen = 0; ; banklen++) {
			battery = totalbanks[i][banklen];
			switch (battery) {
				case -1:
					putchar('\n');
					break;
				default:
					putchar((battery + '0'));
					continue;
			}
			break;
		}

		/*
		 * My prototype in Korn Shell 93:
		 *
		 * largest=0
		 * largest_pos=0
		 * pos=0
		 * typeset -a newbank[12]
		 * for (( k=0; k < 12; k++ )); do
		 * 	for (( j=$pos; j < $((${#batbank} - ((12 - k) - 1))); j++ )); do
		 *		battery=${batbank:$j:1}
		 *		if (($battery > $largest)); then
		 * 			largest=$battery
		 * 			newbank[$k]=$largest
		 * 			largest_pos=$j
		 * 		fi
		 * 	done
		 * 	pos=$(($largest_pos + 1))
		 * 	largest=0
		 * 	largest_pos=0
		 * done
		 */
		pos = 0;
		for (k = 0; k < 12; k++) {
			/* Get the largest battery from the bank. */
			for (j = pos; j < (banklen - ((12 - k) - 1)); j++) {
				battery = totalbanks[i][j];
				if (battery > largest) {
					largest = battery;
					batteries[k] = largest;
					largest_pos = j;
				}
			}
			pos = (largest_pos + 1);
			largest = 0;
			largest_pos = 0;
		}

		/*
		 * Now "convert" the batteries[] array
		 * into a single (and really large)
		 * integer.
		 */
		m = 1;
		for (k = 0; k < 12; k++) {
			mostpowerfulofbank[i] += (batteries[((12 - 1) - k)] * m);
			/* Shift a digit to left. */
			m *= 10;
		}
		printf("Largest batteries of the bank: %ld\n",
				mostpowerfulofbank[i]);
		sum += mostpowerfulofbank[i];
	}

	printf("Sum of the total joltage: %ld\n", sum);

	free(totalbanks);
	free(mostpowerfulofbank);
	fclose(inputfp);
	return 0;
}

int8_t *getbatterybank(FILE *f) {
	int8_t *bank = NULL,
		*newbankbuf = NULL;
	size_t l = 0,
		bufsiz = BUFSIZ;
	int b = 0;
	bank = malloc(bufsiz);

	for (l = 0; (b = getc(f)); l++) {
		if ((l + 1) > bufsiz) {
			/*
			 * We shouldn't be goign too far if
			 * it already surpassed BUFSIZ.
			 */
			bufsiz += 1;
			if ((newbankbuf = realloc(bank, bufsiz)) == NULL) {
				return NULL;
			} else {
			        bank = newbankbuf;
			}
		}
		if ('0' <= b && b <= '9') {
			bank[l] = (b - '0');
		} else if (b == EOF || b == '\n') {
			bank[l] = -1;
			return (l <= 0) ? NULL : bank;
		}
	}
	return NULL; /* Never reach; just for the warn. */
}
