message '***************************************************************'
message '*PROJECT NAME :BS83B08A CTOUCH  V5.01                         *'
message '*     VERSION :                                               *'
message '*     IC BODY :BS83B08A                                       *'
message '* ICE VERSION :ICE VERSION IDE3000V7.93                       *'
message '*      REMARK :                                               *'
message '***************************************************************'


;;        #define OneKeyActiveFunction            ;Touch channel scan type
;;      #define CStestMode                      ;for cs test define / test key1~key4



        #define LibraryVersion          501H
        ;--
        #define BalanceCentralPoint     128
        #define UnBalanceOffset         18
        #define NoiseLevel              16
        ;--
        #define RAMbank0Address         060H
;;      #define RAMbank1Address         080H
;;      #define RAMbank2Address         080H
;;      #define RAMbank3Address         080H
        ;--
        #define TouchINTaddress         008H
        #define LibraryVersionAddress   TouchINTaddress + 3
        #define TouchTimeBaseINTaddress 014H



        INCLUDE BS83B08A_CTOUCH_WATER_V501.INC
        INCLUDE BS83B08A_CTOUCH_WATER_V501.MCU

        ;-SUBROUTIN
        PUBLIC  _BS83B08A_CTOUCH_WATER_V501_INITIAL
        PUBLIC  _BS83B08A_CTOUCH_WATER_V501
        PUBLIC  _LIBRARY_RESET
        PUBLIC  _GET_KEY_BITMAP
        PUBLIC  _GET_ENV_VALUE
        PUBLIC  _GET_REF_VALUE
        PUBLIC  _GET_RCC_VALUE
        PUBLIC  _GET_LIB_VER
        PUBLIC  _GET_KEY_AMOUNT
        PUBLIC  _GET_KEY_AMOUNTx3
        PUBLIC  _CHECK_KEY_WAKEUP

        ;-DATA
        PUBLIC  _DATA_BUF
        PUBLIC  _GLOBE_VARIES
        PUBLIC  _KEY_REF
        PUBLIC  _KEY_STATUS
        PUBLIC  _TKS_TIME_BASE
        ;PUBLIC  _STANDBY_TIME
        PUBLIC  _KEY_IO_SEL
        PUBLIC  _KEY_DATA

        ;-FLAG
        PUBLIC  _TKS_FLAGA
        PUBLIC  _SCAN_CYCLEF
        PUBLIC  _FORCE_CALIBRATEF
        PUBLIC  _ANY_KEY_PRESSF
        PUBLIC  _TKS_ACTIVEF
        PUBLIC  _TKS_63MSF
        PUBLIC  _TKS_250MSF
        PUBLIC  _TKS_500MSF

        ;-----------------
        ;-RAM BANK DECLARE
        ;-----------------
ifdef   RAMbank0Address
        RAMBANK 0 CTOUCH_DATA0
endif
;----------------------------------
ifdef   RAMbank1Address
        RAMBANK 1 CTOUCH_DATA1
endif
;----------------------------------
ifdef   RAMbank2Address
        RAMBANK 2 CTOUCH_DATA2
endif
;----------------------------------
ifdef   RAMbank3Address
        RAMBANK 3 CTOUCH_DATA3
endif
;----------------------------------

        ;-DATA LENGTH DEFINE
        #define         BYTE_DATA               1       ;BYTE
        #define         WORD_DATA               2       ;WORD


;--------------------------------
;------- RAM BANK0 AREA ---------
;--------------------------------
        CTOUCH_DATA0            .SECTION AT RAMbank0Address   'DATA'

;-TKS GLOBE VARIES
_GLOBE_VARIES   DB      KeyAmount+3 DUP(?)
TKS_OPTIONA     EQU     0
TKS_OPTIONB     EQU     1
TKS_OPTIONC     EQU     2
KEY1_THR        EQU     3
KEY2_THR        EQU     4
KEY3_THR        EQU     5
KEY4_THR        EQU     6
if      KeyAmount > 4
KEY5_THR        EQU     7
KEY6_THR        EQU     8
KEY7_THR        EQU     9
KEY8_THR        EQU     10
endif
if      KeyAmount > 8
KEY9_THR        EQU     11
KEY10_THR       EQU     12
KEY11_THR       EQU     13
KEY12_THR       EQU     14
endif
if      KeyAmount > 12
KEY13_THR       EQU     15
KEY14_THR       EQU     16
KEY15_THR       EQU     17
KEY16_THR       EQU     18
endif
;-OPTION A BIT DEFINE
DBCE_DEF0       EQU     0
DBCE_DEF1       EQU     1
DBCE_DEF2       EQU     2
DBCE_DEF3       EQU     3
CALIBRATE_TIME0 EQU     4
CALIBRATE_TIME1 EQU     5
CALIBRATE_TIME2 EQU     6
CALIBRATE_TIME3 EQU     7
;-OPTION B BIT DEFINE
SENS_LEVEL      EQU     0       ;0/2=SENSITIVITY LOW ; 1/2=SENSITIVITY HIGH
;               EQU     1
;               EQU     2
;               EQU     3
MAXON0          EQU     4       ;0=MAXIMUM ON TIME DISABLE
MAXON1          EQU     5
MAXON2          EQU     6
MAXON3          EQU     7
;-OPTION C BIT DEFINE
RESERVEA_OPN    EQU     0
RESERVEB_OPN    EQU     1
SAMPLE_SPEED    EQU     2       ;0/1 NORMAL/FAST SAMPLING SPEED
AUTO_RS         EQU     3       ;0/1 MANUAL/AUTO SELECT RS
CS_PROTECT      EQU     4       ;0/1 DISABLE/ENABLE CS PROTECT MODE
ONE_KEY_ACTIVE  EQU     5       ;0/1 ONE/ANY KEY ACTIVE
POWER_SAVE      EQU     6       ;0/1 DISABLE/ENABLE POWER SAVING MODE
ACTIVE_LOGIC    EQU     7       ;0/1 DISABLE/ENABLE UPDATE REFERENCE WHEN PRESS

PWM_SYNC        EQU     5

;-COMMON RAM DEFINE
_DATA_BUF       DB      8 DUP(?)
POS_COUNT       EQU     _DATA_BUF[0]
HYSTERESIS      EQU     _DATA_BUF[1]
NEG_COUNT       EQU     _DATA_BUF[2]
KPRESS_AMOUNT   EQU     _DATA_BUF[5]
MAX_COUNT       EQU     _DATA_BUF[6]
MAX_COUNT_CHANNEL EQU   _DATA_BUF[7]
;-MP & BP BUFFER
BP_BUF          EQU     _DATA_BUF[2]
MP_BUF          EQU     _DATA_BUF[3]
;TKMX16DL_BUF    DB      ?
;TKMX16DH_BUF    DB      ?


;-LIBRARY USED RAM DEFINE
;_STANDBY_TIME   DB      ?
_TKS_TIME_BASE  DB      ?
TKS_STACK       DB      4 DUP(?)
_KEY_IO_SEL     DB      ((KeyAmount-1)/8)+1 DUP(?)   ;BIT CONETNT 1=KEY 0=IO
_KEY_DATA       DB      ((KeyAmount-1)/8)+1 DUP(?)
TKM_BUF         DB      ((KeyAmount/4)+1) DUP(?)
KEY_BUF         DB      ((KeyAmount-1)/8)+1 DUP(?)
KEY_DBCE        DB      ?
KEY_STATE_BUF   DB      ?
CHANNEL_INDEX   DB      ?
BALANCE_BUF     DB      2 DUP(?)
SAMPLE_TIMES    DB      ?
;;POWER_ON_STABLEF EQU   SAMPLE_TIMES.6

;HALT_CAL_TIME   DB      ?
;;CS_STAY_TIME    DB      ?

TKS_TIMER       DB      ?
TKS_TIMERB      DB      ?
;--
CAL_TIMER       DB      ?
UNBALANCE_TIMER EQU     BALANCE_BUF[1]
;HALT_DATA_BUF   EQU     TKS_TIMER


;-LIBRARY USED FLAG DEFINE
_TKS_FLAGA      LABEL   BYTE    ;for C complier V3
_FORCE_CALIBRATEF DBIT
_TKS_ACTIVEF    DBIT
_SCAN_CYCLEF    DBIT
_ANY_KEY_PRESSF DBIT
_TKS_63MSF      DBIT
_TKS_250MSF     DBIT
_TKS_500MSF     DBIT
POWER_ON_STABLEF DBIT
;;UNBALANCEF      DBIT

ifdef   RAMbank1Address
;--------------------------------
;------- RAM BANK1 AREA ---------
;--------------------------------
        CTOUCH_DATA1            .SECTION AT RAMbank1Address  'DATA'
endif

;-KEY STATUS & TIMER RAM DEFINE
_KEY_STATUS     DB      KeyAmount*(WORD_DATA) DUP(?)
KEY_PRESSF      EQU     7
KEY_DBCE2       EQU     6
KEY_DBCE1       EQU     5
KEY_DBCE0       EQU     4
;--
CS_INTERFEREF   EQU     3
FILTER_DIRF     EQU     2
IIR_LOOP1       EQU     1
IIR_LOOP0       EQU     0
;--
_KEY_TIMER      EQU     _KEY_STATUS+1


