                INCLUDE WHEEL_SLIDE_V101.INC


                PUBLIC  _WHEEL_SLIDE_V101_INITIAL
                PUBLIC  _WHEEL_SLIDE_V101
                PUBLIC  _WHEEL_SLIDE_POS

        ifndef _WHEEL_SLIDE_V101_
                #define WS_PAD1      0  ;key1
                #define WS_PAD2      1  ;key2
                #define WS_PAD3      2  ;key3
                #define WS_PAD4      3  ;key4
                ;#define WS_PAD5      4
                ;#define WS_PAD6      5
                ;#define WS_PAD7      6
                ;#define WS_PAD8      7

                #define WS_MODE 1               ; 0:WHEEL  1:SLIDE
                #define WS_SCALE 2              ; 0=x1,1=x2,2=x4,3=x8,4=x16,5=x32,6=x64,7=x128
                #define BackgroundValue 1       ; 0~128 Back ground Value
                #define WS_BNC 2                ; 0~5 Debounce
        endif

ifdef WS_PAD1
	#define	WS_USED_KEY_X1 WS_PAD1%8
	#define	WS_USED_KEY_Y1 WS_PAD1/8
endif
ifdef WS_PAD2
	#define	WS_USED_KEY_X2 WS_PAD2%8
	#define	WS_USED_KEY_Y2 WS_PAD2/8
endif
ifdef WS_PAD3
	#define	WS_USED_KEY_X3 WS_PAD3%8
	#define	WS_USED_KEY_Y3 WS_PAD3/8
endif
ifdef WS_PAD4
	#define	WS_USED_KEY_X4 WS_PAD4%8
	#define	WS_USED_KEY_Y4 WS_PAD4/8
endif
ifdef WS_PAD5
	#define	WS_USED_KEY_X5 WS_PAD5%8
	#define	WS_USED_KEY_Y5 WS_PAD5/8
endif
ifdef WS_PAD6
	#define	WS_USED_KEY_X6 WS_PAD6%8
	#define	WS_USED_KEY_Y6 WS_PAD6/8
endif
ifdef WS_PAD7
	#define	WS_USED_KEY_X7 WS_PAD7%8
	#define	WS_USED_KEY_Y7 WS_PAD7/8
endif
ifdef WS_PAD8
	#define	WS_USED_KEY_X8 WS_PAD8%8
	#define	WS_USED_KEY_Y8 WS_PAD8/8
endif

IFDEF WS_PAD8
        #define WS_PADn 8
ENDIF

IFDEF WS_PAD7
IFNDEF WS_PADn
        #define WS_PADn 7
ENDIF
ENDIF

IFDEF WS_PAD6
IFNDEF WS_PADn
        #define WS_PADn 6
ENDIF
ENDIF

IFDEF WS_PAD5
IFNDEF WS_PADn
        #define WS_PADn 5
ENDIF
ENDIF

IFDEF WS_PAD4
IFNDEF WS_PADn
        #define WS_PADn 4
ENDIF
ENDIF

IFNDEF WS_PADn
        #define WS_PADn 3
        IFNDEF WS_PAD3
                #define WS_PAD3      2
        ENDIF
        IFNDEF WS_PAD2
                #define WS_PAD2      1
        ENDIF
        IFNDEF WS_PAD1
                #define WS_PAD1      0
        ENDIF
ENDIF


IFDEF MP1H
        #define BP MP1H
ENDIF
IFDEF MP1L
        #define MP1 MP1L
ENDIF

rambank 0 WHEEL_SLIDE_DATA
WHEEL_SLIDE_DATA       .SECTION          'DATA'
bLAST_DIR DBIT
DIV_LOOP_COUNT DB ?
_WS_KEY DB WS_PADn*2 DUP(?)
WS_BNC_TIME DB ?

_POSITION DB 2 DUP(?)
LAST_POS DB 2 DUP(?)

