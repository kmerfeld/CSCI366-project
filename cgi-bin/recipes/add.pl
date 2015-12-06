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
my $RecName		= $FORM{recName};
my $instructions 	= $FORM{instructions};
my $ingredients		= $FORM{ingredients};
my $utensils		= $FORM{utensils};


##########################################################
#ADD TO THE DATABASE
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password
#connect to MySQL database
my $dbh = DBI->connect("DBI:mysql:database=$db:host=$host", $user, $password ) or die $DBI::errstr;
#my $sth = $dbh->prepare("INSERT INTO recipes (recName instructions)
#	values($RecName, $instructions)");
#$sth->execute() or die $DBI::errstr;

@ing = split(/, /, $ingredients);
#foreach (@ing) {
#	my $sth = $dbh->prepare("INSERT INTO itemsNeeded (recName genericName)
#		VALUES(\"$RecName\", \"$_\")");
#	$sth->execute() or die $DBI::errstr;
#}
#$sth->finish();
#$dbh->commit or die $DBI::errstr;

##########################################################
#HTML CODE
print "Content-type:text/html\r\n\r\n";
print "<html>";
print "<head>";
print "<title>Pantry</title>";
print "</head>";
print "<body>";
print "<p>recipe name = $RecName</p>";
print "<p>instructions = $instructions</p>";
print "<p>ingredients = $ingredients</p>";
print "<p>utensils = $utensils</p>";
print "<p>arrays</p>";
print "@pairs";
print "<p>ing</p>";
print "@ing";
print "<br>";
print '<a href="http://kmerfeld1.me/pantry.html">home</a>';
print "</body>";
print "</html>";
1;
