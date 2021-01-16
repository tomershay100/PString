# PString Exercise Project:  
1. [Introduction](#introduction)  
2. [run_main.s:](#run_main.s)  
3. [Dependencies:](#dependencies)

## Introduction
An exercise in computer structure course, we were given a task to implement pstring.s with several methods similar to the string.h, as -

* `char pstrlen(pstring* pstr)` - get the length of pstring
* `pstring* replaceChar(pstring* pstr, char oldChar, char newChar)` - replace all the oldChar instance with newChar in pstr
* `pstring* pstrijcpy(pstring* dst, pstring* src, char i, char j)` - copy src[i:j] to dst[i:j]
* `pstring* swapCase(pstring* pstr)` - replace all chars cases (a-z or A-Z). From lower-case to upper-case and the opposite
* `int pstrijcmp(pstring* pstr1, pstring* pstr2, char i, char j)` - compare between src[i:j] to dst[i:j]

## run_main.s:
Getting an int from the user - the length of the first pstring (n), then getting n chars for the first pstirng. Than doing the same procces for the second pstring. Getting a number from the user (50, 52-55 or 60) and run one of the functions above using a switch case statement.
The switch-case options:
50 or 60:
> Calculate and print the two pstring length.
52:
> Getting from the user two chars, oldChar and newChar. Than replace all the instance of the oldChar to the newChar (in the two pstrings).
< 53:
> Getting from the user two integers, i and j. Than call the pstrijcpy function with src as the second pstring and dst as the first. Then prints the two pstrings.
54:
> Using the swapCase function to swap every upper-case to lower-case in the two pstring.
55:
> Getting from the user two integers, i and j. Than call the pstrijcmp function with pstr1 as the first pstring and pstr2 as the second. Then prints the compare result.

## Dependencies:
* MacOS / Linux
* Git
