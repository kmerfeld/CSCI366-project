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
	FROM shoppingList");

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
print "<h2>This is your shopping list</h2>";
print "<h2>Item:\tquantity:\tunit:</h2>";
print '</body>';
print '</html>';

print '<FORM action="/cgi-bin/shopping/delete.pl" method="GET">';
print 'itemId to delete: <input type="text" name="listId">';
print '<input type="submit" value="Submit">';
print '</FORM>';
print "<h2>$v</h2>";
print '<br><a href="pantry.html">home</a>';

1;
