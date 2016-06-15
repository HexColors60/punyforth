marker -tests

: '.' [ char . ] literal ; 

: factorial ( n -- n! | err:1024 )
       dup 0< if
           drop 1024 throw
       then
       dup 0= if
           drop 1
       else
           dup 1= if
               drop 1
           else
               dup 1- factorial *
           then
       then ;

: ifactorial ( n -- n! )
    1 2 rot
    begin
        2dup <=
    while
        -rot tuck
        * swap
        1+ rot
    repeat
    2drop ;

: 'F' [ char F ] literal ; 

5 array test_numbers

struct
  cell field: .width
  cell field: .height
constant Rect

: new-rect Rect create allot does> ;

: area ( rect -- area ) dup .width @ swap .height @ * ;

new-rect r1

: nested-throw1 dup 1= if drop 10 throw then 2 = if 20 throw then 42 ;

: nested-throw2
       ['] nested-throw1 catch dup 10 = if
          drop 30 throw
       else
          throw
       then ;

: bench ( ntimes -- sec )
       time swap
       0 do 10 factorial drop loop
       time swap - ;

0 variable! test_count
variable test_var1 variable test_var2
variable stored_dp 
dp stored_dp !

marker -test-test

: assert ( bool -- )
       test_count @ 1+ test_count ! '.' emit
       TRUE <> if 'F' emit test_count ? then ;

: selftest ( -- )
   ." testing"
   depth 0= assert
   0 test_count !
   12 3 min 3 = assert
   -3 7 min -3 = assert
   -3 -7 min -7 = assert
   132 33 max 132 = assert
   -33 77 max 77 = assert
   -389 -27 max -27 = assert
   0 1- -1 = assert
   -10 1+ -9 = assert
   -10 4 < assert
   -10 -4 < assert
   324 12 > assert
   -24 -212 > assert
   24 -2 > assert
   1 1- 0= assert
   -1 1+ 0= assert
   15 0<> assert
   0 0<> invert assert
   -3 0< TRUE = assert 3 0< FALSE = assert
   3 0> TRUE = assert -3 0> FALSE = assert
   -12 2 / 6 + 0 = assert
   1 2 tuck 2 = assert 1 = assert 2 = assert
   -123 abs 123 = assert 32 abs 32 = assert 0 abs 0 = assert
   -42 abs 42 abs = assert
   -12 -3 * 36 = assert -3 4 * -12 = assert 2 -4 * -8 = assert
   -12 -3 + -15 = assert -3 4 + 1 = assert 2 -4 + -2 = assert
   -12 -3 - -9 = assert -3 4 - -7 = assert 2 -4 - 6 = assert
   12 -6 / -2 = assert -36 6 / -6 = assert -4 -2 / 2 = assert 
   0 1 lshift 0 = assert
   1 1 lshift 2 = assert
   3 4 lshift 48 = assert
   3 0 lshift 3 = assert
   0 1 rshift 0 = assert
   2 1 rshift 1 = assert
   128 3 rshift 16 = assert
   4 4 >= assert 5 4 >= assert -4 -10 >= assert 4 5 >= invert assert
   6 6 <= assert 3 9 <= assert -9 -5 <= assert 10 2 <= invert assert
   12 3 /mod 4 = assert 0 = assert 12 4 / 3 = assert
   13 5 /mod 2 = assert 3 = assert 14 6 % 2 = assert
   TRUE if TRUE assert else FALSE assert then
   FALSE if FALSE assert else TRUE assert then
   2 TRUE if dup * then 4 = assert
   2 FALSE if dup * then 2 = assert
   10000 5 bounds 10000 = assert 10005 = assert
   10000 5 bounds do i loop
   10004 = assert 10003 = assert 10002 = assert 10001 = assert 10000 = assert depth 0= assert
   0 11 1 do i + loop 55 = assert

   0 11 1 do i + 1 +loop 55 = assert
   0 50 0 do i + 5 +loop 225 = assert
   15 0 do i 5 +loop 10 = assert 5 = assert 0 = assert depth 0= assert
   3 0 do i 2 +loop 2 = assert 0 = assert depth 0= assert
   1 0 do i 2 +loop 0 = assert depth 0= assert
   -5 0 do i -2 +loop -4 = assert -2 = assert 0 = assert depth 0= assert
   -1 0 do i -1 +loop -1 = assert 0 = assert depth 0= assert
   0 0 do i -1 +loop 0 = assert depth 0= assert

   0 8 2 do 9 3 do i j + + loop loop 360 = assert
   9 factorial 362880 = assert
   8 factorial 8 ifactorial = assert
   2 10 begin 1- swap 2 * swap dup 0= until drop 2048 = assert
   1 0 or 1 = assert 0 1 or 1 = assert
   1 1 or 1 = assert 0 0 or 0 = assert
   1 0 and 0 = assert 0 1 and 0 = assert
   1 1 and 1 = assert 0 0 and 0 = assert
   1 0 xor 1 = assert 0 1 xor 1 = assert
   1 1 xor 0 = assert 0 0 xor 0 = assert
   10 2 < 3 1 > or if 1 else 0 then 1 = assert
   3 10 < 3 11 > and if 1 else 0 then 0 = assert
   -98 45 < 33 11 > and if 1 else 0 then 1 = assert
   5 0 do i i test_numbers ! loop
   5 0 do i test_numbers @ i = assert loop
   3 r1 .width ! 5 r1 .height !
   r1 area 15 = assert
   12 test_var1 ! test_var1 @ 12 = assert
   3 test_var1 +! test_var1 @ 15 = assert

   1 case
       1 of 10 endof
       2 of 20 endof
       3 of 30 endof
   endcase 10 = assert

   2 case
       1 of 10 endof
       2 of 20 endof
       3 of 30 endof
   endcase 20 = assert

   3 case
       1 of 10 endof
       2 of 20 endof
       3 of 30 endof
   endcase 30 = assert

   1 case
       1 of 2 endof
       2 of 3 endof
   endcase 2 = assert

   sp@ test_var1 !
   -1 ['] factorial catch 1024 = assert
   1 ['] nested-throw2 catch 30 = assert
   2 ['] nested-throw2 catch 20 = assert
   3 ['] nested-throw2 catch drop 42 = assert
   3 nested-throw2 42 = assert
   sp@ test_var2 !
   test_var1 @ test_var2 @ = assert
   freemem 16 allot freemem - 16 = assert
   s" " strlen 0 = assert
   s" 1" strlen 1 = assert
   s" 12" strlen 2 = assert
   s" 1234567" strlen 7 = assert
   s' """"' strlen 4 = assert
   s' anystring' 
   s' '
   str-starts-with TRUE = assert
   s' '
   s' '
   str-starts-with TRUE = assert
   s' abc'
   s' bc'
   str-starts-with FALSE = assert
   s' abc'
   s' ab'
   str-starts-with TRUE = assert
   s' aabbc'
   s' aabbc'
   str-starts-with TRUE = assert
   s' aabbc'
   s' aabbcc'
   str-starts-with FALSE = assert
   s' abcxxxx' 
   s' abc' 
   str-includes TRUE = assert   
   s' xxabcyy' 
   s' abc' 
   str-includes TRUE = assert   
   s' xxabzyy' 
   s' abc'
   str-includes FALSE = assert
   s' anystring' 
   s' ' 
   str-includes TRUE = assert   
   s' xxx'
   s' xxx' 
   str-includes TRUE = assert   
   s' abcdef'
   s' def' 
   str-includes TRUE = assert   
   s' abcdef'
   s' efg' 
   str-includes FALSE = assert   
   depth 0= assert
   -test-test dp stored_dp @ = assert
   ." OK " test_count ? cr ; 

' selftest execute ." Punyforth ready" cr

-tests
