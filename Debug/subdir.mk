################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LIB_SRCS += \
../csl5509x.lib 

C_SRCS += \
../main.c 

ASM_SRCS += \
../symFir.asm 

CMD_SRCS += \
../FIR_dec.cmd 

ASM_DEPS += \
./symFir.pp 

OBJS += \
./main.obj \
./symFir.obj 

C_DEPS += \
./main.pp 

OBJS__QTD += \
".\main.obj" \
".\symFir.obj" 

ASM_DEPS__QTD += \
".\symFir.pp" 

C_DEPS__QTD += \
".\main.pp" 

C_SRCS_QUOTED += \
"../main.c" 

ASM_SRCS_QUOTED += \
"../symFir.asm" 


# Each subdirectory must supply rules for building sources it contributes
./main.obj: ../main.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/EE/CCS/ccsv4/tools/compiler/c5500/bin/cl55" -v5509A -g --define="CHIP_5509" --include_path="C:/Program Files/C55xxCSL/include" --include_path="C:/Users/Hathaway/Desktop/FIR_dec_sym" --include_path="C:/EE/CCS/ccsv4/tools/compiler/c5500/include" --include_path="C:/EE/CCS/xdais_7_10_00_06/packages/ti/xdais" --quiet --diag_warning=225 --large_memory_model --memory_model=large --obj_directory="C:/Users/Hathaway/Desktop/FIR_dec_sym/Debug" --preproc_with_compile --preproc_dependency="main.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

./symFir.obj: ../symFir.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/EE/CCS/ccsv4/tools/compiler/c5500/bin/cl55" -v5509A -g --define="CHIP_5509" --include_path="C:/Program Files/C55xxCSL/include" --include_path="C:/Users/Hathaway/Desktop/FIR_dec_sym" --include_path="C:/EE/CCS/ccsv4/tools/compiler/c5500/include" --include_path="C:/EE/CCS/xdais_7_10_00_06/packages/ti/xdais" --quiet --diag_warning=225 --large_memory_model --memory_model=large --obj_directory="C:/Users/Hathaway/Desktop/FIR_dec_sym/Debug" --preproc_with_compile --preproc_dependency="symFir.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '


