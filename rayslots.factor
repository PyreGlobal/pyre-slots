! Copyright (C) 2020 James Oliver
! See http://factorcode.org/license.txt for BSD license.
USING: raylib.ffi kernel sequences math.ranges locals random combinators.random math threads namespaces accessors classes.struct combinators alien.enums sequences.generalizations circular io ;
IN: rayslots


TUPLE: col dat cur end dis ;
TUPLE: board cols ;


! ------------
! Sample board
! ------------

: tigerboss ( -- board )
    { "ring" "crown" "car" "watch"
      "random" "bonus" "10" "20" } ;

! ---------------- 
! Board generation 
! ---------------- 

: dissize ( -- size ) 3 ;
: slot-num ( -- num ) 20 ;

: make-slot-col-unit ( seq' seq -- seq0 seq1 )
    dup random swap [ prefix ] dip ;

: make-slot-col-intern ( seq0 seq1 n -- seq0 )
    dup 0 =
    [ 2drop ]
    [ 1 - [ make-slot-col-unit ] dip
      make-slot-col-intern ]
    if ; recursive

: make-slot-col ( board n -- col )
    [ { } swap ] dip make-slot-col-intern ;
    
: make-board ( n board  -- board )
    [ 20 make-slot-col ] curry 
    <repetition>
    [ call( -- board ) <circular>
      0 20 dissize col boa ] map
    board boa ;
    
! ------------- 
! Backend       
! ------------- 

GENERIC: seed ( col -- col )
GENERIC: tocur ( col -- col )
GENERIC: spin ( board -- board )
GENERIC: print-slot ( som -- )
GENERIC: print-slot-n ( n som -- )

M: col seed
    slot-num random >>end ;

M: col tocur
    dup end>> >>cur
    0 >>end ;

M: board spin
    dup cols>> [ seed tocur drop ] each ;

M: col print-slot-n
    [ cur>> ] [ dat>> ] bi [ + ] dip
    ?nth write " " write ;

M: col print-slot
    [ 0 ] dip print-slot-n ;
    
M: board print-slot
    cols>> [ print-slot ] each ;

M: board print-slot-n
    cols>> swap [ swap print-slot-n ] curry each ;

: print-dissize ( board -- )
    [ -1 swap print-slot-n " " print ]
    [ print-slot " " print ]
    [ 1 swap print-slot-n " " print ] tri ;
    
