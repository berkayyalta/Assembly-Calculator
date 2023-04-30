;By Berkay

section .data 			
	message1   : 	db 10, "Welcome to the assembly calculator ! ", 10, 10, 0
	message2   : 	db 10, "Enter the number 1 : ", 0
	message3   : 	db "Enter the number 2 : ", 0
	add_msg    :  	db 10, "%f + %f = %f", 0
	sub_msg    :  	db 10, "%f - %f = %f", 0
	mul_msg    :  	db 10, "%f * %f = %f", 0
	div_msg    :  	db 10, "%f / %f = %f", 0
	res_msg    : 	db 10, "The result is %f", 10, 10, 0
	operations : 	db "1 for addition, 2 for subtraction ", 10, "3 for multiplication, 4 for division ", 10, "5 to exit : ", 0
	floatf	   : 	db "%f", 0
	intf  	   : 	db "%d", 0
	invld_in   : 	db 10, "Invalid input_operation, the program will be terminated.", 10, 0	

section .bss 			
	number1	   : 	resb 4
	number2    : 	resb 4
	operation  : 	resb 4
	result     : 	resb 4			

section .text 		
	EXTERN 	_printf
	EXTERN 	_scanf	
	GLOBAL 	_main 		


_main: 					
	push message1						; print the message "message1"
	call _printf
	add esp, 4	

	jmp .input_operation
	

.input_operation:
	sub esp, 4							; print the message "operations"
	push operations						
	call _printf										

	sub esp, 8							; get an integer input in "operation"
	push operation						
	push intf						
	call _scanf												

	cmp DWORD [operation], 1 			; jump to the label "invalid_input" if "operation" < 1
	jl .invalid_input		

	cmp DWORD [operation], 5 			; jump to the label "input_numbers" if "operation" < 5 (it is >= 1)
	jl .input_numbers		

	cmp DWORD [operation], 5 			; jump to the label "exit" if "operation" = 5
	je .exit	

	jmp .invalid_input


.input_numbers:
	sub esp, 4							; print the message "message2"
	push message2						
	call _printf   								

	sub esp, 8							; get a float input in "number1"
	push number1						
	push floatf							
	call _scanf											

	sub esp, 4							; print the message "message2"
	push message3						
	call _printf   											

	sub esp, 8							; get a float input in "number1"
	push number2						
	push floatf							
	call _scanf												

	cmp DWORD [operation], 1  			; jump to the label "addition" if "operation" = 1
	je .addition 						

	cmp DWORD [operation], 2 			; jump to the label "subtraction" if "operation" = 2
	je .subtraction 				

	cmp DWORD [operation], 3 			; jump to the label "multiplication" if "operation" = 3
	je .multiplication 					

	cmp DWORD [operation], 4 			; jump to the label "division" if "operation" = 4
	je .division										


.invalid_input:
	sub esp, 4							; throw error if input is invalid
	push invld_in							
	call _printf											
	ret


.addition:				
	fld 	DWORD [number1]				; move number1 to fs(0)
	fadd 	DWORD [number2] 			; add number2 to fs(0)
	fstp 	QWORD [result] 				; store the fs(0) item to result then pop fs(0)

	sub 	esp, 16						; print the operation
	fld 	DWORD [number1] 				
	fld 	DWORD [number2] 				
	fld 	QWORD [result] 				
	fstp 	QWORD [esp+16] 
	fstp 	QWORD [esp+8] 
	fstp 	QWORD [esp] 
	push 	add_msg
	call 	_printf

	jmp .done


.subtraction:
	fld 	DWORD [number1]
	fsub 	DWORD [number2] 
	fstp 	QWORD [result] 

	sub 	esp, 16
	fld 	DWORD [number1] 				
	fld 	DWORD [number2] 				
	fld 	QWORD [result] 				
	fstp 	QWORD [esp+16] 
	fstp 	QWORD [esp+8] 
	fstp 	QWORD [esp] 
	push 	sub_msg
	call 	_printf

	jmp .done


.multiplication:
	fld 	DWORD [number1]
	fmul 	DWORD [number2] 
	fstp 	QWORD [result] 

	sub 	esp, 16
	fld 	DWORD [number1] 				
	fld 	DWORD [number2] 				
	fld 	QWORD [result] 				
	fstp 	QWORD [esp+16] 
	fstp 	QWORD [esp+8] 
	fstp 	QWORD [esp] 
	push 	mul_msg
	call 	_printf

	jmp .done


.division:
	fld 	DWORD [number1]
	fdiv 	DWORD [number2] 
	fstp 	QWORD [result] 

	sub 	esp, 16
	fld 	DWORD [number1] 				
	fld 	DWORD [number2] 				
	fld 	QWORD [result] 				
	fstp 	QWORD [esp+16] 
	fstp 	QWORD [esp+8] 
	fstp 	QWORD [esp] 
	push 	div_msg
	call 	_printf

	jmp .done
 		

.done:		
	sub 	esp, 8						; print the result
	fld 	QWORD [result] 			
	fstp 	QWORD [esp] 					
	push 	res_msg						
	call 	_printf		

	jmp .input_operation


.exit:					
	ret 							