WHEEL_SLIDE_CODE       .SECTION          'CODE'
_WHEEL_SLIDE_V101_INITIAL:
                MOV     A,WS_PAD1
                MOV     _WS_KEY[0],A
                MOV     A,WS_PAD2
                MOV     _WS_KEY[1],A
                MOV     A,WS_PAD3
                MOV     _WS_KEY[2],A
                
	            ifdef WS_PAD4
	                MOV     A,WS_PAD4
	                MOV     _WS_KEY[3],A
	            endif
	            
            	ifdef WS_PAD5
	                MOV     A,WS_PAD5
	                MOV     _WS_KEY[4],A
	            endif
	            
            	ifdef WS_PAD6
	                MOV     A,WS_PAD6
	                MOV     _WS_KEY[5],A
	            endif
	            
            	ifdef WS_PAD7
	                MOV     A,WS_PAD7
	                MOV     _WS_KEY[6],A
	            endif
	            
            	ifdef WS_PAd8
	                MOV     A,WS_PAD8
	                MOV     _WS_KEY[7],A
	            endif
	            
WS_RELEASE:
                SET     _POSITION[0]
                SET     _POSITION[1]
                CLR     LAST_POS[0]
                CLR     LAST_POS[1]
                CLR     WS_BNC_TIME
                CLR     bLAST_DIR
                RET

_WHEEL_SLIDE_POS PROC
                MOV     A,_POSITION[0]
                MOV     _DATA_BUF[0],A
                MOV     A,_POSITION[1]
                MOV     _DATA_BUF[1],A
                RET
_WHEEL_SLIDE_POS ENDP



;******************************************************************************
;******************************************************************************
;******************************************************************************
_WHEEL_SLIDE_V101:
                SNZ     _SCAN_CYCLEF
                RET
                SNZ     _ANY_KEY_PRESSF
                JMP     WS_RELEASE
                
                mov		A,WS_USED_KEY_Y1
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y1].WS_USED_KEY_X1
                JMP     GET_Difference_Value     
                
                mov		A,WS_USED_KEY_Y2
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y2].WS_USED_KEY_X2
                JMP     GET_Difference_Value     
                
                mov		A,WS_USED_KEY_Y3
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y3].WS_USED_KEY_X3
                JMP     GET_Difference_Value     
                
            ifdef WS_PAD4
                mov		A,WS_USED_KEY_Y4
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y4].WS_USED_KEY_X4
                JMP     GET_Difference_Value  
            endif   
                
            ifdef WS_PAD5
                mov		A,WS_USED_KEY_Y5
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y5].WS_USED_KEY_X5
                JMP     GET_Difference_Value   
            endif     
                
            ifdef WS_PAD6
                mov		A,WS_USED_KEY_Y6
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y6].WS_USED_KEY_X6
                JMP     GET_Difference_Value   
            endif     
                
            ifdef WS_PAD7
                mov		A,WS_USED_KEY_Y7
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y7].WS_USED_KEY_X7
                JMP     GET_Difference_Value  
            endif      
                
            ifdef WS_PAD8
                mov		A,WS_USED_KEY_Y8
                call 	_GET_KEY_BITMAP
                sz      _DATA_BUF[WS_USED_KEY_Y8].WS_USED_KEY_X8
                JMP     GET_Difference_Value     
            endif   
                JMP     WS_RELEASE
                
        ;===============================================
        ;       GET difference Value
        ;===============================================
        GET_Difference_Value:
                MOV     A,WS_PADn
                MOV     _DATA_BUF[5],A
                CALL    PTR_WS_KEY
        $1:
                MOV     A,IAR1
                CALL    _GET_ENV_VALUE
                MOV     A,_DATA_BUF[0]
                MOV     _DATA_BUF[4],A
                MOV     A,IAR1
                CALL    _GET_REF_VALUE

                MOV     A,_DATA_BUF[0]
                SUB     A,_DATA_BUF[4]
                MOV     _DATA_BUF[4],A
                SNZ     C
                CLR     _DATA_BUF[4]

                MOV     A,_DATA_BUF[4]
                SUB     A,BackgroundValue
                MOV     _DATA_BUF[4],A
                SNZ     C
                CLR     _DATA_BUF[4]


                MOV     A,WS_PADn
                ADDM    A,MP1
                MOV     A,_DATA_BUF[4]
                MOV     IAR1,A
                MOV     A,-(WS_PADn-1)
                ADDM    A,MP1
                SDZ     _DATA_BUF[5]
                JMP     $1



        ;===============================================
                CALL    GET_MAX_KEY

