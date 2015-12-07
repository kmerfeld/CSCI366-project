#!/usr/bin/perl  -w
use DBI;
use CGI;
#definition of variables
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password

#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
	$user,
	$password) 
	or die "Can't connect to database: $DBI::errstr\n";


my $sql = "DELETE FROM shoppingList";
my $sth = $dbh->prepare($sql);
$sth->execute();
$dbh->disconnect();

print "Content-type:text/html\n\n";
print '<html>';
print '<head>';
print '<title>Pantry</title>';
print '</head>';
print '<body>';
print "<h2>wiped list</h2>";
print ' <a href="http://kmerfeld1.me/pantry.html">home</a>';
print "<br>";
print ' <a href="/cgi-bin/shopping/show.pl">back</a>';

print '</body>';
print '</html>';

