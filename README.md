# lua_sort 

-- Copyright (C) 2017 - DarkRoku12

Lua pure sort algorithm based on lib_table.c (from LuaJIT 2.1.0)

lib_table_sort.c -> table.sort algorithm built-in in LuaJIT.

qsort_raw.lua -> Lua pure version sort algorithm (non-optimized)

qsort_op.lua -> Lua pure version sort algorithm (optimized)

qsort_test.lua -> To test if the algorithm works well.

qsort_bench.lua -> A benchmark comparating table.sort (Buil-in LuaJIT, but NYI) and the lua pure version.

test_all.lua -> Runs the check test and the benchmark test.

results.txt -> Results of running test_all.lua

Resume of results.txt: 

Tested on:
Windows 10 64-bits.
Intel Core I7-4500U (4M Cache, up to 3.00 GHz)
8 GB RAM 
LuaJIT 2.1.0 Beta ( 32-Bits )

Notes: 
Only the lowest times are shown here.
Ratio 1.5 means Lua pure sort runs 1.5 times faster than Built-in sort. 

JIT ON:

| Table Length  | Lua pure sort | Built-in sort | Ratio |
| ------------- | ------------- |:-------------:| -----:|
| 1000          | 0.000000 secs | 0.000000 secs | NaN   |
| 200000 (2e5)  | 0.016000 secs | 0.082000 secs | 5.125 |
| 300000 (3e5)  | 0.016000 secs | 0.159000 secs | 9.937 |
| 1 million     | 0.085000 secs | 0.552000 secs | 6.494 |

JIT OFF:

| Table Length  | Lua pure sort | Built-in sort | Ratio |
| ------------- | ------------- |:-------------:| -----:|
| 1000          | 0.000000 secs | 0.000000 secs | NaN   |
| 200000 (2e5)  | 0.138000 secs | 0.100000 secs | 0.724 |
| 300000 (3e5)  | 0.212000 secs | 0.160000 secs | 0.754 |
| 1 million     | 0.793000 secs | 0.561000 secs | 0.707 |


