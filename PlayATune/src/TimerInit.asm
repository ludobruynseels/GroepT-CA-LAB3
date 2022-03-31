stm8/

	#include "mapping.inc"
	#include "stm8s105k4.inc"
	
		segment 'rom'
		

	public timerInit
	
timerInit
		MOV TIM2_CR1,#%00000000 ; counter enable ON
		MOV TIM2_IER,#$00 ; no interrupts
		MOV TIM2_CCMR1,#%01100000 ; PWM mode 1 + CC1 as output
		MOV TIM2_CCER1,#%00000001 ; enable CC1 output

		mov TIM2_ARRH, #$1d
		mov TIM2_ARRL, #$ee
		mov TIM2_CCR1H, #$0e
		mov TIM2_CCR1L, #$f7
		
		MOV TIM3_CR1,#%00000000 ; TIM3 OFF
		MOV TIM3_PSCR,#$06 ; prescaler x64
		BSET TIM3_EGR,#0 ; force UEV to update prescaler
		MOV TIM3_IER,#$01 ; TIM3 interrupt on update enabled
		
		;Configure period of the flash in these registers. Leave all others unchanged.
		mov TIM3_ARRH, #$ff
		mov TIM3_ARRL, #$ff
		
		mov TIM3_CNTRH, #0 ;set counter to 0. Do not change!
		mov TIM3_CNTRL, #0 ;set counter to 0. Do not change!
		mov TIM3_SR1, #0
		mov TIM3_CR1, #$81;//Allow reassembly to enable timer
	ret
	
	end
	