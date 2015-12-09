#!/usr/bin/perl  -w 
use DBI;
use CGI qw/:standard/;
use CGI::Cookie;

#definition of variables
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password
my $v = "";
my $x = "";

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
$item = $FORM{recId};
$itemTag = $item;

#connect to MySQL database
my $dbh = DBI->connect ("DBI:mysql:database=$db:host=$host",
	$user,
	$password) 
	or die "Can't connect to database: $DBI::errstr\n";

# get recipe name
my $sth = $dbh->selectrow_array("
	select recName
	FROM recipes
	WHERE recId=\'$item\'");
my $name = $sth;

# get instructions
my $sth1 = $dbh->selectrow_array("
	select instructions
	FROM recipes
	WHERE recId=\'$item\'");
my $inst = $sth1;

# print out ingredients
my $sth2 = $dbh->prepare( "
	SELECT foodName, quantity
	FROM itemsNeeded
	WHERE recId=\'$item\'");

# execute query
$sth2->execute( );

my $temp;
my $counter;
my $nestCounter;
my $stuff;
my $thing;
my $quantity;
my $itemCount;
# Retrieve the results of a row of data and print
# and determine if there are enough of the ingredients
# available in the inventory to make it.
while (@row = $sth2->fetchrow_array)  {
	$v = $v . "|" . " @row";
	
	$itemCount = 0;
	$counter = 0;

	foreach $stuff (@row) {
		if ($counter == 0){
			$reqdItem = $stuff;
		}
		else {
			$reqdQuantity = $stuff;
		}

		++$counter;
	}

	$query = $dbh->prepare("
		select quantity
		from item
		where genericName=\'$reqdItem\'");
	$query->execute( );

	# get full count of items in list matching
	# reqd name
	while (@nestRow = $query->fetchrow_array) {
		$nestCounter = 1;

		foreach $row (@nestRow) {
			$itemCount += $row;
		}
	}

	$quantity = $itemCount;

	if ($quantity < $reqdQuantity or $quantity == 0) {
		$v = $v . "\tNot enough<br>";
		$itemTag = 0;
	}
	else {
		$v = $v . "\tAvailable<br>";
	}

}
warn "Problem in retrieving results", $sth2->errstr( ), "\n"
if $sth2->err( );


# print out utensils
my $sth3 = $dbh->prepare( "
	select utName, quantity
	FROM utensilsNeeded
	WHERE recId=\'$item\'");

# execute the query
$sth3->execute( );

# Retrieve the results of a row of data and print
while (@row = $sth3->fetchrow_array) {
	$x = $x . "|" . " @row";
	
	$itemCount = 0;
	$counter = 0;

	foreach $stuff (@row) {
		if ($counter == 0) {
			$reqdUtensil = $stuff;
		}
		else {
			$reqdQuantity = $stuff;
		}

		++$counter;
	}

	$query = $dbh->prepare("
		select quantity
		from availUtensils
		where utName=\'$reqdUtensil\'");
	$query->execute( );

	# get full count of items in list matching
	# reqd name
	while (@nestRow = $query->fetchrow_array) {
		$nestCounter = 1;

		foreach $row (@nestRow) {
			$itemCount += $row;
		}   
	}    

	$quantity = $itemCount;	

	if ($quantity < $reqdQuantity or $quantity == 0) {
		$x = $x . "\tUnavailable<br>";
		$itemTag = 0;
	}
	else {
		$x = $x . "\tAvailable<br>";
	}
}
warn "Problem in retrieving results", $sth3->errstr( ), "\n"
if $sth3->err( );

print "Set-Cookie:recId=$itemTag;\n";
print "Set-Cookie:Path=http://kmerfeld1.me/cgi-bin/recipes;\n";
print "Content-type:text/html\r\n\r\n";
print '<html>';
print '<head>';
print '<title>Pantry</title>';
print '</head>';
print '<header>';
print '</header>';
print '<body>';
print "<h1>$name</h1>";
print "<br><br><h2>Instructions: $inst<h2>";
print '<br><br>';
print "<h2>Item:\tQuantity:</h2>";
print "<h2>$v</h2>";
print "<br><br>";
print "<h2>Utensil:\tQuantity:</h2>";
print "<h2>$x</h2>";
print "<br><br><h2>$itemTag</h2>";
print '<br><form action="http://kmerfeld1.me/cgi-bin/recipes/makeRecipe.pl" method="GET">';
print '<input type="submit" name="makeRec" value="Make Recipe">';
print '</form>';
print '<br><a href="http://kmerfeld1.me/cgi-bin/recipes/showRecipes.pl">Back</a>';
print '<br><a href="http://kmerfeld1.me/pantry.html">home</a>';

1;
