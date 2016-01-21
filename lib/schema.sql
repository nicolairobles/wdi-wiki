DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS articles CASCADE;
DROP TABLE IF EXISTS articles_categories CASCADE;

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR,
	email VARCHAR NOT NULL,
	password VARCHAR NOT NULL,
	image VARCHAR
);

CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	title VARCHAR,
	description TEXT,
	edit_date TIMESTAMP NOT NULL DEFAULT NOW(),
	author_ID INTEGER REFERENCES users(id)
);

CREATE TABLE articles (
	id SERIAL PRIMARY KEY,
	title VARCHAR,
	content TEXT,
	edit_date TIMESTAMP NOT NULL DEFAULT NOW(),
	author_ID INTEGER REFERENCES users(id)
);

CREATE TABLE articles_categories (
  articles_ID integer REFERENCES articles(id),
  categories_ID integer REFERENCES categories(id)
);

INSERT INTO users (name, email, password) VALUES ('Ben Stiller', 'bstiller@gmail.com', 'bentest');
INSERT INTO users (name, email, password) VALUES ('Owen Wilson', 'owilson@gmail.com','owentest');
INSERT INTO users (name, email, password) VALUES ('Winona Ryder', 'wryder@gmail.com', 'winonatest');
INSERT INTO users (name, email, password) VALUES ('Will Ferrell', 'wferrell@gmail.com', 'willtest');
INSERT INTO users (name, email, password) VALUES ('Jack Black', 'jblack@gmail.com', 'jacktest');
INSERT INTO users (name, email, password) VALUES ('Christina Applegate', 'capplegate@gmail.com', 'christinatest');

INSERT INTO categories (title, description, author_ID) VALUES ('Programming Fundamentals', 'Lorem Ipsum', 1);
INSERT INTO categories (title, description, author_ID) VALUES ('Client-Side Scripting in the Browser', 'Lorem Ipsum', 2);
INSERT INTO categories (title, description, author_ID) VALUES ('The DOM API', 'Lorem Ipsum', 3);
INSERT INTO categories (title, description, author_ID) VALUES ('Networking and HTTP', 'Lorem Ipsum', 4);
INSERT INTO categories (title, description, author_ID) VALUES ('Server-Side Scripting', 'Lorem Ipsum', 5);
INSERT INTO categories (title, description, author_ID) VALUES ('Object-Oriented Programming in Ruby', 'Lorem Ipsum', 6);
INSERT INTO categories (title, description, author_ID) VALUES ('Persistence Layers', 'Lorem Ipsum', 1);
INSERT INTO categories (title, description, author_ID) VALUES ('CRUD and MVC Patterns', 'Lorem Ipsum', 2);
INSERT INTO categories (title, description, author_ID) VALUES ('Modern Web Applications', 'Lorem Ipsum', 3);


INSERT INTO articles (title, content, author_ID) VALUES ('Bash', 'Lorem Ipsum', 1);
INSERT INTO articles (title, content, author_ID) VALUES ('HTML Basics', 'Lorem Ipsum', 2);
INSERT INTO articles (title, content, author_ID) VALUES ('CSS', 'Lorem Ipsum', 3);
INSERT INTO articles (title, content, author_ID) VALUES ('Javascript', 'Lorem Ipsum', 4);
INSERT INTO articles (title, content, author_ID) VALUES ('Debugging', 'Lorem Ipsum', 5);
INSERT INTO articles (title, content, author_ID) VALUES ('Callbacks', 'Lorem Ipsum', 6);
INSERT INTO articles (title, content, author_ID) VALUES ('jQuery', 'Lorem Ipsum', 6);

INSERT INTO articles_categories (articles_ID, categories_ID) VALUES (1, 1);
INSERT INTO articles_categories (articles_ID, categories_ID) VALUES (2, 1);
INSERT INTO articles_categories (articles_ID, categories_ID) VALUES (3, 1);
INSERT INTO articles_categories (articles_ID, categories_ID) VALUES (4, 2);
INSERT INTO articles_categories (articles_ID, categories_ID) VALUES (5, 1);
INSERT INTO articles_categories (articles_ID, categories_ID) VALUES (6, 1);
INSERT INTO articles_categories (articles_ID, categories_ID) VALUES (6, 2);

