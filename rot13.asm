section .data
	f_in: db "file_input.txt",0
	f_out: db "file_output.txt",0
section .bss
	Buff resb 1		;hold the value of one char
	fd_in resb 4
	fd_out resb 4
section .data
global _start
_start:
	nop			;keeps gdb debugger happy
;Creates the output file that will be used to store
;the encoded ROT13 data
Create:
	mov eax, 8		;sys call, create
	mov ebx, f_out		;file name is ebx register
	mov ecx, 666q		;file permisions for the outfile in octal
	int 80h			;kernel call
	mov [fd_out], eax	;mov file desc into fd_out

;Open the input file to be read in read only mode
;(0) = read only
;(1) = write only
;(2) = read write only
Open:
	mov eax, 5		;sys call, open
	mov ebx, f_in		;file name in ebx
	mov ecx, 0		;file access mode (0) == read only
	int 80h			;kernel call
	mov [fd_in], eax	;mov file desc into fd_in

;Read the opened file data into Buff var declared above
;Buff only holds 1 byte
Read:	
	mov eax, 3		;sys call, read
	mov ebx, [fd_in]	;mov file desc in ebx
	mov ecx, Buff		;mov pointer Buff into ecx
	mov edx, 1		;mov Buff size into edx
	int 80h

	cmp eax, 0		;check val in eax with 0
	je Exit			;if eax is (0 means EOF) so exit
	
;Test for ASCII characters, if not ASCII just 
;jump to write, dont bother encoding
;Will need better way to test as this assumes
;everything in between 'A' and 'z' are letters
	cmp byte [Buff], 'z'
	ja Write		;if greater then z then not ASCII
	cmp byte [Buff], 'A'
	jb Write
;after this Buff is a "letter" after check
;convert with ROT13 encoding
;check if Buff is less then middle of "UPPER CASE" letters
;if so add 13 to the value (Check against "N")
	cmp byte [Buff], 'N'	;check if val is <= N
	jb Add_13		;add 13 to the value
	cmp byte [Buff], 'Z'	;check if val is <= Z
	jbe Sub_13		;sub 13 to the value
	cmp byte [Buff], 'n'	;check if val is <= n
	jb Add_13		;add 13 to the value
	cmp byte [Buff], 'z'	;check if val is <= z 
	jbe Sub_13		;sub 13 to the value
	
;write all the data encoded into the file
Write:
	mov eax, 4		;sys call, write
	mov ebx, [fd_out]	;file descriptor
	mov ecx, Buff		;message to write
	mov edx, 1		;length of message
	int 80h
	jmp Read		;go back to begining and read again

Exit:
;close the files
Close_files:
	mov eax, 6		;sys call, close
	mov ebx, [fd_in]	;put file descriptor in ebx
	int 80h
	mov ebx, [fd_out]
	int 80h
;now exit after files are closed
	mov eax, 1		;sys call, exit
	int 80h

;add 13 to the value
Add_13:
	add byte [Buff], 13
	jmp Write
;subtract 13 from the value
Sub_13:
	sub byte [Buff], 13
	jmp Write
