#include    "USER_PROGRAM.H"

//==============================================
//**********************************************
//==============================================
//#pragma vector  Interrupt_Extemal			@ 0x04
//void Interrupt_Extemal()
//{	
//	;
//}

void __attribute((interrupt(0x04))) Interrupt_Extemal(void)
{
	//Insert your code here
}


//==============================================
//**********************************************
//==============================================
void USER_PROGRAM_INITIAL()
{
	_pac = 0;
	_pa = 0;
	_pbc = 0;
	_pb = 0;
}

//==============================================
//**********************************************
//==============================================


void USER_PROGRAM()
{
  	if(SCAN_CYCLEF)
  	{
		GET_KEY_BITMAP();
  		
  		if(ANY_KEY_PRESSF)
  		{
  			_nop();
  		}
  		
  		if(GET_WATER_EEPROM_STATE)
  		{
			GET_KEY_BITMAP();
			if(DATA_BUF[0]&0x08)
			{
				
			}
			else
			{
				
			}
  		}
  		
  		
//		//water value init
//  		_acc = 0;
//  		if(_acc)
//  		{
//  			WATER_CAP_REBLA_INIT();
//  		}
 	}
}

