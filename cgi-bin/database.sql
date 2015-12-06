create table item
	(foodId int NOT NULL,
	genericName varchar(20),	
	quantity DOUBLE, 		
	unitOfMeasurement varchar(20),	
	itemStyle varchar(20),		
	expdate date,
	primary key(foodId));

create table nutrition
	(nid int not null,
	calories int,
	fats int,
	cholesterol int,
	sodium int,
	carbohydrates int,
	protein int,
	foreign key(nid) references item(foodId),
	primary key(nid));

create table recipes
	(recipeId int NOT NULL,
	recName varchar(20),
	instructions varchar(1024),
	primary key(recipeId));


create table availUtensils
	(utid int NOT NULL,
	utName varchar(20),
	quantity integer(20),
	primary key(utid));

create table untensilsNeeded
	(utid int not null,
	recipeId int,
	quantityneed int,
	primary key(recipeId),
	foreign key(recipeId) references recipes(recipeId));

create table itemsNeeded
	(foodname varchar(20) not null,
	recipeId int,
	quantityneed int,
	primary key(recipeId),
	foreign key(recipeId) references recipes(recipeId));



