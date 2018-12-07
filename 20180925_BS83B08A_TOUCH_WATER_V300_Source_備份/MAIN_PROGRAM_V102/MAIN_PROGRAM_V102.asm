
message '****************************************************************'
message '*PROJECT NAME :MAIN PROGRAM V102                               *'
message '*     VERSION :V102                                            *'
message '* ICE VERSION :                                                *'
message '*      DATE   :20150317                                        *'
message '*      REMARK :V102 modify ESCpowerIDcheck2,PBP                *'
message '****************************************************************'
                ;=INCLUDE REFERENCE FILE
                INCLUDE MAIN_PROGRAM_V102.INC

                ;-PUBLIC LABEL
                PUBLIC  _LOAD_TKS_GLOBE_VARIES
                PUBLIC  _LOAD_HXT_REFERENCE

CALL_   MACRO   FUNCTION
        ifdef   FUNCTION
                ifdef   PBP
                MOV     A,bank FUNCTION
                MOV     PBP,A
                endif
                CALL    FUNCTION
        endif
                ENDM

EXTEND_FUNCTION_INITIAL MACRO
                CALL_   EXTEND_FUNCTION_1A_INITIAL
                CALL_   EXTEND_FUNCTION_1B_INITIAL
                CALL_   EXTEND_FUNCTION_1C_INITIAL
                CALL_   EXTEND_FUNCTION_1D_INITIAL
                CALL_   EXTEND_FUNCTION_1E_INITIAL
                CALL_   EXTEND_FUNCTION_1F_INITIAL
                CALL_   EXTEND_FUNCTION_1G_INITIAL
                CALL_   EXTEND_FUNCTION_1H_INITIAL

                CALL_   EXTEND_FUNCTION_2A_INITIAL
                CALL_   EXTEND_FUNCTION_2B_INITIAL
                CALL_   EXTEND_FUNCTION_2C_INITIAL
                CALL_   EXTEND_FUNCTION_2D_INITIAL
                CALL_   EXTEND_FUNCTION_2E_INITIAL
                CALL_   EXTEND_FUNCTION_2F_INITIAL
                CALL_   EXTEND_FUNCTION_2G_INITIAL
                CALL_   EXTEND_FUNCTION_2H_INITIAL
                ENDM

EXTEND_FUNCTION MACRO
                CALL_   EXTEND_FUNCTION_1A
                CALL_   EXTEND_FUNCTION_1B
                CALL_   EXTEND_FUNCTION_1C
                CALL_   EXTEND_FUNCTION_1D
                CALL_   EXTEND_FUNCTION_1E
                CALL_   EXTEND_FUNCTION_1F
                CALL_   EXTEND_FUNCTION_1G
                CALL_   EXTEND_FUNCTION_1H

                CALL_   EXTEND_FUNCTION_2A
                CALL_   EXTEND_FUNCTION_2B
                CALL_   EXTEND_FUNCTION_2C
                CALL_   EXTEND_FUNCTION_2D
                CALL_   EXTEND_FUNCTION_2E
                CALL_   EXTEND_FUNCTION_2F
                CALL_   EXTEND_FUNCTION_2G
                CALL_   EXTEND_FUNCTION_2H
                ENDM
                ;==============
                ;=DATA SETCTION
                ;==============
MAIN_DATA       .SECTION          'DATA'

ifndef  ESCpowerIDcheck
POR_ID          DB      2 DUP(?)
endif



                ;==============
                ;=CODE SETCTION
                ;==============
PROGRAM_ENTRY   .SECTION  AT 000H 'CODE'
        ifdef   PBP
                CLR     PBP
                ifndef  ESCpowerIDcheck
                MOV     A,042H      ;ASCII = B
                endif
        else
                ;----------------
                ;-SET POR ID 1---
                ;----------------
                ifndef  ESCpowerIDcheck
                MOV     A,042H      ;ASCII = B
                SNZ     TO
                MOV     POR_ID[0],A
                endif
        endif
        		
                JMP     PROGRAM_RESET

                ;==============
                ;=MAIN PROGRAM=
                ;==============
MAIN_PROGRAM    .SECTION          'CODE'

                ;;***********************
