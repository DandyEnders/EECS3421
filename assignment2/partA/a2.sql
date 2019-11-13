SET search_path TO A2;
-- Add below your SQL statements. 
-- For each of the queries below, your final statement should populate the respective answer table (queryX) with the correct tuples. It should look something like:
-- INSERT INTO queryX (SELECT … <complete your SQL query here> …)
-- where X is the correct index [1, …,10].
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables query1, query2, ...
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.
-- Good Luck!

--Query 1 statements CHECKED
BEGIN; --------------------------------------------------
INSERT INTO query1
    SELECT pname, cname, tname 
    FROM champion, tournament, country, player
    WHERE champion.tid = tournament.tid 
        AND tournament.cid = country.cid 
        AND country.cid = player.cid 
        AND champion.pid = player.pid
    ORDER BY pname ASC
;
COMMIT; -------------------------------------------------


--Query 2 statements CHECKED
BEGIN; --------------------------------------------------
CREATE VIEW sumCaps AS 
    SELECT tname, sum(court.capacity) AS sumCapacity
    FROM tournament, court
    WHERE tournament.tid = court.tid
    GROUP By tname;

INSERT INTO query2
    SELECT tname, sumCapacity AS totalCapacity
    FROM sumCaps
    WHERE sumCapacity >= ALL(SELECT sumCapacity FROM sumCaps)
    ORDER BY tname ASC;

DROP VIEW IF EXISTS sumCaps CASCADE;
COMMIT; -------------------------------------------------


--Query 3 statements UNCHECKED
BEGIN; --------------------------------------------------
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
    FROM (SELECT * FROM winnerEvents
            UNION 
            SELECT * FROM loserEvents) AS E; 

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

CREATE VIEW p1GlobalRank AS
    SELECT pid, MAX(Oglobalrank) AS maxGR
    FROM p1p2EventPlayer
    GROUP BY pid;

INSERT INTO query3
    SELECT 	E.pid AS p1id,
            E.pname AS p1name,
            E.Opid AS p2id,
            E.Opname AS p2name  
    FROM p1p2EventPlayer E 
        JOIN p1GlobalRank GR ON E.pid = GR.pid
    WHERE E.Oglobalrank = GR.maxGR
    ORDER BY p1name ASC;

DROP VIEW IF EXISTS winnerEvents CASCADE;
DROP VIEW IF EXISTS loserEvents CASCADE;
DROP VIEW IF EXISTS p1p2Events CASCADE;
DROP VIEW IF EXISTS opponentPlayer CASCADE;
DROP VIEW IF EXISTS p1p2EventPlayer CASCADE;
DROP VIEW IF EXISTS p1GlobalRank CASCADE;

COMMIT; -------------------------------------------------


--Query 4 statements UNCHECKED
BEGIN; --------------------------------------------------
CREATE VIEW champTournamentPlayer AS
    SELECT C.pid, P.pname, C.tid
    FROM champion C
        JOIN tournament T ON C.tid = T.tid
        JOIN player P ON C.pid = P.pid;

CREATE VIEW playerParticipation AS
    SELECT pid, pname, COUNT(tid) AS tcount
    FROM champTournamentPlayer T
    GROUP BY pid, pname;

INSERT INTO query4
    SELECT pid, pname
    FROM playerParticipation
    WHERE tcount = (SELECT COUNT(*) FROM tournament)
    ORDER BY pname ASC;

DROP VIEW IF EXISTS champTournamentPlayer CASCADE;
DROP VIEW IF EXISTS playerParticipation CASCADE;
COMMIT; -------------------------------------------------


--Query 5 statements UNCHECKED
BEGIN; --------------------------------------------------
INSERT INTO query5 
    SELECT MAX(avgwins) 
    FROM (  SELECT P.pid, P.pname, AVG(wins) AS avgwins
            FROM record R, player P
            WHERE R.pid = P.pid 
                    AND year BETWEEN 2011 AND 2014 
            GROUP BY P.pid, P.pname
            ORDER BY avgwins DESC
            LIMIT 10
            ) AS A;
