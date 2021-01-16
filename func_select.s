#	323082701	Tomer	Shay
.section	.rodata
	.align 8

	format50:		.string	"first pstring length: %d, second pstring length: %d\n"
	format_default:	.string	"invalid option!\n"
	format52:		.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
	scanf_two_char:	.string	" %c %c"
	format53:		.string	"length: %d, string: %s\n"
	scanf_two_int:	.string	" %d %d"
	format55:		.string	"compare result: %d\n"

.L0:
	.quad	.L5060						# case 50
	.quad	.Ldeafult					# case 51 (default)
	.quad	.L52						# case 52
	.quad	.L53						# case 53
	.quad	.L54						# case 54
	.quad	.L55						# case 55
	.quad	.Ldeafult					# case 56 (default)
	.quad	.Ldeafult					# case 57 (default)
	.quad	.Ldeafult					# case 58 (default)
	.quad	.Ldeafult					# case 59 (default)
	.quad	.L5060						# case 60

	.text								# beginning of the code
# arguments: %rdi, %rsi, %rdx
.global	run_func
	.type	run_func,	@function
run_func:
	pushq	%rbp						# save the old frame pointer
	movq	%rsp,				%rbp	# create the new frame pointer

	pushq	%rbx
	pushq	%r10
	pushq	%r11
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15


	leaq	-50(%rdi),			%r10	# r10 = choise - 50
	cmpq	$10,				%r10	# compare choise to 10
	jg		.Ldeafult					# if choise > 10 goto default-case
	cmpq	$0,					%r10	# compare choise to 0
	jl		.Ldeafult					# if choise < 0 goto default-case
	jmp		*.L0(, %r10, 8)				# jump to the case array at r10

.L5060:								# case 50 or 60
	movq	%rsi,				%rdi	# pstring1 to first argument
	call	pstrlen
	movq	%rax,				%r10	# save pstring1 length in r10

	movq	%rdx,				%rdi	# pstring2 to first argument
	call	pstrlen
	movq	%rax,				%r11	# save pstring2 length in r11

	movq	$format50,			%rdi	# move format to first argument
	movq	%r10,				%rsi	# move pstring1 length to second
	movq	%r11,				%rdx	# move pstring1 length to thrid
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$0,					%rax	# set rax to 0
	jmp		.Lend

.Ldeafult:							# default
	movq	$format_default,	%rdi	# move format to first argument
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$0,					%rax	# set rax to 0
	jmp		.Lend

.L52:								# case 52
	subq	$1,					%rsp	# increase stack for old char
	subq	$1,					%rsp	# increase stack for new char
	pushq	%rsi						# push pointer to pstring1 to the stack
	pushq	%rdx						# push pointer to pstring2 to the stack

	movq	$scanf_two_char,	%rdi	# format to first argument
# the stack: 1byte(place for new char), 1byte(place for old char), pointer to pstring1(8bytes), pointer to pstring2(8bytes)
# want to save old char in rsp+8+8
	leaq	16(%rsp),			%rsi	# rsi is pointer to old char (second argument for scanf)
# want to save new char in rsp+8+8+1
	leaq	17(%rsp),			%rdx	# rdx is pointer to new char (third argument for scanf)
	movq	$0,					%rax	# set rax to 0
	call	scanf

	popq	%rdi						# rdi is pointer to pstring2 (first arg for replaceChar)
# the stack: 1byte(place for new char), 1byte(place for old char), pointer to pstring1(8bytes)
	movq	%rdi,				%r10	# r10 is pointer to pstring2
# want to save in rsi the old char (in rsp+8)
	movq	8(%rsp),			%rsi	# rsi is pointer to the old char (second arg for replaceChar)
# want to save in rdx the new char (in rsp+8+1)
	movq	9(%rsp),			%rdx	# rdx is pointer to the new char (third arg for replaceChar)
# want to save only the last byte in rsi and rdx (000...000char)
	call	replaceChar

	popq	%rdi						# rdi is pointer to pstring1 (first arg for replaceChar)
# the stack: 1byte(place for new char), 1byte(place for old char)
	movq	%rdi,				%r11	# r11 is pointer to pstring1
# want to save in rsi the old char (in rsp)
	movq	0(%rsp),			%rsi	# rsi is pointer to the old char (second arg for replaceChar)
# want to save in rdx the new char (in rsp+1)
	movq	1(%rsp),			%rdx	# rdx is pointer to the new char (third arg for replaceChar)
# want to save only the last byte in rsi and rdx (000...000char)
	call	replaceChar

# want to print %c, %c, %s, %s - 5 arguments: rdi - format, rsi - old char, rdx - new char, rcx - pstring1, r8 - pstring2 
	movq	$format52,			%rdi 
# want to save in rsi the old char (in rsp)
	movq	0(%rsp),			%rsi	# rsi is pointer to the old char (second arg for replaceChar)
# want to save in rdx the new char (in rsp+1)
	movq	1(%rsp),			%rdx	# rdx is pointer to the new char (third arg for replaceChar)
# want to save only the last byte in rsi and rdx (000...000char)
	movzbq	%sil,				%rsi
	movzbq	%dl,				%rdx
# pstring has the length at the first byte - need to add 1 to the pointer
	addq	$1,					%r11
	addq	$1,					%r10
	movq	%r11,				%rcx	# rcx - pstring1
	movq	%r10,				%r8		# r8  - pstring2
	movq	$0,					%rax
	call	printf
	movq	$0,					%rax

	addq	$2,					%rsp	# return rsp to its original size
	jmp		.Lend

