use strict;
use warnings;
package WWW::REST::Simple;
use LWP::UserAgent;
use LWP::Protocol::https;
use HTTP::Request::Common;
use URI;
use utf8;

# ABSTRACT: Just provides GET and POST http methods

use base 'Exporter';
our @EXPORT = qw/get post/;

our $VERSION = '0.003';

sub get {
  die "At least a url is needed!" if @_ < 1;
  _send_request('GET', @_);
}

sub post {
  die "At least a url is needed!" if @_ < 1;
  _send_request('POST', @_);
}

sub _send_request {
  my ($method, $url, $args) = @_;
  my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
  $ua->timeout(20);
  $url = URI->new($url);

  my $resp = do {
    if ($method eq 'GET') {
      $url->query_form(%$args);
      $ua->request( GET $url );
    }
    else {
      $ua->request( POST $url, $args );
    }
  };

  $resp->is_success ? $resp->content : $resp->status_line;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WWW::REST::Simple - Just provides two most frequently used http methods: GET and POST

=head1 VERSION

version 0.002

=head1 SYNOPSIS

    use WWW::REST::Simple qw/get post/;

    # just GET a url
    my $content = get('http://www.example.com/?param_x=1');

    my $args = { param_x => 1, param_y => 2 };

    # GET some url like 'http://www.example.com/?param_x=1&param_y=2
    my $content = get('http://www.example.com/', $args);

    # or by POST, here we just take args as form data
    my $content = post('http://www.example.com/', $args);

=head1 EXPORTS

Exports the C<get> and C<post> functions.

No other methods like DELETE, PUT etc. provided.

No any header can be passed by.

So if you need more powerful one, go to L<WWW::REST> or L<REST::Client>, or just search the keyword 'REST' in CPAN.

Call it Simple it's really simple ; )

=head1 AUTHOR

Bin Joy <perlxruby@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Bin Joy.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
