#!/usr/bin/perl  -w
use DBI;
use CGI;
#definition of variables
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password
my $output = "";
#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
	$user,
	$password) 
	or die "Can't connect to database: $DBI::errstr\n";

#prepare the query
my $sth = $dbh->prepare( "
	SELECT utName, quantity
	FROM availUtensils");

#execute the query
$sth->execute( );
## Retrieve the results of a row of data and print
while ( my @row = $sth->fetchrow_array( ) )  {
	$output = $output . "|" .  " @row <br>";
}
warn "Problem in retrieving results", $sth->errstr( ), "\n"
if $sth->err( );

print "Content-type:text/html\n\n";
print '<html>';
print '<head>';
print '<title>Pantry</title>';
print '</head>';
print '<body>';
print "<h2>These are your available utensils:</h2>";
print "<h2>Utensil:\tquantity:</h2>";
print "<h2>$output</h2>";
print "<h2>$q</h2>";
print '</body>';
print '</html>';

1;
