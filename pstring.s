#	323082701	Tomer	Shay
.section	.rodata
	.align 8
	invalid:	.string	"invalid input!\n"

	.text								# beginning of the code
.global	pstrlen
	.type	pstrlen,	@function
pstrlen:
# arguments: %rdi - pstring
	pushq	%rbp						# save the old frame pointer
	movq	%rsp,				%rbp	# create the new frame pointer

	movsbq	0(%rdi),			%rax	# rax is the pstring length

	movq	%rbp,				%rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp						# restore old frame pointer (the caller function frame)
	ret									# return to caller function (OS).

.global	replaceChar
	.type	replaceChar,	@function
# arguments: %rdi - pstring, %rsi - old char, %rdx - new char
replaceChar:
	pushq	%rbp						# save the old frame pointer
	movq	%rsp,				%rbp	# create the new frame pointer

	movq	%rdi,				%rax	# rax is pointer to pstring - return value
	addq	$1,					%rdi	# pstring has the length at the first byte - need to add 1 to the pointer
.while_loop_rpc:
	cmpb	$0,					(%rdi)	# check if pstring at index i = \0 
	je		.break_rpc					# if true - ends the loop

	cmpb	0(%rdi),			%sil	# check if rsi = old char
	je		.replace_current			# if true - jmp to replace the current char
	jmp		.end_if_rpc					# else, jmp to the end of the if
.replace_current:
	movb	%dl,				(%rdi)	# change the current byte from rsi to rax (old to new)
.end_if_rpc:
	addq	$1,					%rdi	# go to the next char in the pstring ("increase i")
	jmp		.while_loop_rpc
.break_rpc:
	movq	%rbp,				%rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp						# restore old frame pointer (the caller function frame)
	ret									# return to caller function (OS).

.global	pstrijcpy
	.type	pstrijcpy,	@function
pstrijcpy:
# arguments: %rdi - pstring1, %rsi - pstring2, rdx - i, %rcx - j
	pushq	%rbp						# save the old frame pointer
	movq	%rsp,				%rbp	# create the new frame pointer	

	pushq	%r12						# save r12
	pushq	%rdi						# save pointer to pstring1 to the stack

	cmpb	%dl,				%cl		# compare i and j (rdx and rcx)
	jl		.invalid_cpy				# if j is less than i, goto invalid
	cmpb	$0,					%dl		# compare 0 and i (rdx)
	jl		.invalid_cpy				# if i is less than 0, goto invalid
	addb	$1,					%cl		# add 1 to j - to check length (start in 0)
	cmpb	%cl,				0(%rdi)	# compare pstring1 length (rdi) and j+1 (rcx)
	jl		.invalid_cpy				# if pstring1 length is less than j+1, goto invalid
	cmpb	%cl,				0(%rsi)	# compare pstring2 length (rsi) and j+1 (rcx)
	jl		.invalid_cpy				# if pstring2 length is less than j+1, goto invalid
	subb	$1,					%cl		# subtract 1 from j - to check length (start in 0)

	addq	$1,					%rdi	# pstring has the length at the first byte - need to add 1 to the pointer
	addq	$1,					%rsi	# pstring has the length at the first byte - need to add 1 to the pointer
	addq	%rdx,				%rdi	# add i to pstring1 pointer - rdi is pointer to pstring1[i]
	addq	%rdx,				%rsi	# add i to pstring2 pointer - rsi is pointer to pstring2[i]
.while_loop_cpy:
	cmpb	%dl,				%cl		# compare i and j (rdx and rcx)
	jl		.break_cpy					# if j is less than i, break

	movb	0(%rsi),			%r12b	# copy pstring2[i] to r12
	movb	%r12b,				0(%rdi)	# copt r12 to pstring2[i]
	addb	$1,					%dl		# add 1 to i (i++)
	addq	$1,					%rdi	# add 1 to rdi
	addq	$1,					%rsi 	# add 1 to rsi
	jmp		.while_loop_cpy
.invalid_cpy:
	movq	$invalid,			%rdi	# move format to first argument for printf
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$0,					%rax	# set rax to 0
.break_cpy:
	popq	%rax						# return value - pointer to pstring1
	popq	%r12						# save r12
	movq	%rbp,				%rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp						# restore old frame pointer (the caller function frame)
	ret

