SET search_path TO A2;
-- Add below your SQL statements. 
-- For each of the queries below, your final statement should populate the respective answer table (queryX) with the correct tuples. It should look something like:
-- INSERT INTO queryX (SELECT … <complete your SQL query here> …)
-- where X is the correct index [1, …,10].
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables query1, query2, ...
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.
-- Good Luck!

--Query 1 statements CHECKED

INSERT INTO query1
    SELECT pname, cname, tname 
    FROM champion, tournament, country, player
    WHERE champion.tid = tournament.tid 
        AND tournament.cid = country.cid 
        AND country.cid = player.cid 
        AND champion.pid = player.pid
    ORDER BY pname ASC
;



--Query 2 statements CHECKED

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



--Query 3 statements CHECKED

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
    SELECT DISTINCT
        E.pid AS p1id,
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




--Query 4 statements CHECKED

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



--Query 5 statements CHECKED


INSERT INTO query5 
    SELECT
        P.pid AS pid,
        P.pname AS pname,
        AVG(wins) AS avgwins
    FROM player P
        JOIN record R ON P.pid = R.pid 
    WHERE R.year >= 2011 AND R.year <= 2014
    GROUP BY P.pid, P.pname
    HAVING AVG(wins) < MAX(wins)
    ORDER BY avgwins DESC;




--Query 6 statements CHECKED

CREATE VIEW increasingwins AS 
    SELECT R1.pid
    FROM record R1
        JOIN record R2 ON R1.pid = R2.pid
    WHERE 
        R1.year < R2.year AND
        R1.wins < R2.wins AND
        R1.year BETWEEN 2011 AND 2014 AND
        R2.year BETWEEN 2011 AND 2014
    GROUP BY R1.pid
    HAVING COUNT(R1.pid) = 6; -- 3 + 2 + 1

INSERT INTO query6 
    SELECT P.pid, P.pname
    FROM increasingwins W
        JOIN player P ON W.pid = P.pid
    ORDER BY P.pname;

DROP VIEW IF EXISTS increasingwins CASCADE; 
                



--Query 7 statements CHECKED


INSERT INTO query7
    SELECT
        P.pname AS pname,
        C.year AS year
    FROM player P 
        JOIN champion C ON P.pid = C.pid
    GROUP BY pname, year
    HAVING COUNT(year) >= 2
    ORDER BY pname DESC, year DESC;



--Query 8 statements CHECKED


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
    SELECT DISTINCT
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




--Query 9 statements CHECKED

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



--Query 10 statements CHECKED


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
    GROUP BY P.pname, R.year 
    HAVING 
        AVG(E.duration) > 200 AND
        R.year = 2014
    ORDER BY pname;


DROP VIEW IF EXISTS winnerEvents CASCADE;
DROP VIEW IF EXISTS loserEvents CASCADE;
DROP VIEW IF EXISTS p1p2Events CASCADE;

