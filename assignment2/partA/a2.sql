SET search_path TO A2;
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
	-- eid, year, courtid, playerid, opponentid, duration
	CREATE VIEW winnerEvents AS
		SELECT 	eid, 
				year, 
				courtid, 
				winid AS playerid, 
				lossid AS opponentid,
				duration
		FROM event;

	-- eid, year, courtid, playerid, opponentid, duration
	CREATE VIEW loserEvents AS
		SELECT 	eid, 
				year, 
				courtid, 
				lossid AS playerid, 
				winid AS opponentid,
				duration
		FROM event;

	-- eid, year, courtid, playerid, opponentid, duration
	CREATE VIEW p1p2Events AS
		SELECT *
		FROM (SELECT * FROM winnerEvents)
			 UNION 
			 (SELECT * FROM loserEvents) AS E; 

	-- Opid, Opname, Oglobalrank, Ocid
	CREATE VIEW opponentPlayer AS
		SELECT 	pid AS Opid,
				pname AS Opname,
				globalrank AS Oglobalrank,
				cid AS Ocid
		FROM player;
	
	-- eid, year, courtid, playerid, opponentid, duration
	CREATE VIEW p1p2EventPlayer AS
		SELECT *
		FROM p1p2Events E 
			JOIN player P ON E.playerid = P.pid
			JOIN opponentPlayer OP ON E.opponentid = OP.Opid;
	
	-- p1id, p1name, p2id, p2name
	SELECT 	E.pid AS p1id,
			E.pname AS p1name,
			E.Opid AS p2id,
			E.Opname AS p2name  
	FROM p1p2EventPlayer E
	GROUP BY E.pid, MAX(E.Oglobalrank)
	ORDER BY p1name ASC;
	
	c winnerEvents;
	DROP VIEW IF EXISTS loserEvents;
	DROP VIEW IF EXISTS p1p2Events;
	DROP VIEW IF EXISTS opponentPlayer;
	DROP VIEW IF EXISTS p1p2EventPlayer;
);

)

--Query 4 statements
INSERT INTO query4 (
	CREATE VIEW champTournamentPlayer AS
		SELECT C.pid AS pid
			   T.tid AS tid
		FROM champion C
			JOIN tournament T ON C.tid = T.tid
			JOIN player P ON C.pid = P.pid;
	
	CREATE VIEW playerParticipation AS
		SELECT pid, COUNT(tid) AS tcount
		FROM champTournamentPlayer T
		GROUP BY pid
	
	SELECT pid, pname
	FROM playerPartification
	WHERE tcount = (SELECT COUNT(*) 
					FROM tournament) AS C
	ORDER BY pname ASC;
	
	DROP VIEW IF EXISTS champTournamentPlayer;
	DROP VIEW IF EXISTS playerParticipation;
);

--Query 5 statements
INSERT INTO query5 Select MAX(avgwins) FROM((Select pid, pname, AVG(wins) AS avgwins
                    FROM record, player
                    WHERE record.pid = player.pid AND year BETWEEN 2011 AND 2014 
                    LIMIT 10
                    ORDER BY avgwins DESC));

--Query 6 statements
INSERT INTO query6 (CREATE VIEW playerswithdecreasingwins AS 
                   SELECT pid
                   FROM record AS r1, record AS r2 player
                   WHERE r1.pid = r2.pid AND r1.year < r2.year AND r1.wins >= r2.wins  AND year BETWEEN 2011 AND 2014;
                   
                   CREATE VIEW increasingwins AS
                   (SELECT pid
                   FROM player)
                   EXCEPT
                   (SELECT pid FROM playerswithdecreasingwins);
                   
                   SELECT pid, pname
                   FROM increasingwins, player
                   WHERE increasingwins.pid = player.pid
                   ORDER BY pname;
                   
                   DROP VIEW IF EXISTS playerswithdecreasingwins;
                   DROP VIEW IF EXISTS increasingwins; 
                   
                   );
                   


--Query 7 statements
INSERT INTO query7

--Query 8 statements
INSERT INTO query8 (
	CREATE VIEW winnerEvents AS
		SELECT 	eid, 
				year, 
				courtid, 
				winid AS playerid, 
				lossid AS opponentid,
				duration
		FROM event;

	-- eid, year, courtid, playerid, opponentid, duration
	CREATE VIEW loserEvents AS
		SELECT 	eid, 
				year, 
				courtid, 
				lossid AS playerid, 
				winid AS opponentid,
				duration
		FROM event;

	-- eid, year, courtid, playerid, opponentid, duration
	CREATE VIEW p1p2Events AS
		SELECT *
		FROM (SELECT * FROM winnerEvents)
			 UNION 
			 (SELECT * FROM loserEvents) AS E; 
	
		DROP VIEW IF EXISTS winnerEvents;
		DROP VIEW IF EXISTS loserEvents;
		DROP VIEW IF EXISTS p1p2Events;
);

--Query 9 statements
INSERT INTO query9

--Query 10 statements
INSERT INTO query10

