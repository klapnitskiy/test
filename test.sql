
-- creating new table "user"
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    email VARCHAR(255),
    cultureID INT,
    deleted BOOLEAN,
    country VARCHAR(255),
    isRevokeAccess BOOLEAN,
    created TIMESTAMP
);

-- inserting data into table "user"
INSERT INTO "user" (firstName, lastName, email, cultureID, deleted, country, isRevokeAccess, created) VALUES
('Victor', 'Shevchenko', 'vs@gmail.com', 1033, TRUE, 'US', FALSE, '2011-04-05'::TIMESTAMP),
('Oleksandr', 'Petrenko', 'op@gmail.com', 1034, FALSE, 'UA', FALSE, '2014-05-01'::TIMESTAMP),
('Victor', 'Tarasenko', 'vt@gmail.com', 1033, TRUE, 'US', TRUE, '2015-07-03'::TIMESTAMP),
('Sergiy', 'Ivanenko', 'sergiy@gmail.com', 1046, FALSE, 'UA', TRUE, '2010-02-02'::TIMESTAMP),
('Vitalii', 'Danilchenko', 'shumko@gmail.com', 1031, FALSE, 'UA', TRUE, '2014-05-01'::TIMESTAMP),
('Joe', 'Dou', 'joe@gmail.com', 1032, FALSE, 'US', TRUE, '2009-01-01'::TIMESTAMP),
('Marko', 'Polo', 'marko@gmail.com', 1033, TRUE, 'UA', TRUE, '2015-07-03'::TIMESTAMP);

-- creating table usergroup
CREATE TABLE usergroup (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created TIMESTAMP
);

-- inserting data into "usergroup"
INSERT INTO usergroup (name, created) VALUES
('Support', '2010-02-02'::TIMESTAMP),
('Dev team', '2010-02-03'::TIMESTAMP),
('Apps team', '2011-05-06'::TIMESTAMP),
('TEST - dev team', '2013-05-06'::TIMESTAMP),
('Guest', '2014-02-02'::TIMESTAMP),
('TEST-QA-team', '2014-02-02'::TIMESTAMP),
('TEST-team', '2011-01-07'::TIMESTAMP);


-- creating table "groupmembership"
CREATE TABLE groupmembership (
    id SERIAL PRIMARY KEY,
    userID INT,
    groupID INT,
    created TIMESTAMP
);

-- inserting data into "groupmembership"
INSERT INTO groupmembership (userID, groupID, created) VALUES
(2, 10, '2010-02-02'::TIMESTAMP),
(3, 15, '2010-02-03'::TIMESTAMP),
(1, 10, '2014-02-02'::TIMESTAMP),
(1, 17, '2011-05-02'::TIMESTAMP),
(4, 12, '2014-07-13'::TIMESTAMP),
(5, 15, '2014-06-15'::TIMESTAMP);


-- Selecting names of all empty test groups.
select name 
from "usergroup" where name like 'TEST-%' and id not in (select groupID from groupmembership)

-- Selecting user first names and last names for the users that have Victor as a first name and are not members of any test groups.
SELECT "user".firstName, "user".lastName
FROM "user"
WHERE "user".firstName = 'Victor' 
  AND "user".id NOT IN (
    SELECT groupmembership.userID
    FROM groupmembership
    JOIN usergroup ON groupmembership.groupID = usergroup.id
    WHERE usergroup.name LIKE 'TEST-%'
  );

-- Selecting users and groups for which user was created before the group for which he(she) is member of
SELECT "user".id, "user".firstName, "user".lastName, "usergroup".id, "usergroup".name
FROM "user"
JOIN groupmembership ON "user".id = groupmembership.userID
JOIN "usergroup" ON groupmembership.groupID = "usergroup".id
WHERE "user".created < "usergroup".created;
