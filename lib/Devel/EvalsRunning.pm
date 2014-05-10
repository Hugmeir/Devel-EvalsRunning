package Devel::EvalsRunning;

use 5.006;
use strict;
use warnings FATAL => 'all';

BEGIN {
    require Exporter;
    our @ISA = 'Exporter';
    our @EXPORT_OK = 'evals_running';
}

=head1 NAME

Devel::EvalsRunning - Detect the number of active evals.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

require XSLoader;
XSLoader::load(__PACKAGE__);

=head1 SYNOPSIS

    use Devel::EvalsRunning;

    say                     ${^EVALS_RUNNING};          # 0
    say eval {              ${^EVALS_RUNNING}  };       # 1
    say eval { eval {       ${^EVALS_RUNNING}  } };     # 2
    say eval { eval { eval '${^EVALS_RUNNING}' } };     # 3

=head1 DESCRIPTION

This module allows you to easily retrieve the number of active evals
in the current context.
Note that this means both eval BLOCK and eval STRING, but B<not> the
internal evals used to implement require/use.

=head1 EXPORTS

=head2 evals_running

For those of you adverse to magic variables.

=head1 AUTHOR, LICENSE AND COPYRIGHT

Brian Fraser, C<< <fraserbn at gmail.com> >>

This program is free software; you may redistribute it and/or modify it under the same terms as perl.

=head1 BUGS

Please report any bugs or feature requests to C<bug-devel-evalsrunning at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Devel-EvalsRunning>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

Ævar Arnfjörð Bjarmason, for the mild shock that lead to writing the module.

=cut

1; # End of Devel::EvalsRunning
