﻿SET search_path TO A2;
-- Add below your SQL statements. 
-- For each of the queries below, your final statement should populate the respective answer table (queryX) with the correct tuples. It should look something like:
-- INSERT INTO queryX (SELECT … <complete your SQL query here> …)
-- where X is the correct index [1, …,10].
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables query1, query2, ...
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.
-- Good Luck!

--Query 1 statements
INSERT INTO query1 (
	SELECT pname, cname, tname FROM champion, tournament, country, player
	WHERE champion.tid = tournament.tid AND tournament.cid = country.cid AND country.cid = player.cid AND champion.pid = player.pid
	ORDER BY pname ASC
);

--Query 2 statements
INSERT INTO query2 (
	CREATE VIEW sumCaps AS 
		SELECT tname, sum(capacity) AS sumCapacity
		FROM tournament, court
		WHERE tournament.tid = court.tid
		GROUP By tname
		ORDER BY tname ASC;

	SELECT tname, max(sumCapacity) AS totalCapacity
	FROM sumCaps;

	DROP VIEW IF EXISTS sumCaps;
)
--Query 3 statements
INSERT INTO query3 (
	CREATE VIEW winnerEvents AS
		-- blah
		
	CREATE VIEW loserEvents AS
		-- blah
	
	CREATE VIEW p1p2Events AS
		-- blah
		
	SELECT -- blah
	
	
	DROP VIEW IF EXISTS winnerEvents;
	DROP VIEW IF EXISTS loserEvents;
	DROP VIEW IF EXISTS p1p2Events;
)

--Query 4 statements
INSERT INTO query4

--Query 5 statements
INSERT INTO query5

--Query 6 statements
INSERT INTO query6

--Query 7 statements
INSERT INTO query7

--Query 8 statements
INSERT INTO query8

--Query 9 statements
INSERT INTO query9

--Query 10 statements
INSERT INTO query10

