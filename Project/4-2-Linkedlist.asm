assume cs:code, ds:data, ss:stacksg

SHOW macro string
	push ax
	
	lea dx, string
	mov ax, 0900h
	int 21h
	
	pop ax
endm

CLS macro
	push ax
	
	mov ax, 0003h
	int 10h
	
	pop ax
endm

NODE struc
	score dw 0
	link dw 0
NODE ends

HNODE struc
	head dw 0
	len dw 0
HNODE ends

data segment
	la NODE 20 dup(<>)
	lh HNODE <>
	entrance dw Init
	str_list db 256 dup('$')
	divisor dw 10
data ends

stacksg segment stack
	dw 256 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 512
		
		call Init
		; Test data
		; mov word ptr la[0].link, 4
		; mov word ptr la[4].score, 1
		; mov word ptr la[4].link, 8
		; mov word ptr la[8].score, 65535
		; mov word ptr la[8].link, 1
		; mov lh.len, 2
		;call ListtoStr
		;SHOW str_list
		;SHOW menu
		call Choice
		
		mov ax, 4c00h
		int 21h
	
	; function: Initialize the list
	; input: none
	; outpt: none
	Init:
		push bx
		; all nodes' likn set 0
		mov bx, 0
		forI1:
			cmp bx, 80
			jz endforI1
			
			mov byte ptr la[bx].link, 0
			
			add bx, 4
			jmp forI1
			endforI1:
				nop
		; the first node's link set 1
		mov bx, lh.head
		mov word ptr la[bx].link, 1
		
		; the list length is 0
		mov lh.len, 0
		call ListtoStr
		
		pop bx
		ret
	
	Choice:
		push ax
		push bx
		
		whileC1:
			CLS
			; SHOW logo
			SHOW str_list
			; SHOW options
			; 1 -- Initialize the list
			; 2 -- Add node
			; 3 -- Delete Node
			; 4 -- Exit
		
			; input a character
			mov ax, 0100h
			int 21h
			
			; judge the character
			cmp al, '4'
			jz returnC
			
			; handle the character
			xor ah, ah
			sub ax, 31h
			mov bx, ax
			add bx, bx
			
			; chosse the entrance
			call word ptr entrance[bx]
			
			jmp whileC1
		
		returnC:
			pop bx
			pop ax
		
			ret
	
	; function: Generates a string from a linked list
	; input: none
	; output: none
	ListtoStr:
		push ax
		push bx
		push bp
		push cx
		push dx
	
		call Clearlist
		mov cx, lh.len
		cmp cx, 0
		jnz convert
		mov str_list[0],'N'
		mov str_list[1],'U'
		mov str_list[2],'L'
		mov str_list[3],'L'
		jmp returnL
		
		convert:
			mov bx, 0
			mov bp, lh.head
			mov bp, word ptr la[bp].link
			mov ax, 0
			mov dx, 1
			
			whileL1:
				; add serial number
				mov ax, dx
				call NumtoStr
				mov str_list[bx], '|'
				inc bx
				
				; add score
				mov ax, word ptr la[bp].score
				mov bp, word ptr la[bp].link
				call NumtoStr
				
				; add decoration
				mov str_list[bx], ' '
				inc bx
				mov str_list[bx], '-'
				inc bx
				mov str_list[bx], '>'
				inc bx
				mov str_list[bx], ' '
				inc bx
				
				inc dx
				loop whileL1
			sub bx, 4
			mov str_list[bx], '$'
			
		returnL:
			pop dx
			pop cx
			pop bp
			pop bx
			pop ax
			ret
	
	; function: make str_list all '$'
	; input: none
	; output: none
	Clearlist:
		push bx
		
		mov bx, 0
		forC1:
			cmp byte ptr str_list[bx], '$'
			jz endforC1
			
			mov byte ptr str_list[bx], '$'
			
			inc bx
			jmp forC1
			endforC1:
				nop
		
		pop bx
		ret
	
	; function: Convert number to string
	; input: ax--the number bx--the first empty place of string
	; output: bx--after the last place  of string 
	NumtoStr:
		push cx
		push dx
		
		mov cx, 0
		
		whileN1:
			mov dx, 0		
			div divisor
			add dx, 30h
			push dx
			inc cx
			cmp ax, 0
			jnz whileN1
		
		whileN2:
			pop dx
			mov byte ptr str_list[bx], dl
			inc bx
			loop whileN2
		
		pop dx
		pop cx
		ret
	
	Addnode:
		
code ends
end start