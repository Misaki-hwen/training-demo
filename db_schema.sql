CREATE DATABASE IF NOT EXISTS test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE test;

CREATE TABLE user (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('enterprise','operation','school','student') NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE enterprise (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(200) NOT NULL,
    contact_name VARCHAR(100),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_enterprise_user FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE school (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(200) NOT NULL,
    contact_name VARCHAR(100),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_school_user FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE training_plan (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    enterprise_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(200) NOT NULL,
    position_type VARCHAR(100),
    headcount INT NOT NULL,
    budget DECIMAL(12,2),
    education_requirements VARCHAR(255),
    major_requirements VARCHAR(255),
    skills_requirements VARCHAR(255),
    start_date DATE,
    end_date DATE,
    location VARCHAR(100),
    settlement_method ENUM('Post','Phased') DEFAULT 'Post',
    status ENUM('Draft','Pending','Auditing','Approved','Rejected') DEFAULT 'Draft',
    remark TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plan_enterprise FOREIGN KEY (enterprise_id) REFERENCES enterprise(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE training_camp (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    school_id BIGINT UNSIGNED,
    start_date DATE,
    end_date DATE,
    headcount INT,
    status ENUM('Pending','Ongoing','Finished') DEFAULT 'Pending',
    pass_score_threshold INT DEFAULT 60,
    target_pass_rate INT DEFAULT 80,
    required_lessons INT DEFAULT 0,
    attendance_weight INT DEFAULT 50,
    review_weight INT DEFAULT 50,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_camp_school FOREIGN KEY (school_id) REFERENCES school(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE training_camp_plan (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    camp_id BIGINT UNSIGNED NOT NULL,
    plan_id BIGINT UNSIGNED NOT NULL,
    CONSTRAINT fk_camp_plan_camp FOREIGN KEY (camp_id) REFERENCES training_camp(id),
    CONSTRAINT fk_camp_plan_plan FOREIGN KEY (plan_id) REFERENCES training_plan(id),
    UNIQUE KEY uk_camp_plan (camp_id, plan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE course (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    content TEXT,
    teacher VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE camp_course (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    camp_id BIGINT UNSIGNED NOT NULL,
    course_id BIGINT UNSIGNED NOT NULL,
    schedule DATETIME,
    location VARCHAR(200),
    CONSTRAINT fk_camp_course_camp FOREIGN KEY (camp_id) REFERENCES training_camp(id),
    CONSTRAINT fk_camp_course_course FOREIGN KEY (course_id) REFERENCES course(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE student_profile (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    school_name VARCHAR(200),
    major VARCHAR(200),
    resume_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_user FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE enrollment (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT UNSIGNED NOT NULL,
    plan_id BIGINT UNSIGNED NOT NULL,
    status ENUM('Pending','Passed','Rejected') DEFAULT 'Pending',
    apply_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES student_profile(id),
    CONSTRAINT fk_enroll_plan FOREIGN KEY (plan_id) REFERENCES training_plan(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE camp_student (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    camp_id BIGINT UNSIGNED NOT NULL,
    student_id BIGINT UNSIGNED NOT NULL,
    final_status ENUM('Pending','Confirmed','Completed','Dropped') DEFAULT 'Pending',
    CONSTRAINT fk_camp_student_camp FOREIGN KEY (camp_id) REFERENCES training_camp(id),
    CONSTRAINT fk_camp_student_student FOREIGN KEY (student_id) REFERENCES student_profile(id),
    UNIQUE KEY uk_camp_student (camp_id, student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE attendance_record (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    camp_id BIGINT UNSIGNED NOT NULL,
    course_id BIGINT UNSIGNED NOT NULL,
    student_id BIGINT UNSIGNED NOT NULL,
    status ENUM('Present','Absent','Late') DEFAULT 'Present',
    checkin_time DATETIME,
    CONSTRAINT fk_attendance_camp FOREIGN KEY (camp_id) REFERENCES training_camp(id),
    CONSTRAINT fk_attendance_course FOREIGN KEY (course_id) REFERENCES course(id),
    CONSTRAINT fk_attendance_student FOREIGN KEY (student_id) REFERENCES student_profile(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE assessment_result (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    camp_id BIGINT UNSIGNED NOT NULL,
    student_id BIGINT UNSIGNED NOT NULL,
    score INT NOT NULL,
    is_passed TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_assessment_camp FOREIGN KEY (camp_id) REFERENCES training_camp(id),
    CONSTRAINT fk_assessment_student FOREIGN KEY (student_id) REFERENCES student_profile(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE settlement_order (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_no VARCHAR(32) NOT NULL UNIQUE,
    enterprise_id BIGINT UNSIGNED NOT NULL,
    camp_id BIGINT UNSIGNED NOT NULL,
    headcount INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status ENUM('Pending','Confirmed','Paid') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_settle_enterprise FOREIGN KEY (enterprise_id) REFERENCES enterprise(id),
    CONSTRAINT fk_settle_camp FOREIGN KEY (camp_id) REFERENCES training_camp(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

