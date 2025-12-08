/*
 * AoC 2k25, day 3 in C99.
 * Question statement: "You descend a short staircase,
 * enter the surprisingly vast lobby, and are quickly
 * cleared by the security checkpoint. When you get
 * to the main elevators, however, you discover that
 * each one has a red light above it: they're all
 * offline.
 * [...]
 * '[...] it just needs power. Maybe you can get it
 * running while I keep working on the elevators.'
 * There are batteries nearby that can supply
 * emergency power to the escalator for just such
 * an occasion. The batteries are each labeled with
 * their joltage rating, a value from 1 to 9.
 * [...]
 * The batteries are arranged into banks; each line
 * of digits in your input corresponds to a single
 * bank of batteries.
 * Within each bank, you need to turn on exactly
 * two batteries; the joltage that the bank produces
 * is equal to the number formed by the digits on
 * the batteries you've turned on. [...]
 * You cannot rearrange batteries."
 */

#include <stddef.h>
#include <stdio.h>
int8_t *getbatterybank(FILE *f);

int main(int argc, char *argv[]) {
	unsigned int banks = 0,
		     banklen = 0,
		     bufsiz = 5,
		     first_largest_pos = 0,
		     second_largest_pos = 0;
	int8_t battery = 0,
	       first_largest = 1,
	       second_largest = 1,
	       *mostpowerfulofbank = NULL,
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
		if ((banks + 1)	> 5) {
			bufsiz += 5;
			if ((newtotalbanks = realloc(totalbanks, bufsiz)) == NULL) {
				return -1;
			} else {
			        totalbanks = newtotalbanks;
			}
		}
		totalbanks[banks] = bankbuf;
	}

	if ((mostpowerfulofbank = malloc(banks)) == NULL)
		return -1;

	for (int i = 0; i < banks; i++) {
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
		for (int j = 0; j < (banklen - 1); j++) {
			battery = totalbanks[i][j];
			if (first_largest < battery) {
				first_largest = battery;
				first_largest_pos = j;
				for (int k = (first_largest_pos + 1); k < banklen; k++) {
					battery = totalbanks[i][k];
					if (second_largest < battery || second_largest_pos <= first_largest_pos) {
						second_largest = battery;
						second_largest_pos = k;
					}
				}
			}
		}
		printf("First largest: %d\nSecond largest: %d\n",
				first_largest, second_largest);
		mostpowerfulofbank[i] = ((first_largest * 10) + second_largest);
		printf("Largest batteries of the bank: %d\n",
				mostpowerfulofbank[i]);
		first_largest = 1;
		second_largest = 1;
		first_largest_pos = 0;
		second_largest_pos = 0;
	}

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
}