;-DEFINE KEY_REF RAM
_KEY_REF        DB      KeyAmount*(WORD_DATA+WORD_DATA) DUP(?)
_KEY_FREQ       EQU     _KEY_REF+1
_BALANCE_CAP3M  EQU     _KEY_REF+2
_BALANCE_CAP11M EQU     _KEY_REF+3

ifdef   RAMbank2Address
;--------------------------------
;------- RAM BANK2 AREA ---------
;--------------------------------
        CTOUCH_DATA2            .SECTION AT RAMbank2Address  'DATA'
endif

;-DEFINE FILTER RAM
_M3_LIMIT       DB      KeyAmount*(WORD_DATA+WORD_DATA) DUP(?)
_M3_MAXA        EQU     _M3_LIMIT+0
_M3_MAXB        EQU     _M3_LIMIT+1
_M3_MINA        EQU     _M3_LIMIT+2
_HL_DIFF_MAX    EQU     _M3_LIMIT+3
;_M3_HL_DIFF     EQU     _M3_LIMIT+3
;--
_M11_LIMIT      DB      KeyAmount*(WORD_DATA+WORD_DATA) DUP(?)
_M11_MAXA       EQU     _M11_LIMIT+0
_M11_MAXB       EQU     _M11_LIMIT+1
_M11_MINA       EQU     _M11_LIMIT+2
;_M11_HL_DIFF    EQU     _M11_LIMIT+3
_LAST_FREQ      EQU     _M11_LIMIT+3

UNBALANCEF      		EQU   	SAMPLE_TIMES.7


WATER_TOUCH_COUNTER DB  ?

ifdef   RAMbank3Address
;--------------------------------
;------- RAM BANK3 AREA ---------
;--------------------------------
        CTOUCH_DATA3            .SECTION AT RAMbank3Address  'DATA'

endif

                ;==============
                ;=TKM  INT. ===
                ;==============
TOUCH_INT       .SECTION  AT TouchINTaddress  'CODE'
                SET     EMI
                JMP     _TKS_SAMPLING_INT
                ;RETI
                ;==============
                ;=LIB VERSION =
                ;==============
CTOUCH_VERSION  .SECTION  AT LibraryVersionAddress 'CODE'
                DC      LibraryVersion

                ;==============
                ;=TIME BASE INT.
                ;==============
TIME_BASE_INT   .SECTION  AT TouchTimeBaseINTaddress 'CODE'
                ;-COUNT _TKS_TIME_BASE
                SIZ     _TKS_TIME_BASE
                RETI
                SET     _TKS_TIME_BASE
                RETI




CTOUCH_CODE             .SECTION   'CODE'
;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_BS83B08A_CTOUCH_WATER_V501:

                ;-CLEAR FLAG
                CLR     _SCAN_CYCLEF
                CLR     _TKS_500MSF     ;500 MSF
                CLR     _TKS_250MSF     ;250 MSF
                CLR     _TKS_63MSF      ;62.5 MSF

                ;------------------------
                ;-WAIT SAMPLING DONE ----
                ;------------------------
                SZ      TKST
                JMP     CHECK_SYNC_TIME

                ;-CHECK IF TKS ACTIVE
                SNZ     _TKS_ACTIVEF
                CALL    _PON_CALIBRATE
                ;--

		SNZ     _TKS_ACTIVEF
		JMP     $+5
		SNZ	WATER_TOUCH_COUNTER.1
		INC     WATER_TOUCH_COUNTER
		SZ      WATER_TOUCH_COUNTER.1
		JMP     CHECK_SYNC_TIME

                CALL    _TKM_RESET
                CALL    _LOAD_BALCAP

                ;-IF TIMER INT DISAPPEAR
                SNZ     TB0E
                CALL    TBASE_INITIAL

                ;------------------------
CHECK_SYNC_TIME:;-CHECK SYNC. TIME 10.49MS
                ;------------------------
                ;-CHECK 10.49MS
                ;-CHECK 15.61MS
                MOV     A,100H-61;91;61    ;FOR 12M
                SZ      CTRL.5
                SZ      CTRL.4
                MOV     A,100H-41;61;41       ;FOR 8M/16M
                ADD     A,_TKS_TIME_BASE
                SNZ     C
                RET
                MOV     _TKS_TIME_BASE,A

		CLR	WATER_TOUCH_COUNTER
                CALL    _TKS_TIMER

                ;----------------
                ;-IF TKS ACTIVE -
                ;----------------
                SNZ     _TKS_ACTIVEF
                RET

                ;-COUNT PROCESS ORDER
                INC     SAMPLE_TIMES
                SZ      SAMPLE_TIMES.4
                CLR     SAMPLE_TIMES.4

                CALL    _TKS_FILTER

                CALL    _TKS_STATE_CHECK

                CALL    _NORMAL_CALIBRATE

                CALL    _CHECK_KEY_TIMER

                CALL    _FORCE_CALIBRATE

                CALL    _RE_BALANCE             ;MUST BE IN LAST CALL

				;-- WATER FUNCTION --


;                ;------------------------
;        ifdef   CStestMode
;                ;------------
;                ;-FOR CS TEST
;                ;------------
;
;          ;;    ;-TEST
;          ;;    CLR     PAC.1
;          ;;    SNZ     KEY_STATE_BUF.CS_INTERFEREF
;          ;;    CLR     PA.1
;          ;;    SZ      KEY_STATE_BUF.CS_INTERFEREF
;          ;;    SET     PA.1
;
;
;                ;-TEST 1~4
;                CLR     _DATA_BUF[0]
;TEST_LOOP:
;                MOV     A,_DATA_BUF[0]
;                MOV     CHANNEL_INDEX,A
;             ;  CALL    GET_M3_HL_MPX
;                CALL    GET_HL_DIFF_MAX_MPX
;                MOV     A,IAR1
;                MOV     _DATA_BUF[2],A
;
;                CALL    GET_M11_LIMIT_MPX
;                INC     MP1
;                INC     MP1
;                INC     MP1
;                MOV     A,IAR1
;                MOV     _DATA_BUF[3],A
;
;                MOV     A,_DATA_BUF[0]
;                ADD     A,4
;                MOV     CHANNEL_INDEX,A
;                CALL    GET_KEY_REF_MPX ;REF
;                MOV     A,_DATA_BUF[2]
;                MOV     IAR1,A          ;SAVE 3M HL DIFF
;
;                INC     MP1             ;FREQ
;                MOV     A,_DATA_BUF[3]
;                MOV     IAR1,A          ;SAVE 11M HL DIFF
;
;
;                INC     _DATA_BUF[0]
;                MOV     A,_DATA_BUF[0]
;                SUB     A,4
;                SNZ     C
;                JMP     TEST_LOOP
;        endif   ;------------------------

                RET





;;;***********************************************************
;;;*SUB. NAME:                                               *
;;;*INPUT    :                                               *
;;;*OUTPUT   :                                               *
;;;*USED REG.:                                               *
;;;*FUNCTION :                                               *
;;;***********************************************************
_BS83B08A_CTOUCH_WATER_V501_INITIAL:
_LIBRARY_RESET:

                ;-BALANCE INITIAL
                CLR     BALANCE_BUF[1]
                MOV     A,10000000B
                MOV     BALANCE_BUF[0],A
                ;-SET BALANCE CAP
                CLR     CHANNEL_INDEX
                ;--
                CALL    GET_BALANCE_CAP_MPX
                MOV     A,BALANCE_BUF[0]
                MOV     IAR1,A
                INC     MP1
                MOV     IAR1,A
                CALL	CHECK_AMOUNT
                SNZ     C
                JMP     $-7

                ;-VARIES INITIAL
                CLR     _TKS_ACTIVEF
                CLR     UNBALANCE_TIMER
                SET     KEY_DBCE

		CLR     TKS_TIMERB
		CLR     TKS_TIMER

                ;-TKM INITIAL
                CALL    _TKM_RESET
                CALL    _LOAD_BALCAP
                SET     TKME

                SET     _FORCE_CALIBRATEF
                CALL    _FORCE_CALIBRATE

                ;------------------
TBASE_INITIAL:  ;-TIME BASE INITIAL
                ;------------------
                MOV     A,00100000B     ;256 us BASE ON 16MHZ
              ;;MOV     A,00010000B     ;128 us BASE ON 16MHZ
                SNZ     CTRL.5
                SNZ     CTRL.4
              ;;MOV     A,00000000B     ;128 us BASE ON 8MHZ ; 85.S uS BASE ON 12MHZ
                MOV     A,00010000B     ;256 us BASE ON 8MHZ ; 170.6 uS BASE ON 12MHZ
                MOV     TBC,A
                SET     TBE
                SET     EMI
                RET



;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
#define         SampleA                 1024
#define         SampleB                 2048

#define         SampleWindowLimitA      (SampleA-BalanceCentralPoint)
#define         SampleWindowLimitB      (SampleB-BalanceCentralPoint)

#define         TKTMRA                  (SampleA/64)
#define         TKTMRB                  (SampleB/64)

