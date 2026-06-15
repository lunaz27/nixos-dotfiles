#ifndef INT_QSORT_H
#define INT_QSORT_H

#include <stddef.h>

int compar_ascending(const void *a, const void *b);
int compar_descending(const void *a, const void *b);
void print_array(int a[], size_t size);

#endif // INT_QSORT_H
