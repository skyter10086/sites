
ATTACH DATABASE 'A03.db' as 'A03';

CREATE TABLE A03.Zjmx (
	id     INTEGER         PRIMARY KEY AUTOINCREMENT,
    zjq      DATE  NOT NULL,
    dwbm     CHAR(4) NOT NULL,
    dyyzrs   INT NOT NULL,
    dwjs     DECIMAL(12,2),
    grjs     DECIMAL(10,2),
    dwdy     DECIMAL(12,2),
    grdy     DECIMAL(10,2),
    dwbz     DECIMAL(12,2),
    grbz     DECIMAL(10,2),
    dwsz     DECIMAL(12,2),
    grsz     DECIMAL(10,2),
    dzsj     DATE   

);

CREATE TABLE A03.Bjmx (

    jflx     CHAR(10) NOT NULL,
    scbh     CHAR(12)         ,
    xm       CHAR(40)         ,
    dwbm     CHAR(5)  ,
    dwmc     CHAR(40)         ,
    zjq      DATE     NOT NULL,
    sj1      DATE             ,
    sj2      DATE             ,
    jfgzjs   DECIMAL(12,2),
    dwjn     DECIMAL(12,2),
    grjn     DECIMAL(10,2)

);

CREATE TABLE A03.Zgxx (

    scbh     CHAR(12) NOT NULL,
    sfzh     CHAR(19) ,
    xm       CHAR(40) NOT NULL,
    xb       CHAR(2)  ,
    mz       CHAR(20) ,
    csny     DATE     ,
    gzsj     DATE     ,
    dwbm     CHAR(5)  ,
    dwmc     CHAR(40) ,
    jfgzjs   DECIMAL(10,2)    ,
    grjn     DECIMAL(10,2)    ,
    dwhz     DECIMAL(10,2)    ,
    zzsj     DATE             ,
    zzflbz   CHAR(3)      ,
    zzyy     CHAR(40) ,
    aac001   CHAR(16)         ,
    aab001   CHAR(16)         ,

    PRIMARY KEY    (scbh ASC) 
    
);

CREATE TABLE A03.Zgbd (

    scbh     CHAR(12) NOT NULL,
    xm       CHAR(40) NOT NULL,
    dwbm     CHAR(5)  NOT NULL,
    bdsj     DATE     NOT NULL,
    ydwbm    CHAR(5)  NOT NULL,
    tsfl     CHAR(3)          ,
    jfgzjs   DECIMAL(10,2)    

);

CREATE TABLE A03.Jfmx (

    zjq      DATE     NOT NULL,
    scbh     CHAR(12) NOT NULL,
    xm       CHAR(40) NOT NULL,
    dwbm     CHAR(5)  NOT NULL,
    jfgzjs   DECIMAL(10,2)    ,
    grjn     DECIMAL(10,2)    ,
    dwhz     DECIMAL(10,2)    ,
    bzys     INT              ,
    dzbz     BOOLEAN          ,
    dzsj     DATE             
    
);

CREATE TABLE A03.Jfbl (

    sj1      DATE         NOT NULL,
    sj2      DATE         NOT NULL,
    dwbms    VARCHAR(255) NOT NULL,
    dwbl     DECIMAL(5,4) NOT NULL,
    grbl     DECIMAL(5,4) NOT NULL

);