.L53:								# case 53
	subq	$4,					%rsp	# increase stack for i (4bytes)
	subq	$4,					%rsp	# increase stack for j (4bytes)
	pushq	%rsi						# push pointer to pstring1 to the stack
	pushq	%rdx						# push pointer to pstring2 to the stack

	movq	$scanf_two_int,		%rdi	# format to first argument
# the stack: 4bytes(place for j), 4bytes(place for i), pointer to pstring1(8bytes), pointer to pstring2(8bytes)
# want to save i in rsp+8+8
	leaq	16(%rsp),			%rsi	# rsi is pointer to i (second argument for scanf)
# want to save j in rsp+8+8+4
	leaq	20(%rsp),			%rdx	# rdx is pointer to j (third argument for scanf)
	movq	$0,					%rax	# set rax to 0
	call	scanf

	popq	%rsi						# rsi is pointer to pstring2 (second arg for pstrijcpy - src)
# the stack: 4bytes(j), 4bytes(i), pointer to pstring1(8bytes)
	movq	%rsi,				%r12	# r12 is pointer to pstring2
	popq	%rdi						# rdi is pointer to pstring1 (first arg for pstrijcpy - dst)
# the stack: 4bytes(j), 4bytes(i)
	movq	%rsi,				%r11	# r11 is pointer to pstring1
	movl	0(%rsp),			%edx	# save i to rdx (4bytes)
	movl	4(%rsp),			%ecx	# szve j to rcx (4bytes)
	call	pstrijcpy					# rax is new dst

	movq	$format53,			%rdi	# format to first arg (for printf)
	movzbq	0(%rax),			%rsi	# rsi is dst length
	movq	%rax,				%rdx	# rdx is pointer to dst
	addq	$1,					%rdx	# pstring has the length at the first byte - need to add 1 to the pointer
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$0,					%rax	# set rax to 0

	movq	$format53,			%rdi	# format to first arg (for printf)
	movzbq	0(%r12),			%rsi	# rsi is src length
	movq	%r12,				%rdx	# rdx is pointer to src
	addq	$1,					%rdx	# pstring has the length at the first byte - need to add 1 to the pointer
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$0,					%rax

	addq	$8,					%rsp	# return rsp to its original size
	jmp		.Lend

.L54:								# case 54
	pushq	%rdx						# push pointer to pstring2 to the stack
# the stack: pointer to pstring2(8bytes)
	movq	%rsi,				%rdi	# rdi is pointer to pstring1 (first arg for swapCase)
	call	swapCase					# rax is new pstring1

	movq	$format53,			%rdi	# format to first arg (for printf)
	movzbq	0(%rax),			%rsi	# rsi is psrting1 length
	movq	%rax,				%rdx	# rdx is pointer to pstring1
	addq	$1,					%rdx	# pstring has the length at the first byte - need to add 1 to the pointer
	movq	$0,					%rax	# set rax to 0
	call	printf

	popq	%rdi						# rdi is pointer to pstring2 (first arg for swapCase)
# the stack returns to its previous state
	call	swapCase					# rax is new pstring2

	movq	$format53,			%rdi	# format to first arg (for printf)
	movzbq	0(%rax),			%rsi	# rsi is psrting2 length
	movq	%rax,				%rdx	# rdx is pointer to pstring2
	addq	$1,					%rdx	# pstring has the length at the first byte - need to add 1 to the pointer
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$0,					%rax

	jmp		.Lend

.L55:								# case 55
	subq	$4,					%rsp	# increase stack for i (4bytes)
	subq	$4,					%rsp	# increase stack for j (4bytes)
	pushq	%rsi						# push pointer to pstring1 to the stack
	pushq	%rdx						# push pointer to pstring2 to the stack

	movq	$scanf_two_int,		%rdi	# format to first argument
# the stack: 4bytes(place for j), 4bytes(place for i), pointer to pstring1(8bytes), pointer to pstring2(8bytes)
# want to save i in rsp+8+8
	leaq	16(%rsp),			%rsi	# rsi is pointer to i (second argument for scanf)
# want to save j in rsp+8+8+4
	leaq	20(%rsp),			%rdx	# rdx is pointer to j (third argument for scanf)
	movq	$0,					%rax	# set rax to 0
	call	scanf

	popq	%rsi						# rsi is pointer to pstring2 (second arg for pstrijcmp - src)
# the stack: 4bytes(place for j), 4bytes(place for i), pointer to pstring1(8bytes)
	movq	%rsi,				%r10	# r10 is pointer to pstring2
	popq	%rdi						# rdi is pointer to pstring1 (first arg for pstrijcmp - dst)
# the stack: 4bytes(place for j), 4bytes(place for i)
	movq	%rsi,				%r11	# r11 is pointer to pstring1
	movl	0(%rsp),			%edx	# save i to rdx (4bytes)
	movl	4(%rsp),			%ecx	# szve j to rcx (4bytes)
	call	pstrijcmp					# rax is compare result

	movq	$format55,			%rdi	# format to rdi - first arg of printf
	movq	%rax,				%rsi	# rsi is compare result
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$0,					%rax

	addq	$8,					%rsp	# return rsp to its original size
	jmp		.Lend

.Lend:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%r11
	popq	%r10
	popq	%rbx

	movq	%rbp,				%rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp						# restore old frame pointer (the caller function frame)
	ret									# return to caller function (OS).