;                CLR     _DATA_BUF[1]
;                CLR     _DATA_BUF[3]
                ;.......................
                ;LOAD B
                CALL    PTR_WS_KEY
                MOV     A,WS_PADn
                ADD     A,TBLP
                ADDM    A,MP1

                MOV     A,IAR1
                MOV     _DATA_BUF[2],A
                CLR     _DATA_BUF[3]
                MOV     _DATA_BUF[0],A
                CLR     _DATA_BUF[1]


                ;.......................
                ;LOAD C
                CALL    PTR_WS_KEY
                MOV     A,WS_PADn
                ADDM    A,MP1

                MOV     A,TBLP
                XOR     A,WS_PADn-1
                SNZ     Z
                INCA    TBLP

                ADDM    A,MP1

                MOV     A,IAR1
                ADDM    A,_DATA_BUF[2]
                CLR     ACC
                ADCM    A,_DATA_BUF[3]

                MOV     A,IAR1
                ADDM    A,_DATA_BUF[0]
                CLR     ACC
                ADCM    A,_DATA_BUF[1]
                MOV     A,IAR1
                ADDM    A,_DATA_BUF[0]
                CLR     ACC
                ADCM    A,_DATA_BUF[1]

                ;.......................


                ;.......................
                ;LOAD A
                CALL    PTR_WS_KEY
                MOV     A,WS_PADn
                ADDM    A,MP1

                MOV     A,WS_PADn-1
                SZ      TBLP
                DECA    TBLP

                ADDM    A,MP1

                MOV     A,IAR1
                ADDM    A,_DATA_BUF[2]
                CLR     ACC
                ADCM    A,_DATA_BUF[3]
        ;===============================================


                MOV     A,WS_SCALE
                SZ      ACC
                JMP     $+2
                JMP     $+6
                CLR     C
                RLC     _DATA_BUF[0]
                RLC     _DATA_BUF[1]
                SDZ     ACC
                JMP     $-4




                CALL    _DIV17

                SZ      TBLP
                JMP     $+2
                JMP     WS_END

                MOV     A,1<<WS_SCALE
                ADDM    A,_DATA_BUF[0]
                CLR     ACC
                ADCM    A,_DATA_BUF[1]
                SDZ     TBLP
                JMP     $-5


WS_END:
        IF WS_MODE==1
                MOV     A,100H-(1<<WS_SCALE)
                ADDM    A,_DATA_BUF[0]
                SET     ACC
                ADCM    A,_DATA_BUF[1]
        ENDIF


                MOV     A,LAST_POS[0]
                SUB     A,_DATA_BUF[0]
                MOV     _DATA_BUF[2],A
                MOV     A,LAST_POS[1]
                SBC     A,_DATA_BUF[1]
                MOV     _DATA_BUF[3],A

                MOV     A,_DATA_BUF[0]
                MOV     LAST_POS[0],A
                MOV     A,_DATA_BUF[1]
                MOV     LAST_POS[1],A

                MOV     A,WS_BNC_TIME
                SUB     A,WS_BNC
                SNZ     C
                JMP     CHECK_DIR
                MOV     A,_DATA_BUF[0]
                MOV     _POSITION[0],A
                MOV     A,_DATA_BUF[1]
                MOV     _POSITION[1],A
                CLR     WS_BNC_TIME
                JMP     END_CHECK_DIR
        CHECK_DIR:
                MOV     A,10000000B
                ANDM    A,_DATA_BUF[3]
                CLR     _DATA_BUF[2]
                SZ      bLAST_DIR
                SET     _DATA_BUF[2].7

                MOV     A,_DATA_BUF[3]
                XOR     A,_DATA_BUF[2]
                SNZ     Z
                CLR     WS_BNC_TIME

        END_CHECK_DIR:
                SNZ     _DATA_BUF[3].7
                CLR     bLAST_DIR
                SZ      _DATA_BUF[3].7
                SET     bLAST_DIR

                SIZ     WS_BNC_TIME
                JMP     $+2
                SET     WS_BNC_TIME
                RET

