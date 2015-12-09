#!/usr/bin/perl  -w 
use DBI;
use CGI qw/:standard/;

#definition of variables
$db="pantry";
$host="localhost";
$user="kyle";
$password="O6Pi[A&{I3";  # the root password

my @debug;
my $item = 0;
my $outcome = "";

# Retrieve cookie info
$rcvd_cookies = $ENV{'HTTP_COOKIE'};
@cookies = split /;/, $rcvd_cookies;
foreach $cookie (@cookies) {
	($key, $val) = split(/=/, $cookie);
	$key =~ s/^\s+//;
	$val =~ s/^\s+//;
	$key =~ s/\s+$//;
	$val =~ s/\s+$//;
	if( $key eq 'recId' ) {
		$item = $val;
	}
}
if ($item == 0) {
	$outcome = "Not enough ingredients or utensils";
}

#connect to MySQL database
my $dbh = DBI->connect ("DBI:mysql:database=$db:host=$host",
	$user,
	$password) 
	or die "Can't connect to database: $DBI::errstr\n";

# get recipe name
$name = "";
$sth = $dbh->selectrow_array("
	select recName
	FROM recipes
	WHERE recId=\'$item\'");
$name = $sth;

# get ingredients, make sure there is the right amount
# and update by removing correct quantity from item.
$sth2 = $dbh->prepare( "
	SELECT foodName, quantity
	FROM itemsNeeded
	WHERE recId=\'$item\'");

# execute query
$sth2->execute( );

#my $temp; 
my $counter;	
my $itemCount;
my $quantity;
my $thing;
my $total;
my @nestRow;
my $row;
my $reqdItem;
my $reqdQuantity;
my $delId;

#debugging
my @itemDebug;

# Retrieve the results of a row of data and print
# and determine if there are enough of the ingredients
# available in the inventory to make it.
while (@row = $sth2->fetchrow_array)  {
	if ($item == 0) {
		last;
	}

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
		foreach $row (@nestRow) {
			$itemCount += $row;
		}
	}

	$query->finish( );

	$quantity = $itemCount;

	# if there's enough in inventory,
	# calculate total remaining based on first
	# occurance and update based on that. Query again
	# to get the quantity of the first occurance. If 
	# negative, delete that entry and add that negative
	# quantity to the next occurance. Repeat until 
	# positive where it will delete the correct
	# amount and exit.
	if ($quantity >= $reqdQuantity and $quantity != 0) {
		push @itemDebug, "IF";
		while(1) {

			# get amount of first occurance in 
			# db
			$sthQ = $dbh->selectrow_array("
				select quantity
				from item
				where genericName=\'$reqdItem\'
				order by expdate");
			$amount = $sthQ;
			
			# if amount of first occurance
			# in db is less than reqdQuantity
			if ($amount <= $reqdQuantity and $amount != 0 and $reqdQuantity != 0) {
				# set reqd to reqd - amount
				$reqdQuantity -= $amount;
				
				# get current items id to delete
				my $toDelete = $dbh->selectrow_array("
					select foodId
					from item
					where genericName=\'$reqdItem\'
					order by expdate");
				$delId = $toDelete;
				
				# delete item from database
				my $delete = $dbh->prepare("
					delete from item
					where foodId=\'$delId\'");
				$delete->execute( );
				$delete->finish( );
			}
			else {
				$amount -= $reqdQuantity;

				# update quant in db
				my $update = $dbh->prepare("
					update item
					set quantity=\'$amount\'
					where genericName=\'$reqdItem\'");
				$update->execute( );
				$update->finish( );
				last;
			}
		}	
	}
}
warn "Problem in retrieving results", $sth2->errstr( ), "\n"
if $sth2->err( );
$sth2->finish( );

print "Content-type:text/html\r\n\r\n";
print '<html>';
print '<head>';
print '<title>Pantry</title>';
print '</head>';
print '<body>';
print "<h1>$name</h1>";
print "<br><h2>$outcome</h2>";
print "<br><br><br><h2>recID = $item</h2><br><br>";
print "<p>this is the debug array: @itemDebug</p>";
print "<p>this is the debug array: @debug</p>";
print '<br><a href="http://kmerfeld1.me/cgi-bin/recipes/showRecipes.pl">View other recipes</a>';
print '<br><a href="http://kmerfeld1.me/pantry.html">home</a>';

1;
