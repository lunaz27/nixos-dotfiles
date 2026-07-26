#include "int_qsort.h"
#include <stddef.h>
#include <stdio.h>

int compar_ascending(const void *a, const void *b)
{
	const int *left_ptr = a;
	const int *right_ptr = b;

	if (*left_ptr > *right_ptr) {
		return 1;
	}

	if (*left_ptr < *right_ptr) {
		return -1;
	}

	return 0;
}

int compar_descending(const void *a, const void *b)
{
	const int *left_ptr = a;
	const int *right_ptr = b;

	if (*left_ptr < *right_ptr) {
		return 1;
	}

	if (*left_ptr > *right_ptr) {
		return -1;
	}

	return 0;
}

void print_array(int a[], size_t size)
{
	for (size_t i = 0; i < size; i++) {
		if (i != 0) {
			printf(" ");
		}
		printf("%d", a[i]);
	}

	printf("\n");
}
