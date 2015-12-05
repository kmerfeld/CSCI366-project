create table item
(barcode int NOT NULL,
genericName varchar(20),	
quantity DOUBLE, 		
unitOfMeasurement varchar(20),	
itemStyle varchar(20),		
expdate date,
primary key(foodId));

create table nutrition
(nid varchar(20) not null,
cal integer,
protean integer,
sugar integer,
fats integer,
foreign key(nid) references item(barcode),
primary key(nid));

create table recipes
(recid int NOT NULL,
recName varchar(20),
instructions varchar(1024),
primary key(recid));


create table availUtensils
(utid int NOT NULL,
	utName varchar(20),
	quantity integer(20),
	primary key(utid));

create table untensilsNeeded
(utid int not null,
	recid varchar(20),
	quantityneed integer(20),
	primary key(recid)
	foreign key(recid) references recipes(recid);

create table itemsNeeded
(foodname varchar(20) not null,
	recid varchar(20),
	quantityneed integer(20),
	primary key(recid)
	foreign key(recid) references recipes(recid);



