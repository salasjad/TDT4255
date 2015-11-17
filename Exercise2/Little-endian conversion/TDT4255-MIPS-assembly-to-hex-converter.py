run = True

while run == True:

    valid = True
    
    output = ""
    
    instruction = raw_input("Instruction: ").upper()
    
    if instruction == "Q": #Quit
        run = False
        break

    elif instruction == "ADD":
        output += "000000 "
        d = "{0:05b}".format(input("$d "))
        s = "{0:05b}".format(input("$s "))
        t = "{0:05b}".format(input("$t "))
        output += str(s) + " " + str(t) + " " + str(d)
        output += " 00000 100000"

    elif instruction == "SUB":
        output += "000000 "
        d = "{0:05b}".format(input("$d "))
        s = "{0:05b}".format(input("$s "))
        t = "{0:05b}".format(input("$t "))
        output += str(s) + " " + str(t) + " " + str(d)
        output += " 00000 100010"

    elif instruction == "SLT":
        output += "000000 "
        d = "{0:05b}".format(input("$d "))
        s = "{0:05b}".format(input("$s "))
        t = "{0:05b}".format(input("$t "))
        output += str(s) + " " + str(t) + " " + str(d)
        output += " 00000 101010"

    elif instruction == "AND":
        output += "000000 "
        d = "{0:05b}".format(input("$d "))
        s = "{0:05b}".format(input("$s "))
        t = "{0:05b}".format(input("$t "))
        output += str(s) + " " + str(t) + " " + str(d)
        output += " 00000 100100"

    elif instruction == "OR":
        output += "000000 "
        d = "{0:05b}".format(input("$d "))
        s = "{0:05b}".format(input("$s "))
        t = "{0:05b}".format(input("$t "))
        output += str(s) + " " + str(t) + " " + str(d)
        output += " 00000 100101"

    elif instruction == "NOR":
        output += "000000 "
        d = "{0:05b}".format(input("$d "))
        s = "{0:05b}".format(input("$s "))
        t = "{0:05b}".format(input("$t "))
        output += str(s) + " " + str(t) + " " + str(d)
        output += " 00000 100111"

    elif instruction == "BEQ":
        output += "000100 "
        s = "{0:05b}".format(input("$s "))
        t = "{0:05b}".format(input("$t "))
        offset = "{0:016b}".format(input("offset "))
        output += str(s) + " " + str(t) + " " + str(offset)

    elif instruction == "LW":
        output += "100011 "
        t = "{0:05b}".format(input("$t "))
        offset = "{0:016b}".format(input("offset "))
        s = "{0:05b}".format(input("$s "))
        output += str(s) + " " + str(t) + " " + str(offset)

    elif instruction == "SW":
        output += "101011 "
        t = "{0:05b}".format(input("$t "))
        offset = "{0:016b}".format(input("offset "))
        s = "{0:05b}".format(input("$s "))
        output += str(s) + " " + str(t) + " " + str(offset)

    elif instruction == "LUI":
        output += "001111 00000 "
        t = "{0:05b}".format(input("$t "))
        imm = "{0:016b}".format(input("imm "))
        output += str(t) + " " + str(imm)

    elif instruction == "J":
        output += "000010 "
        target = "{0:026b}".format(input("target "))
        output += str(target)

    else:
        valid = False
        print("That's not a vaild instruction.")

    if valid:
        #Remove spaces
        output = output.replace(" ", "")
        #Convert to hex
        output = "{0:0>8X}".format(int(output, 2))
        #Convert to little endian format used by hostcomm (Comment out for big endian format)
        output = output[6:8] + output[4:6] + output[2:4] + output[0:2]
        print("Encoding: " + output)
