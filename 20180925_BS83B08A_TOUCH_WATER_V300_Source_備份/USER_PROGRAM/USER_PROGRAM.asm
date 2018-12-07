        

message '***************************************************************'
message '*PROJECT NAME :USER PROGRAM CODE                              *'
message '*     VERSION :                                               *'
message '*     IC BODY :                                               *'
message '* ICE VERSION :                                               *'
message '*      REMARK :                                               *'
message '***************************************************************'

                INCLUDE USER_PROGRAM.INC

                PUBLIC  _USER_PROGRAM_INITIAL
                PUBLIC  _USER_PROGRAM 


                ;========================
                ;=USER DATA DEFINE      =
                ;========================
USER_DATA       .SECTION   'DATA'

_UA_ON_OFF 	dbit
_KEY_OFF	dbit

                ;========================
                ;=USER PROGRAM          =
                ;========================
USER_PROGRAM    .SECTION   'CODE'
                           
;;***********************************************************                           
;;*SUB. NAME:USER INITIAL PROGRAM                           *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************                           
                      ;;************************
_USER_PROGRAM_INITIAL:;;* USER_PROGRAM_INITIAL *
                      ;;************************

               	CLR     PAC
               	CLR     PA
               	CLR     PBC
               	CLR     PB
                RET




;;***********************************************************                           
;;*SUB. NAME:USER_MAIN                                      *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************                           
                ;;********************
_USER_PROGRAM:  ;;USER PROGRAM ENTRY *
                ;;********************

                SNZ     _SCAN_CYCLEF
                RET
                
                SNZ     _ANY_KEY_PRESSF
                clr		_KEY_OFF
                SNZ     _ANY_KEY_PRESSF
                jmp		CHECK_UN_ON_OFF_BIT
                
                sz		_KEY_OFF
                jmp		CHECK_UN_ON_OFF_BIT
                set		_KEY_OFF
                
                snz		_UA_ON_OFF
                jmp		$+3                
                clr		_UA_ON_OFF
                jmp		CHECK_UN_ON_OFF_BIT
                set		_UA_ON_OFF
          CHECK_UN_ON_OFF_BIT:
          		;mov		A,100H-183	;30ms
          		;mov		A,100H-122	;20ms
          		mov		A,100H-61	;10ms
          		;mov		A,100H-30	;5ms
          		mov		_Ultrasonic_Atomizer_Working_Time,A
          		
                sz		_UA_ON_OFF
                SET     _Ultrasonic_Atomizer_WORK
                snz		_UA_ON_OFF
                CLR     _Ultrasonic_Atomizer_WORK
                
                RET
