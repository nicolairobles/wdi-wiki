-- Put apartment schema here
DROP TABLE IF EXISTS buildings;

CREATE TABLE buildings (
	id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	address VARCHAR NOT NULL,
	num_floors INTEGER NOT NULL
);

DROP TABLE IF EXISTS apartments;

CREATE TABLE apartments (
	id SERIAL PRIMARY KEY,
	floor INTEGER NOT NULL,
	name VARCHAR NOT NULL,
	price INTEGER NOT NULL,
	sqft INTEGER NOT NULL,
	bedrooms INTEGER NOT NULL,
	bathrooms INTEGER NOT NULL,
	building_id INTEGER REFERENCES buildings(id)
);

DROP TABLE IF EXISTS tenants;

CREATE TABLE tenants (
	id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	age INTEGER NOT NULL,
	gender VARCHAR NOT NULL,
	apartment_id INTEGER REFERENCES apartments(id)
);

DROP TABLE IF EXISTS doormen;

CREATE TABLE doormen (
	id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	experience INTEGER NOT NULL,
	shift VARCHAR NOT NULL,
	building_id INTEGER NOT NULL
);
