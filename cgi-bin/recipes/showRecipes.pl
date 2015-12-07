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
	SELECT recId, recName
	FROM recipes");

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
print "<h2>These are the recipes in your recipe book</h2>";
print "<h2>Recipe ID:\tRecipe Name:</h2>";
print "<h2>$output</h2>";
print '<FORM action="/cgi-bin/recipes/showRecipeIngredient.pl" method="GET">'; 
print 'view recipe: <input type="text" name="recId">';
print '<input type="submit" value="Submit">'; 
print '</FORM>';
print '<br><a href="http://kmerfeld1.me/pantry.html">home</a>';
print '</body>';
print '</html>';

1;
