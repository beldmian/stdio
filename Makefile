run:
	nasm -felf -o print.o main.asm && gcc -Wall -m32 -o main main.c print.o && ./main
