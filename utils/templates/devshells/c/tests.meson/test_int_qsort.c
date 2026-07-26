#include "int_qsort.h"
#include <criterion/criterion.h>

Test(int_qsort, ascending_standard)
{
	int target[] = { 5, 3, 2, 4, 1 };
	int expected[] = { 1, 2, 3, 4, 5 };
	size_t size = sizeof(target) / sizeof(target[0]);

	qsort(target, size, sizeof(int), compar_ascending);
	cr_assert_arr_eq(target, expected, sizeof(expected));
}

Test(int_qsort, descending_standard)
{
	int target[] = { 1, 5, 2, 4, 3 };
	int expected[] = { 5, 4, 3, 2, 1 };
	size_t num_elements = sizeof(target) / sizeof(target[0]);

	qsort(target, num_elements, sizeof(int), compar_descending);
	cr_assert_arr_eq(target, expected, sizeof(expected));
}
