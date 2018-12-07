        

message '***************************************************************'
message '*PROJECT NAME :USER PROGRAM CODE                              *'
message '*     VERSION :                                               *'
message '*     IC BODY :                                               *'
message '* ICE VERSION :                                               *'
message '*      REMARK :                                               *'
message '***************************************************************'

                INCLUDE EEPROM_PROGRAM.INC

                PUBLIC  _EEPROM_PROGRAM_INITIAL
                PUBLIC  _EEPROM_PROGRAM 
                
                
                PUBLIC  _WATER_CAP_REBLA_INIT
                PUBLIC  _WATER_FLAG
                PUBLIC  _GET_WATER_EEPROM_STATE 
                
                

#DEFINE ADD_BLOCK1          6
                
                ;========================
                ;=USER DATA DEFINE      =
                ;========================
USER_DATA       .SECTION   'DATA'

_WATER_FLAG     LABEL   BYTE    ;for C complier V3
;-OPTION WATER BIT DEFINE     
_GET_WATER_EEPROM_STATE DBIT                                      
_READ_DATA_TO_RAM       DBIT
_BLOCK1_CHECK           DBIT
_BLOCK2_CHECK           DBIT                                                      
_RESET_DATA             DBIT                                                    
_RE_SAVE_DATA           DBIT                                                    
_WATER_FLAG7            DBIT                                                    
_WATER_FLAG8            DBIT      

                ;========================
                ;=USER PROGRAM          =
                ;========================
EEPROM_PROGRAM    .SECTION   'CODE'
                           
;;***********************************************************                           
;;*SUB. NAME:USER INITIAL PROGRAM                           *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************                           
                        ;;**************************
_EEPROM_PROGRAM_INITIAL:;;* EEPROM_PROGRAM_INITIAL *
                        ;;**************************

                CLR     EMI
                MOV     A,ADD_BLOCK1
                MOV     _DATA_BUF[1],A
                CLR     _READ_DATA_TO_RAM
                CALL    READ_BLOCK
                SZ      Z
                SET     _BLOCK1_CHECK
                
                ;MOV     A,ADD_BLOCK2
                CALL    _GET_KEY_AMOUNTx3
                ADD     A,ADD_BLOCK1+1
                
                MOV     _DATA_BUF[1],A
                CLR     _READ_DATA_TO_RAM
                CALL    READ_BLOCK
                SZ      Z
                SET     _BLOCK2_CHECK
                SET     EMI
                
                RET
                
;;***********************************************************                           
;;*SUB. NAME:USER_MAIN                                      *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************                           
                ;;********************
_EEPROM_PROGRAM:  ;;USER PROGRAM ENTRY *
                ;;********************
                
                SNZ     _TKS_ACTIVEF
                SET     _RESET_DATA
                
                SZ      _TKS_ACTIVEF
                SNZ     _TKS_500MSF
                JMP     EEPROM_SAVE_END
                
                SNZ     _GET_WATER_EEPROM_STATE
                JMP     EEPROM_SAVE
                
                SZ      _RESET_DATA
                JMP     RESET_DATA
                JMP     EEPROM_SAVE_END
        
        EEPROM_SAVE:        
                CLR     EMI
                SNZ     _RE_SAVE_DATA
                CALL    READ_BLOCK1_TO_RAM
                CALL    WRITE_BLOCK1_TO_RAM
                
        RESET_DATA:
                CALL    READ_BLOCK1_TO_RAM
                CLR     _RESET_DATA
                CLR     _RE_SAVE_DATA
                SET     _GET_WATER_EEPROM_STATE
        EEPROM_SAVE_END:
                SET     EMI
                RET
                
;*****************************************************************************              
        READ_BLOCK1_TO_RAM:     
                SNZ     _BLOCK1_CHECK
                JMP     READ_BLOCK2_TO_RAM
                MOV     A,ADD_BLOCK1
                MOV     _DATA_BUF[1],A
                SET     _READ_DATA_TO_RAM
                CALL    READ_BLOCK
                SZ      Z
                SET     _BLOCK1_CHECK
                JMP     WRITE_BLOCK1_TO_RAM
                
        READ_BLOCK2_TO_RAM: 
                SNZ     _BLOCK2_CHECK
                RET
                ;--
                ;MOV     A,ADD_BLOCK2
                CALL    _GET_KEY_AMOUNTx3
                ADD     A,ADD_BLOCK1+1
                ;--
                MOV     _DATA_BUF[1],A
                SET     _READ_DATA_TO_RAM
                CALL    READ_BLOCK
                SZ      Z
                SET     _BLOCK2_CHECK
                RET
                
        WRITE_BLOCK1_TO_RAM:    
                SZ      _BLOCK1_CHECK
                JMP     $+5             
                MOV     A,ADD_BLOCK1
                MOV     _DATA_BUF[1],A
                CALL    WRITE_BLOCK
                SET     _BLOCK1_CHECK
        WRITE_BLOCK2_TO_RAM:
                SZ      _BLOCK2_CHECK
                JMP     $+6
                ;--
                ;MOV     A,ADD_BLOCK2
                CALL    _GET_KEY_AMOUNTx3
                ADD     A,ADD_BLOCK1+1
                ;--
                MOV     _DATA_BUF[1],A
                CALL    WRITE_BLOCK
                SET     _BLOCK2_CHECK
                RET
                
                