_TKM_RESET:

		;-SET MAIN FREQ
		MOV     A,00000001B             ;3MHZ
		MOV     TKC1,A
		;--
		CLR     TKC0

		;-SET SAMPLING LENGTH (PRE X 2)
		MOV     A,256-TKTMRA;28;32;24;20;16          ;SET 1024+1024             ;SET 1024 COUNT
		SZ      _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
		MOV     A,256-TKTMRB;44;36;32          ;SET 2048+1024             ;SET 2048 COUNT
		MOV     TKTMR,A


		;-INITIAL TKMXC0
		MOV     A,00100111B     ;DEN/FEN
		SZ      _GLOBE_VARIES[TKS_OPTIONC].AUTO_RS
		MOV     A,00101111B     ;DEN/FEN/RSEN
		MOV     TKM0C0,A        ;KEY 4

		;-- BS83B08A touch setting---
		MOV     A,_KEY_IO_SEL[0]
		AND     A,00001111B
		MOV     TKM0C1,A


                RET





;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_TKS_SAMPLING_INT:
                ;-PUSH
                MOV     TKS_STACK[0],A
                MOV     A,STATUS
                MOV     TKS_STACK[1],A
                MOV     A,MP1
                MOV     TKS_STACK[2],A
                MOV     A,BP
                MOV     TKS_STACK[3],A

                ;-SET SAMPLE COUNT
                MOV     A,HIGH SampleWindowLimitA
                SZ      _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                MOV     A,HIGH SampleWindowLimitB
                MOV     MP1,A           ;TEMP USE MP1 AS BUFFER
                ;--
                MOV     A,LOW SampleWindowLimitA
                SZ      _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                MOV     A,LOW SampleWindowLimitB
                MOV     TKM_BUF[0],A

                ;-READ TKM0 COUNT
                MOV     A,TKM016DL
                SUBM    A,TKM_BUF[0]
                MOV     A,TKM016DH
                SBC     A,MP1
                SZ      ACC
                SET     TKM_BUF[0]
                SNZ     C
                CLR     TKM_BUF[0]


                ;-GET KEY_LIMIT MP & BP
                SWAPA   TKM0C0          ;X4
                AND     A,00001100B
                MOV     MP1,A
                MOV     A,OFFSET _M3_LIMIT
                SZ      TKC1.1
                MOV     A,OFFSET _M11_LIMIT
                ADDM    A,MP1           ;MAXA
                ;--
                MOV     A,BANK _M3_LIMIT
                SZ      TKC1.1
                MOV     A,BANK _M11_LIMIT
                MOV     BP,A
                ;--

                ;-IF TKS READY
                SZ      _TKS_ACTIVEF
                JMP     SORTING_LIMIT

                ;-----------------
                ;-SUM TKMx COUNTS-
                ;-----------------
                ;-SUM TKM0 COUNTS
                MOV     A,TKM_BUF[0]
                ADDM    A,IAR1
                INC     MP1             ;MAXB
                CLR     ACC
                ADCM    A,IAR1
                ;------------------------

                JMP     SAMPLING_NEXT

                ;------------------------
SORTING_LIMIT:  ;-SORT M3/M11 LIMIT     -
                ;------------------------
                ;-SORT TKM0 LIMIT
                ;-MAXA
                MOV     A,TKM_BUF[0]
                SUB     A,IAR1
                SZ      C
                ADDM    A,IAR1
                ;-MAXB
                INC     MP1
                MOV     A,TKM_BUF[0]
                SUB     A,IAR1
                SZ      C
                ADDM    A,IAR1
                ;-MINA
                INC     MP1
                MOV     A,TKM_BUF[0]
                SUB     A,IAR1
                SNZ     C
                ADDM    A,IAR1
                ;------------------------


SAMPLING_NEXT:  ;-SAMPLING NEXT KEY
                ;-SCAN TYPEA
                CLR     TKC0
                MOV     A,01000000B
                ADDM    A,TKM0C0
   if KeyAmount == 4
                SNZ     C
                JMP     _LOAD_BALCAP
   endif
   if KeyAmount == 2
   				snz		TKM0C0.7
                JMP 	_LOAD_BALCAP
   				clr		TKM0C0.7
   endif
   if KeyAmount == 3
   				sz	TKM0C0.6
   				snz	TKM0C0.7
                JMP _LOAD_BALCAP
                clr	TKM0C0.6
   				clr	TKM0C0.7
   endif
   if KeyAmount == 1
                clr	TKM0C0.6
   				clr	TKM0C0.7
   endif
                ;-CHANGE TO 7M OR 11M
                MOV     A,00000010B     ;11M
                SZ      _GLOBE_VARIES[TKS_OPTIONC].CS_PROTECT
                MOV     A,00000011B     ;7M
                XORM    A,TKC1
                SNZ     TKC1.1
                JMP     END_SAMPLING_INT


                ;------------------------
_LOAD_BALCAP:   ;-LOAD BALANCE CAP. VALUE
                ;------------------------
                ;-TURN ON KEY/REF. OSC.
                MOV     A,00110000B
                ORM     A,TKM0C1
                ;-LOAD BALANCE CAP.
                MOV     A,BANK _KEY_REF
                MOV     BP,A
                SWAPA   TKM0C0
                AND     A,00001100B     ;X4
                ADD     A,OFFSET _BALANCE_CAP3M
                SZ      TKC1.1
                INC     ACC
                MOV     MP1,A
                ;-25P 256 STEP
                CLR     C
                RLCA    IAR1
                MOV     TKM0ROL,A
                CLR     TKM0ROH
                RLC     TKM0ROH
                ;-50P 256 STEP
                CLR     C
                RLC     TKM0ROL
                RLC     TKM0ROH

END_SAMPLING_INT:;-POP
                MOV     A,TKS_STACK[3]
                MOV     BP,A
                MOV     A,TKS_STACK[2]
                MOV     MP1,A
                MOV     A,TKS_STACK[1]
                MOV     STATUS,A
                MOV     A,TKS_STACK[0]
                ;-IF END SAMPLING (REF. OCS. OFF)
                SNZ     TKM0C1.4
                RETI
                ;-RE-START SAMPLING
                CLR     EMI
                SET     TKST
                RETI





;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_TKS_FILTER:
              ;;;-TEST
              ;;MOV     A,000000010B
              ;;XORM    A,PA

                CLR     _DATA_BUF[1]
                CLR     CHANNEL_INDEX
                ;-------------
FILTER_LOOP:    ;-FILTER LOOP
                ;-------------

                ;-GET KEY STATUS
                CALL    GET_KEY_STATUS_MPX
                MOV     A,IAR1
                MOV     _DATA_BUF[0],A

                ;----------------
                ;-GET 11M LIMIT
                ;----------------
                CALL    GET_M11_LIMIT_MPX
                ;-GET MAX               ;11M MAXA
                SZ      SAMPLE_TIMES.0
                INC     MP1             ;11M MAXB
                MOV     A,IAR1
                CLR     IAR1            ;RERET MAX TO 0
                MOV     _DATA_BUF[7],A  ;GET 11M MAX
                ;-GET H/L DIFFERENT
                SNZ     SAMPLE_TIMES.0
                JMP     $+7
                INC     MP1
                SUB     A,IAR1
                SET     IAR1
                SNZ     C
                CLR     ACC
                MOV     _DATA_BUF[5],A

                ;----------------
                ;-GET 3M LIMIT
                ;----------------
                CALL    GET_M3_LIMIT_MPX
                ;-GET MAX               ;3M MAXA
                SZ      SAMPLE_TIMES.0
                INC     MP1             ;3M MAXB
                MOV     A,IAR1
                CLR     IAR1
                MOV     _DATA_BUF[6],A  ;GET 3M MAX
                ;-GET H/L DIFFERENT
                SNZ     SAMPLE_TIMES.0
                JMP     CHECK_BAL_POINT
                INC     MP1
                SUB     A,IAR1          ;3M H-L
                SET     IAR1
                SNZ     C
                CLR     ACC

                ;-GET 3M/11 HL DIFF MAX
                SUB     A,_DATA_BUF[5]  ;COMPARE M3/M11 HL DIFF.
                SZ      C
                ADDM    A,_DATA_BUF[5]  ;SWAP
                ;-HL_DIFF_MAX IIR
                INC     MP1             ;HL_DIFF_MAX
                MOV     A,_DATA_BUF[5]
                SUB     A,IAR1
                SNZ     C
                JMP     $+5
                ;1/2 IIR RISING
                MOV     A,_DATA_BUF[5]
                ADDM    A,IAR1
                RRC     IAR1
                JMP     $+5
                ;-1/16 IIR FALLING
                SWAP    ACC
                AND     A,00001111B
                OR      A,11110000B
                ADDM    A,IAR1


                ;-CHECK CS INTERFERE
              ;;;-IF KEY PRESSED NO CHECK CS INTERFERE
              ;;SZ      _DATA_BUF[0].KEY_PRESSF
              ;;JMP     CHECK_BAL_POINT
                CALL    GET_KEY_THR_MP0
                CLR     C
                RRCA    IAR1            ;1/2 HL_DIFF_MAX
                ;--
                SUB     A,IAR0
                CLR     _DATA_BUF[0].CS_INTERFEREF
                SZ      C
                SET     _DATA_BUF[0].CS_INTERFEREF



                ;------------------------
