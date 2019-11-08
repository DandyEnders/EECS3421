--
-- PostgreSQL port of the MySQL "SAMPLE" database.
--
-- The sample data used in the world database is Copyright Statistics 
-- Finland, http://www.stat.fi/worldinfigures.
--


BEGIN;

DROP SCHEMA IF EXISTS A2 CASCADE;
CREATE SCHEMA A2;
SET client_encoding = 'UTF8';
SET search_path TO A2;



-- The country table contains some countries in the world.
-- 'cid' is the id of the country.
-- 'cname' is the name of the country.
CREATE TABLE country(
    cid         INTEGER     PRIMARY KEY,
    cname       VARCHAR     NOT NULL
    );
    
-- The player table contains information about some tennis players.
-- 'pid' is the id of the player.
-- 'pname' is the name of the player.
-- 'globalrank' is the global rank of the player.
-- 'cid' is the id of the country that the player belongs to.
CREATE TABLE player(
    pid         INTEGER     PRIMARY KEY,
    pname       VARCHAR     NOT NULL,
    globalrank  INTEGER     NOT NULL,
    cid         INTEGER     REFERENCES country(cid) ON DELETE RESTRICT
    );

-- The record table contains information about players performance in each year.
-- 'pid' is the id of the player.
-- 'year' is the year.
-- 'wins' is the number of wins of the player in that year.
-- 'losses' is the the number of losses of the player in that year.
CREATE TABLE record(
    pid         INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    year        INTEGER     NOT NULL,
    wins        INTEGER     NOT NULL,
    losses      INTEGER     NOT NULL,
    PRIMARY KEY(pid, year));

-- The tournament table contains information about a tournament.
-- 'tid' is the id of the tournament.
-- 'tname' is the name of the tournament.
-- 'cid' is the country where the tournament hold.
CREATE TABLE tournament(
    tid         INTEGER     PRIMARY KEY,
    tname       VARCHAR     NOT NULL,
    cid         INTEGER     REFERENCES country(cid) ON DELETE RESTRICT 
    );

-- The court table contains the information about tennis court
-- 'courtid' is the id of the court.
-- 'courtname' is the name of the court.
-- 'capacity' is the maximum number of audience the court can hold.
-- 'tid' is the tournament that this court is used for
--  Notice: only one tournament can happen on a given court.
CREATE TABLE court(
    courtid     INTEGER     PRIMARY KEY,
    courtname   VARCHAR     NOT NULL,
    capacity    INTEGER     NOT NULL,
    tid         INTEGER     REFERENCES tournament(tid) ON DELETE RESTRICT
    );

-- The champion table provides information about the champion of each tournament.
-- 'pid' refers to the id of the champion(player).
-- 'year' is the year when the tournament hold.
-- 'tid' is the tournament id.
CREATE TABLE champion(
    pid     INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    year    INTEGER     NOT NULL, 
    tid     INTEGER     REFERENCES tournament(tid) ON DELETE RESTRICT,
    PRIMARY KEY(tid, year));

-- The event table provides information about certain tennis games.
-- 'eid' refers to the id of the event.
-- 'year' is the year when the event hold.
-- 'courtid' is the id of the court where the event hold.
-- 'pwinid' is the id of the player who win the game.
-- 'plossid' is the id of the player who loss the game.
-- 'duration' is duration of the event, in minutes.
CREATE TABLE event(
    eid        INTEGER     PRIMARY KEY,
    year       INTEGER     NOT NULL,
    courtid    INTEGER     REFERENCES court(courtid) ON DELETE RESTRICT,
    winid      INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    lossid     INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    duration   INTEGER     NOT NULL
    );


-- The following tables will be used to store the results of your queries. 
-- Each of them should be populated by your last SQL statement that looks like:
-- "INSERT INTO QueryX (SELECT ...<complete your SQL query here> ... )"

CREATE TABLE query1(
    pname    VARCHAR,
    cname    VARCHAR,
    tname    VARCHAR    
);

CREATE TABLE query2(
    tname   VARCHAR,
    totalCapacity INTEGER    
);

CREATE TABLE query3(
    p1id    INTEGER,
    p1name  VARCHAR,
    p2id    INTEGER,
    p2name  VARCHAR    
);

CREATE TABLE query4(
    pid     INTEGER,
    pname   VARCHAR    
);

CREATE TABLE query5(
    pid      INTEGER,
    pname    VARCHAR,
    avgwins  REAL
);

CREATE TABLE query6(
    pid     INTEGER,
    pname   VARCHAR    
);

CREATE TABLE query7(
    pname    VARCHAR,
    year     INTEGER
);

CREATE TABLE query8(
    p1name  VARCHAR,
    p2name  VARCHAR,
    cname   VARCHAR    
);

CREATE TABLE query9(
    cname       VARCHAR,
    champions   INTEGER
);

