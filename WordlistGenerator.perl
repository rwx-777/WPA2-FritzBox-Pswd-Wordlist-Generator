#!/usr/bin/perl

$startingNum = 0001000000000000;
$EndNum =      9999000000000000;

$KiloBytes = $EndNum - $startingNum /1024;
$MegaByte = $KiloBytes / 1024;
$GigaByte = $MegaByte / 1024;
$Terabyte = $GigaByte / 1024;

print "The File will take up: " , $KiloBytes , "kb\n" , $MegaByte , "mb\n" , $GigaByte , "gb\n" , $Terabyte , "TB\n";

while($startingNum++ < $EndNum) {
	#print "$startingNum\n";
	#print "Writing " + $startingNum + " to file";
	printf "%016d\n", $startingNum;

}

