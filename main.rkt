; talha ordukaya
; 2021400228
; compiling: yes
; complete: yes
#lang racket


; Converts a binary string to a decimal number
(define (binary_to_decimal binary)
  (let loop ([bits (string->list binary)]
             [acc 0])
    (if (null? bits)
        acc
        ; Converts each binary digit to its corresponding decimal value
        (loop (cdr bits)
              (+ (* 2 acc) (- (char->integer (car bits)) (char->integer #\0)))))))


; Relocates logical addresses to physical addresses using limit and base
(define (relocator args limit base)
  (map (lambda (addr)
         (let ([dec-addr (binary_to_decimal addr)]) ; Convert each binary address to decimal 
           (if (> dec-addr limit)
               -1 ; Return -1 if it exceeds the limit
               (+ dec-addr base)))) ; Otherwise, add the base to the address
       args))


; Divides an address into page number and offset based on page size
(define (divide_address_space num page_size)
  (let* ([log_base_2 (lambda (n) (inexact->exact (/ (log n) (log 2))))] ; Calculates the log base 2 of a number
         [page_number_bits (lambda (args page_size)
                             (- (string-length args) (+ 10 (log_base_2 page_size))))] ; Calculates the number of bits for the page number
         [page-bits (page_number_bits num page_size)] ; Number of bits for the page number
         [page-num (substring num 0 page-bits)] ; Extracts the page number
         [offset (substring num page-bits)]) ; Extracts the offset
    (cons page-num (list offset)))) ; Returns the page number and offset


; Maps logical addresses to physical addresses using page table and page size
(define (page args page_table page_size)
  (map (lambda (addr)
         (let* ([div-addr (divide_address_space addr page_size)] ; Divide the address into page number and offset
                [page-num (string->number (first div-addr) 2)] ; Convert the page number to a number
                [offset (second div-addr)] ; Extract the offset
                [frame-num (list-ref page_table page-num)]) ; Get the frame number from the page table
           (string-append frame-num offset))) ; Concatenate the frame number and offset
       args))


; Converts a binary string to a decimal number
(define (factorial n)
  (if (zero? n)
      1
      (* n (factorial (- n 1)))))

; Computes the sine of an angle using Taylor series expansion
(define (find_sin degrees num)
  (let* ([x (* degrees (/ 3.141592653589793 180))]) ; Convert degrees to radians
    (let loop ([n 0] [sum 0.0])
      (if (>= n num)
          sum
          (let* ([term (/ (expt -1 n) (factorial (+ (* 2 n) 1)))] ; Calculate the nth term of the Taylor series
                 [term-value (* term (expt x (+ (* 2 n) 1)))]) ; Multiply by x^(2n+1)
            (loop (+ n 1) (+ sum term-value))))))) ; Add the term to the sum


; Computes the hash value of an address using the sine function
(define (myhash arg table_size)
  (let* ([dec-arg (binary_to_decimal arg)] ; Convert the binary address to decimal
         [n (+ (modulo dec-arg 5) 1)] ; Calculate the number of terms in the Taylor series
         [sin-value (find_sin dec-arg n)] ; Calculate the sine of the address
         [digits (string->list (substring (number->string sin-value) 2 12))] ; Extract the digits of the sine value
         [sum-digits (foldl (lambda (digit acc) (+ acc (char->integer digit) (- (char->integer #\0)))) 0 digits)]) ; Sum the digits
    (modulo sum-digits table_size))) ; Return the modulo of the sum of digits and the table size


; Maps logical addresses to physical addresses using a hashed page table
(define (hashed_page arg table_size page_table page_size)
  (let* ([div-addr (divide_address_space arg page_size)] ; Divide the address into page number and offset
         [page-num (first div-addr)] ; Extract the page number
         [offset (second div-addr)] ; Extract the offset
         [hash-value (myhash page-num table_size)] ; Calculate the hash value of the page number
         [frame-num (second (assoc page-num (list-ref page_table hash-value)))]) ; Get the frame number from the hashed page table
    (string-append frame-num offset))) ; Concatenate the frame number and offset


; Splits the addresses into chunks of a given size
(define (split_addresses args size)
  (let loop ([remaining args]
             [result '()])
    (if (string=? remaining "")
        (reverse result)
        (let ([split-addr (list (substring remaining 0 size))]) ; Split the address into chunks of the given size
          (loop (substring remaining size (string-length remaining)) (cons split-addr result)))))) ; Recursively split the remaining addresses


; Maps logical addresses to physical addresses using a hashed page table
(define (map_addresses args table_size page_table page_size address_space_size)
  (let* ([split-args (split_addresses args address_space_size)]) ; Split address stream into individual addresses
    (map (lambda (addr)
           (hashed_page (first addr) table_size page_table page_size)) ; Map each address using hashed page table
         split-args)))