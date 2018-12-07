; ========================================================================================================================
; * Created by: Holtek Touch Key Workshop, Version 3.0.2.6
; MAIN_PROGRAM_V101.inc
; 05:48:27 PM Friday, October 24, 2014
; =========================================================================================================;;***********************************
;;***** MAIN_PROGRAM INCLUDE FILE   *
;;***********************************
;=-------------------------------
;=INCLUDE LIBRARY               -
;=EXTERNAL REFERENCE FILE       -
;=-------------------------------
INCLUDE "..\TKS_GLOBE_VARIES.INC"
INCLUDE "MAIN_PROGRAM\MAIN_PROGRAM_20180222.MCU"

        ;-FUNCTION DEFINE               ;-FUNCTION NAME
INCLUDE "..\BS83B08A_CTOUCH_WATER_V501\BS83B08A_CTOUCH_WATER_V501.AEX"
#DEFINE EXTEND_FUNCTION_1A_INITIAL      _BS83B08A_CTOUCH_WATER_V501_INITIAL
#DEFINE EXTEND_FUNCTION_1A              _BS83B08A_CTOUCH_WATER_V501

        ;-FUNCTION DEFINE               ;-FUNCTION NAME
INCLUDE "..\EEPROM_PROGRAM\EEPROM_PROGRAM.AEX"
#DEFINE EXTEND_FUNCTION_1B_INITIAL      _EEPROM_PROGRAM_INITIAL
#DEFINE EXTEND_FUNCTION_1B              _EEPROM_PROGRAM


;INCLUDE "..\UART_TEST\UART_TEST.AEX"
;#DEFINE EXTEND_FUNCTION_1E_INITIAL      _UART_TEST_INITIAL
;#DEFINE EXTEND_FUNCTION_1E              _UART_TEST

;--
INCLUDE "..\USER_PROGRAM\USER_PROGRAM.AEX"
#DEFINE EXTEND_FUNCTION_1F_INITIAL      _USER_PROGRAM_INITIAL
#DEFINE EXTEND_FUNCTION_1F              _USER_PROGRAM
