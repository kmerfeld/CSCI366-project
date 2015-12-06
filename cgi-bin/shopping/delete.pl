#!/usr/bin/perl  -w
use DBI;
use CGI;
#definition of variables
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password



#READ IN THE INPUT
local ($buffer, @pairs, $pair, $name, $value, %FORM);
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
$item = $FORM{listId};

#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
	$user,
	$password) 
	or die "Can't connect to database: $DBI::errstr\n";


my $sql = "DELETE FROM shoppingList WHERE listId = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($item);
$dbh->disconnect();

print "Content-type:text/html\n\n";
print '<html>';
print '<head>';
print '<title>Pantry</title>';
print '</head>';
print '<body>';
print "<h2>Deleted item</h2>";
print "$item <br>";
print ' <a href="http://kmerfeld1.me/pantry.html">home</a>';
print "<br>";
print ' <a href="/cgi-bin/shopping/expired.pl">back</a>';

print '</body>';
print '</html>';

