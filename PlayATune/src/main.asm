stm8/

	#include "mapping.inc"
	#include "stm8s105k.inc"
	
	extern timerInit.w
	extern IOInit.w
	
	segment 'ram0'
beatcount dc.w 0
songIndex dc.w 0

	segment 'rom'
	
tones
	dc.w	$1dee 	;C4 - 261.63 Hz
	dc.w	$1a9a 	;D4 - 293.66
	dc.w  $17b3		;E4 - 329.63
	dc.w  $165e		;F4 - 349.23
	dc.w  $13ee		;G4 - 392.00
	dc.w  $11c1		;A4 - 440.00
	dc.w  $0fd1		;B4 - 493.88
	dc.w	$0eee		;C5 - 523.25


;birthday tune
Birthday
	dc.b 0, 1 ; play tones[0] for a duration of 1 tick
	dc.b 0, 1 ; play tones[0] for a duration of 1 tick
	dc.b 1, 2 ; play tones[1] for a duration of 2 tick
	dc.b 0, 2 ; play tones[0] for a duration of 2 ticks
	dc.b 2, 2 ; play tones[2] for a duration of 2 ticks
	dc.b 3, 4 ; play tones[3] for a duration of 4 ticks
	dc.b 0, 1 ; play tones[0] for a duration of 1 tick
	dc.b 0, 1 ; play tones[0] for a duration of 1 tick
	dc.b 1, 2 ; play tones[1] for a duration of 2 ticks
	dc.b 0, 2 ; play tones[0] for a duration of 2 ticks
	dc.b 4, 2 ; play tones[4] for a duration of 2 ticks
	dc.b 3, 4 ; play tones[3] for a duration of 4 ticks
	dc.b $ff ; end of tune
	
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

init
	sim
	ldw x, #0
	call timerInit
	call IOInit
	
	bset TIM2_CR1, #0
	RIM

infinite_loop.l
	jra infinite_loop

	interrupt NonHandledInterrupt
NonHandledInterrupt.l
	iret

	interrupt TIM3ISR
TIM3ISR.l	
 	mov TIM3_SR1, #0 ; acknowledge interrupt. do not delete.
	
	bcpl PD_ODR, #6 ;toggle LED 6 to indicate tim3 is working
	ldw x, songIndex 
	
	ld a, (Birthday,x) ; load index of note to play (C=0, D=1, E=2,...)
	cp a , #$ff ;$ff = -1. -1 indicates end of song.
	jrne continue 
	MOV TIM2_CR1,#%00000000 ;if last note: stop timer3
	jra end_tim3isr ;jmp to end of ISR
continue
	call PlayNote ;config of TIM2 to play note has been moved to a subroutine.
	
	incw x ; inc X twice because we need to advance pointer by 2 bytes
	incw x
	ldw songIndex, x ;store pointer
	
end_tim3isr
	iret
	
PlayNote ; configure TIM2 to play frequency
	sll a
	pushw x
	clrw x
	ld xl, a
	
	ldw x, (tones,x)
		ld a, xh
		ld TIM2_ARRH, a
		ld a, xl
		ld TIM2_ARRL, a
		
		srlw x
		ld a, xh
		ld TIM2_CCR1H, a
		ld a, xl
		ld TIM2_CCR1L, a

		popw x
	ret
	
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
	dc.l {$82000000+TIM3ISR}	; irq15
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
