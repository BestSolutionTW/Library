        
message '***************************************************************'                          
message '*SUB. NAME:UART TEST CODE                                     *'                          
message '*INPUT    :                                                   *'                          
message '*OUTPUT   :                                                   *'                          
message '*USED REG.:                                                   *'                          
message '*FUNCTION :                                                   *'                          
message '*REMARK   :                                                   *' 
message '***************************************************************'
                ;=INCLUDE REFERENCE FILE
                INCLUDE UART_TEST.INC

                PUBLIC  _UART_TEST_INITIAL
                PUBLIC  _UART_TEST
                
             

                ifndef  _UART_TEST_
                ;----------------------
                ;-UART FUNCTION DEFINE
                ;------------------
                #define _UART_TX_C      PAC.0 ;PAC.7PAC.7   ;Define PXX as TX output 
                #define _UART_TX        PA.0 ;PA.7    ;   
;                #define _UART_TX_C      PBC.3 ;PAC.7PAC.7   ;Define PXX as TX output 
;                #define _UART_TX        PB.3 ;PA.7    ;                                                       
                #define BAUDRATE_OPTION 2       ;0=38400 ;1=57600 ; 2=115200
                endif
 

                ;================================================
                ;=Compatable with old MAIN_PROGRAM.ASM version  =
                ;================================================
                ;=Define IC Body 
                ifdef   BS83A04A
                    ifndef  _BS83A04A_
                    #define _BS83A04A_
                    endif
                endif
                ;----------------------
                ifdef   BS83B08A
                    ifndef  _BS83B08A_
                    #define _BS83B08A_
                    endif
                endif
                ;----------------------
                ifdef   BS83B12A
                    ifndef  _BS83B12A_
                    #define _BS83B12A_
                    endif
                endif
                ;----------------------
                ifdef   BS83B16A
                    ifndef  _BS83B16A_
                    #define _BS83B16A_
                    endif
                endif
                ;----------------------
                ifdef   BS84B08A
                    ifndef  _BS84B08A_
                    #define _BS84B08A_
                    endif
                endif
                ;----------------------
                ifdef   BS84C12A
                    ifndef  _BS84C12A_
                    #define _BS84C12A_
                    endif
                endif
                ;----------------------
                ifdef   BS82B16 
                    ifndef  _BS82B16_  
                    #define _BS82B16_ 
                    endif
                endif
                ;----------------------
                ifdef   BS82C16A
                    ifndef  _BS82C16A_ 
                    #define _BS82C16A_
                    endif
                endif
                ;----------------------
                ifdef   BS82D20A
                    ifndef  _BS82D20A_ 
                    #define _BS82D20A_
                    endif
                endif
                ;----------------------
         

                ;================
                ;=BAUDRATE MACRO=                               
                ;================  
                ifdef   _BS83A02A_
                #define _SYS_CLK        0
                endif

                ifdef   _BS83A04A_
                #define _SYS_CLK        0
                endif

                ifndef  _SYS_CLK  
                #define _SYS_CLK        1
                endif  
                                                                
BAUDRATE_DELAY  MACRO                                           
        ;-System clock = 8MHZ                               
if      _SYS_CLK == 0 ;SystemClock == 0 ;8MHZ                   
        if      BAUDRATE_OPTION == 0                            
                JMP     $+1                                     
                MOV     A,14            ;38400                  
                                                                
        elseif  BAUDRATE_OPTION == 1                            
                MOV     A,8             ;57600                  
                                                                
        else    ;-----                                          
              ;;NOP                                             
                MOV     A,2             ;115200                 
                                                                
        endif                                                   
                                                                
        ;-System clock = 12MHZ                               
elseif  _SYS_CLK == 1 ;SystemClock == 1 ;12MHZ                  
        if      BAUDRATE_OPTION == 0                            
                NOP                                             
                MOV     A,22            ;38400                  
                                                                
        elseif  BAUDRATE_OPTION == 1                            
                MOV     A,13            ;57600                  
                                                                
        else    ;---                                            
                MOV     A,5             ;115200                 
        endif                                                   
;--                                                             
else                                    ;16MHZ                  
        ;-System clock = 16MHZ                               
        if      BAUDRATE_OPTION == 0                            
                NOP                                             
                MOV     A,30            ;38400                  
                                                                
        elseif  BAUDRATE_OPTION == 1                            
                NOP                                             
                NOP                                             
                MOV     A,19            ;57600                  
                                                                
        else    ;--                                             
                MOV     A,8             ;115200                 
                                                                
        endif                                                   
;--                                                             
endif            
                ;--                         
                SDZ     ACC                                     
                JMP     $-1
                ;--                                  
                ENDM    ;END OF MACRO                           
                                                                
                ;===                                            
                



                ;==============
                ;=DATA SETCTION
                ;==============
UART_TEST_DATA  .SECTION   'DATA'
                                     
TX_REF_TIME     DB      ?

            
                ;==============
                ;=CODE SETCTION
                ;==============
UART_TEST_CODE  .SECTION   'CODE'

;;***********************************************************                           
;;*SUB. NAME:                                               *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************                           
_UART_TEST_INITIAL:
              ;;RET


;;***********************************************************                           
;;*SUB. NAME:                                               *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************                           
_UART_TEST: 
                SZ      _TKS_ACTIVEF
                SNZ     _SCAN_CYCLEF
                RET

                ;-PER 8 CYCLE TX REF. VALUE
                SZ      TX_REF_TIME.2
                CLR     TX_REF_TIME
                INC     TX_REF_TIME

                ;---------------------                                  
