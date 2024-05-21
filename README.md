# Racket Address Mapping Project

This project contains a collection of functions written in Racket for address mapping. It includes functions for converting binary strings to decimal numbers, relocating logical addresses to physical addresses, dividing an address into page number and offset based on page size, and mapping logical addresses to physical addresses using a page table and page size.

## Functions

- `binary_to_decimal(binary)`: Converts a binary string to a decimal number.

- `relocator(args, limit, base)`: Relocates logical addresses to physical addresses using limit and base. If the decimal representation of the address exceeds the limit, it returns -1. Otherwise, it adds the base to the address.

- `divide_address_space(num, page_size)`: Divides an address into page number and offset based on page size. It calculates the number of bits for the page number, extracts the page number and offset from the address, and returns the page number and offset.

- `page(args, page_table, page_size)`: Maps logical addresses to physical addresses using a page table and page size. It divides the address into page number and offset, converts the page number to a number, gets the frame number from the page table, and concatenates the frame number and offset.

- `factorial(n)`: Calculates the factorial of a number.

- `find_sin(degrees, num)`: Computes the sine of an angle using Taylor series expansion.

- `myhash(arg, table_size)`: Computes the hash value of an address using the sine function.

- `hashed_page(arg, table_size, page_table, page_size)`: Maps logical addresses to physical addresses using a hashed page table.

- `split_addresses(args, size)`: Splits the addresses into chunks of a given size.

- `map_addresses(args, table_size, page_table, page_size, address_space_size)`: Maps logical addresses to physical addresses using a hashed page table.

## Usage

To use these functions, import the `main.rkt` file into your Racket environment and call the functions with the appropriate arguments.