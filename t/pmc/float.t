#!perl
# Copyright (C) 2001-2006, The Perl Foundation.
# $Id$

use strict;
use warnings;
use lib qw( . lib ../lib ../../lib );

use Test::More;
use Parrot::Test tests => 61;

=head1 NAME

t/pmc/float.t - Floating-point Numbers

=head1 SYNOPSIS

    % prove t/pmc/float.t

=head1 DESCRIPTION

Tests the Float PMC.

=cut


pasm_output_is( <<"CODE", <<OUTPUT, "basic assignment" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']

    set P0, 0.001
    .fp_eq_pasm( P0, 0.001, EQ1)
    print "not "
EQ1:    print "ok 1\\n"

        set P0, 1000
        .fp_eq_pasm( P0, 1000.0, EQ2)
    print "not "
EQ2:    print "ok 2\\n"

        set P0, "12.5"
        .fp_eq_pasm( P0, 12.5, EQ3)
    print "not "
EQ3:    print "ok 3\\n"

        set P0, "Twelve point five"
        .fp_eq_pasm( P0, 0.0, EQ4)
    print "not "
EQ4:    print "ok 4\\n"

        set P0, 123.45
        set I0, P0
        eq I0, 123, EQ5
    print "not "
EQ5:    print "ok 5\\n"

        set P0, 123.45
        set N0, P0
        .fp_eq_pasm(N0, 123.45, EQ6)
    print "not "
EQ6:    print "ok 6\\n"

        set P0, 123.45
        set S0, P0
        eq S0, "123.45", EQ7
    print "not "
EQ7:    print "ok 7\\n"

    end
CODE
ok 1
ok 2
ok 3
ok 4
ok 5
ok 6
ok 7
OUTPUT

pasm_output_is( <<"CODE", <<OUTPUT, "add number to self" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 0.001
    add P0, P0, P0
    .fp_eq_pasm( P0, 0.002, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"
    end
CODE
ok 1
OUTPUT

pasm_output_is( <<"CODE", <<OUTPUT, "sub number from self" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, -1000.2
    sub P0, P0, P0
    .fp_eq_pasm( P0, 0.0, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"
    end
CODE
ok 1
OUTPUT

pasm_output_is( <<"CODE", <<OUTPUT, "multiply number by self" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 123.4
    mul P0, P0, P0
    .fp_eq_pasm( P0, 15227.56, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"
    end
CODE
ok 1
OUTPUT

pasm_output_is( <<"CODE", <<OUTPUT, "divide number by self" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 1829354.988
    div P0, P0, P0
    .fp_eq_pasm( P0, 1.0, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"
    end
CODE
ok 1
OUTPUT

pir_output_is( <<'CODE', <<OUTPUT, "divide by zero" );
.sub _main :main
    $P0 = new ['Float']
    set $P0, "12.0"
    $P1 = new ['Float']
    $P2 = new ['Float']
    set $P2, "0.0"
    push_eh OK
    $P1 = $P0 / $P2
    print "fail\n"
    pop_eh
OK:
    get_results '0', $P0
    $S0 = $P0
    print "ok\n"
    print $S0
    print "\n"
.end
CODE
ok
float division by zero
OUTPUT

pir_output_is( << 'CODE', << 'OUTPUT', "Truth of a positive float" );

.sub _main
    .local pmc float_1
    float_1 = new ['Float']
    float_1 = 123.123
    print float_1
    if float_1 goto IS_TRUE
      print " is false\n"
    end
    IS_TRUE:
      print " is true\n"
    end
.end
CODE
123.123 is true
OUTPUT

pir_output_is( << 'CODE', << 'OUTPUT', "Truth of a negative float" );

.sub _main
    .local pmc float_1
    float_1 = new ['Float']
    float_1 = -123.123
    print float_1
    if float_1 goto IS_TRUE
      print " is false\n"
    end
    IS_TRUE:
      print " is true\n"
    end
.end
CODE
-123.123 is true
OUTPUT

pir_output_is( << 'CODE', << 'OUTPUT', "Truth of a positive integer" );

.sub _main
    .local pmc float_1
    float_1 = new ['Float']
    float_1 = 1
    print float_1
    if float_1 goto IS_TRUE
      print " is false\n"
    end
    IS_TRUE:
      print " is true\n"
    end
.end
CODE
1 is true
OUTPUT

pir_output_is( << 'CODE', << 'OUTPUT', "Truth of a negative integer" );

.sub _main
    .local pmc float_1
    float_1 = new ['Float']
    float_1 = -1
    print float_1
    if float_1 goto IS_TRUE
      print " is false\n"
    end
    IS_TRUE:
      print " is true\n"
    end
.end
CODE
-1 is true
OUTPUT

pir_output_is( << 'CODE', << 'OUTPUT', "Falseness of 0" );

.sub _main
    .local pmc float_1
    float_1 = new ['Float']
    float_1 = 0
    print float_1
    if float_1 goto IS_TRUE
      print " is false\n"
    end
    IS_TRUE:
      print " is true\n"
    end
.end
CODE
0 is false
OUTPUT

pir_output_is( << 'CODE', << 'OUTPUT', "Falseness of 0.000" );

.sub _main
    .local pmc float_1
    float_1 = new ['Float']
    float_1 = 0.000
    print float_1
    if float_1 goto IS_TRUE
      print " is false\n"
    end
    IS_TRUE:
      print " is true\n"
    end
.end
CODE
0 is false
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic integer arithmetic: addition" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 0.001
    add P0, 1
    .fp_eq_pasm(P0, 1.001, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    add P0, -2
    .fp_eq_pasm(P0, -0.999, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"
    end
CODE
ok 1
ok 2
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic integer arithmetic: subtraction" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 103.45
    sub P0, 77
    .fp_eq_pasm(P0, 26.45, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    sub P0, -24
    .fp_eq_pasm(P0, 50.45, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"
    end
CODE
ok 1
ok 2
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic integer arithmetic: multiplication" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 0.001
    mul P0, 10000
    .fp_eq_pasm(P0, 10.0, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    mul P0, -1
    .fp_eq_pasm(P0, -10.0, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"

    mul P0, 0
    .fp_eq_pasm(P0, 0.0, EQ3)
    print P0
    print "not "
EQ3:    print "ok 3\\n"
    end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic integer arithmetic: division" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 1e8
    div P0, 10000
    .fp_eq_pasm(P0, 10000.0, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    div P0, 1000000
    .fp_eq_pasm(P0, 0.01, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"
    end
CODE
ok 1
ok 2
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic numeric arithmetic: addition" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 0.001
    add P0, 1.2
    .fp_eq_pasm(P0, 1.201, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    add P0, -2.4
    .fp_eq_pasm(P0, -1.199, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"
    end
CODE
ok 1
ok 2
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic numeric arithmetic: subtraction" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 103.45
    sub P0, 3.46
    .fp_eq_pasm(P0, 99.99, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    sub P0, -0.01
    .fp_eq_pasm(P0, 100.00, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"
    end
CODE
ok 1
ok 2
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic numeric arithmetic: multiplication" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 0.001
    mul P0, 123.5
    .fp_eq_pasm(P0, 0.1235, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    mul P0, -2.6
    .fp_eq_pasm(P0, -0.3211, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"

    mul P0, 0
    .fp_eq_pasm(P0, 0.0, EQ3)
    print P0
    print "not "
EQ3:    print "ok 3\\n"
    end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Basic numeric arithmetic: division" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 1e8
    div P0, 0.5
    .fp_eq_pasm(P0, 2e8, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    div P0, 4000.0
    .fp_eq_pasm(P0, 50000.0, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"
    end
CODE
ok 1
ok 2
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Increment & decrement" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 0.5
    inc P0
    .fp_eq_pasm(P0, 1.5, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

    dec P0
    .fp_eq_pasm(P0, 0.5, EQ2)
    print P0
    print "not "
EQ2:    print "ok 2\\n"

    dec P0
    .fp_eq_pasm(P0, -0.5, EQ3)
    print P0
    print "not "
EQ3:    print "ok 3\\n"

    inc P0
    .fp_eq_pasm(P0, 0.5, EQ4)
    print P0
    print "not "
EQ4:    print "ok 4\\n"
    end
CODE
ok 1
ok 2
ok 3
ok 4
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Neg" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 0.5
    neg P0
    .fp_eq_pasm(P0, -0.5, EQ1)
    print P0
    print "not "
EQ1:    print "ok 1\\n"

        new P1, ['Float']
    neg P1, P0
    .fp_eq_pasm(P1, 0.5, EQ2)
    print P1
    print "not "
EQ2:    print "ok 2\\n"
    end
CODE
ok 1
ok 2
OUTPUT

SKIP: {
    skip 'failing on win32' => 1 if $^O =~ m/win32/i;

pasm_output_like( << 'CODE', << 'OUTPUT', "neg 0" );
    new P0, ['Float']
    set P0, 0.0
    neg P0
        print P0
    end
CODE
/^-0/
OUTPUT

}

pasm_output_is( << 'CODE', << 'OUTPUT', "Equality" );
    new P0, ['Float']
    set P0, 1e8
        new P1, ['Float']
        set P1, 1e8
        new P2, ['Float']
        set P2, 2.4

        eq P0, P1, OK1
        print "not "
OK1:    print "ok 1\n"

        eq P0, P2, BAD2
        branch OK2
BAD2:   print "not "
OK2:    print "ok 2\n"

        ne P0, P2, OK3
        print "not "
OK3:    print "ok 3\n"

        ne P0, P1, BAD4
        branch OK4
BAD4:   print "not "
OK4:    print "ok 4\n"

        eq_num P0, P1, OK5
        print "not "
OK5:    print "ok 5\n"

        eq_num P0, P2, BAD6
        branch OK6
BAD6:   print "not "
OK6:    print "ok 6\n"

        ne_num P0, P2, OK7
        print "not "
OK7:    print "ok 7\n"

        ne_num P0, P1, BAD8
        branch OK8
BAD8:   print "not "
OK8:    print "ok 8\n"
    end
CODE
ok 1
ok 2
ok 3
ok 4
ok 5
ok 6
ok 7
ok 8
OUTPUT

pir_output_is( << 'CODE', << 'OUTPUT', "check whether interface is done" );

.sub _main
    .local pmc pmc1
    pmc1 = new ['Float']
    .local int bool1
    does bool1, pmc1, "scalar"
    print bool1
    print "\n"
    does bool1, pmc1, "float"
    print bool1
    print "\n"
    does bool1, pmc1, "no_interface"
    print bool1
    print "\n"
    end
.end
CODE
1
1
0
OUTPUT

pasm_output_is( << "CODE", << 'OUTPUT', "Abs" );
    .include 'include/fp_equality.pasm'
    new P0, ['Float']
    set P0, 1.0
    abs P0
        eq P0, P0, OK1
    print P0
    print "not "
OK1:    print "ok 1\\n"

        set P0, -1.0
        abs P0
    .fp_eq_pasm(P0, 1.0, OK2)
    print P0
    print "not "
OK2:    print "ok 2\\n"

        new P1, ['Float']
        set P0, -5.0
        abs P1, P0
        .fp_eq_pasm(P1, 5.0, OK3)
    print P1
    print "not "
OK3:    print "ok 3\\n"
    end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: lt" );
        new P1, ['Float']
        set P1, 111.1
        set N1, P1

        lt P1, 111.2, OK1
        print "not "
OK1:    print "ok 1\n"

        lt P1, N1, BAD2
        branch OK2
BAD2:   print "not "
OK2:    print "ok 2\n"

        lt P1, 111.0, BAD3
        branch OK3
BAD3:   print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: lt_num" );
        new P1, ['Float']
        set P1, 1.1
        new P2, ['Float']
        set P2, 1.2
        new P3, ['Float']
        set P3, 1.0
        new P4, ['Float']
        set P4, P1

        lt_num P1, P2, OK1
        print "not "
OK1:    print "ok 1\n"

        lt_num P1, P4, BAD2
        branch OK2
BAD2:   print "not "
OK2:    print "ok 2\n"

        lt_num P1, P3, BAD3
        branch OK3
BAD3:   print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: le" );
        new P1, ['Float']
        set P1, 111.1
        set N1, P1

        le P1, 111.2, OK1
        print "not "
OK1:    print "ok 1\n"

        le P1, N1, OK2
        print "not "
OK2:    print "ok 2\n"

        le P1, 111.0, BAD3
        branch OK3
BAD3:   print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: le_num" );
        new P1, ['Float']
        set P1, 1.1
        new P2, ['Float']
        set P2, 1.2
        new P3, ['Float']
        set P3, 1.0
        new P4, ['Float']
        set P4, P1

        le_num P1, P2, OK1
        print "not "
OK1:    print "ok 1\n"

        le_num P1, P4, OK2
        print "not "
OK2:    print "ok 2\n"

        le_num P1, P3, BAD3
        branch OK3
BAD3:   print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: gt" );
        new P1, ['Float']
        set P1, 111.1
        set N1, P1

        gt P1, 111.2, BAD1
        branch OK1
BAD1:   print "not "
OK1:    print "ok 1\n"

        gt P1, N1, OK2
        branch OK2
BAD2:   print "not "
OK2:    print "ok 2\n"

        gt P1, 111.0, OK3
        print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: gt_num" );
        new P1, ['Float']
        set P1, 1.1
        new P2, ['Float']
        set P2, 1.2
        new P3, ['Float']
        set P3, 1.0
        new P4, ['Float']
        set P4, P1

        gt_num P1, P2, BAD1
        branch OK1
BAD1:   print "not "
OK1:    print "ok 1\n"

        gt_num P1, P4, OK2
        branch OK2
BAD2:   print "not "
OK2:    print "ok 2\n"

        gt_num P1, P3, OK3
        print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: ge" );
        new P1, ['Float']
        set P1, 111.1
        set N1, P1

        ge P1, 111.2, BAD1
        branch OK1
BAD1:   print "not "
OK1:    print "ok 1\n"

        ge P1, N1, OK2
        print "not "
OK2:    print "ok 2\n"

        ge P1, 111.0, OK3
        print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: ge_num" );
        new P1, ['Float']
        set P1, 1.1
        new P2, ['Float']
        set P2, 1.2
        new P3, ['Float']
        set P3, 1.0
        new P4, ['Float']
        set P4, P1

        ge_num P1, P2, BAD1
        branch OK1
BAD1:   print "not "
OK1:    print "ok 1\n"

        ge_num P1, P4, OK2
        print "not "
OK2:    print "ok 2\n"

        ge_num P1, P3, OK3
        print "not "
OK3:    print "ok 3\n"
        end
CODE
ok 1
ok 2
ok 3
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: cmp_p_n" );
        new P1, ['Float']
        set P1, 123.45
        set N1, 123.45
        set N2, -1.0
        set N3, 123.54

        cmp I0, P1, N1
        print I0
        print "\n"
        cmp I0, P1, N2
        print I0
        print "\n"
        cmp I0, P1, N3
        print I0
        print "\n"
        end
CODE
0
1
-1
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: isgt" );
        new P1, ['Float']
        new P2, ['Float']
        new P3, ['Float']
        new P4, ['Integer']
        new P5, ['Integer']
        new P6, ['Float']

        set P1, 10.0
        set P2, 20.0
        set P3, 5.0
        set P4, 3
        set P5, 12
        set P6, 10.0

        isgt I0, P1, P2
        print I0
        print "\n"
        isgt I0, P1, P1
        print I0
        print "\n"
        isgt I0, P1, P3
        print I0
        print "\n"
        isgt I0, P1, P4
        print I0
        print "\n"
        isgt I0, P1, P5
        print I0
        print "\n"
        isgt I0, P1, P6
        print I0
        print "\n"
        end
CODE
0
0
1
1
0
0
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: isge" );
        new P1, ['Float']
        new P2, ['Float']
        new P3, ['Float']
        new P4, ['Integer']
        new P5, ['Integer']
        new P6, ['Float']

        set P1, 10.0
        set P2, 20.0
        set P3, 5.0
        set P4, 3
        set P5, 12
        set P6, 10.0

        isge I0, P1, P2
        print I0
        print "\n"
        isge I0, P1, P1
        print I0
        print "\n"
        isge I0, P1, P3
        print I0
        print "\n"
        isge I0, P1, P4
        print I0
        print "\n"
        isge I0, P1, P5
        print I0
        print "\n"
        isge I0, P1, P6
        print I0
        print "\n"
        end
CODE
0
1
1
1
0
1
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: islt" );
        new P1, ['Float']
        new P2, ['Float']
        new P3, ['Float']
        new P4, ['Integer']
        new P5, ['Integer']
        new P6, ['Float']

        set P1, 10.0
        set P2, 20.0
        set P3, 5.0
        set P4, 3
        set P5, 12
        set P6, 10.0

        islt I0, P1, P2
        print I0
        print "\n"
        islt I0, P1, P1
        print I0
        print "\n"
        islt I0, P1, P3
        print I0
        print "\n"
        islt I0, P1, P4
        print I0
        print "\n"
        islt I0, P1, P5
        print I0
        print "\n"
        islt I0, P1, P6
        print I0
        print "\n"
        end
CODE
1
0
0
0
1
0
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: isle" );
        new P1, ['Float']
        new P2, ['Float']
        new P3, ['Float']
        new P4, ['Integer']
        new P5, ['Integer']
        new P6, ['Float']

        set P1, 10.0
        set P2, 20.0
        set P3, 5.0
        set P4, 3
        set P5, 12
        set P6, 10.0

        isle I0, P1, P2
        print I0
        print "\n"
        isle I0, P1, P1
        print I0
        print "\n"
        isle I0, P1, P3
        print I0
        print "\n"
        isle I0, P1, P4
        print I0
        print "\n"
        isle I0, P1, P5
        print I0
        print "\n"
        isle I0, P1, P6
        print I0
        print "\n"
        end
CODE
1
1
0
0
1
1
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: iseq" );
        new P1, ['Float']
        new P2, ['Float']
        new P3, ['Float']
        new P4, ['Integer']

        set P1, 2.5
        set P2, 2.6
        set P3, 2.5
        set P4, 2

        iseq I0, P1, P1
        print I0
        print "\n"
        iseq I0, P1, P2
        print I0
        print "\n"
        iseq I0, P1, P3
        print I0
        print "\n"
        iseq I0, P1, P4
        print I0
        print "\n"
        end
CODE
1
0
1
0
OUTPUT

pasm_output_is( << 'CODE', << 'OUTPUT', "comparison ops: isne" );
        new P1, ['Float']
        new P2, ['Float']
        new P3, ['Float']
        new P4, ['Integer']

        set P1, 2.5
        set P2, 2.6
        set P3, 2.5
        set P4, 2

        isne I0, P1, P1
        print I0
        print "\n"
        isne I0, P1, P2
        print I0
        print "\n"
        isne I0, P1, P3
        print I0
        print "\n"
        isne I0, P1, P4
        print I0
        print "\n"
        end
CODE
0
1
0
1
OUTPUT

pir_output_is( <<'CODE', <<OUTPUT, "new_from_string" );
.sub main :main
    .const 'Float' pi = "3.1"
    print pi
    print "\n"
.end
CODE
3.1
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'cmp functions for subclasses' );
.sub main :main
    $P0 = subclass 'Float', 'Flt'

    $P1 = new ['Flt']
    $P1 = 1.5
    $P2 = new ['Flt']
    $P2 = 2.73

    $I0 = cmp $P1, $P2
    say $I0
    $I0 = cmp $P1, $P1
    say $I0
    $I0 = cmp $P2, $P1
    say $I0
.end
CODE
-1
0
1
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'acos as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'acos'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "acos(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'acos'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "acos(%.1f) is %.9f", array
    say $S0
.end
CODE
acos(0.0) is 1.570796327
acos(0.5) is 1.047197551
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'cos as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'cos'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "cos(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'cos'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "cos(%.1f) is %.9f", array
    say $S0
.end
CODE
cos(0.0) is 1.000000000
cos(0.5) is 0.877582562
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'asec as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 1.0
    $P1 = $P0.'asec'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "asec(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 3.0
    $P3 = $P2.'asec'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "asec(%.1f) is %.9f", array
    say $S0
.end
CODE
asec(1.0) is 0.000000000
asec(3.0) is 1.230959417
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'asin as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'asin'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "asin(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'asin'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "asin(%.1f) is %.9f", array
    say $S0
.end
CODE
asin(0.0) is 0.000000000
asin(0.5) is 0.523598776
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'atan as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'atan'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "atan(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'atan'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "atan(%.1f) is %.9f", array
    say $S0
.end
CODE
atan(0.0) is 0.000000000
atan(0.5) is 0.463647609
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'atan2 as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 3
    $P0 = new ['Float']
    $P1 = new ['Float']
    $P0 = 0.7
    $P1 = 0.5
    $P2 = $P0.'atan2'($P1)
    array[0] = $P0
    array[1] = $P1
    array[2] = $P2
    $S0 = sprintf "atan2(%.1f, %.1f) is %.9f", array
    say $S0
.end
CODE
atan2(0.7, 0.5) is 0.950546841
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'cosh as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'cosh'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "cosh(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'cosh'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "cosh(%.1f) is %.9f", array
    say $S0
.end
CODE
cosh(0.0) is 1.000000000
cosh(0.5) is 1.127625965
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'exp as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'exp'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "exp(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'exp'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "exp(%.1f) is %.9f", array
    say $S0
.end
CODE
exp(0.0) is 1.000000000
exp(0.5) is 1.648721271
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'ln as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 45.0
    $P1 = $P0.'ln'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "ln(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'ln'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "ln(%.1f) is %.9f", array
    say $S0
.end
CODE
ln(45.0) is 3.806662490
ln(0.5) is -0.693147181
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'log10 as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 1000.0
    $P1 = $P0.'log10'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "log10(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'log10'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "log10(%.1f) is %.9f", array
    say $S0
.end
CODE
log10(1000.0) is 3.000000000
log10(0.5) is -0.301029996
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'log2 as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 32.0
    $P1 = $P0.'log2'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "log2(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'log2'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "log2(%.1f) is %.9f", array
    say $S0
.end
CODE
log2(32.0) is 5.000000000
log2(0.5) is -1.000000000
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'sec as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'sec'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "sec(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'sec'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "sec(%.1f) is %.9f", array
    say $S0
.end
CODE
sec(0.0) is 1.000000000
sec(0.5) is 1.139493927
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'sech as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'sech'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "sech(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'sech'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "sech(%.1f) is %.9f", array
    say $S0
.end
CODE
sech(0.0) is 1.000000000
sech(0.5) is 0.886818884
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'sin as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'sin'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "sin(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'sin'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "sin(%.1f) is %.9f", array
    say $S0
.end
CODE
sin(0.0) is 0.000000000
sin(0.5) is 0.479425539
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'sinh as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'sinh'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "sinh(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'sinh'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "sinh(%.1f) is %.9f", array
    say $S0
.end
CODE
sinh(0.0) is 0.000000000
sinh(0.5) is 0.521095305
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'tan as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'tan'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "tan(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'tan'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "tan(%.1f) is %.9f", array
    say $S0
.end
CODE
tan(0.0) is 0.000000000
tan(0.5) is 0.546302490
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'tanh as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 0.0
    $P1 = $P0.'tanh'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "tanh(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 0.5
    $P3 = $P2.'tanh'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "tanh(%.1f) is %.9f", array
    say $S0
.end
CODE
tanh(0.0) is 0.000000000
tanh(0.5) is 0.462117157
OUTPUT

pir_output_is( <<'CODE', <<'OUTPUT', 'sqrt as a method' );
.include 'fp_equality.pasm'
.sub main :main
    .local pmc array
    array = new 'FixedFloatArray'
    array = 2
    $P0 = new ['Float']
    $P0 = 16.0
    $P1 = $P0.'sqrt'()
    array[0] = $P0
    array[1] = $P1
    $S0 = sprintf "sqrt(%.1f) is %.9f", array
    say $S0

    $P2 = new ['Float']
    $P2 = 2.0
    $P3 = $P2.'sqrt'()
    array[0] = $P2
    array[1] = $P3
    $S0 = sprintf "sqrt(%.1f) is %.9f", array
    say $S0
.end
CODE
sqrt(16.0) is 4.000000000
sqrt(2.0) is 1.414213562
OUTPUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
