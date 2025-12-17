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

/* Just for the love of the game. */
#define cephalopod_to_human_homework(n, op) \
	printf("%d ", atoi(n)); \
	if (m < (maxm - 2)) { \
		putchar(' '); \
		putchar(op); \
		putchar(' '); \
	}

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
		***lines;
	FILE *inputfp = NULL;

	if (argc <= 1) return -1;
	input = argv[1];
	inputfp = fopen(input, "r");
	if (!inputfp) return -1;

	lines = gethomeworkline(inputfp);
	for (maxm = 0; lines[maxm]; maxm++);
	for (maxn = 0; lines[(maxm - 1)][maxn] != NULL; maxn++);
	/* Allocate size dynamically for lines[]. */
	for (n = 0; n < maxn; n++) {
		op = *lines[(maxm - 1)][n];
		/* total = (op == '*')? 1 : 0; */
		total = (op == '*');
		for (m = 0; m < (maxm - 1); m++) {
			if (lines[m][n] == NULL) continue;
			cephalopod_to_human_homework(lines[m][n], op);
			switch (op) {
				case '*':
					total *= atoi(lines[m][n]);
					break;
				case '+':
					total += atoi(lines[m][n]);
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
	char *elem = NULL,
	     **linebuf = NULL,
	     ***homeworkelems = NULL;
	size_t c = 0,
	       e = 0,
	       l = 0,
	       lns = 0,
	       col = 0,
	       cols = 0,
	       curc = 0,
	       lines = 0,
	       linebufsiz = 1,
	       *numlen = NULL;
	linebuf = malloc(((linebufsiz) * sizeof(char *)));

	for (c = 0; (b = fgetc(f)) != EOF; c++) {
		if ((c == 0) || (b == '\n')) {
			if (b == '\n') {
				l++;
				c = 0;
			}
			linebufsiz += 1;
			if (((linebuf = realloc(linebuf, (linebufsiz * sizeof(char *)))) == NULL) ||
					((linebuf[l] = malloc((BUFSIZ * sizeof(char)))) == NULL))
				return NULL;
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
	lines = l;
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
	numlen = calloc(BUFSIZ, sizeof(size_t));
	for (c = 0; linebuf[(lines - 1)][c]; c++) {
		if (linebuf[(lines - 1)][c] != ' ') {
			cols += (c > 0); /* 1 when true. */
			if ((cols > 0) &&
				linebuf[(lines - 1)][(c - 1)] == ' ') {
				numlen[(cols - 1)] -= 1;
			}
		}
		numlen[cols] += 1;
	}
	/* Since we're counting from 0. */
	cols += 1;

	homeworkelems = calloc(lines, sizeof(char **));
	for (e = 0; e < lines; e++)
		homeworkelems[e] = calloc((cols + 1), sizeof(char *));
	elem = malloc((BUFSIZ * sizeof(char)));

	/*
	 * This... Well, this walks through each column, then goes
	 * for each line and return the numbers/characters in that
	 * column.
	 * This is a prototype in, again, Korn Shell 93:
	 *
	 * for ((col=0; col < ${#collen[@]}; col++)); do
	 * for ((clen=$nclen; clen < $((${collen[$col]} + $nclen)); clen++)); do
	 * 	for ((sline=0; sline < ${#t[@]}; sline++)); do
	 * 		troca+="${t[$sline]:$clen:1}"
	 * 	done
	 * 	nova[$line][$col]="$troca"
	 * 	unset troca
	 * 	((line+=1))
	 * done
	 * line=0
	 * ((nclen+= ${collen[$col]} + 1))
	 * done
	 */
	l = 0;
	for (col = 0; col < cols; col++) {
		for (c = curc; c < (numlen[col] + curc); c++) {
			for (lns=0; lns < (lines - 1); lns++)
				elem[lns] = linebuf[lns][c];
			elem[(lns + 1)] = '\0';
			homeworkelems[l][col] = strdup(elem);
			l += 1;
		}
		l = 0;
		curc += numlen[col];
		curc += 1;
	}
	curc = 0;
	for (col = 0; col < cols; col++) {
		memset(elem, '\0', sizeof(elem));
		for (e = 0, c = curc; c < (numlen[col] + curc); c++, e++) {
			elem[e] = linebuf[(lines - 1)][c];
		}
		homeworkelems[(lines - 1)][col] = strdup(elem);
		curc += numlen[col];
		curc += 1;
	}

	for (l = 0; l < lines; l++) {
		for (col = 0; col < cols; col++) {
			printf("[%d][%d] = %s\n", l, col, homeworkelems[l][col]);
		}
	}
	for (e = 0; e < lines; e++)
		free(linebuf[e]);
	free(linebuf);
	free(elem);
	return (l > 0)? homeworkelems : NULL;
}