CHECK_BAL_POINT:;-CHECK IF UNBALANCE   --
                ;------------------------
                ;-CHECK 3M
                CALL    GET_BALANCE_CAP3M_MPX
                MOV     A,_DATA_BUF[6]
                CALL    CHECK_UNBALANCE         ;USE _DATA_BUF[1]
                ;-CHECK 11M
                INC     MP1
                MOV     A,_DATA_BUF[7]
                SNZ     C
                CALL    CHECK_UNBALANCE         ;USE _DATA_BUF[1]
                RRC     _DATA_BUF[1]
              ;;;-TEST
              ;;CALL    GET_HL_DIFF_MAX_MPX
              ;;MOV     A,_DATA_BUF[7]
              ;;MOV     IAR1,A                  ;11M H

                ;----------------
                ;-GET FREQ ------
                ;----------------
                ;-GET LOWER MAX. COUNT
                MOV     A,_DATA_BUF[7]
                SUB     A,_DATA_BUF[6]
                SNZ     C
                ADDM    A,_DATA_BUF[6]  ;SWAP _BUF[6];_BUF[7]

FREQ_IIR_FILTER:;-FREQ IIR FILTER
                CALL    GET_KEY_FREQ_MPX
                MOV     A,_DATA_BUF[6]
                SUB     A,IAR1
                MOV     _DATA_BUF[6],A
                ;-RECORD C FLAG
                CLR     _DATA_BUF[5]
                SNZ     C
                SET     _DATA_BUF[5]
                ;--
                SNZ     C
                CPL     ACC
              ;;SZ      _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
              ;;SUB     A,NoiseLevel/2  ;SWING UNDER +- 1 NoiseLevel
              ;;SNZ     _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                SUB     A,NoiseLevel/2  ;SWING UNDER +- 1/2 NoiseLevel
                SZ      C
                JMP     $+6
                ;-PRE-SET FILTER RECORD TO 1/16
                CLR     _DATA_BUF[0].IIR_LOOP0
                CLR     _DATA_BUF[0].IIR_LOOP1
                SZ      _DATA_BUF[6]
                JMP     $+2
                JMP     SAVE_FILTER_REC

                ;-GET IIR LOOP
                CPLA    _DATA_BUF[0]
                AND     A,00000011B
                INC     ACC
              ;;SNZ     _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                SZ      _DATA_BUF[0].CS_INTERFEREF
                INC     ACC                             ;MORE IIR WHEN CS INTERFERE/HIGH SENS_LEVEL
                ;-IIR 1/16 ; 1/8 ; 1/4 ; 1/2
              ;;CLR     _DATA_BUF[7]
                ;--
                RRC     _DATA_BUF[5]
                RRC     _DATA_BUF[6]
                RRC     _DATA_BUF[7]    ;SAVE C FLAG
                SDZ     ACC
                JMP     $-4;3


                ;-CHECK IIR MIN. VALUE
                SNZ     _DATA_BUF[5].0
                SZ      _DATA_BUF[6]
                JMP     $+4
                SNZ     _DATA_BUF[7].7
                SZ      _DATA_BUF[7].6
                INC     _DATA_BUF[6]
                ;--
                MOV     A,_DATA_BUF[6]
                ADDM    A,IAR1

                ;-FILTER LOOP + (-1)
                SZ      _DATA_BUF[0].IIR_LOOP0
                SNZ     _DATA_BUF[0].IIR_LOOP1
                INC     _DATA_BUF[0]
SAVE_FILTER_REC:;-SAVE FILTER LOOP/DIR
                CALL    GET_KEY_STATUS_MPX
                MOV     A,_DATA_BUF[0]
                MOV     IAR1,A



END_TKS_FILTER: ;-END OF FILTER
                CALL    CHECK_AMOUNT
                SNZ     C
                JMP     FILTER_LOOP
                ;-IF UNBALANCE
                CLR     UNBALANCEF

;***water check point
                ; CLR		_DATA_BUF[0]
                ; SZ		_KEY_IO_SEL[0].7
           		; JMP		$+8
                ; SWAPA	_KEY_IO_SEL[0]
                ; AND		A,00000011B
                ; INC		ACC
                ; SET		C
                ; RLC		_DATA_BUF[0]
                ; SDZ		ACC
                ; JMP		$-2
                ; CPL		_DATA_BUF[0]

                ; SWAPA   _DATA_BUF[1]
                ; AND     A,_KEY_IO_SEL[0]
                ; AND		A,_DATA_BUF[0]
                ; AND		A,00001111B
                ; SNZ     Z
                ; SET     UNBALANCEF

                SWAPA   _KEY_IO_SEL[0]
                CPL     ACC
                AND     A,_KEY_IO_SEL[0]
                AND     A,00001111B
                MOV     _DATA_BUF[0],A

                SWAPA   _DATA_BUF[1]
          if    KeyAmount == 1
                RR      ACC
                RR      ACC
                RR      ACC
          elseif KeyAmount == 2
                RR      ACC
                RR      ACC
          elseif KeyAmount == 3
                RR      ACC
          endif
                ;AND     A,00001111B
                ;AND     A,_KEY_IO_SEL[0]
                AND     A,_DATA_BUF[0]
;==
                SNZ     Z
                SET     UNBALANCEF
                RET



;;***********************************************************
;;***********************************************************
;;***********************************************************
                #define LowUnBalanceOffset      18
                #define HighUnBalanceOffset     26
CHECK_UNBALANCE:


                ;-IF CAP = 0 WHEN OVER Centralpoint
                SNZ     _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                SUB     A,BalanceCentralPoint+LowUnBalanceOffset
                SZ      _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                SUB     A,BalanceCentralPoint+HighUnBalanceOffset

                SNZ     C
                JMP     UNDER_CENTRAL
                SZ      IAR1
                RET
                CLR     C
                RET

UNDER_CENTRAL:
                SNZ     _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                ADD     A,(BalanceCentralPoint+LowUnBalanceOffset - (BalanceCentralPoint-LowUnBalanceOffset-1))
                SZ      _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                ADD     A,(BalanceCentralPoint+HighUnBalanceOffset - (BalanceCentralPoint-HighUnBalanceOffset-1))

                SIZA    IAR1
                SZ      C
                JMP     $+3
                SET     C
                RET
                ;--
                CLR     C
                RET




;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_CHECK_KEY_WAKEUP:

                RET


;;***********************************************************
;;*SUB. NAME:POWER ON CALIBRATE                             *
;;*INPUT    :                                               *
;;*OUTPUT   :ACC FFH= NOT BALANCE                           *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_PON_CALIBRATE:
                ;-COUNT 16 TIMES FOR 16 AVG.
                INC     SAMPLE_TIMES
                SNZ     SAMPLE_TIMES.4
                RET
                CLR     SAMPLE_TIMES

              ;;;-DUMMY SAMPLE 2 CYCLE COUNTER
              ;;SNZ     BALANCE_BUF[1].1
              ;;INC     BALANCE_BUF[1]

            ;--20180430--
            MOV     A,_KEY_IO_SEL[0]
            AND		A,00001111B
            MOV     _DATA_BUF[4],A
            ;--

                CLR     CHANNEL_INDEX
                ;------------------------
CAP_BAL_LOOP:   ;-CAP. BALANCE LOOP     -
                ;------------------------
                ;-GET 3M AVG.
                CALL    GET_M3_LIMIT_MPX
                ;-DIV16 / CLR /PRE-SET M3 LIMIT
                CALL    PON_DIV16_PRESET
                MOV     _DATA_BUF[0],A
                MOV     _DATA_BUF[1],A	;TONY DEF
                INC     MP1
                CLR     IAR1            ;CLR H-L

                ;-GET 11M AVG.
                CALL    GET_M11_LIMIT_MPX
                CALL    PON_DIV16_PRESET
                MOV     _DATA_BUF[1],A

            ;--20180430--
            RRC     _DATA_BUF[4]
            ;--
            RRC     _DATA_BUF[7]
            SNZ     _DATA_BUF[7].7
            SET     _DATA_BUF[0]
            SNZ     _DATA_BUF[7].7
            SET     _DATA_BUF[1]
            ;--

                ;-IF DUMMY SAMPLE DONE
                SZ      BALANCE_BUF[1].1        ;DUMMY 2 CYCLE
                JMP     CHK_BALANCE_TYPE
                ;--
                CALL	CHECK_AMOUNT
                SNZ     C
                JMP     CAP_BAL_LOOP
                ;--
                INC     BALANCE_BUF[1]
                RET




CHK_BALANCE_TYPE:;-CHECK BALANCE TYPE
                SZ      BALANCE_BUF[1].3
                JMP     BAL_APPROACH
                ;----------------------------
                ;-FAST BALANCE WITH BIT SHIFT
                ;----------------------------

                ;-LOAD BALANCE CAP.
                CALL    GET_BALANCE_CAP_MPX     ;3M BAL CAP
                ;-CHECK BALANCE POINT
                MOV     A,_DATA_BUF[0]
                CALL    PON_BIT_INVERT

                ;-LOAD BALANCE CAP.
                INC     MP1             ;11M BAL CAP
                ;-CHECK BALANCE POINT
                MOV     A,_DATA_BUF[1]
                CALL    PON_BIT_INVERT

                CALL	CHECK_AMOUNT
                SNZ     C
                JMP     CAP_BAL_LOOP

                ;-SHIFT TO NEXT BIT
                CLR     C
                RRC     BALANCE_BUF[0]
                SZ      C
                SET     BALANCE_BUF[1].3
                RET


                ;-----------------
