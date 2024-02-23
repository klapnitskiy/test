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

INSERT INTO "user" (firstName, lastName, email, cultureID, deleted, country, isRevokeAccess, created) VALUES
('Victor', 'Shevchenko', 'vs@gmail.com', 1033, TRUE, 'US', FALSE, '2011-04-05'::TIMESTAMP),
('Oleksandr', 'Petrenko', 'op@gmail.com', 1034, FALSE, 'UA', FALSE, '2014-05-01'::TIMESTAMP),
('Victor', 'Tarasenko', 'vt@gmail.com', 1033, TRUE, 'US', TRUE, '2015-07-03'::TIMESTAMP),
('Sergiy', 'Ivanenko', 'sergiy@gmail.com', 1046, FALSE, 'UA', TRUE, '2010-02-02'::TIMESTAMP),
('Vitalii', 'Danilchenko', 'shumko@gmail.com', 1031, FALSE, 'UA', TRUE, '2014-05-01'::TIMESTAMP),
('Joe', 'Dou', 'joe@gmail.com', 1032, FALSE, 'US', TRUE, '2009-01-01'::TIMESTAMP),
('Marko', 'Polo', 'marko@gmail.com', 1033, TRUE, 'UA', TRUE, '2015-07-03'::TIMESTAMP);

CREATE TABLE userGroup (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created TIMESTAMP
);

INSERT INTO userGroup (name, created) VALUES
('Support', '2010-02-02'::TIMESTAMP),
('Dev team', '2010-02-03'::TIMESTAMP),
('Apps team', '2011-05-06'::TIMESTAMP),
('TEST - dev team', '2013-05-06'::TIMESTAMP),
('Guest', '2014-02-02'::TIMESTAMP),
('TEST-QA-team', '2014-02-02'::TIMESTAMP),
('TEST-team', '2011-01-07'::TIMESTAMP);

CREATE TABLE groupMembership (
    id SERIAL PRIMARY KEY,
    userID INT,
    groupID INT,
    created TIMESTAMP
);

INSERT INTO groupMembership (userID, groupID, created) VALUES
(2, 10, '2010-02-02'::TIMESTAMP),
(3, 15, '2010-02-03'::TIMESTAMP),
(1, 10, '2014-02-02'::TIMESTAMP),
(1, 17, '2011-05-02'::TIMESTAMP),
(4, 12, '2014-07-13'::TIMESTAMP),
(5, 15, '2014-06-15'::TIMESTAMP);

select name 
from "group" where name like 'TEST-%' and id not in (select groupID from groupmembership)

alter table "group"
rename to "userGroup"

SELECT "user".firstName, "user".lastName
FROM "user"
WHERE "user".firstName = 'Victor' 
  AND "user".id NOT IN (
    SELECT groupMembership.userID
    FROM groupMembership
    JOIN userGroup ON groupMembership.groupID = userGroup.id
    WHERE userGroup.name LIKE 'TEST-%'
  );

SELECT "user".id, "user".firstName, "user".lastName, "usergroup".id, "usergroup".name
FROM "user"
JOIN groupmembership ON "user".id = groupmembership.userID
JOIN "usergroup" ON groupmembership.groupID = "usergroup".id
WHERE "user".created < "usergroup".created;
