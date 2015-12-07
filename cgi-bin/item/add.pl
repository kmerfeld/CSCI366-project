#!/usr/bin/perl
use DBI;
use CGI;

##########################################################
#READ IN THE INPUT
local ($buffer, @pairs, $pair, $name, $value, %FORM);
# Read in text
#$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/1-9;
if ($ENV{'REQUEST_METHOD'} eq "GET")
{
	$buffer = $ENV{'QUERY_STRING'};
}
# Split information into name/value pairs
@pairs = split(/&/, $buffer);
foreach $pair (@pairs)
{
	($name, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%(..)/pack("C", hex($1))/eg;
	$FORM{$name} = $value;
}
$genericName  	= $FORM{genericName};
$quantity 	= $FORM{quantity};
$unit 		= $FORM{unitOfMeasurement};
$itemStyle 	= $FORM{itemStyle};
$expdate 	= $FORM{expdate};

my @itemS = split(/=/, $pair[5]);
my @expd = split(/=/, $pair[6]);

##########################################################
#ADD TO THE DATABASE
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password
#connect to MySQL database
my $dbh = DBI->connect("DBI:mysql:database=$db:host=$host", $user, $password ) or die $DBI::errstr;
my $sth = $dbh->prepare("INSERT INTO item
	(genericName, quantity, unitOfMeasurement, itemStyle, expdate )
	values(\"$genericName\", \"$quantity\", \"$unit\", \"$itemStyle\", \"$expdate\")");
$sth->execute() or die $DBI::errstr;
$sth->finish();
#$dbh->commit or die $DBI::errstr;

##########################################################
#HTML CODE
print "Content-type:text/html\r\n\r\n";
print "<html>";
print "<head>";
print "<title>Pantry</title>";
print "</head>";
print "<body>";
print "<p>genericName = $genericName</p>";
print "<p>quantity =  $quantity</p>";
print "<p>itemStyle = $itemStyle</p>";
print "<p>expdate = $expdate</p>";
print "<p>unit = $unit</p>";
print "<br>";
print '<a href="http://kmerfeld1.me/additem.html">Add more</a>';
print '<br><a href="http://kmerfeld1.me/pantry.html">home</a>';
print "</body>";
print "</html>";
1;
