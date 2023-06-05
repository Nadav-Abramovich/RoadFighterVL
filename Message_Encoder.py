import math 
def integer_to_binary(integer):
    binary = format(integer, '05b')
    return binary



def convert_string_to_numbers(string):
    numbers = []
    for char in string:
        char_number = ord(char.lower()) - 97  # Convert character to lowercase and get its corresponding number (0-25)
        numbers.append(char_number)
    return numbers

def generate_systemverilog_array(numbers, array_name):
    sv_array = f'logic[0:10][0:4] {array_name} = {{'
    for num in numbers:
        sv_array += '5\'d'+ str(num) + ','
    sv_array = sv_array[:-1] + '};'  # Remove the trailing comma and add closing bracket
    return sv_array

# Main program
string = input("Enter a string: ")
array_name = input("Enter a name for the string: ")

numbers = convert_string_to_numbers(string)


systemverilog_array = generate_systemverilog_array(numbers, array_name)

print(f"The SystemVerilog array is:\n{systemverilog_array}")