CREATE TABLE query10(
    pname       VARCHAR
);


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY country (cid, cname) FROM stdin;
1	Afghanistan
2	Albania
3	Algeria
4	American Samoa
5	Andorra
6	Angola
7	Anguilla
8	Antarctica
9	Antigua and Barbuda
10	Argentina
11	Armenia
12	Aruba
13	Australia
14	Austria
15	Azerbaijan
16	Bahamas
17	Bahrain
18	Bangladesh
19	Barbados
20	Belarus
21	Belgium
22	Belize
23	Benin
24	Bermuda
25	Bhutan
26	Bolivia
27	Bosnia and Herzegovina
28	Botswana
29	Bouvet Island
30	Brazil
31	British Indian Ocean Territory
32	Brunei
33	Bulgaria
34	Burkina Faso
35	Burundi
36	Cambodia
37	Cameroon
38	Canada
39	Cape Verde
40	Cayman Islands
41	Central African Republic
42	Chad
43	Chile
44	China
45	Christmas Island
46	Cocos (Keeling) Islands
47	Colombia
48	Comoros
49	Congo
50	Congo, The Democratic Republic of the
51	Cook Islands
52	Costa Rica
53	Côte d�Ivoire
54	Croatia
55	Cuba
56	Cyprus
57	Czech Republic
58	Denmark
59	Djibouti
60	Dominica
61	Dominican Republic
62	East Timor
63	Ecuador
64	Egypt
65	El Salvador
66	Equatorial Guinea
67	Eritrea
68	Estonia
69	Ethiopia
70	Falkland Islands
71	Faroe Islands
72	Fiji Islands
73	Finland
74	France
75	French Guiana
76	French Polynesia
77	French Southern territories
78	Gabon
79	Gambia
80	Georgia
81	Germany
82	Ghana
83	Gibraltar
84	Greece
85	Greenland
86	Grenada
87	Guadeloupe
88	Guam
89	Guatemala
90	Guinea
91	Guinea-Bissau
92	Guyana
93	Haiti
94	Heard Island and McDonald Islands
95	Holy See (Vatican City State)
96	Honduras
97	Hong Kong
98	Hungary
99	Iceland
100	India
101	Indonesia
102	Iran
103	Iraq
104	Ireland
105	Israel
106	Italy
107	Jamaica
108	Japan
109	Jordan
110	Kazakstan
111	Kenya
112	Kiribati
113	Kuwait
114	Kyrgyzstan
115	Laos
116	Latvia
117	Lebanon
118	Lesotho
119	Liberia
120	Libyan Arab Jamahiriya
121	Liechtenstein
122	Lithuania
123	Luxembourg
124	Macao
125	Macedonia
126	Madagascar
127	Malawi
128	Malaysia
129	Maldives
130	Mali
131	Malta
132	Marshall Islands
133	Martinique
134	Mauritania
135	Mauritius
136	Mayotte
137	Mexico
138	Micronesia, Federated States of
139	Moldova
140	Monaco
141	Mongolia
142	Montserrat
143	Morocco
144	Mozambique
145	Myanmar
146	Namibia
147	Nauru
148	Nepal
149	Netherlands
150	Netherlands Antilles
151	New Caledonia
152	New Zealand
153	Nicaragua
154	Niger
155	Nigeria
156	Niue
157	Norfolk Island
158	Northern Mariana Islands
159	North Korea
160	Norway
161	Oman
162	Pakistan
163	Palau
164	Palestine
165	Panama
166	Papua New Guinea
167	Paraguay
168	Peru
169	Philippines
170	Pitcairn
171	Poland
172	Portugal
173	Puerto Rico
174	Qatar
175	Réunion
176	Romania
177	Russian Federation
178	Rwanda
179	Saint Helena
180	Saint Kitts and Nevis
181	Saint Lucia
182	Saint Pierre and Miquelon
183	Saint Vincent and the Grenadines
184	Samoa
185	San Marino
186	Sao Tome and Principe
187	Saudi Arabia
188	Senegal
189	Seychelles
190	Sierra Leone
191	Singapore
192	Slovakia
193	Slovenia
194	Solomon Islands
195	Somalia
196	South Africa
197	South Georgia and the South Sandwich Islands
198	South Korea
199	Spain
200	Sri Lanka
201	Sudan
202	Suriname
203	Svalbard and Jan Mayen
204	Swaziland
205	Sweden
206	Switzerland
207	Syria
208	Taiwan
209	Tajikistan
210	Tanzania
211	Thailand
212	Togo
213	Tokelau
214	Tonga
215	Trinidad and Tobago
216	Tunisia
217	Turkey
218	Turkmenistan
219	Turks and Caicos Islands
220	Tuvalu
221	Uganda
222	Ukraine
223	United Arab Emirates
224	United Kingdom
225	United States
226	United States Minor Outlying Islands
227	Uruguay
228	Uzbekistan
229	Vanuatu
230	Venezuela
231	Vietnam
232	Virgin Islands, British
233	Virgin Islands, U.S.
234	Wallis and Futuna
235	Western Sahara
236	Yemen
237	Yugoslavia
238	Zambia
239	Zimbabwe
\.


--
-- Data for Name: player; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY player (pid, pname, globalrank, cid) FROM stdin;
1	John	5	1
2	Wasim	4	5
3	Orla	9	3
4	Jao	10	2
5	Jin	1	4
\.


--
-- Data for Name: record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY record (pid, year, wins, losses) FROM stdin;
2	2011	4	0
1	2012	7	2
4	2013	0	7
3	2016	4	3
5	2015	3	2
\.


--
-- Data for Name: tournament; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tournament (tid, tname, cid) FROM stdin;
1	blues	1
2	green	4
3	yellow	2
4	browns	5
\.


--
-- Data for Name: court; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY court (courtid, courtname, capacity, tid) FROM stdin;
1	court1	70	1
2	court2	60	3
3	court3	100	2
4	court4	170	4
\.


--
-- Data for Name: champion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY champion (pid, year, tid) FROM stdin;
2	2011	1
1	2012	2
3	2016	4
4	2013	3
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY event (eid, year, courtid, winid, lossid, duration) FROM stdin;
1	2010	1	1	2	60
2	2011	3	3	4	70
3	2014	2	4	5	100
4	2015	4	1	5	75
\.


COMMIT;

--BEGIN;

\i a2.sql

--COMMIT;

\i check_queries.sql