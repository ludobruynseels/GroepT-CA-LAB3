stm8/

	#include "mapping.inc"
	#include "stm8s105k.inc"
	
		public IOInit
LED EQU 5
PB1 EQU 2 ;PC2
PB2 EQU 5 ;PE5

	segment 'rom'
	
IOInit
	mov PD_DDR, #$FF
	mov PD_CR1, #$FF
	mov PD_ODR, #$FF
	
	bset PD_DDR, #LED
	bset PD_CR1, #LED ;push-pull
	bset PD_ODR, #LED
	
	bres PC_DDR, #PB1 ;input
	bres PE_DDR, #PB2 ;input
	
	bres PC_CR1, #PB1 ;floating
	bres PE_CR1, #PB2 ;floating
	
	bset PC_CR2, #PB1 ;interrupt
	bset PE_CR2, #PB2 ;interrupt
	

	ret
	
	end