;;***********************************************************                           
;;*SUB. NAME:WRITE EEPROM                                   *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************


        WRITE_BLOCK:    
                MOV     A,OFFSET _KEY_REF+1
                MOV     MP0,A
                ;--kye x 3
                CALL    _GET_KEY_AMOUNTx3
                MOV     _DATA_BUF[0],A
                ;--
                MOV     A,4
                MOV     _DATA_BUF[2],A
                CLR     _DATA_BUF[3]    ;CHECK SUM
        WRITE_BLOCK1_DATA_LOOP:
                SDZA    _DATA_BUF[2]
                JMP     $+4
                MOV     A,4
                MOV     _DATA_BUF[2],A
                INC     MP0
                
                MOV     A,_DATA_BUF[1]
                MOV     EEA,A
                MOV     A,IAR0
                ADDM    A,_DATA_BUF[3]
                CALL    WRITE_EEPROM
                
                INC     MP0
        WRITE_DATA_END:
                DEC     _DATA_BUF[2]
                INC     _DATA_BUF[1]
                SDZ     _DATA_BUF[0]
                JMP     WRITE_BLOCK1_DATA_LOOP
                
                MOV     A,_DATA_BUF[1]
                MOV     EEA,A
                MOV     A,_DATA_BUF[3]
                CALL    WRITE_EEPROM
                RET
                
;******************************************************************************             
        READ_BLOCK: 
                MOV     A,OFFSET _KEY_REF
                MOV     MP0,A
                ;--kye x 3
                CALL    _GET_KEY_AMOUNTx3
                MOV     _DATA_BUF[0],A
                ;--
                MOV     A,2
                MOV     _DATA_BUF[2],A
                CLR     _DATA_BUF[3]    ;CHECK SUM
                
           if KeyAmount == 1   
                MOV     A,1
                MOV     _DATA_BUF[4],A
           else  
                SWAPA   _KEY_IO_SEL[0]
                MOV     _DATA_BUF[4],A
           endif
                
        READ_BLOCK1_DATA_LOOP:
                SDZA    _DATA_BUF[2]
                JMP     $+4
                MOV     A,4
                MOV     _DATA_BUF[2],A
                INC     MP0
                
                MOV     A,_DATA_BUF[1]
                CALL    READ_EEPROM
                MOV     _DATA_BUF[5],A
                
                RRCA    _DATA_BUF[4]
                SNZ     C
                JMP     $+4
                MOV     A,_DATA_BUF[5]
                SZ      _READ_DATA_TO_RAM
                MOV     IAR0,A
                
                DEC     _DATA_BUF[2]
                MOV     A,_DATA_BUF[2]
                XOR     A,2
                SZ      Z
                RR      _DATA_BUF[4]
                
                MOV     A,_DATA_BUF[5]
                ADDM    A,_DATA_BUF[3]
                INC     MP0
        READ_DATA_END:
                INC     _DATA_BUF[1]
                SDZ     _DATA_BUF[0]
                JMP     READ_BLOCK1_DATA_LOOP
                
                MOV     A,_DATA_BUF[1]
                CALL    READ_EEPROM
                XOR     A,_DATA_BUF[3]
                RET
                
;;***********************************************************                           
;;*SUB. NAME:                                               *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************

_WATER_CAP_REBLA_INIT:
                CLR     _WATER_FLAG
                JMP     _LIBRARY_RESET

;;***********************************************************                           
;;*SUB. NAME:WRITE EEPROM                                   *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************
WRITE_EEPROM:
                MOV     EED,A
                MOV     A,040H
                MOV     MP1,A
                MOV     A,001H
                MOV     BP,A
                
                SET     IAR1.3
                SET     IAR1.2
                ;-WAIT WRITE FINISH
                SZ      IAR1.2
                JMP     $-1
                CLR     EEA
                RET
                
;;***********************************************************                           
;;*SUB. NAME:WRITE EEPROM                                   *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************
READ_EEPROM: 
                MOV     EEA,A
                MOV     A,040H
                MOV     MP1,A
                MOV     A,001H
                MOV     BP,A
                SET     IAR1.1
                SET     IAR1.0
                ;-WAIT READ FINISH
                SZ      IAR1.0
                JMP     $-1
                MOV     A,EED
                CLR     IAR1
                CLR     EEA
                RET
