
# RHCSA EX200 Exam Practice Set 2

## Task 1: Group Creation

### 1. Create a group named `developers`

**Syntax:**
```bash
groupadd [GROUP_NAME]
```

**Commands:**
```bash
groupadd developers
```

**Verify:**
```bash
cat /etc/group
```

### 2. Create another group named `auditors`

**Syntax:**
```bash
groupadd [GROUP_NAME]
```

**Commands:**
```bash
groupadd auditors
```

**Verify:**
```bash
cat /etc/group
```

### 3. Rename the group `auditors` to `security_auditors`

**Syntax:**
```bash
groupmod -n [NEW_GROUP_NAME] [OLD_GROUP_NAME]
```

**Commands:**
```bash
groupmod -n security_auditors auditors
```

**Verify:**
```bash
cat /etc/group
```

### 4. Set the GID of `developers` to `2500`

**Syntax:**
```bash
groupmod -g [GID] [GROUP]
```

**Commands:**
```bash
groupmod -g 2500 developers
```

**Verify:**
```bash
cat /etc/group
```

### 5. Verify both groups and their GIDs

**Commands:**
```bash
cat /etc/group
```

**Expected output:**
```text
developers:x:2500:
security_auditors:x:1006:
```

---

## Task 2: User Account Creation

Create the following users:

| Username | Primary Group | Login Shell |
|---|---|---|
| john | developers | `/bin/bash` |
| sarah | security_auditors | `/bin/bash` |
| michael | developers | `/bin/bash` |

**Syntax:**
```bash
useradd -m -s /path/to/shell -g [GID] [USER]
```

**Commands:**
```bash
useradd -m -s /bin/bash -g 2500 john
useradd -m -s /bin/bash -g 1006 sarah
useradd -m -s /bin/bash -g 2500 michael
```

**Verify:**
```bash
cat /etc/passwd
```

**Expected output:**
```text
john:x:1004:2500::/home/john:/bin/bash
sarah:x:1005:1006::/home/sarah:/bin/bash
michael:x:1006:2500::/home/michael:/bin/bash
```

---

## Task 3: Supplementary Group Membership

Configure the following supplementary group memberships:

| Username | Supplementary Groups |
|---|---|
| john | security_auditors |
| sarah | developers |
| michael | security_auditors |

**Syntax:**
```bash
usermod -aG [GROUP] [USER]
```

**Commands:**
```bash
usermod -aG security_auditors john
usermod -aG developers sarah
usermod -aG security_auditors michael
```

**Verify:**
```bash
tail -n 3 /etc/passwd
```

**Expected output:**
```text
john:x:1004:2500::/home/john:/bin/bash
sarah:x:1005:1006::/home/sarah:/bin/bash
michael:x:1006:2500::/home/michael:/bin/bash
```

Verify supplementary group memberships:
```bash
tail -n 2 /etc/group
```

**Expected output:**
```text
developers:x:2500:sarah
security_auditors:x:1006:john,michael
```

**Requirement:** Do not change the users' primary groups.

---

## Task 4: Password Aging

Configure the following password policies:

| Username | Maximum Days | Minimum Days | Warning Days |
|---|---:|---:|---:|
| john | 60 | 7 | 10 |
| sarah | 90 | 5 | 14 |
| michael | 30 | 10 | 15 |

**Commands:**
```bash
chage -m 7 -M 60 -W 10 john
chage -m 5 -M 90 -W 14 sarah
chage -m 10 -M 30 -W 15 michael
```

**Verify:**
```bash
chage -l john
chage -l sarah
chage -l michael
```

**Requirement:** Make sure all password aging settings are applied correctly.

---

## Task 5: Account Expiration

### 1. Configure Michael's account expiration

Configure `michael` so his account expires on December 31, 2026.

**Syntax:**
```bash
chage -E [EXPIRE_DATE] [USER]
```

**Commands:**
```bash
chage -E 2026-01-01 michael
```

**Verify:**
```bash
chage -l michael
```

**Expected output:**
```text
Account expires : Dec 31, 2026
```

### 2. Force Sarah to change her password at the next login

Configure `sarah` so she must change her password at the next login.

**Syntax:**
```bash
chage -d [VALUE] [USER]
```

**Commands:**
```bash
chage -d 0 sarah
```

**Verify:**
```bash
chage -l sarah
```

**Expected output:**
```text
Last password change : password must be changed
Password expires     : password must be changed
Password inactive    : password must be changed
```

### 3. Verify both configurations

Verify Michael:
```bash
chage -l michael
```

Expected:
```text
Account expires : Dec 31, 2026
```

Verify Sarah:
```bash
chage -l sarah
```

Expected:
```text
Last password change : password must be changed
Password expires     : password must be changed
Password inactive    : password must be changed
```

---

## Task 6: User Modification

The company has changed its organizational structure.

### 1. Change John's login shell to `/bin/sh`

**Syntax:**
```bash
usermod -s /path/to/shell [USER]
```

**Commands:**
```bash
usermod -s /bin/sh john
```

**Verify:**
```bash
cat /etc/passwd
```

**Expected output:**
```text
john:x:1004:2500::/home/john:/bin/sh
```

### 2. Add John to the `developers` supplementary group

Add `john` to the `developers` supplementary group without removing his existing supplementary group memberships.

**Syntax:**
```bash
usermod -aG [GROUP] [USER]
```

**Commands:**
```bash
usermod -aG developers john
```

**Verify:**
```bash
cat /etc/group
```

**Expected output:**
```text
developers:x:2500:sarah,john
```

### 3. Lock Michael's password

**Syntax:**
```bash
usermod -L [USER]
```

**Commands:**
```bash
usermod -L michael
```

**Verify:**
```bash
cat /etc/shadow
```

**Expected output:**
```text
michael:!$y$j9T$ulB/7cUjT9zwnQal8DO2D/$.U/zrmqZxVdBg8uQcszv8XO6hcSmUcZnKJnKVbZn9K8:20774:0:99999:7::20818:
```

### 4. Verify all modifications

Verify John's login shell:
```bash
cat /etc/passwd
```

Expected:
```text
john:x:1004:2500::/home/john:/bin/sh
```

Verify supplementary group membership:
```bash
cat /etc/group
```

Expected:
```text
developers:x:2500:sarah,john
```

Verify Michael's locked password:
```bash
cat /etc/shadow
```

Expected:
```text
michael:!$y$j9T$ulB/7cUjT9zwnQal8DO2D/$.U/zrmqZxVdBg8uQcszv8XO6hcSmUcZnKJnKVbZn9K8:20774:0:99999:7::20818:
```

---

## Task 7: User Account Removal

An employee named `john` has left the company.

### 1. Delete the user account

**Syntax:**
```bash
userdel [USER]
```

**Commands:**
```bash
userdel john
```

### 2. Preserve John's home directory

Do not remove John's home directory when deleting his account.

### 3. Verify that the user account no longer exists

**Commands:**
```bash
cat /etc/passwd | grep john
```

**Expected result:**

No output should be returned.

### 4. Verify that his home directory still exists

**Commands:**
```bash
ls -l /home
```

**Expected output:**
```text
drwx------. 2 1004 developers 62 Nov 17 19:43 john
```

**Requirement:** John's account must be removed, but his home directory and its contents must remain intact.