BAL_APPROACH:   ;-BALANCE_APPROACH
                ;-----------------

                ;-LOAD PREVIOUS 3M
                CALL    GET_KEY_REF_MPX
                MOV     A,IAR1
                MOV     _DATA_BUF[2],A
                ;-SAVE 3M
                MOV     A,_DATA_BUF[0]

        ;--20180430--
        SNZ     _DATA_BUF[7].7
        CLR     ACC
        ;--

                MOV     IAR1,A
                ;-LOAD PREVIOUS 11M
                INC     MP1                     ;FREQ
                MOV     A,IAR1
                MOV     _DATA_BUF[3],A
                ;-SAVE 11M
                MOV     A,_DATA_BUF[1]
        ;--20180430--
        SNZ     _DATA_BUF[7].7
        CLR     ACC
        ;--
                MOV     IAR1,A
                ;-LOAD BALANCE CAP.
                CALL    GET_BALANCE_CAP_MPX     ;3M CAP

                SZ      BALANCE_BUF[1].6
                JMP     LAST_BALANCE
                ;--
                CALL    PON_INC_OR_DEC_CAP

                INC     MP1                     ;11M CAP
                MOV     A,_DATA_BUF[1]
                MOV     _DATA_BUF[0],A
                CALL    PON_INC_OR_DEC_CAP

                CALL	CHECK_AMOUNT
                SNZ     C
                JMP     CAP_BAL_LOOP

                ;--
                MOV     A,00010000B
                ADDM    A,BALANCE_BUF[1]

                RET


LAST_BALANCE:   ;-LAST BALANCE
                ;-COMPARE CURRENT / LAST BASE ON Centralpoint
                ;-COMPARE 3M
                CALL    PON_CMP_CURRENT_LAST
                ;-COMPARE 11M
                INC     MP1                     ;11M
                MOV     A,_DATA_BUF[3]          ;LAST
                MOV     _DATA_BUF[2],A
                MOV     A,_DATA_BUF[1]          ;CURRENT
                MOV     _DATA_BUF[0],A
                CALL    PON_CMP_CURRENT_LAST

END_PON_BAL:    ;-END OF BALANCE
                CALL	CHECK_AMOUNT
                SNZ     C
                JMP     CAP_BAL_LOOP

                ;-BALANCE DONE
                SET     _TKS_ACTIVEF
                SET     _FORCE_CALIBRATEF
                ;--
                CLR     BALANCE_BUF[0]
                CLR     BALANCE_BUF[1]
                RET


;;***********************************************
;;***********************************************
;;***********************************************
PON_DIV16_PRESET:
                SWAPA   IAR1
                AND     A,00FH
                MOV     _DATA_BUF[2],A
                CLR     IAR1
                ;--
                INC     MP1
                SWAPA   IAR1
                AND     A,0F0H
                OR      A,_DATA_BUF[2]
                CLR     IAR1

                ;-SET 3M/11M MIN TO 0FFH
                INC     MP1             ;SET LOW LIMIT = FF
                SET     IAR1
              ;;INC     MP1
              ;;CLR     IAR1            ;CLR H-L
                RET

;;***********************************************
;;***********************************************
;;***********************************************
PON_CMP_CURRENT_LAST:
                ;-CURRENT SUB CENTRALPOINT
                MOV     A,_DATA_BUF[0]
                SUB     A,BalanceCentralPoint
                SNZ     C
                CPL     ACC
            ;--20180430--
            ;;MOV     _DATA_BUF[4],A
            MOV     TBLP,A
            ;--

                ;-LAST SUB CENTRALPOINT
                MOV     A,_DATA_BUF[2]
                SUB     A,BalanceCentralPoint
                SNZ     C
                CPL     ACC
            ;--20180430--
            ;;SUB     A,_DATA_BUF[4]
            SUB     A,TBLP
            ;--
                ;--
                SZ      C
                RET

PON_INC_OR_DEC_CAP: ;---
                MOV     A,_DATA_BUF[0]
                SUB     A,BalanceCentralPoint
                SNZ     C
                JMP     $+4
                SZ      IAR1
                DEC     IAR1
                JMP     $+4
                INCA    IAR1
                SZ      ACC
                INC     IAR1
                RET

;;***********************************************
;;***********************************************
;;***********************************************
PON_BIT_INVERT: ;--
                SUB     A,BalanceCentralPoint
                ;-INVERT CURRENT BIT
                MOV     A,BALANCE_BUF[0]
                SZ      C
                XORM    A,IAR1
                ;-LOAD NEXT BIT
                CLR     C
                RRCA    BALANCE_BUF[0]
                ORM     A,IAR1
                RET




;;***********************************************************
;;*SUB. NAME:RE_BALANCE                                     *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_RE_BALANCE:
                ;-IF ANY KEY FUNCTION WILL ACTIVE
                SZ      UNBALANCEF
                SZ      KEY_STATE_BUF
                CLR     UNBALANCE_TIMER
                ;--
                SZ      _TKS_500MSF
                SZ      KEY_STATE_BUF
                RET


                ;-LOAD KEY / IO SETTING
                MOV     A,_KEY_IO_SEL[0]
                AND		A,00001111B
                MOV     _DATA_BUF[2],A

                INC     UNBALANCE_TIMER
                ;--



                CLR     CHANNEL_INDEX
                ;----------------------
RE_BALANCE_LOOP:;-CHECK RE-BALANCE LOOP
                ;------------------------
                RRC     _DATA_BUF[2]
                SNZ     C
                JMP     END_RE_BALANCE

;***water check point
                ; SZ		_KEY_IO_SEL[0].7
           		; JMP		$+6
				; SWAPA	_KEY_IO_SEL[0]
				; AND		A,00000011B
				; XOR		A,CHANNEL_INDEX
				; SZ		Z
				; JMP		END_RE_BALANCE

                CALL    CHECK_WATER_KEY
                SZ      C
                JMP     END_RE_BALANCE
;==
                ;-CHECK IF HL SWING OVER THREHSOLD
                CALL    GET_KEY_THR_MP0
                ;-IF NOISE INTERFERE
                CALL    GET_HL_DIFF_MAX_MPX
                MOV     A,IAR1
                SUB     A,IAR0
                SZ      C
                CLR     UNBALANCE_TIMER


END_RE_BALANCE: ;-END OF RE-BALANCE
                CALL    CHECK_AMOUNT
                SNZ     C
                JMP     RE_BALANCE_LOOP

                ;-COUNT & CHECK UNBALANCE TIMER
                ;-IF UNBALANCE OVER 6/2 SEC THEN RE-INITIAL TOUCH KEY SYSTEM
                MOV     A,2*1000/500    ;2SEC
                SZ      POWER_ON_STABLEF
                MOV     A,6*1000/500    ;6SEC
                SUB     A,UNBALANCE_TIMER
                SNZ     C
                JMP     _LIBRARY_RESET;;_BS83B08A_CTOUCH_WATER_V501_INITIAL
                RET



;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_FORCE_CALIBRATE:

                SNZ     _FORCE_CALIBRATEF
                RET
                ;--
                CLR     _ANY_KEY_PRESSF
                CLR     _FORCE_CALIBRATEF

                CLR     CHANNEL_INDEX
FORCE_CAL_LOOP: ;-FORCE CALIBRATE LOOP
                ;-CLEAR REFERENCE WAIT DRIFT UPDATE
                CALL    GET_KEY_REF_MPX
                CLR     IAR1
                ;-RESET KEY STATUS & TIMER
                CALL    GET_KEY_STATUS_MPX
                CLR     IAR1    ;CLEAR KEY STATUS
                ;-CLEAR KEY TIMER
                INC     MP1
                CLR     IAR1
                ;--
                CALL    CHECK_AMOUNT
                SNZ     C
                JMP     FORCE_CAL_LOOP

                ;-CLEAR ALL KEY STATUS
                CLR     KEY_DBCE
                ;--

                ;WATER STATUS DON'T CLR
;***water check point
                ; SWAPA	_KEY_IO_SEL[0]
                ; AND		A,00000011B
                ; INC		ACC
                ; MOV		_DATA_BUF[0],A
                ; MOV		A,0
                ; SET		C
                ; RLC		ACC
                ; SDZ		_DATA_BUF[0]
                ; JMP		$-2
                ; ANDM    A,_KEY_DATA[0]
                ; ANDM    A,KEY_BUF[0]

                SWAPA	_KEY_IO_SEL[0]
                AND     A,00001111B
                ANDM    A,_KEY_DATA[0]
                ANDM    A,KEY_BUF[0]
;==
                RET








;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_NORMAL_CALIBRATE:

                ;-CHECK IF SAMPLE TIMES =XXXX0010B = 40MS
                SZ      SAMPLE_TIMES.1
                SZ      SAMPLE_TIMES.0
                RET

                ;-CALCULATE CALIBRATE TIMER
                INC     CAL_TIMER
                SWAPA   _GLOBE_VARIES[TKS_OPTIONA]
                AND     A,00001111B
                INC     ACC
                RL      ACC             ;MINI=80MS ; MAX = 1280MS
                SUB     A,CAL_TIMER
                SNZ     C
                CLR     CAL_TIMER

                ;--------------------
                ;-NORMAL CALIBRATION
                ;--------------------
                CLR     CHANNEL_INDEX