;******************************************************************************
;******************************************************************************
;******************************************************************************

PTR_WS_KEY      PROC
                MOV     A,OFFSET _WS_KEY
                MOV     MP1,A
                MOV     A,BANK _WS_KEY
                MOV     BP,A
                RET
PTR_WS_KEY      ENDP


GET_MAX_KEY     PROC
        ;===============================================
        ;       GET_MAX_KEY
        ;===============================================
                CALL    PTR_WS_KEY
                MOV     A,WS_PADn
                MOV     _DATA_BUF[5],A
                RL      ACC
                ADDM    A,MP1
                CLR     _DATA_BUF[6]
        $2:
                DEC     MP1
                MOV     A,_DATA_BUF[6]
                SUB     A,IAR1
                SZ      C
                JMP     $+5
                MOV     A,IAR1
                MOV     _DATA_BUF[6],A
                DECA    _DATA_BUF[5]
                MOV     TBLP,A

                SDZ     _DATA_BUF[5]
                JMP     $2
                RET
GET_MAX_KEY     ENDP





;;**************************************************************
;;SUB. NAME     :DIV17                                         *
;;INPUT         :C:BUF1:BUF0/BUF3:BUF2                         *
;;OUTPUT        :BUF1-0.......BUF5-4                           *
;;USED REGISTER :ACC,BUF0-BUF8                                 *
;;REMARK        :formula = BUF1-0/BUF3-2=BUF1-0...BUF5-4       *
;;              :LIMIT = 0 - 2^16  ; C flag = 17th bit         *
;;**************************************************************
_DIV17:
                CLR     _DATA_BUF[4]
                CLR     _DATA_BUF[5]
                ;--
                MOV     A,_DATA_BUF[2]
                OR      A,_DATA_BUF[3]
                SNZ     Z
                JMP     $+4
                ;-DIV17 OVERFLOW
                CLR     _DATA_BUF[0]
                CLR     _DATA_BUF[1]
                RET

                ;-TOTAL 17 LOOP
                MOV     A,17
                MOV     DIV_LOOP_COUNT,A
                JMP     DIV_MSB

DIV17_LOOP:     ;-DIVID LOOP
                CLR     C
                RLC     _DATA_BUF[0]
                RLC     _DATA_BUF[1]


DIV_MSB:        ;-DIV MSB (C FLAG) FIRST
                RLC     _DATA_BUF[4]
                RLC     _DATA_BUF[5]

                CPLA    _DATA_BUF[4]
                MOV     _DATA_BUF[6],A
                CPLA    _DATA_BUF[5]
                MOV     _DATA_BUF[7],A

                MOV     A,_DATA_BUF[2]
                ADDM    A,_DATA_BUF[6]
                MOV     A,_DATA_BUF[3]
                ADCM    A,_DATA_BUF[7]

                SZ      C
                JMP     DIV17_1

                CPLA    _DATA_BUF[6]
                MOV     _DATA_BUF[4],A
                CPLA    _DATA_BUF[7]
                MOV     _DATA_BUF[5],A
                SET     _DATA_BUF[0].0

DIV17_1:
                SDZ     DIV_LOOP_COUNT
                JMP     DIV17_LOOP
                RET

