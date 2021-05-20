-- Companies
insert into company(id, name)
values (1001, 'Amazon'),
       (1002, 'IBM'),
       (1003, 'Oracle');

-- Users
insert into user(id, login, password)
values (2001, 'user1', 'password'),
       (2002, 'user2', 'password'),
       (2003, 'admin', 'password');

-- User roles
insert into user_roles(user_id, roles)
values (2001, 'user'),
       (2002, 'user'),
       (2002, 'manager'),
       (2003, 'admin');

-- User-Company
insert into user_company(user_id, companies_id)
values (2001, 1001),
       (2001, 1002),
       (2002, 1003),
       (2003, 1001),
       (2003, 1002),
       (2003, 1003);

-- ACLs

CREATE TABLE IF NOT EXISTS acl_sid (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    principal tinyint(1) NOT NULL,
    sid varchar(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_uk_1 (sid,principal)
    );

CREATE TABLE IF NOT EXISTS acl_class (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    class varchar(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_uk_2 (class)
    );

CREATE TABLE IF NOT EXISTS acl_entry (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    acl_object_identity bigint(20) NOT NULL,
    ace_order int(11) NOT NULL,
    sid bigint(20) NOT NULL,
    mask int(11) NOT NULL,
    granting tinyint(1) NOT NULL,
    audit_success tinyint(1) NOT NULL,
    audit_failure tinyint(1) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_uk_4 (acl_object_identity,ace_order)
    );

CREATE TABLE IF NOT EXISTS acl_object_identity (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    object_id_class bigint(20) NOT NULL,
    object_id_identity bigint(20) NOT NULL,
    parent_object bigint(20) DEFAULT NULL,
    owner_sid bigint(20) DEFAULT NULL,
    entries_inheriting tinyint(1) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_uk_3 (object_id_class,object_id_identity)
    );

ALTER TABLE acl_entry
    ADD FOREIGN KEY (acl_object_identity) REFERENCES acl_object_identity(id);

ALTER TABLE acl_entry
    ADD FOREIGN KEY (sid) REFERENCES acl_sid(id);

--
-- Constraints for table acl_object_identity
--
ALTER TABLE acl_object_identity
    ADD FOREIGN KEY (parent_object) REFERENCES acl_object_identity (id);

ALTER TABLE acl_object_identity
    ADD FOREIGN KEY (object_id_class) REFERENCES acl_class (id);

ALTER TABLE acl_object_identity
    ADD FOREIGN KEY (owner_sid) REFERENCES acl_sid (id);

-- ACLs data

INSERT INTO acl_sid (id, principal, sid)
VALUES (1, 1, 'user1'),
       (2, 1, 'user2'),
       (3, 0, 'ROLE_ADMIN');

INSERT INTO acl_class (id, class)
VALUES (1, 'edu.spingsecurity.model.Company');

INSERT INTO acl_object_identity (id, object_id_class, object_id_identity, parent_object, owner_sid, entries_inheriting)
VALUES (1, 1, 1001, NULL, 3, 0),
       (2, 1, 1002, NULL, 3, 0),
       (3, 1, 1003, NULL, 3, 0);

INSERT INTO acl_entry (id, acl_object_identity, ace_order, sid, mask, granting, audit_success, audit_failure)
VALUES (1, 1, 1, 1, 1, 1, 1, 1),
       (2, 1, 2, 1, 2, 1, 1, 1),
       (3, 1, 3, 3, 1, 1, 1, 1),
       (4, 2, 1, 2, 1, 1, 1, 1),
       (5, 2, 2, 3, 1, 1, 1, 1),
       (6, 3, 1, 3, 1, 1, 1, 1),
       (7, 3, 2, 3, 2, 1, 1, 1);
