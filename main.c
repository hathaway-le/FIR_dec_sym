#include <stdio.h>
#include <csl.h>
#include <csl_pll.h>
#include <coefficients.h>
#include <input.h>

#define ST1_55            *(int *)0x03
#define FIR_FILTER_SIZE   174
#define N                 2048    
 
long int output[N/2];
long int value[FIR_FILTER_SIZE]; /* Retain value between calls */
int index;
extern void symFir(long *input,long *coefficients,long *output,int order,long *value,int *index);

PLL_Config  myConfig      = {
  0,                                    //IAI: the PLL locks using the same process that was underway 
                                        //before the idle mode was entered
  1,                                    //IOB: If the PLL indicates a break in the phase lock, 
                                        //it switches to its bypass mode and restarts the PLL phase-locking 
                                        //sequence
  24,                                   //PLL multiply value; multiply 24 times
  1                                     //Divide by 2 PLL divide value; it can be either PLL divide value 
                                        //(when PLL is enabled), or Bypass-mode divide value
                                        //(PLL in bypass mode, if PLL multiply value is set to 1)
};

 void main()
{
    int k=0;
    ST1_55 =  ST1_55|0x0100;   	        //SXMD=1(允许符号拓展) SATD=0（不做饱和处理） FRCT=0(小数模式关)

    CSL_init();                         //Initialize CSL library   
    PLL_config(&myConfig);              //144MHz=12*24/(1+1)
/***************************************************************************************************************/    
    for(k=0;k<N/2;k++)
    {
    	output[k]=0;
    }
    for(k=0;k<FIR_FILTER_SIZE;k++)
    {
    	value[k]=0;
    }
    index=0; 
/****************************************************************************************************************/    
	for(k=0;k<N;k=k+2) //汇编中一次采集2个输入数据
	{		
	    symFir(&input[k],&coefficient[0],&output[k/2],FIR_FILTER_SIZE,&value[0],&index);
	}

//	while(1)
//	{
		
//	}
}      
