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

	/* Allocate size dynamically for crudelines[]. */
	crudelines = malloc(linebufsiz * sizeof(char **));
	for (i=0; (line = gethomeworkline(inputfp)) != NULL ; i++, maxm++) {
		if ((i + 1) > linebufsiz) {
			linebufsiz+=1;
			crudelines = realloc(crudelines, (linebufsiz * sizeof(char **)));
		}
		crudelines[i] = line;
	}
	for (maxn = 0; crudelines[(maxm - 1)][maxn] != NULL; maxn++);

	/* For this "cephalopod math" to work, we will basically */
	for (m=0; m < (maxm - 1); m++) {
		for (n=0; n < maxn; n++) {
			puts(crudelines[m][n]);
		}
	}

	//for (i=0; crudelines[i]; i++) free(crudelines[i]);


	for (n = 0; n < maxn; n++) {
		op = *crudelines[(maxm - 1)][n];
		/* total = (op == '*')? 1 : 0; */
		total = (op == '*');
		for (m = 0; m < (maxm - 1); m++) {
			cephalopod_to_human_homework(crudelines[m][n], op);
			switch (op) {
				case '*':
					total *= atoi(crudelines[m][n]);
					break;
				case '+':
					total += atoi(crudelines[m][n]);
					break;
			}

		}
		printf("= %ld\n", total);
		grandtotal += total;
	}
	printf("Grand total: %ld\n", grandtotal);

	fclose(inputfp);
	return 0;
}

char **gethomeworkline(FILE *f) {
	int b = 0;
	char *linebuf = NULL,
	     *newlinebuf = NULL,
	     *elem = NULL,
	     **homeworkelems,
	     **newhomeworkelems;
	size_t l = 0,
	       e = 0,
	       bufsiz = 250,
	       elemsbufsiz = 4;
	homeworkelems = malloc((elemsbufsiz * sizeof(char *)));
	linebuf = malloc((bufsiz * sizeof(char)));
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
	for (l = 0; (b = getc(f)) != EOF; l++) {
		if ((l + 1) > bufsiz) {
			bufsiz += 250;
			if ((newlinebuf = realloc(linebuf, (bufsiz * sizeof(char)))) == NULL)
				return NULL;
			else
				linebuf = newlinebuf;
		}
		switch (b) {
			case '\n':
				break;
			default:
				linebuf[l] = b;
				continue;
		}
		break;
	}
	linebuf[l] = '\0';

	for (e = 0, elem = strtok(linebuf, " "); (elem != NULL);
		elem = strtok(NULL, " "), e++) {
		if ((e + 1) > elemsbufsiz) {
			elemsbufsiz += 4;
			if ((newhomeworkelems =
				realloc(homeworkelems,
					(elemsbufsiz * sizeof(char *)))) == NULL)
				return NULL;
			else
				homeworkelems = newhomeworkelems;
		}

		homeworkelems[e] = strdup(elem);
	}
	free(linebuf);
	return (l > 0)? homeworkelems : NULL;
}