COMMIT; -------------------------------------------------


--Query 6 statements UNCHECKED
BEGIN; --------------------------------------------------
CREATE VIEW playerswithdecreasingwins AS 
    SELECT P.pid
    FROM record r1, record r2, player P
    WHERE r1.pid = r2.pid 
        AND r1.year < r2.year 
        AND r1.wins >= r2.wins  
        AND r1.year BETWEEN 2011 AND 2014
        AND r2.year BETWEEN 2011 AND 2014;
    
CREATE VIEW increasingwins AS
    (SELECT pid
    FROM player)
    EXCEPT
    (SELECT pid FROM playerswithdecreasingwins);

INSERT INTO query6 
    SELECT P.pid, P.pname
    FROM increasingwins, player P
    WHERE increasingwins.pid = P.pid
    ORDER BY P.pname;

DROP VIEW IF EXISTS playerswithdecreasingwins CASCADE;
DROP VIEW IF EXISTS increasingwins CASCADE; 
                
COMMIT; -------------------------------------------------


--Query 7 statements UNCHECKED
BEGIN; --------------------------------------------------
--INSERT INTO query7
COMMIT; -------------------------------------------------


--Query 8 statements UNCHECKED
BEGIN; --------------------------------------------------

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
    FROM ((SELECT * FROM winnerEvents)
            UNION 
            (SELECT * FROM loserEvents)) AS E; 

CREATE VIEW playerCountry AS
    SELECT P.pid, P.pname, C.cname
    FROM player P
        JOIN country C ON P.cid = C.cid;

INSERT INTO query8 
    SELECT 
        PlayerC.pname AS p1name, 
        OpponentC.pname AS p2name,
        PlayerC.cname as cname
    FROM p1p2Events E
        JOIN playerCountry PlayerC ON E.playerid = PlayerC.pid
        JOIN playerCountry OpponentC ON  E.opponentid = OpponentC.pid
    WHERE PlayerC.cname = OpponentC.cname 
    ORDER BY cname ASC, p1name DESC;

DROP VIEW IF EXISTS winnerEvents CASCADE;
DROP VIEW IF EXISTS loserEvents CASCADE;
DROP VIEW IF EXISTS p1p2Events CASCADE;
DROP VIEW IF EXISTS playerCountry CASCADE;

COMMIT; -------------------------------------------------


--Query 9 statements CHECKED
BEGIN; --------------------------------------------------
CREATE VIEW countryChampions AS
    SELECT 
        C.cname AS cname,
        COUNT(CH.tid) as champions
    FROM country C
        JOIN player P ON C.cid = P.cid
        JOIN champion CH ON P.pid = CH.pid 
    GROUP BY C.cname;

INSERT INTO query9
    SELECT
        C.cname AS cname,
        c.champions AS champions
    FROM countryChampions C
    WHERE C.champions >= ALL(SELECT champions FROM countryChampions)
    ORDER BY cname DESC;

DROP VIEW IF EXISTS countryChampions CASCADE;
COMMIT; -------------------------------------------------


--Query 10 statements UNCHECKED
BEGIN; --------------------------------------------------

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
    FROM ((SELECT * FROM winnerEvents)
            UNION 
            (SELECT * FROM loserEvents)) AS E;

INSERT INTO query10
    SELECT
        P.pname AS pname
    FROM player P
        JOIN record R ON P.pid = R.pid
        JOIN p1p2Events E ON P.pid = E.playerid
    WHERE R.wins > R.losses
    GROUP BY P.pname, E.year 
    HAVING 
        AVG(E.duration) > 200 AND
        E.year = 2014
    ORDER BY pname;


DROP VIEW IF EXISTS winnerEvents CASCADE;
DROP VIEW IF EXISTS loserEvents CASCADE;
DROP VIEW IF EXISTS p1p2Events CASCADE;
COMMIT; -------------------------------------------------
