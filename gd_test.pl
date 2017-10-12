use strict;
use warnings;
use GD::SecurityImage;

# use external ttf font
my $image = GD::SecurityImage->new(
               width    => 100,
               height   => 40,
               lines    => 10,
               font     => "/home/zl/sites/DejaVuSans.ttf",
               scramble => 1,
            );
my $your_random_str = '0123456789';
   $image->random( $your_random_str );
   $image->create( ttf => 'default' );
   $image->particle;
my($image_data, $mime_type, $random_number) = $image->out;

