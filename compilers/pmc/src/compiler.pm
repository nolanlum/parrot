# Copyright (C) 2009, Parrot Foundation.
# $Id$

# Main PMC compiler.

class PMC::Compiler;


# Generate .h file for pmc.
method generate_h_file() {
    my $res;

    #my $self; PIR q< store_lex "$self", self >;
    my $filename := self.filename();
    $res := dont_edit($filename);

    $res := $res ~ c_code_coda();

    $res;
}

method filename() {
    our $?filename;
    $?filename;
}

method set_filename($name) {
    our $?filename := $name;
}

# Generate don't edit warning
sub dont_edit($filename) {
     "/* ex: set ro ft=c:\n"
    ~" * !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!\n"
    ~" *\n"
    ~" * This file is generated automatically from '" ~$filename ~"'\n"
    ~" * by Divine Intervention.\n"
    ~" *\n"
    ~" * Any changes made here will be lost!\n"
    ~" *\n"
    ~" */\n";
}

#=item C<c_code_coda()>
#
#Returns the Parrot C code coda
#
#=back
#
#=cut
sub c_code_coda() {
     "/*\n"
    ~" * Local variables:\n"
    ~" *   c-file-style: parrot\n"
    ~" * End:\n"
    ~" * vim: expandtab shiftwidth=4:\n"
    ~" */\n"
}

# Local Variables:
#   mode: perl6
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
