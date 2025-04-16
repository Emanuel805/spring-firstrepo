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
    ('john_doe', 'john@example.com'),
    ('jane_doe', 'jane@example.com');

SELECT * FROM Users;

-- Inserting an address (ensure user exists before running)
INSERT INTO Addresses (user_id, street, city, zip_code)
VALUES
    (
        (SELECT user_id FROM Users WHERE username = 'user1'),
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
    ('user1', 'user1@example.com'),
    ('user2', 'user2@example.com'),
    ('user3', 'user3@example.com');

-- Viewing users
SELECT username, email FROM Users;
SELECT * FROM Users WHERE email LIKE '%@example.com';

-- Inserting addresses
INSERT INTO Addresses (user_id, street, city, zip_code)
VALUES
    (
        (SELECT user_id FROM Users WHERE username = 'john_doe'),
        '456 Elm St',
        'Townsville',
        '54321'
    );

SELECT * FROM Addresses;

-- Inserting sample messages
INSERT INTO Messages (user_id, content)
VALUES
    ((SELECT user_id FROM Users WHERE username = 'john_doe'), 'Hello there!'),
    ((SELECT user_id FROM Users WHERE username = 'jane_doe'), 'SQL is fun!'),
    ((SELECT user_id FROM Users WHERE username = 'john_doe'), 'Working on a new project.'),
    ((SELECT user_id FROM Users WHERE username = 'user1'), 'Just checking in!'),
    ((SELECT user_id FROM Users WHERE username = 'user2'), 'Learning SQL with Copilot!');

-- Updating messages containing "hello"
UPDATE Messages
SET content = 'Hello World!'
WHERE content ILIKE '%hello%';

SELECT * FROM Messages;

-- Deleting addresses of users with "@example.com" emails
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
           WHEN LENGTH(content) < 100 THEN 'Short'
           ELSE 'Long'
           END AS message_type
FROM Messages;