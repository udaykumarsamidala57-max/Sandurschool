-- PHRMS Module 1: direct applications and configurable salary components.
-- Target: MySQL 8.0+ / Flyway migration V2.
-- branch_code values must match PInventory's signed-in users.branch value.
-- A branch code is required for every HR record; do not default records to a branch.

CREATE TABLE phrms_branches (
    branch_code VARCHAR(80) NOT NULL,
    branch_name VARCHAR(120) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (branch_code),
    UNIQUE KEY uk_phrms_branch_name (branch_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Current PInventory branch codes; add future branches here before use in PHRMS.
INSERT INTO phrms_branches (branch_code, branch_name) VALUES
    ('SRS', 'SRS'),
    ('Sanpoly', 'Sanpoly');

CREATE TABLE phrms_designations (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    code VARCHAR(40) NOT NULL,
    name VARCHAR(120) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_designation_code (branch_code, code),
    UNIQUE KEY uk_phrms_designation_name (branch_code, name),
    UNIQUE KEY uk_phrms_designation_id_branch (id, branch_code),
    KEY idx_phrms_designation_active (branch_code, is_active, sort_order),
    CONSTRAINT fk_phrms_designation_branch FOREIGN KEY (branch_code)
        REFERENCES phrms_branches (branch_code) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE phrms_reporting_managers (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    employee_code VARCHAR(40) NULL,
    display_name VARCHAR(160) NOT NULL,
    designation_id BIGINT NULL,
    email VARCHAR(254) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_reporting_manager_code (branch_code, employee_code),
    UNIQUE KEY uk_phrms_reporting_manager_id_branch (id, branch_code),
    KEY idx_phrms_reporting_manager_active (branch_code, is_active, display_name),
    CONSTRAINT fk_phrms_reporting_manager_branch FOREIGN KEY (branch_code)
        REFERENCES phrms_branches (branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_reporting_manager_designation FOREIGN KEY (designation_id, branch_code)
        REFERENCES phrms_designations (id, branch_code) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE phrms_appointment_types (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    code VARCHAR(40) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_appointment_type_code (branch_code, code),
    UNIQUE KEY uk_phrms_appointment_type_name (branch_code, name),
    UNIQUE KEY uk_phrms_appointment_type_id_branch (id, branch_code),
    KEY idx_phrms_appointment_type_active (branch_code, is_active, sort_order),
    CONSTRAINT fk_phrms_appointment_type_branch FOREIGN KEY (branch_code)
        REFERENCES phrms_branches (branch_code) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Starter appointment options. Adjust names/types to the organization's policy.
INSERT INTO phrms_appointment_types (branch_code, code, name, description, sort_order) VALUES
    ('SRS', 'PERMANENT', 'Permanent', 'Regular appointment', 10),
    ('SRS', 'CONTRACT', 'Contract', 'Contract appointment', 20),
    ('SRS', 'TEMPORARY', 'Temporary', 'Temporary appointment', 30),
    ('SRS', 'CONSULTANT', 'Consultant', 'Consultancy appointment', 40),
    ('Sanpoly', 'PERMANENT', 'Permanent', 'Regular appointment', 10),
    ('Sanpoly', 'CONTRACT', 'Contract', 'Contract appointment', 20),
    ('Sanpoly', 'TEMPORARY', 'Temporary', 'Temporary appointment', 30),
    ('Sanpoly', 'CONSULTANT', 'Consultant', 'Consultancy appointment', 40);

CREATE TABLE phrms_probation_policies (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    code VARCHAR(40) NOT NULL,
    name VARCHAR(100) NOT NULL,
    duration_months SMALLINT UNSIGNED NOT NULL,
    extension_allowed BOOLEAN NOT NULL DEFAULT FALSE,
    max_extension_months SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_probation_policy_code (branch_code, code),
    UNIQUE KEY uk_phrms_probation_policy_name (branch_code, name),
    UNIQUE KEY uk_phrms_probation_policy_id_branch (id, branch_code),
    CONSTRAINT fk_phrms_probation_policy_branch FOREIGN KEY (branch_code)
        REFERENCES phrms_branches (branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_phrms_probation_extension
        CHECK ((extension_allowed = FALSE AND max_extension_months = 0)
            OR (extension_allowed = TRUE AND max_extension_months > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Starter dropdown values only. Confirm these durations with HR before use.
INSERT INTO phrms_probation_policies
    (branch_code, code, name, duration_months, extension_allowed, max_extension_months, is_active) VALUES
    ('SRS', 'PROBATION_3M', 'Probation - 3 months', 3, FALSE, 0, TRUE),
    ('SRS', 'PROBATION_6M', 'Probation - 6 months', 6, FALSE, 0, TRUE),
    ('Sanpoly', 'PROBATION_3M', 'Probation - 3 months', 3, FALSE, 0, TRUE),
    ('Sanpoly', 'PROBATION_6M', 'Probation - 6 months', 6, FALSE, 0, TRUE);

CREATE TABLE phrms_leave_policies (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    code VARCHAR(40) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_leave_policy_code (branch_code, code),
    UNIQUE KEY uk_phrms_leave_policy_name (branch_code, name),
    UNIQUE KEY uk_phrms_leave_policy_id_branch (id, branch_code),
    CONSTRAINT fk_phrms_leave_policy_branch FOREIGN KEY (branch_code)
        REFERENCES phrms_branches (branch_code) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE phrms_direct_applications (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    application_number VARCHAR(40) NOT NULL,
    candidate_name VARCHAR(160) NOT NULL,
    mobile_number VARCHAR(25) NOT NULL,
    address TEXT NULL,
    designation_id BIGINT NOT NULL,
    date_of_birth DATE NULL,
    marital_status ENUM('SINGLE','MARRIED','DIVORCED','WIDOWED','OTHER','NOT_SPECIFIED')
        NOT NULL DEFAULT 'NOT_SPECIFIED',
    experience_years DECIMAL(5,2) UNSIGNED NULL,
    previous_organization VARCHAR(200) NULL,
    qualification VARCHAR(255) NULL,
    subject VARCHAR(160) NULL,
    probation_policy_id BIGINT NULL,
    reporting_manager_id BIGINT NULL,
    position_type ENUM('NEW_POSITION','REPLACEMENT') NOT NULL DEFAULT 'NEW_POSITION',
    replacement_for VARCHAR(160) NULL,
    appointment_type_id BIGINT NOT NULL,
    leave_policy_id BIGINT NULL,
    application_status ENUM('DRAFT','SUBMITTED','UNDER_REVIEW','SHORTLISTED','SELECTED','REJECTED','WITHDRAWN')
        NOT NULL DEFAULT 'DRAFT',
    submitted_at DATETIME(6) NULL,
    notes TEXT NULL,
    created_by VARCHAR(100) NOT NULL,
    updated_by VARCHAR(100) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_application_number (application_number),
    UNIQUE KEY uk_phrms_application_id_branch (id, branch_code),
    KEY idx_phrms_application_status_created (branch_code, application_status, created_at),
    KEY idx_phrms_application_mobile (branch_code, mobile_number),
    KEY idx_phrms_application_designation (branch_code, designation_id),
    KEY idx_phrms_application_manager (branch_code, reporting_manager_id),
    CONSTRAINT fk_phrms_application_branch FOREIGN KEY (branch_code)
        REFERENCES phrms_branches (branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_application_designation FOREIGN KEY (designation_id, branch_code)
        REFERENCES phrms_designations (id, branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_application_probation FOREIGN KEY (probation_policy_id, branch_code)
        REFERENCES phrms_probation_policies (id, branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_application_manager FOREIGN KEY (reporting_manager_id, branch_code)
        REFERENCES phrms_reporting_managers (id, branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_application_appointment_type FOREIGN KEY (appointment_type_id, branch_code)
        REFERENCES phrms_appointment_types (id, branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_application_leave_policy FOREIGN KEY (leave_policy_id, branch_code)
        REFERENCES phrms_leave_policies (id, branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_phrms_replacement_details
        CHECK (position_type <> 'REPLACEMENT' OR replacement_for IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Salary component catalog. Create any number of ALLOWANCE and DEDUCTION rows.
-- Percentage formulas use a selected base; do not store executable SQL/formula text.
CREATE TABLE phrms_salary_component_definitions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    code VARCHAR(40) NOT NULL,
    name VARCHAR(120) NOT NULL,
    component_type ENUM('ALLOWANCE','DEDUCTION') NOT NULL,
    calculation_method ENUM('FIXED','PERCENTAGE') NOT NULL DEFAULT 'FIXED',
    value_frequency ENUM('MONTHLY','CONSTANT') NOT NULL DEFAULT 'MONTHLY',
    percentage_base_type ENUM('BASIC','GROSS_ALLOWANCES','GROSS_EARNINGS','CTC','OTHER_COMPONENT') NULL,
    percentage_base_component_id BIGINT NULL,
    is_variable BOOLEAN NOT NULL DEFAULT FALSE,
    include_in_ctc BOOLEAN NOT NULL DEFAULT FALSE,
    rounding_scale TINYINT UNSIGNED NOT NULL DEFAULT 2,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_salary_component_code (branch_code, code),
    UNIQUE KEY uk_phrms_salary_component_name (branch_code, name),
    UNIQUE KEY uk_phrms_salary_component_id_branch (id, branch_code),
    KEY idx_phrms_salary_component_active (branch_code, is_active, component_type, sort_order),
    CONSTRAINT fk_phrms_salary_component_branch FOREIGN KEY (branch_code)
        REFERENCES phrms_branches (branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_salary_component_base FOREIGN KEY (percentage_base_component_id, branch_code)
        REFERENCES phrms_salary_component_definitions (id, branch_code)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_phrms_component_percentage_base
        CHECK ((calculation_method = 'FIXED'
                AND percentage_base_type IS NULL
                AND percentage_base_component_id IS NULL)
            OR (calculation_method = 'PERCENTAGE'
                AND percentage_base_type IS NOT NULL
                AND ((percentage_base_type = 'OTHER_COMPONENT' AND percentage_base_component_id IS NOT NULL)
                    OR (percentage_base_type <> 'OTHER_COMPONENT' AND percentage_base_component_id IS NULL)))),
    CONSTRAINT chk_phrms_component_rounding_scale CHECK (rounding_scale <= 4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE phrms_candidate_salary_packages (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    application_id BIGINT NOT NULL,
    version_no SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    currency_code CHAR(3) NOT NULL DEFAULT 'INR',
    effective_from DATE NOT NULL,
    effective_to DATE NULL,
    monthly_ctc DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    annual_ctc DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    package_status ENUM('DRAFT','PROPOSED','APPROVED','SUPERSEDED') NOT NULL DEFAULT 'DRAFT',
    calculation_notes VARCHAR(500) NULL,
    created_by VARCHAR(100) NOT NULL,
    approved_by VARCHAR(100) NULL,
    approved_at DATETIME(6) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_salary_package_version (application_id, branch_code, version_no),
    UNIQUE KEY uk_phrms_salary_package_id_branch (id, branch_code),
    KEY idx_phrms_salary_package_status (branch_code, package_status, effective_from),
    CONSTRAINT fk_phrms_salary_package_application FOREIGN KEY (application_id, branch_code)
        REFERENCES phrms_direct_applications (id, branch_code) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_phrms_salary_package_dates
        CHECK (effective_to IS NULL OR effective_to >= effective_from)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE phrms_candidate_salary_components (
    id BIGINT NOT NULL AUTO_INCREMENT,
    branch_code VARCHAR(80) NOT NULL,
    salary_package_id BIGINT NOT NULL,
    component_definition_id BIGINT NOT NULL,
    component_type ENUM('ALLOWANCE','DEDUCTION') NOT NULL,
    calculation_method ENUM('FIXED','PERCENTAGE') NOT NULL,
    value_frequency ENUM('MONTHLY','CONSTANT') NOT NULL,
    is_variable BOOLEAN NOT NULL DEFAULT FALSE,
    fixed_amount DECIMAL(14,2) NULL,
    percentage_rate DECIMAL(7,4) NULL,
    percentage_base_type ENUM('BASIC','GROSS_ALLOWANCES','GROSS_EARNINGS','CTC','OTHER_COMPONENT') NULL,
    percentage_base_component_id BIGINT NULL,
    calculation_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    calculated_monthly_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    include_in_ctc BOOLEAN NOT NULL DEFAULT FALSE,
    rounding_scale TINYINT UNSIGNED NOT NULL DEFAULT 2,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_phrms_salary_package_component (salary_package_id, branch_code, component_definition_id),
    KEY idx_phrms_salary_component_order (branch_code, salary_package_id, calculation_order),
    CONSTRAINT fk_phrms_candidate_component_package FOREIGN KEY (salary_package_id, branch_code)
        REFERENCES phrms_candidate_salary_packages (id, branch_code) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_phrms_candidate_component_definition FOREIGN KEY (component_definition_id, branch_code)
        REFERENCES phrms_salary_component_definitions (id, branch_code) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_phrms_candidate_component_base FOREIGN KEY (percentage_base_component_id, branch_code)
        REFERENCES phrms_salary_component_definitions (id, branch_code) ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_phrms_candidate_component_amount
        CHECK ((calculation_method = 'FIXED'
                AND fixed_amount IS NOT NULL AND fixed_amount >= 0
                AND percentage_rate IS NULL
                AND percentage_base_type IS NULL
                AND percentage_base_component_id IS NULL)
            OR (calculation_method = 'PERCENTAGE'
                AND fixed_amount IS NULL
                AND percentage_rate IS NOT NULL AND percentage_rate >= 0 AND percentage_rate <= 100
                AND percentage_base_type IS NOT NULL
                AND ((percentage_base_type = 'OTHER_COMPONENT' AND percentage_base_component_id IS NOT NULL)
                    OR (percentage_base_type <> 'OTHER_COMPONENT' AND percentage_base_component_id IS NULL)))),
    CONSTRAINT chk_phrms_candidate_component_rounding CHECK (rounding_scale <= 4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Reporting query: one row per package with stored calculated totals.
-- Application code should recalculate components in calculation_order, update
-- calculated_monthly_amount, then update the package totals in one transaction.
CREATE VIEW phrms_candidate_salary_package_totals AS
SELECT
    p.id AS salary_package_id,
    p.branch_code,
    p.application_id,
    p.version_no,
    p.currency_code,
    p.package_status,
    COALESCE(SUM(CASE WHEN c.component_type = 'ALLOWANCE'
                      THEN c.calculated_monthly_amount ELSE 0 END), 0) AS monthly_allowances,
    COALESCE(SUM(CASE WHEN c.component_type = 'DEDUCTION'
                      THEN c.calculated_monthly_amount ELSE 0 END), 0) AS monthly_deductions,
    COALESCE(SUM(CASE WHEN c.include_in_ctc = TRUE
                      THEN c.calculated_monthly_amount ELSE 0 END), 0) AS calculated_monthly_ctc,
    COALESCE(SUM(CASE WHEN c.include_in_ctc = TRUE
                      THEN c.calculated_monthly_amount ELSE 0 END), 0) * 12 AS calculated_annual_ctc
FROM phrms_candidate_salary_packages p
LEFT JOIN phrms_candidate_salary_components c
    ON c.salary_package_id = p.id AND c.branch_code = p.branch_code
GROUP BY p.id, p.branch_code, p.application_id, p.version_no, p.currency_code, p.package_status;

-- Every dropdown/list/detail query must include the authenticated branch_code.
-- For a normal user, obtain branch_code from the PInventory SSO principal.
-- A Global user may select only an active branch from this master, then scope all queries to it.
-- SELECT branch_code, branch_name FROM phrms_branches WHERE is_active = TRUE ORDER BY branch_name;
-- SELECT id, name FROM phrms_probation_policies WHERE branch_code = ? AND is_active = TRUE ORDER BY duration_months;
-- SELECT id, display_name, designation_id FROM phrms_reporting_managers WHERE branch_code = ? AND is_active = TRUE ORDER BY display_name;
-- SELECT id, name FROM phrms_designations WHERE branch_code = ? AND is_active = TRUE ORDER BY sort_order, name;
-- SELECT id, name FROM phrms_appointment_types WHERE branch_code = ? AND is_active = TRUE ORDER BY sort_order, name;
-- SELECT id, name FROM phrms_leave_policies WHERE branch_code = ? AND is_active = TRUE ORDER BY name;
-- Never trust a branch_code sent by the browser for a non-Global user.

-- Salary calculation rules:
-- FIXED: monthly amount = fixed_amount (for CONSTANT values, retain the same value across periods).
-- PERCENTAGE: monthly amount = selected base amount * percentage_rate / 100, rounded to rounding_scale.
-- Apply components in calculation_order; reject circular component-base references in application validation.
-- Monthly CTC = sum of components where include_in_ctc = TRUE; annual CTC = monthly CTC * 12.
