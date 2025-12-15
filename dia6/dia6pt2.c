/*
 * AoC 2k25, day 6 pt. 2 in C99.
 * Question statement:
 * Part I:
 * "After helping the Elves in the kitchen, you were
 * taking a break and helping them re-enact a movie
 * scene when you over-enthusiastically jumped into
 * the garbage chute!
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
 *
 * Part II:
 * "The big cephalopods come back to check on how
 * things are going. When they see that your grand total
 * doesn't match the one expected by the worksheet, they
 * realize they forgot to explain how to read cephalopod
 * math.
 *
 * Cephalopod math is written right-to-left in columns.
 * Each number is given in its own column, with the most
 * significant digit at the top and the least significant
 * digit at the bottom."
 *
 * "Problems are still separated with a column consisting
 * only of spaces, and the symbol at the bottom of the
 * problem is still the operator to use."
 *
 * compile: cc -Wall -std=c99 -O3 -o dia6 dia6pt2.c -pipe
 */
#define cephalopod_to_human_homework(n, op) ((void)0)
/* Just for the love of the game. */
//#define cephalopod_to_human_homework(n, op) \
//	printf("%d", n); \
//	if (m < (maxm - 2)) { \
//		putchar(' '); \
//		putchar(op); \
//		putchar(' '); \
//	}

#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char *strdup(const char*);
char **gethomeworkline(FILE *f);

int main(int argc, char *argv[]) {
	unsigned long int total = 0,
		      grandtotal = 0;
	size_t linebufsiz = 1,
	       i = 0,
	       m = 0,
	       n = 0,
	       maxm = 0,
	       maxn = 0;
	char op = '\0',
	     *input = NULL,
	     **line = NULL,
		***crudelines;
	FILE *inputfp = NULL;

	if (argc <= 1) return -1;
	input = argv[1];
	inputfp = fopen(input, "r");
	if (!inputfp) return -1;

	gethomeworkline(inputfp);
	/* Allocate size dynamically for crudelines[]. */
//	for (n = 0; n < maxn; n++) {
//		op = *crudelines[(maxm - 1)][n];
//		/* total = (op == '*')? 1 : 0; */
//		total = (op == '*');
//		for (m = 0; m < (maxm - 1); m++) {
//			cephalopod_to_human_homework(crudelines[m][n], op);
//			switch (op) {
//				case '*':
//					total *= atoi(crudelines[m][n]);
//					break;
//				case '+':
//					total += atoi(crudelines[m][n]);
//					break;
//			}
//
//		}
//		printf("= %ld\n", total);
//		grandtotal += total;
//	}
	printf("Grand total: %ld\n", grandtotal);

	fclose(inputfp);
	return 0;
}

char **gethomeworkline(FILE *f) {
	int b = 0;
	char *elem = NULL,
	     **linebuf = NULL,
	     **newlinebuf = NULL,
	     **homeworkelems,
	     **newhomeworkelems;
	size_t c = 0,
	       e = 0,
	       l = 0,
	       col = 0,
	       linebufsiz = 1,
	       elemsbufsiz = 5,
	       *numlen = NULL;
	linebuf = malloc(((linebufsiz) * sizeof(char *)));

	for (c = 0; (b = fgetc(f)) != EOF; c++) {
		if ((c == 0) || (b == '\n')) {
			if (b == '\n') {
				l++;
				c = 0;
			}
			linebufsiz += 1;
			linebuf = realloc(linebuf, (linebufsiz * sizeof(char *)));
			linebuf[l] = malloc((BUFSIZ * sizeof(char)));
			if (b == '\n') {
				/*
				 * So it becomes 0 later. I know
				 * this isn't a good practice.
				 */
				c--;
				continue;
			}
		}
		linebuf[l][c] = b;
	}

	/*
	 * Count how many spaces does a number occupy.
	 * A small prototype in Korn Shell 93:
	 *
	 * # t[3] is the last line containing the operators.
	 * col=0
	 * lennum=(0 0 0 0)
	 * for ((i=0; i<${#t[3]}; i++)); do
	 * 	if [[ "${t[3]:$i:1}" != ' ' ]]; then
	 * 		if ((($i + $col) > 0 )) &&
	 * 			[[ "${t[3]:$(($i - 1)):1}" == ' ' ]]; then
	 * 			((col+=1))
	 * 			((lennum[$(($col - 1))]-= 1))
	 * 		fi
	 * 	fi
	 * 	((lennum[$col]+= 1))
	 * done
	 */
	numlen = malloc((l * sizeof(size_t)));
	for (c = 0; linebuf[(l - 1)][c]; c++) {
		if (linebuf[(l - 1)][c] != ' ') {
			if (((c + col) > 0) && 
				linebuf[(l - 1)][(c - 1)] == ' ') {
				col += 1;
				numlen[(col - 1)] -= 1;
			}
		}
		numlen[col] += 1;
	}
	
	for (e = 0; e < l; e++) printf("%d\n", numlen[e]);
	for (e = 0; e < l; e++) puts(linebuf[e]);
//	homeworkelems = malloc((elemsbufsiz * sizeof(char *)));
//	for (e = 0, elem = strtok(linebuf, " "); (elem != NULL);
//		elem = strtok(NULL, " "), e++) {
//		if ((e + 1) > elemsbufsiz) {
//			elemsbufsiz += 4;
//			if ((newhomeworkelems =
//				realloc(homeworkelems,
//					(elemsbufsiz * sizeof(char *)))) == NULL)
//				return NULL;
//			else
//				homeworkelems = newhomeworkelems;
//		}
//
//		homeworkelems[e] = strdup(elem);
//	}
	free(linebuf);
	return (l > 0)? homeworkelems : NULL;
}
