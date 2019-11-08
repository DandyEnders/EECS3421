--
-- PostgreSQL port of the MySQL "SAMPLE" database.
--
-- The sample data used in the world database is Copyright Statistics 
-- Finland, http://www.stat.fi/worldinfigures.
--


BEGIN;

DROP SCHEMA IF EXISTS sample CASCADE;
CREATE SCHEMA sample;
SET search_path TO sample;

SET client_encoding = 'LATIN1';

CREATE TABLE country (
    cid       INTEGER       PRIMARY KEY,
    cname     VARCHAR       NOT NULL
);

CREATE TABLE player (
    pid         INTEGER     PRIMARY KEY,
    pname       VARCHAR     NOT NULL,
    globalrank  INTEGER     NOT NULL,
    cid         INTEGER     REFERENCES country(cid) ON DELETE RESTRICT
);

CREATE TABLE record (
    pid         INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    year        INTEGER     NOT NULL,
    wins        INTEGER     NOT NULL,
    losses      INTEGER     NOT NULL,
    PRIMARY KEY(pid, year)
);

CREATE TABLE tournament(
    tid         INTEGER     PRIMARY KEY,
    tname       VARCHAR     NOT NULL,
    cid         INTEGER     REFERENCES country(cid) ON DELETE RESTRICT 
    );
    
    CREATE TABLE court(
    courtid     INTEGER     PRIMARY KEY,
    courtname   VARCHAR     NOT NULL,
    capacity    INTEGER     NOT NULL,
    tid         INTEGER     REFERENCES tournament(tid) ON DELETE RESTRICT
    );
    
    CREATE TABLE champion(
    pid     INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    year    INTEGER     NOT NULL, 
    tid     INTEGER     REFERENCES tournament(tid) ON DELETE RESTRICT,
    PRIMARY KEY(tid, year)
    );
    
    CREATE TABLE event(
    eid        INTEGER     PRIMARY KEY,
    year       INTEGER     NOT NULL,
    courtid    INTEGER     REFERENCES court(courtid) ON DELETE RESTRICT,
    winid      INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    lossid     INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    duration   INTEGER     NOT NULL
    );

--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY country (cid, cname) FROM stdin;
2322  Canada
2200  United states
4300  Afghanistan
2100  Iran
1000  Pakistan

--
-- Data for Name: player; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY player (pid, pname, globalrank, cid) FROM stdin;

1  John 5 2322
2  Wasim 4 1000
3  Orla	9 4300
4  Jao	10 2200
5  Jin	1 2100




--
-- Data for Name: record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY record (pid, year, wins, losses) FROM stdin;
2 2011 4 0
1 2012 7 2
4 2013 0 7
3 2016 4 3
5 2015 3 2



--
-- Data for Name: tournament; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tournament (tid, tname, cid) FROM stdin;
t1 blues 2322
t2 green 2100
t3 yellow 2200
t4 browns 1000


--
-- Data for Name: court; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY court (courtid, courtname, capacity, tid) FROM stdin;
c1 court1 70 t1
c2 court2 60 t3
c3 court3 100 t2
c4 court4 170 t4



--
-- Data for Name: champion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY champion (pid, year, tid) FROM stdin;
2 2011 t1
1 2012 t2
3 2016 t4
4 2013 t3



--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY event (eid, year, courtid, winid, lossid, duration) FROM stdin;
e1 2010 c1 1 2 60
e2 2011 c3 3 4 70
e3 2014 c2 4 5 100
e4 2015 c4 1 5 75

COMMIT;