CALIBRATE_LOOP: ;-CALIBRATION LOOP

;***water check point
                ; SZ		_KEY_IO_SEL[0].7
           		; JMP		$+6
				; SWAPA	_KEY_IO_SEL[0]
				; AND		A,00000011B
				; XOR		A,CHANNEL_INDEX
				; SZ		Z
				; JMP		END_CALIBRATE

                CALL    CHECK_WATER_KEY
                SZ      C
                JMP     END_CALIBRATE
;==
                CALL    GET_KEY_STATUS_MPX
                MOV     A,IAR1          ;KEY STATUS
                MOV     _DATA_BUF[2],A
                INC     MP1
                MOV     A,IAR1          ;KEY TIMER
                MOV     _DATA_BUF[3],A


                ;---------------------------
                ;-GET NOISE COMPENASTE
                ;-WITH REF. LEARNNING OFFSET
                ;---------------------------
                ;-GET HL DIFF MAX
                CALL    GET_HL_DIFF_MAX_MPX
                CLR     C
                RRCA    IAR1            ;1/2 NOISE
                CLR     C
                SNZ     _GLOBE_VARIES[TKS_OPTIONB].SENS_LEVEL
                RRCA    IAR1            ;1/4 NOISE
                MOV     _DATA_BUF[4],A

              ;;;-GET KEY THRESHOLD
              ;;CALL    GET_KEY_THR_MP0
              ;;MOV     A,IAR0          ;1 THR
                MOV     A,NoiseLevel*3/2        ;1.5 NOISE LEVEL
                SUB     A,_DATA_BUF[4]
                SNZ     C
                ADDM    A,_DATA_BUF[4]  ;SWAP;REF LEARNNING OFFSET;MAX IS NoiseLevel


                ;-GET FREQ-REF
                CALL    GET_KEY_FREQ_MPX
                MOV     A,IAR1          ;
                ;-IF KEY PRESS NO COMPENSATE NOISE
                SZ      _DATA_BUF[2].KEY_PRESSF
                JMP     $+4
                SUB     A,_DATA_BUF[4]  ;COMPENSATE NOISE
                SNZ     C
                CLR     ACC
                ;--
                DEC     MP1             ;REF
                SUB     A,IAR1          ;FREQ-REF
                SZ      Z
                JMP     END_CALIBRATE
                MOV     _DATA_BUF[0],A
                ;-SAVE C FLAG
                CLR     _DATA_BUF[1]
                SNZ     C
                SET     _DATA_BUF[1]

                ;-CHECK IF KEY PRESS
                SZ      _DATA_BUF[2].KEY_PRESSF
                JMP     KEY_PRESS_CAL
                ;-----------------
                ;-NORMAL CALIBRATE
                ;-----------------
                ;-CHECK IF NEED TO FAST UP CALIBRATE
                SNZ     _DATA_BUF[1].0  ;FALLING
                JMP     RISING_CAL      ;RISING
              ;;JMP     DO_CALIBRATE    ;RISING
                ;-FALLING CALIBRATE
                SZ      _ANY_KEY_PRESSF
                CLR     _DATA_BUF[3]
                ;--
                MOV     A,2             ;1.5SEC ~ 2 SEC BAE ON 500MS
                SUB     A,_DATA_BUF[3]
                SNZ     C
                SZ      CAL_TIMER
                JMP     END_CALIBRATE
                JMP     DO_CALIBRATE
              ;;JMP     CHK_CAL_TIMER

RISING_CAL:     ;-RISING CALIBRATE
                SZ      _DATA_BUF[2].CS_INTERFEREF
                SNZ     IAR1.7          ;IF REF OVER 128
                JMP     DO_CALIBRATE
                ;--
                SET     _DATA_BUF[1]
                MOV     A,BalanceCentralPoint
                SUB     A,IAR1
                MOV     _DATA_BUF[0],A
                ;--
                SNZ     C
                JMP     DO_CALIBRATE
                JMP     END_CALIBRATE


                ;-----------------------
KEY_PRESS_CAL:  ;-KEY PRESSING CALIBRATE
                ;-----------------------
                SZ      _GLOBE_VARIES[TKS_OPTIONC].ACTIVE_LOGIC
                SIZA    KEY_DBCE        ;IF DEBOUCING
                JMP     END_CALIBRATE

                ;-LOAD THRESHOLD RAM
                CALL    GET_KEY_THR_MP0
                CLR     C
                RLCA    IAR0            ;2THR
                SZ      C
                JMP     END_CALIBRATE
                ;-IF CS INTERFERE
                SZ      _DATA_BUF[2].CS_INTERFEREF
                ADD     A,IAR0          ;3THR
                ;--
                SZ      _DATA_BUF[1].0  ;IF FREQ >= REF INHIBIT
                SZ      C
                JMP     END_CALIBRATE

                ;-MAX. = 64
                SNZ     ACC.7
                SZ      ACC.6
                MOV     A,64
                ;--
                ADDM    A,_DATA_BUF[0]
                SZ      C
                JMP     END_CALIBRATE

                ;----------------------
DO_CALIBRATE:   ;-DO CALIBRATE FUNCTION
                ;----------------------

                MOV     A,2     ;1/4 IIR
                ;-25% IIR
                RRC     _DATA_BUF[1]
                RRC     _DATA_BUF[0]
                SDZ     ACC
                JMP     $-3

                ;-MINIMUM = 1
                MOV     A,1
                SNZ     _DATA_BUF[1].0
                SZ      _DATA_BUF[0]
                MOV     A,_DATA_BUF[0]

                ;-SAVE IIR RESULT
                ADDM    A,IAR1
                ;-IF "0" OVERFLOW
                SZ      _DATA_BUF[1].0
                SZ      C
                JMP     $+2
                CLR     IAR1

END_CALIBRATE:  ;-END OF CALIBRATE
                CALL    CHECK_AMOUNT
                SNZ     C
                JMP     CALIBRATE_LOOP

                RET

;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_CHECK_KEY_TIMER:
                SNZ     _TKS_500MSF
                RET


                CLR     CHANNEL_INDEX
CHK_KTIMER_LOOP:;-CHECK KEY TIMER  LOOP

;***water check point
                ; SZ		_KEY_IO_SEL[0].7
           		; JMP		$+6
				; SWAPA	_KEY_IO_SEL[0]
				; AND		A,00000011B
				; XOR		A,CHANNEL_INDEX
				; SZ		Z
				; JMP		END_CHK_KTIMER

                CALL    CHECK_WATER_KEY
                SZ      C
                JMP     END_CHK_KTIMER
;==
                CALL    GET_KEY_STATUS_MPX
                MOV     A,IAR1
                MOV     _DATA_BUF[0],A
                ;-COUNT KEY TIMER
                INC     MP1
                SIZA    IAR1
                MOV     IAR1,A
                ;-------------------
                ;-CHECK MAXON TIME -
                ;-------------------
                RRA     _GLOBE_VARIES[TKS_OPTIONB]
                AND     A,01111000B     ;DIV2 TO MATCH PER STEP 4 SEC
                SNZ     Z
                SNZ     _DATA_BUF[0].KEY_PRESSF       ;IF NO KEY PRESS
                JMP     END_CHK_KTIMER  ;MAXON TIME DISABLE
                ;--
                SUB     A,IAR1
                SZ      C
                JMP     END_CHK_KTIMER
                ;-LIMIT TIME OUT
                CLR     IAR1            ;CLEAR KEY TIMER
                DEC     MP1             ;KEY_STATUS
                MOV     A,00001111B     ;HOLD CS FLAG/FILTER FLAG
                ANDM    A,IAR1
                ;-CLEAR REF
                CALL    GET_KEY_REF_MPX
                CLR     IAR1


END_CHK_KTIMER: ;-END OF CHECK MAXON TIME
                CALL    CHECK_AMOUNT
                SNZ     C
                JMP     CHK_KTIMER_LOOP


                RET


;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_TKS_STATE_CHECK:

              ;;;-CHECK IF SAMPLE TIMES =XXXXXX01B
              ;;SNZ     SAMPLE_TIMES.0
              ;;RET

                SET     _SCAN_CYCLEF

                CLR     MAX_COUNT
                CLR     MAX_COUNT_CHANNEL
                ;--
                CLR     CHANNEL_INDEX
