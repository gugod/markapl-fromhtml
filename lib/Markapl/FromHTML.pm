package Markapl::FromHTML;

use warnings;
use strict;
use 5.008;
use Rubyish;
use HTML::PullParser;
# use Data::Dump qw(pp);

our $VERSION = '0.01';

def load($html) {
    $self->{html} = $html
}

def dump {
    return $_ if (defined($_ = $self->{markapl}));
    return $self->convert;
}

def convert {
    return "" unless $self->{html};

    my $p = HTML::PullParser->new(
        doc => $self->{html},
        start => '"S", tagname, @attr',
        text  => '"T", text',
        end   => '"E", tagname',
    );
    
    my $current_tag = "";
    my @stack = ();
    while(my $token = $p->get_token) {
        # pp $token;
        if ($token->[0] eq 'S') {
            push @stack, { tag => $token->[1], attr => $token->[2] };
        }
        elsif ($token->[0] eq 'T') {
            unless($token->[1] =~ /^\s*$/s ) {
                push @stack, { text => $token->[1] }
            }
        }
        elsif ($token->[0] eq 'E') {
            # pp $token;
            my @content;

            my $content = pop @stack;
            while (!$content->{tag} || $content->{tag} ne $token->[1]) {
                push @content, $content;
                $content = pop @stack;
            }
            my $start_tag = $content;

            if (@content == 1) {
                my $content_text = $content[0]->{code};
                $content_text = "\"$content[0]->{text}\"" unless $content_text;
                push @stack, {
                    code => "$start_tag->{tag} { $content_text }"
                };
            }
            else {
                # pp @content;
                my $content_code = join "\n", map { $_->{code} || $_->{text} } reverse @content;
                push @stack, {
                    code => "$start_tag->{tag} { $content_code }"
                };
            }
        }
    }

    my $ret = join "\n", map { $_->{code} || $_->{text} } @stack;
    $ret = "sub {\n$ret\n}\n";
    return $ret;
}

1; 
__END__

=head1 NAME

Markapl::FromHTML - [One line description of module's purpose here]


=head1 VERSION

This document describes Markapl::FromHTML version 0.01


=head1 SYNOPSIS

    use Markapl::FromHTML;


=head1 DESCRIPTION


=head1 INTERFACE 


=over

=item new()

=back

=head1 DIAGNOSTICS

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

Markapl::FromHTML requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-markapl-fromhtml@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Kang-min Liu  C<< <gugod@gugod.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Kang-min Liu C<< <gugod@gugod.org> >>.

This is free software, licensed under:

    The MIT (X11) License

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