SEND_UART_DATA: ;-SEND ENV/REF COUNT -                                  
                ;---------------------    
                ;-SEND START IDENTIFY CODE
                MOV     A,002H          ;SEND ENVIRONMENT
                SZ      TX_REF_TIME.2
                MOV     A,004H          ;SEND REFERENCE
                CALL    SEND_BYTE

                ;-GET KEY AMOUNT
                CALL    _GET_KEY_AMOUNT
                MOV     _DATA_BUF[4],A
SEND_UART_LOOP: ;-SEND UART DATA LOOP
                CALL    _GET_KEY_AMOUNT
                SUB     A,_DATA_BUF[4]
                ;--
                SNZ     TX_REF_TIME.2
                CALL    _GET_ENV_VALUE      
                SZ      TX_REF_TIME.2
                CALL    _GET_REF_VALUE
                ;--
                SWAPA   _DATA_BUF[0]
                CALL    SEND_HIGH_NIBBLE
                MOV     A,_DATA_BUF[0]
                CALL    SEND_LOW_NIBBLE
                ;--
                SWAPA   _DATA_BUF[1]
                CALL    SEND_HIGH_NIBBLE
                MOV     A,_DATA_BUF[1]
                CALL    SEND_LOW_NIBBLE
                ;--
                SDZ     _DATA_BUF[4]
                JMP     SEND_UART_LOOP
                
                CALL    _GET_KEY_AMOUNT
                MOV     _DATA_BUF[4],A
SEND_UART_LOOP1: ;-SEND UART DATA LOOP
                CALL    _GET_KEY_AMOUNT
                SUB     A,_DATA_BUF[4]
                ;--
                CALL    _GET_RCC_VALUE
                ;CALL    _GET_RCC_VALUE  ;GET REFERENCE VALUE
                ;--
                SWAPA   _DATA_BUF[0]
                CALL    SEND_HIGH_NIBBLE
                MOV     A,_DATA_BUF[0]
                CALL    SEND_LOW_NIBBLE
                ;--
                SWAPA   _DATA_BUF[1]
                CALL    SEND_HIGH_NIBBLE
                MOV     A,_DATA_BUF[1]
                CALL    SEND_LOW_NIBBLE
                ;--
                
                SDZ     _DATA_BUF[4]
                JMP     SEND_UART_LOOP1
                
                MOV     A,003H
                CALL    SEND_BYTE


              ;;SZ      TX_REF_TIME.2
              ;;CALL    _LIBRARY_RESET


                RET


                                  
;;***********************************************************                           
;;*SUB. NAME:                                               *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************
SEND_HIGH_NIBBLE:
SEND_LOW_NIBBLE:
                AND     A,00001111B                                                     
                OR      A,00110000B                                                     
                                                  
;;***********************************************************                           
;;*SUB. NAME:                                               *                           
;;*INPUT    :                                               *                           
;;*OUTPUT   :                                               *                           
;;*USED REG.:                                               *                           
;;*FUNCTION :                                               *                           
;;***********************************************************                           
SEND_BYTE:                      
                MOV     _DATA_BUF[5],A                                  
                SET     _DATA_BUF[6]                                    
                ;--                                                     
                MOV     A,9+3           ;3 STOP BIT                     
                MOV     _DATA_BUF[7],A                                  
                ;----------------                                       
                ;-SEND START BIT-                                       
                ;----------------                                       
                CLR     EMI                                             
                SET     _UART_TX                                        
                CLR     _UART_TX_C                                      
                CLR     C               ;START BIT                      
SEND_BIT_LOOP:  ;-SEND BIT DATA LOOP                                    
                SZ      C                                               
                JMP     TX_HIGH                                         
                ;-TX LOW                                                
                NOP                     ;DELAY 1 INST.                  
                CLR     _UART_TX                                        
                JMP     TX_BIT                                          
TX_HIGH:        ;-TX HIGH                                               
                SET     _UART_TX                                        
                JMP     $+1             ;DELAY 2 INST.                  
TX_BIT:         ;-TX ONE BIT                                            
                RRC     _DATA_BUF[6]                                    
                RRC     _DATA_BUF[5]                                    
                ;--                                                     
                BAUDRATE_DELAY                                          
                ;--                                                     
                SDZ     _DATA_BUF[7]                                    
                JMP     SEND_BIT_LOOP                                   
                ;--                                                     
                SET     EMI                                             
                RET         
                




;;***********************************************************   
;;*SUB. NAME:                                               *   
;;*INPUT    :ACC                                            *   
;;*OUTPUT   :_DATA_BUF[0],_DATA_BUF[1]                      *   
;;*USED REG.:ACC , _DATA_BUF[0] , MP1 , IAR1 , BP           *   
;;*FUNCTION :GET "RCC" VALUE                                *   
;;***********************************************************   
GET_RCC_3M:                  
                RL      ACC
                RL      ACC
                ADD     A,OFFSET _KEY_STATUS+2
                MOV     MP1,A
                MOV     A,BANK _KEY_STATUS
                MOV     BP,A 
                MOV     A,IAR1
                MOV     _DATA_BUF[0],A
                CLR     _DATA_BUF[1]
                RET


                                            
;;***********************************************************   
;;*SUB. NAME:                                               *   
;;*INPUT    :ACC                                            *   
;;*OUTPUT   :_DATA_BUF[0],_DATA_BUF[1]                      *   
;;*USED REG.:ACC , _DATA_BUF[0] , MP1 , IAR1 , BP           *   
;;*FUNCTION :GET "RCC" VALUE                                *   
;;***********************************************************   
GET_RCC_11M:                 
                RL      ACC
                RL      ACC
                ADD     A,OFFSET _KEY_STATUS+3
                MOV     MP1,A
                MOV     A,BANK _KEY_STATUS
                MOV     BP,A
                MOV     A,IAR1
                MOV     _DATA_BUF[0],A
                CLR     _DATA_BUF[1]
                RET


                                            
                                                                        
                                                                         
                END

                