PROGRAM_RESET:  ;;* PROGRAM ENTRY *******
                ;;***********************
        ifdef   PBP
                ifndef  ESCpowerIDcheck
                SNZ     TO
                MOV     POR_ID[0],A
                endif
        endif
                ;----------------
                ;-SET POR ID 2---
                ;----------------
        ifndef  ESCpowerIDcheck
                MOV     A,053H      ;ASCII = S
                MOV     POR_ID[1],A
        endif


                ;---------------------
                ;-MCU HARDWARE INITIAL
                ;---------------------
                MCU_HARDWARE_INITIAL

                ;------------------------------
                ;-LOAD LIBRARY OPTION/THRESHOLD
                ;------------------------------
                CALL    _LOAD_TKS_GLOBE_VARIES

                ;------------------------
                ;-EXTEND FUNCTION INITIAL
                ;------------------------
                EXTEND_FUNCTION_INITIAL

                ;;-----------------------
MAIN_LOOP:      ;;- MAIN PROGRAM LOOP ---
                ;;-----------------------
                CLR     WDT
                CLR     WDT1
                CLR     WDT2


                ;----------------
                ;-CHECK POR ID --
                ;----------------
        ifndef  ESCpowerIDcheck
                MOV     A,042H
                XORM    A,POR_ID[0]
                MOV     A,053H
                SZ      Z
                XORM    A,POR_ID[1]
                SNZ     Z
                JMP     000H
        endif
                ;----------------------
                ;-RE INITIAL SYS. CLOCK
                ;----------------------
                RELOAD_SYS_CLOCK
                EXTEND_FUNCTION
                ;----------------
                ;-SET POR ID  ---
                ;----------------
        ifndef  ESCpowerIDcheck
                MOV     A,042H      ;ASCII = B
                MOV     POR_ID[0],A
                MOV     A,053H      ;ASCII = S
                MOV     POR_ID[1],A
        endif

                ;--------------------
WDT_WAKEUP:     ;-WDT WAKEUP FUNCTION
                ;--------------------
;                if      PowerSave==1
;                CALL_   _CHECK_KEY_WAKEUP
;                endif

                ifdef   PBP
                MOV     A,BANK MAIN_LOOP
                MOV     PBP,A
                endif
                JMP     MAIN_LOOP









;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
CLEAR_RAM:
                MOV     MP1,A
        ifndef  ESCpowerIDcheck
            ifdef  BP
                ;-CHECK BANK
                SZ      BP
                JMP     CLR_RAM
            endif
                ;-CHECK POR_ID RAM
                MOV     A,OFFSET POR_ID
                XOR     A,MP1
                MOV     A,OFFSET POR_ID+1
                SNZ     Z
                XOR     A,MP1
                SNZ     Z
        endif
CLR_RAM:        ;-CLEAR RAM
                CLR     IAR1
                SIZA    MP1
                JMP     CLEAR_RAM

                RET


;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_LOAD_TKS_GLOBE_VARIES:
_LOAD_HXT_REFERENCE:
                ;------------------------
                ;-SET TKS LIBRARY OPTION-
                ;------------------------
                MOV     A,GlobeOptionA
                MOV     _GLOBE_VARIES[0],A
                MOV     A,GlobeOptionB
                MOV     _GLOBE_VARIES[1],A
                MOV     A,GlobeOptionC
                MOV     _GLOBE_VARIES[2],A
				
                ;--------------------------
                ;-SET TOUCH OR IO ATTRIBUTE
                ;--------------------------
                
                MOV     A,IO_TOUCH_ATTR&0FFH
                MOV     _KEY_IO_SEL[0],A
                ;-IF OVER 2 TOUCH IP (8~16KEY)
                if      KeyAmount > 8
                MOV     A,(IO_TOUCH_ATTR>>8)&0FFH
                MOV     _KEY_IO_SEL[1],A
                endif
                ;-IF OVER 4 TOUCH IP (17~24KEY)
                if      KeyAmount > 16
                MOV     A,(IO_TOUCH_ATTR>>16)&0FFH
                MOV     _KEY_IO_SEL[2],A
                endif
                ;-IF OVER 6 TOUCH IP (25~32KEY)
                if      KeyAmount > 24
                MOV     A,(IO_TOUCH_ATTR>>24)&0FFH
                MOV     _KEY_IO_SEL[3],A
                endif

                ;------------------------
                ;-SET TOUCH KEY THRESHOLD
                ;------------------------
                ;-KEY1 THRESHOLD
                MOV     A,Key1Threshold
                MOV     _GLOBE_VARIES[3],A

                ;-KEY2 THRESHOLD
                MOV     A,Key2Threshold
                MOV     _GLOBE_VARIES[4],A

                ;-KEY3 THRESHOLD
                MOV     A,Key3Threshold
                MOV     _GLOBE_VARIES[5],A

                ;-KEY4 THRESHOLD
                MOV     A,Key4Threshold
                MOV     _GLOBE_VARIES[6],A

                RET




                END