.global	swapCase
	.type	swapCase,	@function
swapCase:
# argument: %rdi - pstring
	pushq	%rbp						# save the old frame pointer
	movq	%rsp,				%rbp	# create the new frame pointer

	movq	%rdi,				%rax	# rax is pointer to pstring - return value
	addq	$1,					%rdi	# pstring has the length at the first byte - need to add 1 to the pointer
.while_loop_swp:
	cmpb	$0,					(%rdi)	# check if pstring at index i = \0 
	je		.break_swp					# if true - ends the loop

	cmpb	$90,				(%rdi)	# check if pstring[i] <= 'Z'
	jbe		.may_be_capital
	cmpb	$122,				(%rdi)	# check if pstring[i] <= 'z'
	jbe		.may_be_small
	jmp		.continue
.may_be_capital:
	cmpb	$65,				(%rdi)	# check if pstring[i] < 'A'
	jb		.continue
	addb	$32,				(%rdi)	# make current char small case
	jmp		.continue
.may_be_small:
	cmpb	$97,				(%rdi)	# check if pstring[i] < 'a'
	jb		.continue
	subb	$32,				(%rdi)	# make current char capital
	jmp		.continue
.continue:
	addq	$1,					%rdi	# add 1 to rdi - next char
	jmp		.while_loop_swp
.break_swp:
	movq	%rbp,				%rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp						# restore old frame pointer (the caller function frame)
	ret

.global	pstrijcmp
	.type	pstrijcmp,	@function
pstrijcmp:
# arguments: %rdi - pstring1, %rsi - pstring2, rdx - i, %rcx - i
	pushq	%rbp						# save the old frame pointer
	movq	%rsp,				%rbp	# create the new frame pointer	

	cmpb	%dl,				%cl		# compare i and j (rdx and rcx)
	jl		.invalid_cmp				# if j is less than i, goto invalid
	cmpb	$0,					%dl		# compare 0 and i (rdx)
	jl		.invalid_cmp				# if i is less than 0, goto invalid
	cmpb	%cl,				0(%rdi)	# compare pstring1 length (rdi) and j (rcx)
	jl		.invalid_cmp				# if pstring1 length is less than j, goto invalid
	cmpb	%cl,				0(%rsi)	# compare pstring2 length (rsi) and j (rcx)
	jl		.invalid_cmp				# if pstring2 length is less than j, goto invalid

	addq	$1,					%rdi	# pstring has the length at the first byte - need to add 1 to the pointer
	addq	$1,					%rsi	# pstring has the length at the first byte - need to add 1 to the pointer
	addq	%rdx,				%rdi	# add i to pstring1 pointer - rdi is pointer to pstring1[i]
	addq	%rdx,				%rsi	# add i to pstring2 pointer - rsi is pointer to pstring2[i]
	movq	$0,					%rax	# rax = 0 - return value
.while_loop_cmp:
	cmpb	%dl,				%cl		# compare i and j (rdx and rcx)
	jl		.break_cmp					# if j is less than i, break

	movb	0(%rdi),			%r12b	# copy pstring1[i] to r12
	cmpb	%r12b,				0(%rsi)	# compare r12 to pstring2[i]
	jl		.grater_cmp					# pstring1 > pstring2
	jg		.lower_cmp					# pstring2 > pstring1
	addb	$1,					%dl		# add 1 to i (i++)
	addq	$1,					%rdi	# add 1 to rdi
	addq	$1,					%rsi	# add 1 to rsi
	jmp		.while_loop_cmp
.grater_cmp:
	addq	$1,					%rax	# return value - 1
	jmp		.break_cmp
.lower_cmp:
	subq	$1,					%rax	# return value - (-1)
	jmp		.break_cmp
.invalid_cmp:
	movq	$invalid,			%rdi	# move format to first argument for printf
	movq	$0,					%rax	# set rax to 0
	call	printf
	movq	$-2,				%rax	# set rax to 0
.break_cmp:
	movq	%rbp,				%rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp						# restore old frame pointer (the caller function frame)
	ret
