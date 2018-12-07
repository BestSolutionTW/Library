
;;******************************************
;;****TKS GLOBE VARIES DEFINE FOR ASM CODE *
;;******************************************
;-DEFINE LIBRARY VERSION
#DEFINE _V413_
;-SELECT IC BODY & INCLUDE REFERENCE FILE
#DEFINE _BS83B08A_
;-INCLUDE SYSTEM REFERENCE FILE 
INCLUDE BS83B08A-4.INC


;------------------------
;-DEFINE SYSTEM CLOCK   -
;------------------------
#define SystemClock             0       ;0=8MHZ
                                        ;1=12MHZ
                                        ;2=16MHZ

 

;--------------------------------
;-TOUCH KEY LIBRARY VARIES DEFINE
;--------------------------------
;-numeric operate ; range 0 ~ 15;                                            
#define DebounceTimes           5          

;-numeric operate ; range 0 ~ 15; function: Time period to calibrate                   
#define AutoCalibrationPeriod   7       ;auto calibration period select 0=80ms .....15=1280ms

;-bit operate                   ; function: Sensitive double up
#define HighSensitive           1       ;0=Normal ; 1=High Sensitive

;-numeric operate ; range 0 ~ 15; function: key holding time ,if time out will reset key status to non-press
#define MaximumKeyHoldTime      3       ;0=disable ; 1=4 secend ...... 15=60secend
 
;-bit operate ; range 0/1       ; function: Fasting internal singal filter speed led key response faster
#define FastResponse            0       ;0=Normal ; 1=Fast Response       

;-bit operate ; range 0/1       ; function: enalbe hardware hopping function                           
#define AutoFrequencyHopping    1       ;0=disable ; 1=enable

;-bit operate ; range 0/1       ; function: moving calibration signal whatever key press or not
#define MovingCalibration       1       ;0=calibrate when key non press  ; 1=enable calibration whatever key press or not


  
;-Key threshold define 
#define Key1Threshold           32     ;suggestion range 10 ~ 64
#define Key2Threshold           32	
#define Key3Threshold           32 
#define Key4Threshold           32
;--
#define Key5Threshold           32     ;suggestion range 10 ~ 64
#define Key6Threshold           32	
#define Key7Threshold           32 
#define Key8Threshold           32
;--


;---------------------
;-WATER DEBOUNCE TIME 
;---------------------
;---------------------------------
;-DEFINE PIN AS I/O OR TOUCH INPUT
;---------------------------------
#define IO_TOUCH_ATTR_BUF	00000000B ;0=IO 1=TOUCH INPUT
						   ;8   4  1 KEY
							   

#define IO_WATER_ATTR_BUF	00001111B ;0=IO 1=WATER INPUT
						   ;8   4  1 KEY	
							   
;===============================================================================
;===============================================================================
;===============================================================================
;========================================
;===WARNING : DO NOT MODIFY THE VALUE ===
;========================================

#define KeyAmount               4
;-----------------------------------------
;-conbine above varies in GlobeOptionA/B/C
;-----------------------------------------
;-bit operate ; range 0/1       ; function: Low power consumption 
#define PowerSave               0     ;0=disable ; 1=power save mode
 
;-bit operate ; range 0/1       ; function: Noise interfere protect to prevent false trigger                                
#define NoiseProtect            1       ;0=disable ; 1=enable

#define GlobeOptionA            (AutoCalibrationPeriod<<4)|DebounceTimes                                           
#define GlobeOptionB            (MaximumKeyHoldTime<<4)|HighSensitive                                                 
#define GlobeOptionC            (MovingCalibration<<7)|(PowerSave<<6)|(NoiseProtect<<4)|(AutoFrequencyHopping<<3)|(FastResponse<<2)                                         


#define	IO_TOUCH_ATTR		IO_TOUCH_ATTR_BUF | IO_WATER_ATTR_BUF<<4 | IO_WATER_ATTR_BUF


;#define	AUTO_SCAN_FREQ			0		;1 open, 0 close
;#define	AUTO_SCAN_FREQ1			1700 	;K
;#define	AUTO_SCAN_FREQ2			2400 	;K
;#define	AUTO_SCAN_FREQ3			3000 	;K