stm8/

	#include "mapping.inc"
	segment 'ram0'
cResult1 EQU $0
cResult2 EQU $2

	segment 'rom'
byteA 
	DC.B	$10
byteB 
	dc.b	$0A

pointer
	dc.w	byteA
	
main.l
	; initialize SP
	ldw X,#stack_end
	ldw SP,X

	#ifdef RAM0	
	; clear RAM0
ram0_start.b EQU $ram0_segment_start
ram0_end.b EQU $ram0_segment_end
	ldw X,#ram0_start
clear_ram0.l
	clr (X)
	incw X
	cpw X,#ram0_end	
	jrule clear_ram0
	#endif

	#ifdef RAM1
	; clear RAM1
ram1_start.w EQU $ram1_segment_start
ram1_end.w EQU $ram1_segment_end	
	ldw X,#ram1_start
clear_ram1.l
	clr (X)
	incw X
	cpw X,#ram1_end	
	jrule clear_ram1
	#endif

	; clear stack
stack_start.w EQU $stack_segment_start
stack_end.w EQU $stack_segment_end
	ldw X,#stack_start
clear_stack.l
	clr (X)
	incw X
	cpw X,#stack_end	
	jrule clear_stack
	
	clrw x
	pushw x
	pushw x

; EXAMPLE 1/ pass by value. 
; Operand 1 op stack, 
; Opernand 2 in register A.
; store result in local variable.
	push #$20 ; immediate addressing
	ld a, #$0B
	call optellen
	ld (5,sp), a ; Store result in local variable (0x7FF) -> indirect addressing (PARENTHESIS)
	pop a ; clean up stack.


; EXAMPLE 2/ pass by value. 
; Operand 1 op stack, 
; Opernand 2 in register A.
;Store result in global variable.
	push #$30
	ld a, #$C
	call optellen
	ld cResult1, a ; store result. Direct addressing: NO PARENTHESIS
	pop a
	
;Example 3: addressing with pointer. Pointer. 
; pass by value
	ld a, [pointer] ; DIRECT ADDRESSING
	push a
	ld a, byteB ; byteB: direct addressing. Load contents of byteB
	call optellen
	ld (4,sp), a ; store result in local variable.
	pop a ; clean up stack
	
	; Example 4: pass by value + direct addressing
	ld a, byteA ; DIRECT ADDRESSING
	push a
	ld a, byteB
	call optellen
	ld (4,sp), a
	pop a
	
;Example 5: pass by reference
	;[]
	ldw x, #byteB
	pushw x
	ldw x, #byteA
	call optellenByRef 
	nop ;  result is in A
	popw x ; clean up stack

;Example 6: pass by value, direct addressing, store result in RAM, not on stack.	
	ld a, byteA
	push a
	ld a, byteB
	call optellen
	ld cResult2, a
	pop a
	
;Example 7 Recursion	
	ldw x, #128
	call RecursiveAdd
	
	
infinite_loop.l
	jra infinite_loop

optellen
	add a, (3,sp)
	ret
	
	;[]
optellenByRef
	ld a, (x)
	ldw x, (3,sp)
	add a, (x)
	ret
	
RecursiveAdd ; function of n. n is kept in register x
	cpw x, #1 
	jreq endRecursiveAdd	; if n == 1, jumpt to end of function. Return value in x
	pushw x		; push  result on stack
	decw x		; decrement n
	call RecursiveAdd	 ; recursive call
	addw x, (1,sp)	; x <- n + n -1 
	addw sp, #2	; clean up local variable on stack.
endRecursiveAdd	
	ret
	
	interrupt NonHandledInterrupt
NonHandledInterrupt.l
	iret

	segment 'vectit'
	dc.l {$82000000+main}									; reset
	dc.l {$82000000+NonHandledInterrupt}	; trap
	dc.l {$82000000+NonHandledInterrupt}	; irq0
	dc.l {$82000000+NonHandledInterrupt}	; irq1
	dc.l {$82000000+NonHandledInterrupt}	; irq2
	dc.l {$82000000+NonHandledInterrupt}	; irq3
	dc.l {$82000000+NonHandledInterrupt}	; irq4
	dc.l {$82000000+NonHandledInterrupt}	; irq5
	dc.l {$82000000+NonHandledInterrupt}	; irq6
	dc.l {$82000000+NonHandledInterrupt}	; irq7
	dc.l {$82000000+NonHandledInterrupt}	; irq8
	dc.l {$82000000+NonHandledInterrupt}	; irq9
	dc.l {$82000000+NonHandledInterrupt}	; irq10
	dc.l {$82000000+NonHandledInterrupt}	; irq11
	dc.l {$82000000+NonHandledInterrupt}	; irq12
	dc.l {$82000000+NonHandledInterrupt}	; irq13
	dc.l {$82000000+NonHandledInterrupt}	; irq14
	dc.l {$82000000+NonHandledInterrupt}	; irq15
	dc.l {$82000000+NonHandledInterrupt}	; irq16
	dc.l {$82000000+NonHandledInterrupt}	; irq17
	dc.l {$82000000+NonHandledInterrupt}	; irq18
	dc.l {$82000000+NonHandledInterrupt}	; irq19
	dc.l {$82000000+NonHandledInterrupt}	; irq20
	dc.l {$82000000+NonHandledInterrupt}	; irq21
	dc.l {$82000000+NonHandledInterrupt}	; irq22
	dc.l {$82000000+NonHandledInterrupt}	; irq23
	dc.l {$82000000+NonHandledInterrupt}	; irq24
	dc.l {$82000000+NonHandledInterrupt}	; irq25
	dc.l {$82000000+NonHandledInterrupt}	; irq26
	dc.l {$82000000+NonHandledInterrupt}	; irq27
	dc.l {$82000000+NonHandledInterrupt}	; irq28
	dc.l {$82000000+NonHandledInterrupt}	; irq29

	end
