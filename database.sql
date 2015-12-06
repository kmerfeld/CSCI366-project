create table item
(foodId int NOT NULL AUTO_INCREMENT,
genericName varchar(20),	
quantity DOUBLE, 		
unitOfMeasurement varchar(20),	
itemStyle varchar(20),		
expdate date,
primary key(foodId));

create table shoppingList
(listId int NOT NULL AUTO_INCREMENT,
	itemName varchar(20),
	quantity int,
	unitOfMeasurement varchar(20),
	primary key(listId));

create table recipes
(recId int NOT NULL AUTO_INCREMENT,
recName varchar(20),
instructions varchar(1024),
primary key(recid));

create table itemsNeeded
(recName varchar(20) NOT NULL,
	genericName varchar(20),
	primary key(recName),
	FOREIGN KEY(recName) references recipes(recName),
	FOREIGN KEY(genericName) references item(genericName);

create table availUtensils
(utId int NOT NULL AUTO_INCREMENT,
	utName varchar(20),
	quantity integer(20),
	primary key(utid));

create table untensilsNeeded
(utnId int NOT NULL AUTO_INCREMENT,
	recid varchar(20),
	quantityneed integer(20),
	primary key(utnId),
	FOREIGN KEY(recid) references recipes(recid);




