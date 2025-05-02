-- Creating tables
CREATE TABLE Users (
                       user_id SERIAL PRIMARY KEY,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Addresses (
                           address_id SERIAL PRIMARY KEY,
                           user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
                           street VARCHAR(100),
                           city VARCHAR(50),
                           zip_code VARCHAR(20)
);

CREATE TABLE Messages (
                          message_id SERIAL PRIMARY KEY,
                          user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
                          content TEXT NOT NULL,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserting sample users
INSERT INTO Users (username, email)
VALUES
    ('john_doe', 'john@gmail.com'),
    ('jane_doe', 'jane@yahoo.com');

SELECT * FROM Users;

-- Inserting an address (ensure user exists before running)
INSERT INTO Addresses (user_id, street, city, zip_code)
VALUES
    (
        (SELECT user_id FROM Users WHERE username = 'john_doe'),
        '789 Maple Ave',
        'Springfield',
        '67890'
    );

-- Updating an email
UPDATE Users
SET email = 'new_email@example.com'
WHERE username = 'john_doe';

-- Deleting a user
DELETE FROM Users WHERE username = 'jane_doe';

-- Inserting more users
INSERT INTO Users (username, email)
VALUES
    ('sam_walker', 'sam_walker@office.com'),
    ('user1', 'user1@email.com'),
    ('user2', 'user2@example.com'),
    ('user3', 'user3@example.com');

-- Specific select
SELECT username, email
FROM Users;

--Conditional select
SELECT username, email FROM Users;
SELECT * FROM Users WHERE email LIKE '%@example.com';

-- Insert with reference:
INSERT INTO Addresses (user_id, street, city, zip_code)
VALUES
    ((SELECT user_id FROM Users WHERE username = 'sam_walker'), '123 Oak St', 'Chicago', '60601'),
    ((SELECT user_id FROM Users WHERE username = 'user1'), '555 Pine St', 'Miami', '33101'),
    ((SELECT user_id FROM Users WHERE username = 'user2'), '678 Birch Ave', 'Seattle', '98101'),
    ((SELECT user_id FROM Users WHERE username = 'user3'), '890 Cedar Rd', 'Denver', '80201');

SELECT * FROM Addresses;

-- Inserting sample messages
INSERT INTO Messages (user_id, content)
VALUES
    ((SELECT user_id FROM Users WHERE username = 'john_doe'), 'Hello there!'),
    ((SELECT user_id FROM Users WHERE username = 'john_doe'), 'SQL is fun!'),
    ((SELECT user_id FROM Users WHERE username = 'sam_walker'), 'Working on a new project.'),
    ((SELECT user_id FROM Users WHERE username = 'user1'), 'Just checking in!'),
    ((SELECT user_id FROM Users WHERE username = 'user2'), 'Learning SQL with Copilot!');
    ((SELECT user_id FROM Users WHERE username = 'user3'), 'Trying out some queries!');

-- Updating messages containing "hello"
UPDATE Messages
SET content = 'Hello World!'
WHERE content ILIKE '%hello%';

SELECT * FROM Messages;

-- Delete with JOIN
DELETE FROM Addresses
WHERE user_id IN (
    SELECT user_id FROM Users WHERE email LIKE '%@example.com'
);

-- Counting messages per user
SELECT user_id, COUNT(*) AS message_count
FROM Messages
GROUP BY user_id
ORDER BY message_count DESC;

-- Retrieving messages with sender usernames
SELECT M.message_id, M.content, M.created_at, U.username
FROM Messages M
         JOIN Users U ON M.user_id = U.user_id;

-- Finding messages from the last 7 days
SELECT * FROM Messages
WHERE created_at >= NOW() - INTERVAL '7 days';

-- Searching for users with "john" in their username
SELECT * FROM Users
WHERE username ILIKE 'john%';

-- Count the number of users from each city based on the Addresses table
SELECT city, COUNT(user_id) AS user_count
FROM Addresses
GROUP BY city;

-- Classify messages into 'Short' and 'Long' based on content length
SELECT message_id, content,
       CASE
           WHEN LENGTH(content) < 25 THEN 'Short'
           ELSE 'Long'
           END AS message_type
FROM Messages;

-- Retrieve the next 5 users starting from the third user
SELECT *
FROM Users
ORDER BY user_id
    LIMIT 5 OFFSET 2;

-- Retrieve all addresses sorted by city (ascending) and street_name (descending)
SELECT * FROM Addresses
ORDER BY city ASC, street DESC

-- Retrieve all unique cities from the Addresses table
SELECT DISTINCT city
FROM Addresses;

-- Retrieve users with specific usernames
SELECT * FROM Users
WHERE username IN ('john_doe', 'jane_doe', 'sam_smith');

-- Insert 2 new users into the Users table for the next task
INSERT INTO Users (username, email)
VALUES
    ('new_user1', 'new_user1@example.com'),
    ('new_user2', 'new_user2@example.com');

-- Retrieve users who have not sent any messages
SELECT * FROM Users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM Messages);

-- Retrieve all messages along with the sender's username and city
SELECT M.message_id, M.content, U.username, A.city
FROM Messages M
         JOIN Users U ON M.user_id = U.user_id
         JOIN Addresses A ON U.user_id = A.user_id;

-- Inserting more addresses
INSERT INTO Addresses (user_id, street, city, zip_code)
VALUES
    ((SELECT user_id FROM Users WHERE username = 'new_user1'), '123 Oak St', 'Chicago', '60601'),
    ((SELECT user_id FROM Users WHERE username = 'new_user2'), '555 Pine Ave', 'Chicago', '60601');

-- Retrieve cities that have 3 or more users
SELECT city
FROM Addresses
GROUP BY city
HAVING COUNT(user_id) >= 3;

-- Update Sam's message to be longer than 50 characters
UPDATE Messages
SET content = 'I am working on a new project that requires a lot of SQL queries and optimizations!'
WHERE user_id = (SELECT user_id FROM Users WHERE username = 'sam_walker');

-- Calculate the average message length per user and filter for users with avg length > 50
SELECT user_id, AVG(LENGTH(content)) AS avg_message_length
FROM Messages
GROUP BY user_id
HAVING AVG(LENGTH(content)) > 50;