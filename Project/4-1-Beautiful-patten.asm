assume cs:code, ds:data, ss:stacksg

SHOW macro string
	push ax
	
	lea dx, string
	mov ax, 0900h
	int 21h
	
	pop ax
endm

CLS macro
	;push ax
	
	mov ax, 0003h
	int 10h
	
	;pop ax
endm

data segment
	hello 	db'  _________.__        __      __.__  __   ', 0dh, 0ah
			db' /   _____/|__| _____/  \    /  \__|/  |_ ', 0dh, 0ah
			db' \_____  \ |  |/     \   \/\/   /  \   __\', 0dh, 0ah
			db' /        \|  |  Y Y  \        /|  ||  |  ', 0dh, 0ah
			db'/_______  /|__|__|_|  /\__/\  / |__||__|  ', 0dh, 0ah
			db'        \/          \/      \/            ', 0dh, 0ah
			db'$'
	hello2 	db '	                                                               ', 0dh, 0ah
			db '.____    .__        __              .___.____    .__          __   ', 0dh, 0ah
			db '|    |   |__| ____ |  | __ ____   __| _/|    |   |__| _______/  |_ ', 0dh, 0ah
			db '|    |   |  |/    \|  |/ // __ \ / __ | |    |   |  |/  ___/\   __\', 0dh, 0ah
			db '|    |___|  |   |  \    <\  ___// /_/ | |    |___|  |\___ \  |  |  ', 0dh, 0ah
			db '|_______ \__|___|  /__|_ \\___  >____ | |_______ \__/____  > |__|  ', 0dh, 0ah
			db '        \/       \/     \/    \/     \/         \/       \/        ', 0dh, 0ah
			db '                                                                   ', 0dh, 0ah
			db '$'
data ends

stacksg segment stack
	dw 16 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 32
		
		CLS
		SHOW hello2
	
		mov ax, 4c00h
		int 21h
code ends
end start