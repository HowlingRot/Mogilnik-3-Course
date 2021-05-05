--Михайлов Илья 31гр
--Лабораторная №2
--Создание таблиц

DROP TABLE OWNER;
DROP TABLE BRANCH;
DROP TABLE BUYER;
DROP TABLE STAFF;
DROP TABLE VIEWING;
DROP TABLE CONTRACT;
USE DreamHome

-- TASK 1
CREATE TABLE OWNER (
    Owner_no member_no   NOT NULL IDENTITY(1,1),
    FName    shortstring NOT NULL,
    LName    shortstring NOT NULL,
    City     shortstring NOT NULL,
    Street   shortstring NOT NULL,
    House    nchar(6)    NOT NULL,
    Flat     smallint        NULL,
    Otel_no  Phonenumber     NULL
    )

-- TASK 2

CREATE TABLE BRANCH (
    Branch_no member_no  NOT NULL PRIMARY KEY,
    Postcode  postcode       NULL,
    City     shortstring NOT NULL,
    Street   shortstring NOT NULL,
    House    nchar(10)   NOT NULL,
    Btel_no  Phonenumber NOT NULL,
    Fax_no   Phonenumber     NULL
    )

-- TASK 3

CREATE TABLE BUYER(
    Buyer_no   member_no   NOT NULL PRIMARY KEY,
    FName      shortstring NOT NULL,
    LName      shortstring NOT NULL,
    City       shortstring NOT NULL,
    Street     shortstring NOT NULL,
    House      nchar(6)    NOT NULL,
    Flat       smallint        NULL,
    Htel_no    Phonenumber     NULL,
    Wtel_no    Phonenumber     NULL,
    Prof_Rooms tinyint     NOT NULL,
    Max_Price  money       NOT NULL,
    Branch_no  member_no   NOT NULL,
    
    CONSTRAINT FK_BUYER_BRANCH FOREIGN KEY(Branch_no) REFERENCES BRANCH ON UPDATE CASCADE,
    CHECK (Htel_no IS NOT NULL OR Wtel_no IS NOT NULL) 
)

-- TASK 4

ALTER TABLE OWNER
ADD CONSTRAINT PK_Owner PRIMARY KEY NONCLUSTERED(Owner_no)

-- TASK 5
ALTER TABLE BRANCH
ADD CONSTRAINT BRANCH_CONSTRAINT
CHECK (Btel_no like '8(021[2-6][0-9])[0-9][0-9]-[0-9][0-9]-[0-9][0-9]')


-- LAST TASKS

CREATE TABLE STAFF (
    Staff_no     shortstring    NOT NULL PRIMARY KEY,
    FName        shortstring    NOT NULL,
    LName        shortstring    NOT NULL,
    DOB          nchar(8)       NOT NULL ,
    Sex          shortstring    NOT NULL CHECK (Sex = 'М' or Sex = 'Ж'),
    City         shortstring    NOT NULL,
    Street       shortstring    NOT NULL,
    House        nchar(6)       NOT NULL,
    Flat         smallint       NULL,
    Stel_no      Phonenumber    NULL,
    Date_Joined  nchar(10)       NOT NULL,
    Position     shortstring    NOT NULL,
    Salary       money          NOT NULL,
    Branch_no    member_no      NOT NULL,
)

CREATE INDEX FName_INDEX    ON STAFF (FName)
CREATE INDEX Position_INDEX ON STAFF (Position)

CREATE TABLE PROPERTY  (
    Property_no         int   NOT NULL PRIMARY KEY,
    Data_registration   nchar(8)    NOT NULL,
    Postcode            postcode    NOT NULL,
    City                shortstring NOT NULL,
    Street              shortstring NOT NULL,
    House               nchar(6)    NOT NULL,
    Flat                smallint        NULL,
    Floor_Type          nchar(6)    NOT NULL,
    Floor               smallint    NOT NULL,
    Rooms               smallint    NOT NULL,
    The_area            shortstring NOT NULL,
    Balcony             shortstring NOT NULL,
    Ptel                shortstring NOT NULL DEFAULT 'Т',
    Selling_Price       money       NOT NULL,
    Branch_no           member_no   NOT NULL,
    Staff_no            shortstring     NULL,
    Owner_no            member_no   NOT NULL,
    
    CONSTRAINT PROPERTY_Staff  FOREIGN KEY(Staff_no)  REFERENCES STAFF  ON UPDATE  CASCADE,
)


CREATE TABLE VIEWING (
    Date_View   shortstring   NOT NULL,
    Comments    shortstring   NOT NULL,
    Property_no int   NOT NULL FOREIGN KEY REFERENCES PROPERTY  ON UPDATE CASCADE,
    Buyer_no    member_no   NOT NULL FOREIGN KEY REFERENCES BUYER  ON UPDATE CASCADE,
    CONSTRAINT STAFF_BRANCH PRIMARY KEY(Property_no, Buyer_no)
)
CREATE INDEX Date_View_INDEX ON VIEWING (Date_View)


CREATE TABLE CONTRACT (
    Sale_no       member_no     NOT NULL PRIMARY KEY,
    Notary_Office shortstring   NOT NULL,
    Date_Contract smalldatetime NOT NULL,
    Service_Cost  money         NOT NULL,
    Property_no   int     NOT NULL,
    Buyer_no      member_no     NOT NULL,
    CONSTRAINT CONTRACT_PROPERTY FOREIGN KEY(Property_no) REFERENCES PROPERTY ON UPDATE  CASCADE,
    CONSTRAINT CONTRACT_BUYER    FOREIGN KEY(Buyer_no)    REFERENCES BUYER    ON UPDATE  CASCADE,
)