STATE_CHK_LOOP:
                ;-LOAD THRESHOLD IN IAR0 & GET HYSTERESIS
                CALL    GET_KEY_THR_MP0
                CLR     C
                RRCA    IAR0
                MOV     HYSTERESIS,A

            CALL    CHECK_WATER_KEY
            SNZ     C
            JMP     $+4

            ;--100% --
            MOV     A,IAR0
            SUB     A,2
            MOV     HYSTERESIS,A

                ;-GET REF-FREQT FOR NEG_TCOUNT
                CALL    GET_KEY_REF_MPX
                MOV     A,IAR1
                INC     MP1             ;FREQ
                SUB     A,IAR1          ;REF-FREQ
                SNZ     C
                JMP     $+4
                MOV     NEG_COUNT,A
                CLR     POS_COUNT
                JMP     $+4
                CPL     ACC
                MOV     POS_COUNT,A
                CLR     NEG_COUNT

                ;-CHECK KEY PRESS STATUS
                CALL    GET_KEY_STATUS_MPX

                ;-IF KEY STATE
                SZ      IAR1.KEY_PRESSF
                JMP     KEY_HOLDING

                MOV     A,IAR0
                SUB     A,NEG_COUNT
                SNZ     C
                JMP     KEY_PRESSING
                ;-CLEAR DEBOUNCE
                MOV     A,00001111B
                ANDM    A,IAR1
                JMP     END_STATE_CHECK

KEY_PRESSING:   ;-KEY PRESSING
                MOV     A,00010000B
                ADDM    A,IAR1
                SNZ     IAR1.5
                JMP     END_STATE_CHECK

                ;-CLEAR DEBOUNCE
                MOV     A,00001111B
                ANDM    A,IAR1
                SET     IAR1.KEY_PRESSF


        ifdef   OneKeyActiveFunction
                ;------------------------
                ;-IF ONE KEY ACTIVE     -
                ;------------------------
                SZ      _GLOBE_VARIES[TKS_OPTIONC].ONE_KEY_ACTIVE
                SNZ     _ANY_KEY_PRESSF
                JMP     CLR_KEY_TIMER
                ;-IF ANY KEY ALREADY PRESSED
                CLR     IAR1.KEY_PRESSF
                ;-CLEAR KEY TIMER
                INC     MP1
                CLR     IAR1
                ;-UPDATE REF
                CALL    GET_KEY_FREQ_MPX
                MOV     A,IAR1
                DEC     MP1             ;REF
                MOV     IAR1,A
                JMP     END_STATE_CHECK
        else
                JMP     CLR_KEY_TIMER
        endif   ;-end of one key active define

                ;----------------
KEY_HOLDING:    ;-KEY HOLDING   -
                ;----------------
                MOV     A,NEG_COUNT
                SUB     A,HYSTERESIS
                SNZ     C
                JMP     KEY_RELEASING
                MOV     A,10001111B     ;CLEAR DEBOUNCE
                ANDM    A,IAR1

        ifdef   OneKeyActiveFunction
                ;------------------------
                ;-IF ONE KEY ACTIVE     -
                ;------------------------
                SNZ     _GLOBE_VARIES[TKS_OPTIONC].ONE_KEY_ACTIVE
                JMP     END_STATE_CHECK
                MOV     A,NEG_COUNT
                SUB     A,IAR0
                SUB     A,MAX_COUNT
                SNZ     C
                JMP     END_STATE_CHECK
                ADDM    A,MAX_COUNT
                MOV     A,CHANNEL_INDEX
                MOV     MAX_COUNT_CHANNEL,A
        endif   ;-end of one key active define
                JMP     END_STATE_CHECK

KEY_RELEASING:  ;-KEY RELEASING
                MOV     A,00010000B
                ADDM    A,IAR1
                SNZ     IAR1.5
                JMP     END_STATE_CHECK
                MOV     A,00001111B
                ANDM    A,IAR1
CLR_KEY_TIMER:  ;-CLEAR KEY TIMER
                INC     MP1
                CLR     IAR1            ;CLEEAR KEY TIMER

END_STATE_CHECK:;-END OF KEY STATE CHECK
                CALL    CHECK_AMOUNT
                SNZ     C
                JMP     STATE_CHK_LOOP



;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_GET_KEY:
                ;----------------------
                ;-CHECK ALL KEY STATUS-
                ;----------------------
                CLR     KEY_STATE_BUF
                CLR     _DATA_BUF[0]
                ;------------------------
        if      KeyAmount > 8
                CLR     _DATA_BUF[1]
        endif   ;------------------------
        if      KeyAmount > 16
                CLR     _DATA_BUF[2]
        endif   ;------------------------

                CLR     KPRESS_AMOUNT
                MOV     A,KeyAmount
                MOV     CHANNEL_INDEX,A
                CALL    GET_KEY_STATUS_MPX

;***water check point
                MOV     A,_KEY_IO_SEL[0]
                MOV     _DATA_BUF[7],A
;==
GET_KSTS_LOOP:  ;-GET KEY STATUS LOOP & GET KEY PRESS AMOUNT
                MOV     A,100H-2                ;OFFSET 2
                ADDM    A,MP1
                ;--

;***water check point
                RLC     _DATA_BUF[7]
                SZ      C
                JMP     $+4
;==
                MOV     A,IAR1
                AND     A,11110000B             ;IGNORE CS DEBOUNCE BIT
                ORM     A,KEY_STATE_BUF
                ;-COUNT TPRESS AMOUNT
                SZ      IAR1.KEY_PRESSF
                INC     KPRESS_AMOUNT           ;COUNT PRESS KEY AMOUNT
                ;--
                CLR     C
                SZ      IAR1.KEY_PRESSF
                SET     C
                ;-GET KEY PRESS FLAG
                RLC     _DATA_BUF[0]
                ;------------------------
        if      KeyAmount > 8
                RLC     _DATA_BUF[1]
        endif   ;------------------------
        if      KeyAmount > 16
                RLC     _DATA_BUF[2]
        endif   ;------------------------
        NEXT_GET_KSTS_LOOP:
                SDZ     CHANNEL_INDEX
                JMP     GET_KSTS_LOOP


                ;-KEY DEBOUNCE
                MOV     A,_DATA_BUF[0]
                XORM    A,KEY_BUF[0]
                MOV     KEY_BUF[0],A
                SNZ     Z
                CLR     KEY_DBCE
                ;------------------------
        if      KeyAmount > 8
                MOV     A,_DATA_BUF[1]
                XORM    A,KEY_BUF[1]
                MOV     KEY_BUF[1],A
                SNZ     Z
                CLR     KEY_DBCE
        endif   ;------------------------
        if      KeyAmount > 16
                MOV     A,_DATA_BUF[2]
                XORM    A,KEY_BUF[2]
                MOV     KEY_BUF[2],A
                SNZ     Z
                CLR     KEY_DBCE
        endif   ;------------------------

                ;------------------------
                ;-CHECK IF DEBOUNCE DONE-
                ;------------------------
                INCA    KEY_DBCE
                SZ      Z
                RET
                MOV     KEY_DBCE,A


                ;-LOAD DEBOUNCE SETTING
                MOV     A,_GLOBE_VARIES[TKS_OPTIONA]
                AND     A,00001111B             ;MAX=15
                INC     ACC                     ;MIN=1
                SZ      KEY_STATE_BUF.CS_INTERFEREF
                INC     ACC

MOV     _DATA_BUF[1],A
CALL    CHECK_WATER_KEY
SNZ     C
JMP     $+5
;--WATER DABOUNCE = TOUCH KEY DEBOUNCE * 2 + 16
CLR     C
RLC     _DATA_BUF[1]
MOV     A,16
ADDM    A,_DATA_BUF[1]

MOV     A,_DATA_BUF[1]

        ifdef   OneKeyActiveFunction
                ;-IF ONE KEY ACITVE
                SZ      _GLOBE_VARIES[TKS_OPTIONC].ONE_KEY_ACTIVE
                ADD     A,KPRESS_AMOUNT
        endif   ;-end of one key active define

                ;-CHECK DEBOUNCE TIME
                SUB     A,KEY_DBCE
                SZ      C
                RET
                SET     KEY_DBCE


        ifdef   OneKeyActiveFunction
                ;------------------------
                ;-IF ONE_KEY_ACTIVE     -
                ;------------------------
                SNZ     _GLOBE_VARIES[TKS_OPTIONC].ONE_KEY_ACTIVE
                JMP     GET_KEY_STATUS
                ;-IF ONLY ONE KEY OR NONE KEY PRESSED
                DECA    KPRESS_AMOUNT
                SZ      KPRESS_AMOUNT
                SZ      Z
                JMP     GET_KEY_STATUS

                ;-MASK KEY
                CLR     CHANNEL_INDEX
MASK_KEY_LOOP:  ;--
                MOV     A,KPRESS_AMOUNT
                SUB     A,3             ;OVER 3 KEY
                SZ      C
                SET     MAX_COUNT_CHANNEL       ;ALL KEY INHIBIT
                ;--
                MOV     A,CHANNEL_INDEX
                XOR     A,MAX_COUNT_CHANNEL
                SZ      Z
                JMP     END_MASK_KEY
                ;-MASK INVALID KEY
                CALL    GET_KEY_STATUS_MPX
                CLR     IAR1.KEY_PRESSF
                ;-REF-FREQ
                CALL    GET_KEY_FREQ_MPX
                MOV     A,IAR1
                DEC     MP1             ;REF
                MOV     IAR1,A
END_MASK_KEY:   ;----
                CALL    CHECK_AMOUNT
                SNZ     C
                JMP     MASK_KEY_LOOP

                ;----------------
                ;-GET ONE KEY   -
                ;----------------
                CLR     KEY_BUF[0]
                ;------------------------
        if      KeyAmount > 8
                CLR     KEY_BUF[1]
        endif   ;------------------------
        if      KeyAmount > 16
                CLR     KEY_BUF[2]
        endif   ;------------------------

                INC     MAX_COUNT_CHANNEL       ;IF =FF IS INHIBIT
                SZ      Z
                RET

                SET     C
