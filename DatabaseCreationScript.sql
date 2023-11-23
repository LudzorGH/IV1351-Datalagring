CREATE TABLE allowed_rentals (
 allowed_rentals_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument_lease_amount INT
);

ALTER TABLE allowed_rentals ADD CONSTRAINT PK_allowed_rentals PRIMARY KEY (allowed_rentals_id);


CREATE TABLE brand (
 brand_name VARCHAR(50) NOT NULL,
 brand_description VARCHAR(1000)
);

ALTER TABLE brand ADD CONSTRAINT PK_brand PRIMARY KEY (brand_name);


CREATE TABLE contact_details (
 contact_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 phone_number VARCHAR(50),
 email VARCHAR(100)
);

ALTER TABLE contact_details ADD CONSTRAINT PK_contact_details PRIMARY KEY (contact_id);


CREATE TABLE contact_person (
 contact_person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 contact_id INT NOT NULL
);

ALTER TABLE contact_person ADD CONSTRAINT PK_contact_person PRIMARY KEY (contact_person_id);


CREATE TABLE instrument_price_scheme (
 instrument_price_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL
);

ALTER TABLE instrument_price_scheme ADD CONSTRAINT PK_instrument_price_scheme PRIMARY KEY (instrument_price_scheme_id);


CREATE TABLE personal_details (
 person_number VARCHAR(12) NOT NULL,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 address VARCHAR(100),
 contact_id INT
);

ALTER TABLE personal_details ADD CONSTRAINT PK_personal_details PRIMARY KEY (person_number);


CREATE TABLE pricing_scheme (
 price_class_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 price_class INT NOT NULL,
 price INT NOT NULL,
 instructor_payment INT NOT NULL,
 discount INT NOT NULL
);

ALTER TABLE pricing_scheme ADD CONSTRAINT PK_pricing_scheme PRIMARY KEY (price_class_id);


CREATE TABLE student (
 student_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_number VARCHAR(12) NOT NULL,
 contact_person_id INT,
 allowed_rentals_id INT NOT NULL
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (student_id);


CREATE TABLE instructor (
 instructor_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 can_teach_ensembles BOOLEAN,
 person_number VARCHAR(12) NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (instructor_id);


CREATE TABLE instrument_for_lease (
 instrument_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 brand_name VARCHAR(50) NOT NULL,
 instrument VARCHAR(50),
 instrument_price_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL
);

ALTER TABLE instrument_for_lease ADD CONSTRAINT PK_instrument_for_lease PRIMARY KEY (instrument_id);


CREATE TABLE instrument_taught (
 instructor_id INT NOT NULL,
 instrument_name VARCHAR(50) NOT NULL
);

ALTER TABLE instrument_taught ADD CONSTRAINT PK_instrument_taught PRIMARY KEY (instructor_id,instrument_name);


CREATE TABLE lease (
 lease_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 student_id INT NOT NULL,
 instrument_id INT NOT NULL,
 lease_start_date DATE NOT NULL,
 lease_end_date DATE NOT NULL,
 is_active BOOLEAN
);

ALTER TABLE lease ADD CONSTRAINT PK_lease PRIMARY KEY (lease_id);


CREATE TABLE sibling (
 sibling_student_id INT NOT NULL,
 student_id INT NOT NULL
);

ALTER TABLE sibling ADD CONSTRAINT PK_sibling PRIMARY KEY (sibling_student_id,student_id);


CREATE TABLE timeslot (
 timeslot_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instructor_id INT NOT NULL,
 date DATE,
 start_time INT,
 end_time INT
);

ALTER TABLE timeslot ADD CONSTRAINT PK_timeslot PRIMARY KEY (timeslot_id);


CREATE TABLE individual_lesson (
 lesson_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 skill_level VARCHAR(50),
 timeslot_id INT,
 price_class_id INT GENERATED ALWAYS AS IDENTITY
);

ALTER TABLE individual_lesson ADD CONSTRAINT PK_individual_lesson PRIMARY KEY (lesson_id);


CREATE TABLE group_lesson (
 lesson_id INT NOT NULL,
 students_attending INT,
 min_students INT,
 max_studens INT
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (lesson_id);


CREATE TABLE booking (
 student_id INT NOT NULL,
 lesson_id INT NOT NULL,
 eligible_for_discount BOOLEAN,
 instructor_id INT,
 instrument_name VARCHAR(50)
);

ALTER TABLE booking ADD CONSTRAINT PK_booking PRIMARY KEY (student_id,lesson_id);


CREATE TABLE ensemble (
 lesson_id INT NOT NULL,
 genre VARCHAR(50)
);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (lesson_id);


ALTER TABLE contact_person ADD CONSTRAINT FK_contact_person_0 FOREIGN KEY (contact_id) REFERENCES contact_details (contact_id);


ALTER TABLE personal_details ADD CONSTRAINT FK_personal_details_0 FOREIGN KEY (contact_id) REFERENCES contact_details (contact_id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_number) REFERENCES personal_details (person_number);
ALTER TABLE student ADD CONSTRAINT FK_student_1 FOREIGN KEY (contact_person_id) REFERENCES contact_person (contact_person_id);
ALTER TABLE student ADD CONSTRAINT FK_student_2 FOREIGN KEY (allowed_rentals_id) REFERENCES allowed_rentals (allowed_rentals_id);


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_number) REFERENCES personal_details (person_number);


ALTER TABLE instrument_for_lease ADD CONSTRAINT FK_instrument_for_lease_0 FOREIGN KEY (brand_name) REFERENCES brand (brand_name);
ALTER TABLE instrument_for_lease ADD CONSTRAINT FK_instrument_for_lease_1 FOREIGN KEY (instrument_price_scheme_id) REFERENCES instrument_price_scheme (instrument_price_scheme_id);


ALTER TABLE instrument_taught ADD CONSTRAINT FK_instrument_taught_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE lease ADD CONSTRAINT FK_lease_0 FOREIGN KEY (student_id) REFERENCES student (student_id);
ALTER TABLE lease ADD CONSTRAINT FK_lease_1 FOREIGN KEY (instrument_id) REFERENCES instrument_for_lease (instrument_id);


ALTER TABLE sibling ADD CONSTRAINT FK_sibling_0 FOREIGN KEY (sibling_student_id) REFERENCES student (student_id);
ALTER TABLE sibling ADD CONSTRAINT FK_sibling_1 FOREIGN KEY (student_id) REFERENCES student (student_id);


ALTER TABLE timeslot ADD CONSTRAINT FK_timeslot_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_0 FOREIGN KEY (timeslot_id) REFERENCES timeslot (timeslot_id);
ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_1 FOREIGN KEY (price_class_id) REFERENCES pricing_scheme (price_class_id);


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (lesson_id) REFERENCES individual_lesson (lesson_id);


ALTER TABLE booking ADD CONSTRAINT FK_booking_0 FOREIGN KEY (student_id) REFERENCES student (student_id);
ALTER TABLE booking ADD CONSTRAINT FK_booking_1 FOREIGN KEY (lesson_id) REFERENCES individual_lesson (lesson_id);
ALTER TABLE booking ADD CONSTRAINT FK_booking_2 FOREIGN KEY (lesson_id) REFERENCES group_lesson (lesson_id);
ALTER TABLE booking ADD CONSTRAINT FK_booking_3 FOREIGN KEY (instructor_id,instrument_name) REFERENCES instrument_taught (instructor_id,instrument_name);


ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_0 FOREIGN KEY (lesson_id) REFERENCES group_lesson (lesson_id);


