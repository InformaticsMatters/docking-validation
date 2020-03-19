#!/usr/bin/perl
#
my @ALL;
while (<>) {
        my @lines = get_record();
##print STDERR "Number of lines: ", scalar @lines,"\n";
        my @xyz = get_coords(\@lines);
##print STDERR "Number of coords: ", scalar @xyz,"\n";
	push (@ALL, @xyz);
}
my $tol = 1.5;
my @centers = select_points(\@ALL,$tol);
sub_sdfout(\@centers);
exit;
#
###############
# SUBROUTINES #
###############
sub get_record
{
        my @lines;
        while (<>) {
                chomp;#Get rid of Unix line separator
                $/ = "\r";
                chomp;#Get rid of DOS line separator
                $/ = "\n";#Reset to normal Unix
                if (/^\$\$\$/) {last}
                push (@lines,$_);
        }
        return @lines;
}
##############
sub get_coords {
	my $lines = shift (@_);
	my @tmp;
	my $line4 = $$lines[2];
##print STDERR $line4;
	my $version = substr($line4,34,5);
print STDERR $version,"\n";
	if ($version eq "V3000"){
		my $read = 0;
		foreach my $s (@$lines) {
			if ($s =~ /END ATOM/){$read = 0; last;};
			if ($read) {
				my @a = split(' ',$s);
				my $x = $a[4];
				my $y = $a[5];
				my $z = $a[6];
				push (@tmp, $x, $y, $z);
			}
			if ($s =~ /BEGIN ATOM/){$read = 1};
		}
	}else {
		my $natom = substr($line4,0,3);
		for my $i (1..$natom) {
			my $j = 2 + $i;
			my $x = substr($$lines[$j],0,10);
			my $y = substr($$lines[$j],10,10);
			my $z = substr($$lines[$j],20,10);
			push (@tmp, $x, $y, $z);
		}
	}
	return @tmp;
}
##############
sub select_points {
	my $xyz = shift (@_);
	my $tol = shift (@_);
	my $N = (scalar @$xyz)/3;
	my @sele;
	COORD:
	for my $i (1..$N) {
		my $x = $$xyz[$i*3 - 3];
		my $y = $$xyz[$i*3 - 2];
		my $z = $$xyz[$i*3 - 1];
		my $M = (scalar @sele)/3;
##print STDERR "M= ",$M, scalar @sele,"\n";
		for my $j (1..$M) {
			my $xr = $sele[$j*3 - 3];
			my $yr = $sele[$j*3 - 2];
			my $zr = $sele[$j*3 - 1];
			if ( $xr-$tol < $x && $x < $xr+$tol &&
			     $yr-$tol < $y && $y < $yr+$tol &&
			     $zr-$tol < $z && $z < $zr+$tol ) { next COORD; }
		}
		push (@sele,$x,$y,$z);
	}
	return @sele;
}
##############
sub sub_sdfout {
	my $xyz = shift (@_);
	my $N = (scalar @$xyz)/3;
	printf "MOL_1\n1234567890123456789 3D\nTITLE\n";
	printf "%3i  0  0  0  0  0  0  0  0  0999 V2000\n",$N;
	for my $i (1..$N) {
		my $x = $$xyz[$i*3 - 3];
		my $y = $$xyz[$i*3 - 2];
		my $z = $$xyz[$i*3 - 1];
		printf "%10.4f%10.4f%10.4f C   0  0  0  0  0  0  0  0  0  0  0  0\n",$x,$y,$z;
	}
	printf "M  END\n\$\$\$\$\n";
}
