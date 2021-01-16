#	323082701	Tomer	Shay
.section	.rodata
	.align	8
	int:	.string	"%hhd"
	string:	.string	"%s"

	.text
.global	run_main
	.type	run_main,	@function
run_main:
	pushq	%rbp						# save the old frame pointer
	movq	%rsp,				%rbp	# create the new frame pointer

# callee registers to the stack
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
# first pstring
	subq	$1,					%rsp	# increase stack for len
	movq	%rsp,				%rsi	# rsi is pointer to len (second argument for scanf)
	movq	$int,				%rdi	# format to first argument (scanf)
	movq	$0,					%rax	
	call	scanf

	movzbq	0(%rsp),			%r12	# len is in r12
	movq	%r12,				%r10	# save len1
	subq	$1,					%rsp	# increase stack for \0
	movq	%rsp,				%r13	# r13 pointing to end for the string 
	subq	%r12,				%rsp	# increase stack by len for the string
	movq	%rsp,				%rsi	# rsi is pointer to string (second argument for scanf)
	movq	$string,			%rdi	# format to first argument (scanf)
	movq	$0,					%rax
	call	scanf

	movb	$0,					(%r13)	# put \0 at the end of the file
	subq	$1,					%rsp	# increase stack for len
	movb	%r12b,				(%rsp)	# put len at the begining of the string

	movq	%rsp,				%r14	# r14 is pointer to pstring1
# second pstring
	subq	$1,					%rsp	# increase stack for len
	movq	%rsp,				%rsi	# rsi is pointer to len (second argument for scanf)
	movq	$int,				%rdi	# format to first argument (scanf)
	movq	$0,					%rax
	call	scanf

	movzbq	0(%rsp),			%r12	# len is in r12
	subq	$1,					%rsp	# increase stack for \0
	movq	%rsp,				%r13	# r13 pointing to end for the string 
	subq	%r12,				%rsp	# increase stack by len for the string
	movq	%rsp,				%rsi	# rsi is pointer to string (second argument for scanf)
	movq	$string,			%rdi	# format to first argument (scanf)
	movq	$0,					%rax
	call	scanf

	movb	$0,					(%r13)	# put \0 at the end of the file
	subq	$1,					%rsp	# increase stack for len
	movb	%r12b,				(%rsp)	# put len at the begining of the string

	movq	%rsp,				%r15	# r15 is pointer to pstring2
# option
	subq	$1,					%rsp	# increase stack for opt
	movq	%rsp,				%rsi	# rsi is pointer to opt (second argument for scanf)
	movq	$int,				%rdi	# format to first argument (scanf)
	movq	$0,					%rax
	call	scanf

	movq	0(%rsp),			%rsi
	movzbq	%sil,				%rdi	# rdi is the option - first argument

	movq	%r14,				%rsi	# rsi is pointer to pstring1 - second arg
	movq	%r15,				%rdx	# rdx is pointer to pstring2 - third arg
	movq	$0,					%rax
	call	run_func

	addq	%r12,				%rsp	# pstring1 length
	addq	$2,					%rsp	# 1 for the len, 1 for the \0
	addq	%r10,				%rsp	# pstring2 length
	addq	$2,					%rsp	# 1 for the len, 1 for the \0

# restor callee
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx

	movq	%rbp,				%rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp						# restore old frame pointer (the caller function frame)
	ret
