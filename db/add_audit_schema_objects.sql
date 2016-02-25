CREATE TABLE audit_result_types  (
	id         	int(11) AUTO_INCREMENT NOT NULL,
	name       	varchar(32) NOT NULL,
	description	varchar(254) NOT NULL,
	active     	tinyint(1) NOT NULL,
	PRIMARY KEY(id)
)
;

CREATE TABLE audit_results  (
	id                  	int(11) AUTO_INCREMENT NOT NULL,
	audit_id            	int(11) NOT NULL,
	auditable_id        	int(11) NOT NULL,
	auditable_type      	varchar(64) NOT NULL,
	class_name      			varchar(64) NOT NULL,
	organization_id     	int(11) NOT NULL,
	audit_result_type_id	int(11) NOT NULL,
	notes               	text NULL,
	created_at          	datetime NULL,
	updated_at          	datetime NULL,
	PRIMARY KEY(id)
)
;
CREATE INDEX audit_results_idx1 ON audit_results(audit_id)
;
CREATE INDEX audit_results_idx2 ON audit_results(auditable_type, auditable_id)
;
CREATE INDEX audit_results_idx3 ON audit_results(class_name)
;
CREATE INDEX audit_results_idx4 ON audit_results(audit_result_type_id)
;

CREATE TABLE audits  (
	id          	int(11) AUTO_INCREMENT NOT NULL,
	object_key  	varchar(12) NOT NULL,
	activity_id   int(11) NULL,
	name        	varchar(64) NOT NULL,
	description 	text NOT NULL,
	instructions	varchar(254) NOT NULL,
	schedule    	varchar(64) NOT NULL,
	auditor_class_name	varchar(128) NOT NULL,
	last_run    	datetime NULL,
	active      	tinyint(1) NOT NULL,
	created_at  	datetime NOT NULL,
	updated_at  	datetime NOT NULL,
	PRIMARY KEY(id)
)
;
CREATE INDEX audits_idx1 ON audits(object_key)
;
CREATE INDEX audits_idx2 ON audits(active)
;

INSERT INTO audit_result_types(id, name, description, active)
	VALUES(1, 'Passed', 'All tests passed the audit', 1)
;
INSERT INTO audit_result_types(id, name, description, active)
	VALUES(2, 'failed', 'One or more tests failed the audit', 1)
;
INSERT INTO audit_result_types(id, name, description, active)
	VALUES(3, 'Untested', 'One or more audit tests were not completed', 1)
;
