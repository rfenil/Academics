
CREATE TABLE IF NOT EXISTS Source (
    sourceID       INTEGER       PRIMARY KEY AUTOINCREMENT,
    source_name    VARCHAR (100) NOT NULL,
    source_website VARCHAR (100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Location (
    iso_code              VARCHAR (10)  PRIMARY KEY,
    location              VARCHAR (100) NOT NULL,
    last_observation_date DATE          NOT NULL,
    sourceID              INT           NOT NULL,
    FOREIGN KEY (
        sourceID
    )
    REFERENCES Source (sourceID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS State (
    stateID   INTEGER PRIMARY KEY AUTOINCREMENT,
    stateName TEXT    NOT NULL,
    UNIQUE (
        stateName
    )
);


CREATE TABLE IF NOT EXISTS Vaccine (
    vaccineID   INTEGER       PRIMARY KEY AUTOINCREMENT,
    vaccineName VARCHAR (100) NOT NULL,
    UNIQUE (
        vaccineName
    )
);


CREATE TABLE IF NOT EXISTS Vaccination_by_age_group (
    date                                 DATE         NOT NULL,
    iso_code                             VARCHAR (10) NOT NULL,
    age_group                            VARCHAR (50) NOT NULL,
    people_vaccinated_per_hundread       FLOAT        CHECK (people_vaccinated_per_hundread >= 0),
    people_fully_vaccinated_per_hundread FLOAT        CHECK (people_fully_vaccinated_per_hundread >= 0),
    people_with_booster_per_hundread     FLOAT        CHECK (people_with_booster_per_hundread >= 0),
    PRIMARY KEY (
        date,
        iso_code,
        age_group
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Us_state_vaccinations (
    date                            DATE         NOT NULL,
    stateID                         INT          NOT NULL,
    iso_code                        VARCHAR (10) NOT NULL,
    total_vaccinations              INT          CHECK (total_vaccinations >= 0),
    total_distributed               INT          CHECK (total_distributed >= 0),
    people_vaccinated               INT          CHECK (people_vaccinated >= 0),
    people_fully_vaccinated         INT          CHECK (people_fully_vaccinated >= 0),
    total_vaccinations_per_hundread FLOAT        CHECK (total_vaccinations_per_hundread >= 0),
    people_vaccinated_per_hundread  FLOAT        CHECK (people_vaccinated_per_hundread >= 0),
    distributed_per_hundread        FLOAT        CHECK (distributed_per_hundread >= 0),
    daily_vaccinations_raw          INT          CHECK (daily_vaccinations_raw >= 0),
    daily_vaccinations              INT          CHECK (daily_vaccinations >= 0),
    daily_vaccinations_per_million  FLOAT        CHECK (daily_vaccinations_per_million >= 0),
    share_doses_used                FLOAT        CHECK (share_doses_used >= 0),
    total_boosters                  INT          CHECK (total_boosters >= 0),
    total_boosters_per_hundred      FLOAT        CHECK (total_boosters_per_hundred >= 0),
    PRIMARY KEY (
        date,
        stateID,
        iso_code
    ),
    FOREIGN KEY (
        stateID
    )
    REFERENCES State (stateID) ON DELETE CASCADE,
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Vaccination_by_manufacture (
    date               DATE         NOT NULL,
    iso_code           VARCHAR (10) NOT NULL,
    vaccineID          INT          NOT NULL,
    total_vaccinations INT          CHECK (total_vaccinations >= 0),
    PRIMARY KEY (
        date,
        iso_code,
        vaccineID
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) ON DELETE CASCADE,
    FOREIGN KEY (
        vaccineID
    )
    REFERENCES Vaccine (vaccineID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Vaccinations (
    date                                 DATE         NOT NULL,
    iso_code                             VARCHAR (10) NOT NULL,
    total_vaccinations                   INT          CHECK (total_vaccinations >= 0),
    people_vaccinated                    INT          CHECK (people_vaccinated >= 0),
    people_fully_vaccinated              INT          CHECK (people_fully_vaccinated >= 0),
    total_boosters                       INT          CHECK (total_boosters >= 0),
    daily_vaccinations_raw               INT          CHECK (daily_vaccinations_raw >= 0),
    daily_vaccinations                   INT          CHECK (daily_vaccinations >= 0),
    total_vaccinations_per_hundread      FLOAT        CHECK (total_vaccinations_per_hundread >= 0),
    people_vaccinated_per_hundread       FLOAT        CHECK (people_vaccinated_per_hundread >= 0),
    people_fully_vaccinated_per_hundread FLOAT        CHECK (people_fully_vaccinated_per_hundread >= 0),
    total_boosters_per_hundread          FLOAT        CHECK (total_boosters_per_hundread >= 0),
    daily_vaccinations_per_million       FLOAT        CHECK (daily_vaccinations_per_million >= 0),
    daily_people_vaccinated              INT          CHECK (daily_people_vaccinated >= 0),
    daily_people_vaccinated_per_hundread FLOAT        CHECK (daily_people_vaccinated_per_hundread >= 0),
    PRIMARY KEY (
        date,
        iso_code
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Provided (
    vaccineID     INT          NOT NULL,
    date          DATE         NOT NULL,
    iso_code      VARCHAR (10) NOT NULL,
    Total_vaccine INT          CHECK (Total_vaccine >= 0),
    sourceID      INTEGER      REFERENCES Source (sourceID),
    PRIMARY KEY (
        vaccineID,
        date,
        iso_code
    ),
    FOREIGN KEY (
        vaccineID
    )
    REFERENCES Vaccine (vaccineID) ON DELETE CASCADE,
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Location_vaccine (
    iso_code  VARCHAR (10) NOT NULL,
    vaccineID INT          NOT NULL,
    PRIMARY KEY (
        iso_code,
        vaccineID
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) ON DELETE CASCADE,
    FOREIGN KEY (
        vaccineID
    )
    REFERENCES Vaccine (vaccineID) ON DELETE CASCADE
);


