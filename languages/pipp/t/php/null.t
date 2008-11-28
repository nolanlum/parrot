# Copyright (C) 2008, The Perl Foundation.
# $Id$

=head1 NAME

t/php/null.t - test the NULL type and associated functions

=head1 SYNOPSIS

    % perl t/harness t/php/null.t

=head1 DESCRIPTION

Tests the NULL type.

See L<http://de.php.net/manual/en/language.types.null.php>

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../../lib", "$FindBin::Bin/../../lib";

use Parrot::Test tests => 1;


language_output_is( 'Pipp', <<'CODE', <<'OUT', 'Stringification of an undefined var' );
<?php
echo $undefined_var;
echo "\n";
CODE
NULL
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
