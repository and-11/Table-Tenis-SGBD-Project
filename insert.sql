-- SALA
INSERT INTO Sala VALUES (1, 'Sala Polivalenta Bucuresti', 'Bucuresti', 5000);
INSERT INTO Sala VALUES (2, 'BT Arena', 'Cluj-Napoca', 10000);
INSERT INTO Sala VALUES (3, 'Sala Polivalenta Cluj', 'Cluj-Napoca', 3000);
INSERT INTO Sala VALUES (4, 'Sala Sporturilor', 'Brasov', 2500);
INSERT INTO Sala VALUES (5, 'Sala Olimpia', 'Ploiesti', 4000);

-- TURNEU
INSERT INTO Turneu VALUES (1, 'Campionatul National',
    TO_DATE('10-03-2025','DD-MM-YYYY'),
    TO_DATE('15-03-2025','DD-MM-YYYY'));
INSERT INTO Turneu VALUES (2, 'Cupa Romaniei',
    TO_DATE('01-04-2025','DD-MM-YYYY'),
    TO_DATE('05-04-2025','DD-MM-YYYY'));
INSERT INTO Turneu VALUES (3, 'Open Bucuresti',
    TO_DATE('20-05-2025','DD-MM-YYYY'),
    TO_DATE('25-05-2025','DD-MM-YYYY'));
INSERT INTO Turneu VALUES (4, 'European Challenge',
    TO_DATE('10-06-2025','DD-MM-YYYY'),
    TO_DATE('15-06-2025','DD-MM-YYYY'));
INSERT INTO Turneu VALUES (5, 'World Series',
    TO_DATE('01-07-2025','DD-MM-YYYY'),
    TO_DATE('06-07-2025','DD-MM-YYYY'));

-- ARBITRU
INSERT INTO Arbitru VALUES (1, 'Popescu', 'Ion', 'Romania');
INSERT INTO Arbitru VALUES (2, 'Ionescu', 'Mihai', 'Romania');
INSERT INTO Arbitru VALUES (3, 'Nikolaidis', 'Petros', 'Grecia');
INSERT INTO Arbitru VALUES (4, 'Rossi', 'Marco', 'Italia');
INSERT INTO Arbitru VALUES (5, 'Muller', 'Hans', 'Germania');

-- JUCATOR
INSERT INTO Jucator VALUES (1, 'Gabriel', 'Balaceanu-Nadal', 'Grecia');
INSERT INTO Jucator VALUES (2, 'Andrei', 'Popescu', 'Romania');
INSERT INTO Jucator VALUES (3, 'Mihai', 'Ionescu', 'Romania');
INSERT INTO Jucator VALUES (4, 'Stefan', 'Marinescu', 'Romania');
INSERT INTO Jucator VALUES (5, 'Alexandru', 'Dumitru', 'Romania');

-- ANTRENOR
INSERT INTO Antrenor VALUES (1, 'Ion', 'Georgescu', 'Romania');
INSERT INTO Antrenor VALUES (2, 'Vasile', 'Iordan', 'Romania');
INSERT INTO Antrenor VALUES (3, 'Petros', 'Nikolaidis', 'Grecia');
INSERT INTO Antrenor VALUES (4, 'Marco', 'Rossi', 'Italia');
INSERT INTO Antrenor VALUES (5, 'Hans', 'Muller', 'Germania');

-- SPONSOR
INSERT INTO Sponsor VALUES (101, 'Nike');
INSERT INTO Sponsor VALUES (102, 'Adidas');
INSERT INTO Sponsor VALUES (103, 'Butterfly');
INSERT INTO Sponsor VALUES (104, 'Stiga');
INSERT INTO Sponsor VALUES (105, 'Joola');
INSERT INTO Sponsor VALUES (106, 'Tibhar');
INSERT INTO Sponsor VALUES (107, 'aBiBas');

-- PALETA
INSERT INTO Paleta VALUES (1, 1, 'Carbon', 'Tenergy 05', 'Tenergy 05 FX');
INSERT INTO Paleta VALUES (2, 2, 'Allround', 'Mark V', 'Mark V');
INSERT INTO Paleta VALUES (3, 3, 'Offensive', 'Dignics 09C', 'Dignics 05');
INSERT INTO Paleta VALUES (4, 4, 'Defensive', 'Feint Long II', 'Sriver');
INSERT INTO Paleta VALUES (5, 5, 'Carbon', 'Tenergy 64', 'Tenergy 80');

-- MECI
INSERT INTO Meci VALUES (1, 1, 2, 1, 1, 1, TO_DATE('11-03-2025','DD-MM-YYYY'));
INSERT INTO Meci VALUES (2, 3, 4, 1, 2, 1, TO_DATE('12-03-2025','DD-MM-YYYY'));
INSERT INTO Meci VALUES (3, 2, 3, 2, 3, 2, TO_DATE('02-04-2025','DD-MM-YYYY'));
INSERT INTO Meci VALUES (4, 4, 5, 3, 4, 3, TO_DATE('22-05-2025','DD-MM-YYYY'));
INSERT INTO Meci VALUES (5, 1, 5, 4, 5, 4, TO_DATE('12-06-2025','DD-MM-YYYY'));

-- CONTRACT_ANTRENOR
INSERT INTO Contract_antrenor VALUES (1, 1, SYSDATE-300, SYSDATE-200);
INSERT INTO Contract_antrenor VALUES (1, 2, SYSDATE-250, SYSDATE-150);
INSERT INTO Contract_antrenor VALUES (2, 2, SYSDATE-200, SYSDATE-100);
INSERT INTO Contract_antrenor VALUES (2, 3, SYSDATE-220, SYSDATE-120);
INSERT INTO Contract_antrenor VALUES (3, 3, SYSDATE-210, SYSDATE-110);
INSERT INTO Contract_antrenor VALUES (3, 4, SYSDATE-180, SYSDATE-80);
INSERT INTO Contract_antrenor VALUES (4, 4, SYSDATE-160, SYSDATE-60);
INSERT INTO Contract_antrenor VALUES (4, 5, SYSDATE-140, SYSDATE-40);
INSERT INTO Contract_antrenor VALUES (5, 1, SYSDATE-130, SYSDATE-30);
INSERT INTO Contract_antrenor VALUES (5, 5, SYSDATE-120, SYSDATE-20);

-- CONTRACT_SPONSORIZARE
INSERT INTO Contract_sponsorizare VALUES (1, 101, 10000);
INSERT INTO Contract_sponsorizare VALUES (1, 102, 8000);
INSERT INTO Contract_sponsorizare VALUES (1, 103, 9000);
INSERT INTO Contract_sponsorizare VALUES (1, 104, 7000);
INSERT INTO Contract_sponsorizare VALUES (1, 105, 6000);
INSERT INTO Contract_sponsorizare VALUES (2, 101, 5000);
INSERT INTO Contract_sponsorizare VALUES (2, 102, 5500);
INSERT INTO Contract_sponsorizare VALUES (3, 103, 6000);
INSERT INTO Contract_sponsorizare VALUES (4, 104, 6500);
INSERT INTO Contract_sponsorizare VALUES (5, 105, 7000);
