;;;
;;; Stub for VIA interrupt Registers
;;; 

; 6522 VIA
;VIA             := $FFD0        ; VIA base address - set in config.asm because it doesn't work if included here.
VIA_PB      := VIA+$0                         ; Port register B
VIA_PA1     := VIA+$1                         ; Port register A
VIA_PRB     := VIA+$0                         ; *** Deprecated ***
VIA_PRA     := VIA+$1                         ; *** Deprecated ***
VIA_DDRB    := VIA+$2                         ; Data direction register B
VIA_DDRA    := VIA+$3                         ; Data direction register A
VIA_T1CL    := VIA+$4                         ; Timer 1, low byte
VIA_T1CH    := VIA+$5                         ; Timer 1, high byte
VIA_T1LL    := VIA+$6                         ; Timer 1 latch, low byte
VIA_T1LH    := VIA+$7                         ; Timer 1 latch, high byte
VIA_T2CL    := VIA+$8                         ; Timer 2, low byte
VIA_T2CH    := VIA+$9                         ; Timer 2, high byte
VIA_SR      := VIA+$A                         ; Shift register
VIA_CR      := VIA+$B                         ; Auxiliary control register
VIA_PCR     := VIA+$C                         ; Peripheral control register
VIA_IFR     := VIA+$D                         ; Interrupt flag register
VIA_IER     := VIA+$E                         ; Interrupt enable register
VIA_PA2     := VIA+$F                         ; Port register A w/o handshake

;***********************************************************************************;
;
; Send byte to UART, wait until UART is ready to transmit
; A, X and Y register contents remain unchanged

UAPUTW:     RTS

;***********************************************************************************;
;
; Get received byte from UART, result returned in A,
; returns A=0 if no character available for reading
; X and Y register contents remain unchanged

UAGET:      RTS
UAGETW:     RTS

;***********************************************************************************;
      
UAEXIT:     RTS                               ; Exit to BASIC or return to SMON if no underlying OS

