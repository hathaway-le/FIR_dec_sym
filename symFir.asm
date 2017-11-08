;
;  Description: This is the assembly implementation of a symmetric FIR filter
;


    .mmregs
    .sect	".text:symFir"
    

    .def _symFir
  
;------------------------------------------------------------------------------
;    void symFir(long  *input,         =>AR0
;                long  *coefficients,  =>AR1
;                long  *output,        =>AR2
;                short  order,         =>T0
;			     long  *value,         =>AR3
;	             short *index,         =>AR4		
;              	)
;------------------------------------------------------------------------------
    
_symFir:
      PSHM  ST1_55                  ; Save ST1, ST2, and ST3
      PSHM  ST2_55
      PSHM  ST3_55   
      PSHBOTH XAR5                  ; Save AR5
      PSHBOTH XAR6                  ; Save AR6
      PSHBOTH XAR7                  ; Save AR0
;-----------------------------------initial-------------------------------------------------------  

      OR     #0x0100,mmap(ST1_55)   ; SXMD=1(open sign extension ) SATD=0 (close Saturation) FRCT=0
      BCLR   CPL                    ; DP   
      MOV    XAR1,XAR7              ; AR7 as coefficient pointer
      MOV    mmap(AR1),BSA67        ; Set up base address for AR7
      MOV    mmap(T0),BK47          ; Set the coefficient array size 
      MOV    XAR3,XAR1              ; AR1 & AR3 are signal buffer pointers
      MOV    mmap(AR3),BSA01        ; Set base address of AR1 for signal buffer
      mov    mmap(AR3),BSA23        ; Set base address of AR3 for signal buffer
      SFTS   T0,#1                  ; order*2 
      MOV    mmap(T0),BK03          ; size = order*2 for int     
      OR     #0x8A,mmap(ST2_55)     ; AR7, AR1, AR3 are circular pointers
      MOV    #0,AR7                 ; Start from the 1st coefficient    
      MOV    *AR4,AR3               ; AR3 is the Head of signal buffer 
      SFTS   T0,#-1                 ; order
      MOV    T0,T1                  ; last shift
      SFTS   T0,#-1                 ; order/2
      SUB    #3,T0                  ; order/2-3            
      MOV    T0,BRC0                ; set up loop counter (order/2-2)   
      MOV    #2,T0                  ; shift    
      MOV    dbl(*(AR0+T0)),dbl(*(AR3-T0))    ; put the new sample to signal buffer 
      MOV    dbl(*AR0),dbl(*AR3)    ; put the next sample to signal buffer   
      AMOV   AR3,AR1               ; AR1 is the Tail of signal buffer      
      AMAR   *+AR1(#-2)              ; Adjust tail starting point	  
      AMOV   #7ff4h,XAR5            ; temp product_64
      AMOV   #7ff8h,XAR6            ; temp sum_64
      AMOV   #7ffCh,XAR0            ; temp sum_32     
      
;-----------------------------------first------------------------------------------------ 

	  MOV40 dbl(*(AR3+T0)),AC0                    ;AC0 = X1 X0
	  ADD   dbl(*(AR1-T0)),AC0                    ;AC0 = X1 X0 + Y1 Y0
	  MOV   AC0,dbl(*AR0)                         
	   
;							     X1 X0*Y1 Y0 = W3 W2 W1 W0         
	  AMAR *AR0+
	  ||AMAR *AR7+
	  AMAR *+AR6(#3)
	  MPYM uns(*AR0-),uns(*AR7),AC0              ;AC0=X0*Y0
	  MOV AC0,*AR6-                              ;save W0
	  MACM *AR0+,uns(*AR7-),AC0>>#16,AC0         ;AC0=X0*Y0>>16+X1*Y0
	  MACM uns(*AR0-),*AR7,AC0                   ;AC0=X0*Y0>>16+X1*Y0+X0*Y1
	  MOV AC0,*AR6-                              ;save W1
	  MACM *AR0,*(AR7+T0),AC0>>#16,AC0           ;AC0=AC0>>16+X1*Y1
	  MOV AC0,*AR6-                              ;save W2
	  MOV HI(AC0),*AR6                           ;save W3  sum=0+product
	        
;-----------------------------------order/2-2 cycles ------------------------------------------------      
      
      RPTB symFir_loop-1    
	  MOV40 dbl(*(AR3+T0)),AC0                    ;AC0 = X1 X0
	  ADD   dbl(*(AR1-T0)),AC0                    ;AC0 = X1 X0 + Y1 Y0
	  MOV   AC0,dbl(*AR0)                         
	        
	  AMAR *AR0+
	  ||AMAR *AR7+
	  AMAR *+AR5(#3)
	  MPYM uns(*AR0-),uns(*AR7),AC0              ;AC0=X0*Y0
	  MOV AC0,*AR5-                              ;save W0
	  MACM *AR0+,uns(*AR7-),AC0>>#16,AC0         ;AC0=X0*Y0>>16+X1*Y0
	  MACM uns(*AR0-),*AR7,AC0                   ;AC0=X0*Y0>>16+X1*Y0+X0*Y1
	  MOV AC0,*AR5-                              ;save W1
	  MACM *AR0,*(AR7+T0),AC0>>#16,AC0      ;AC0=AC0>>16+X1*Y1
	  MOV AC0,*AR5-                              ;save W2
	  MOV HI(AC0),*AR5                           ;save W3     
      
 ;                        X3 X2 X1 X0 + Y3 Y2 Y1 Y0 = W3 W2 W1 W0   	  
	  MOV40 dbl(*AR6(#2)),AC0                    ;AC0 = X1 X0
	  ADD   dbl(*AR5(#2)),AC0                    ;AC0 = X1 X0 + Y1 Y0
	  MOV   AC0,dbl(*AR6(#2))                    ;sum_low+=product_low
	  MOV40 dbl(*AR6),AC0                        ;AC0 = X3 X2
	  ADD   uns(*AR5(#1)),CARRY,AC0              ;AC0 = X3 X2 + 00 Y2 + CARRY
	  ADD   *AR5<<#16,AC0                        ;AC0 = X3 X2 + Y3 Y2 + CARRY
	  MOV   AC0,dbl(*AR6)                        ;sum_high+=product_high+carry		       
symFir_loop     
 ;-----------------------------------the last------------------------------------------------ 
      MOV    T1,T0                                ;last shift
	  MOV40 dbl(*(AR3+T0)),AC0                    ;AC0 = X1 X0
	  ADD   dbl(*AR1),AC0                         ;AC0 = X1 X0 + Y1 Y0
	  MOV   AC0,dbl(*AR0)                         
	        
	  AMAR *AR0+
	  ||AMAR *AR7+
	  AMAR *+AR5(#3)
	  MPYM uns(*AR0-),uns(*AR7),AC0              ;AC0=X0*Y0
	  MOV AC0,*AR5-                              ;save W0
	  MACM *AR0+,uns(*AR7-),AC0>>#16,AC0         ;AC0=X0*Y0>>16+X1*Y0
	  MACM uns(*AR0-),*AR7,AC0                   ;AC0=X0*Y0>>16+X1*Y0+X0*Y1
	  MOV AC0,*AR5-                              ;save W1
	  MACM *AR0,*(AR7+T0),AC0>>#16,AC0      ;AC0=AC0>>16+X1*Y1
	  MOV AC0,*AR5-                              ;save W2
	  MOV HI(AC0),*AR5                           ;save W3   
	  
	  MOV40 dbl(*AR6(#2)),AC0                    ;AC0 = X1 X0
	  ADD   dbl(*AR5(#2)),AC0                    ;AC0 = X1 X0 + Y1 Y0
	  MOV40 dbl(*AR6),AC1                        ;AC1 = X3 X2
	  ADD   uns(*AR5(#1)),CARRY,AC1              ;AC1 = X3 X2 + 00 Y2 + CARRY
	  ADD   *AR5<<#16,AC1                        ;AC1 = X3 X2 + Y3 Y2 + CARRY  
	  
;-----------------------------------Q31->Q32 ------------------------------------------------

	  MOV #0,*AR6                                ; temp 
	  SFTS AC1,#1                                ; shift left
	  SFTSC AC0,#1                               ; shift left and put the last bit into carry
	  ADD *AR6,CARRY,AC1                         ; AC1+=CARRY
	  SFTSC AC0,#1                               ; shift left and put the last bit into carry
	  ADD *AR6,CARRY,AC1                         ; AC1+=CARRY
	  MOV AC1,dbl(*AR2)                          ; Store output data  
	  MOV AR3,*AR4                               ; Return signal buffer index(shift left one long data)
	  
	  POPBOTH XAR7
      POPBOTH XAR6                 
      POPBOTH XAR5                   
      POPM  ST3_55                
      POPM  ST2_55
      POPM  ST1_55  
	  ret
	  .end
	  	  	  