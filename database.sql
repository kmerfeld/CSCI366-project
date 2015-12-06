create table item
(foodId int NOT NULL AUTO_INCREMENT,
genericName varchar(20),	
quantity DOUBLE, 		
unitOfMeasurement varchar(20),	
itemStyle varchar(20),		
expdate date,
primary key(foodId));

create table nutrition
(nId int NOT NULL AUTO_INCREMENT,
cal integer,
protean integer,
sugar integer,
fats integer,
foreign key(nid) references item(barcode),
primary key(nid));

create table recipes
(recId int NOT NULL AUTO_INCREMENT,
recName varchar(20),
instructions varchar(1024),
primary key(recid));


create table availUtensils
(utId int NOT NULL AUTO_INCREMENT,
	utName varchar(20),
	quantity integer(20),
	primary key(utid));

create table untensilsNeeded
(utnId int NOT NULL AUTO_INCREMENT,
	recid varchar(20),
	quantityneed integer(20),
	primary key(recid)
	foreign key(recid) references recipes(recid);

create table itemsNeeded
(foodname int NOT NULL AUTO_INCREMENT,
	recid varchar(20),
	quantityneed integer(20),
	primary key(recid)
	foreign key(recid) references recipes(recid);