GET_ONEKEY_LOOP:;-
                RLC     KEY_BUF[0]
                ;------------------------
        if      KeyAmount > 8
                RLC     KEY_BUF[1]
        endif   ;------------------------
        if      KeyAmount > 16
                RLC     KEY_BUF[2]
        endif   ;------------------------
                CLR     C
                SDZ     MAX_COUNT_CHANNEL
                JMP     GET_ONEKEY_LOOP
        endif   ;-end of one key active define

                ;--------------------
GET_KEY_STATUS: ;-GET KEY STATUS
                ;--------------------
                MOV     A,KEY_BUF[0]
                MOV     _KEY_DATA[0],A
                ;------------------------
        if      KeyAmount > 8
                MOV     A,KEY_BUF[1]
                MOV     _KEY_DATA[1],A
        endif   ;------------------------
        if      KeyAmount > 16
                MOV     A,KEY_BUF[2]
                MOV     _KEY_DATA[2],A
        endif   ;------------------------


                ;--------------------
                ;-CHECK ANY KEY PRESS
                ;--------------------
                CLR     _ANY_KEY_PRESSF
                SZ      KPRESS_AMOUNT           ;KEY AMOUNT
                SET     _ANY_KEY_PRESSF

                RET


;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_TKS_TIMER:
                ;-CHECK 62.5 MS
                INC     TKS_TIMER
                MOV     A,TKS_TIMER
                SUB     A,6 ;1;2            ;62.5  MS ;31.25MS BASE ON 2.56MS
                SNZ     C
                RET
                CLR     TKS_TIMER

                ;--
                INC     TKS_TIMERB

                MOV     A,TKS_TIMERB
                ;--
                AND     A,01111111B     ;8SEC
                SZ      Z
                SET     POWER_ON_STABLEF;POWER ON STABLE AFTER 8 SEC
                ;--
                AND     A,00000111B;00000111B
                SZ      Z
                SET     _TKS_500MSF     ;500 MSF
                ;--
                AND     A,00000011B;00000011B
                SZ      Z
                SET     _TKS_250MSF     ;250 MSF

                SET     _TKS_63MSF      ;62.5NSF

                RET



;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :CHANNEL_INDEX                                  *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************

CHECK_AMOUNT:
                INC     CHANNEL_INDEX
                MOV     A,CHANNEL_INDEX
                SUB     A,KeyAmount
                RET

;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :CHANNEL_INDEX                                  *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
GET_KEY_STATUS_MPX:
                MOV     A,BANK _KEY_STATUS
                MOV     BP,A
                MOV     A,OFFSET _KEY_STATUS
                MOV     MP1,A
                RLA     CHANNEL_INDEX
                ADDM    A,MP1
                RET

;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :CHANNEL_INDEX                                  *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
GET_BALANCE_CAP_MPX:
GET_BALANCE_CAP3M_MPX:
                MOV     A,OFFSET _BALANCE_CAP3M
                JMP     GET_REF_BANK;_MPX
GET_BALANCE_CAP11M_MPX:
                MOV     A,OFFSET _BALANCE_CAP11M
                JMP     GET_REF_BANK;_MPX
;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :CHANNEL_INDEX                                  *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
GET_KEY_FREQ_MPX:
                MOV     A,OFFSET _KEY_FREQ
                JMP     GET_REF_BANK;_MPX
;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :CHANNEL_INDEX                                  *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
GET_KEY_REF_MPX:
                MOV     A,OFFSET _KEY_REF
GET_REF_BANK:
                MOV     MP1,A
                MOV     A,BANK _KEY_REF
                JMP     GET_4OFFSET_MPX

;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :CHANNEL_INDEX                                  *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
GET_M3_LIMIT_MPX:
                MOV     A,OFFSET _M3_LIMIT
                JMP     GET_M3_LIMIT_BANK
GET_HL_DIFF_MAX_MPX:
                MOV     A,OFFSET _HL_DIFF_MAX
                ;;JMP     GET_M3_LIMIT_BANK
GET_M3_LIMIT_BANK:
                MOV     MP1,A
                MOV     A,BANK _M3_LIMIT
                JMP     GET_4OFFSET_MPX

;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :CHANNEL_INDEX                                  *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
GET_M11_LIMIT_MPX:
                MOV     A,OFFSET _M11_LIMIT
                JMP     GET_M11_LIMIT_BANK

GET_LAST_FREQ_MPX:
                MOV     A,OFFSET _LAST_FREQ
                ;;JMP     GET_M11_LIMIT_BANK
GET_M11_LIMIT_BANK:
                MOV     MP1,A
                MOV     A,BANK _M11_LIMIT


GET_4OFFSET_MPX:;-GET RAM MPX WITH 4 OFFSET
                MOV     BP,A
                RLA     CHANNEL_INDEX
                RL      ACC
                ADDM    A,MP1
                RET

;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
GET_KEY_THR_MP0:
                MOV     A,CHANNEL_INDEX
                ADD     A,OFFSET _GLOBE_VARIES[KEY1_THR]
                MOV     MP0,A
                RET



;;===============================
;;=EXTERNAL REFERENCE SUBROUTIN==
;;===============================



;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :NONE                                           *
;;*USED REG.:ACC , _DATA_BUF[0] ,_DATA_BUF[1]               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
_GET_LIB_VER:
                MOV     A,LOW LibraryVersion
                MOV     _DATA_BUF[0],A
                MOV     A,HIGH LibraryVersion
                MOV     _DATA_BUF[1],A

_GET_KEY_AMOUNT:
                MOV     A,KeyAmount
                RET

_GET_KEY_AMOUNTx3:
                MOV     A,KeyAmount
                ADD     A,KeyAmount
                ADD     A,KeyAmount
                RET


;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :NONE                                           *
;;*OUTPUT   :_DATA_BUF[1];_DATA_BUF[0]                      *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
                ;---------------
_GET_KEY_BITMAP:;-READ KEY LEVEL
                ;---------------
                MOV     A,_KEY_DATA[0]
                MOV     _DATA_BUF[0],A
                ;------------------------
        if      KeyAmount > 8
                MOV     A,_KEY_DATA[1]
                MOV     _DATA_BUF[1],A
        endif   ;------------------------
        if      KeyAmount > 16
                MOV     A,_KEY_DATA[2]
                MOV     _DATA_BUF[2],A
        endif   ;------------------------
                RET



;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :ACC                                            *
;;*OUTPUT   :_DATA_BUF[0],_DATA_BUF[1]                      *
;;*USED REG.:ACC , _DATA_BUF[0] , MP1 , IAR1 , BP           *
;;*FUNCTION :GET "RCC" VALUE                                *
;;***********************************************************
_GET_RCC_VALUE:
                MOV     _DATA_BUF[0],A
                MOV     A,OFFSET _BALANCE_CAP3M
                JMP     GET_VALUE


;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :ACC 0=KEY1 ; 1=KEY2....                        *
;;*OUTPUT   :_DATA_BUF[1],_DATA_BUF[0]                      *
;;*USED REG.:ACC,_DATA_BUF[0]~_DATA_BUF[3],MP1,IAR1,BP      *
;;*FUNCTION :GET "ENV" VALUE                                *
;;***********************************************************
_GET_ENV_VALUE:
                MOV     _DATA_BUF[0],A
                MOV     A,OFFSET _KEY_FREQ
                JMP     GET_VALUE

;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :ACC 0=KEY1 ; 1=KEY2....                        *
;;*OUTPUT   :_DATA_BUF[0],_DATA_BUF[1]                      *
;;*USED REG.:ACC,_DATA_BUF[0]~_DATA_BUF[3],MP1,IAR1,BP      *
;;*FUNCTION :GET "REF" VALUE                                *
;;***********************************************************
_GET_REF_VALUE:
                MOV     _DATA_BUF[0],A
                MOV     A,OFFSET _KEY_REF
GET_VALUE:      ;-----
                MOV     _DATA_BUF[1],A
                ;-PUSH MP1,BP
                MOV     A,MP1
                MOV     MP_BUF,A
                MOV     A,BP
                MOV     BP_BUF,A
                ;--
                MOV     A,BANK _KEY_REF
                MOV     BP,A

GET_VALUE_4OFFSET:;-OFFSET 4 BYTE
                RLA     _DATA_BUF[0]
                RL      ACC
                ADD     A,_DATA_BUF[1]
                MOV     MP1,A
                MOV     A,IAR1
                MOV     _DATA_BUF[0],A
                CLR     _DATA_BUF[1]

POP_MP1_BP:     ;-POP BP & MP1 CONTENT
                MOV     A,BP_BUF
                MOV     BP,A
                MOV     A,MP_BUF
                MOV     MP1,A
                RET

CHECK_WATER_KEY:
                MOV     A,CHANNEL_INDEX
                INC     ACC
                MOV     _DATA_BUF[0],A
                SWAPA   _KEY_IO_SEL[0]

                RRC     ACC
                SDZ     _DATA_BUF[0]
                JMP     $-2
                RET


                END
