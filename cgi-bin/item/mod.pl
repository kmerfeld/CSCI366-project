#!/usr/bin/perl  -w
use DBI;
use CGI;
#definition of variables
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password
my $v = "";
my $q = "";
#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
	$user,
	$password) 
	or die "Can't connect to database: $DBI::errstr\n";

#prepare the query
my $sth = $dbh->prepare( "
	SELECT *
	FROM item");

#execute the query
$sth->execute( );
## Retrieve the results of a row of data and print
while ( my @row = $sth->fetchrow_array( ) )  {
	$v = $v . "|" .  " @row <br>";
}
warn "Problem in retrieving results", $sth->errstr( ), "\n"
if $sth->err( );



print "Content-type:text/html\r\n\r\n";
print '<html>';
print '<head>';
print '<title>Pantry</title>';
print '</head>';
print '<body>';
print "<h2>This is the food that has expired</h2>";
print "<h2>food:\tquantity:\tunit:\ttype:\texperation date</h2>";
print '</body>';
print '</html>';

print '<FORM action="/cgi-bin/item/del2.pl" method="GET">';
print 'what food did you use? please use foodId: <input type="text" name="foodId">';
print 'how much did you use?: <input type="text" name="quantity">';
print '<input type="submit" value="Submit">';
print '</FORM>';
print "<h2>$v</h2>";
print '<br><a href="http://kmerfeld1.me/pantry.html">home</a>';

1;
