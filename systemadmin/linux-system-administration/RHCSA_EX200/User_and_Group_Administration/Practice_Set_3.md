
# RHCSA EX200 Exam Practice Set 3

## Task 1: Group Administration

Create the following groups:

| Group | Required GID |
|---|---:|
| infrastructure | 3000 |
| softdevs | 3001 |
| security | 3002 |

**Requirements:**
- Create all three groups.

**Commands:**
```bash
groups=("infrastructure" "softdev" "security")

for teams in "${groups[@]}"; do
    for grpid in {3000..3002}; do
        echo "Adding GID no. $grpid name $teams"
        groupadd -g $grpid $teams
    done
done
```

**Verify:**
```bash
tail -n 3 /etc/group
```

**Expected output:**
```text
infrastructure:x:3000:
softdevs:x:3001:
security:x:3002:
```

### Rename `security` to `security_team`

**Syntax:**
```bash
groupmod -n [NEW_GROUP_NAME] [OLD_GROUP_NAME]
```

**Commands:**
```bash
groupmod -n security_team security
```

**Verify:**
```bash
cat /etc/group
```

**Expected output:**
```text
security_team:x:3002:
```

### Ensure the final group names and GIDs are correct

**Expected configuration:**
```text
infrastructure:x:3000:
softdevs:x:3001:
security_team:x:3002:
```

---

## Task 2: User Creation and Primary Groups

Create the following users:

| Username | Primary Group | Login Shell |
|---|---|---|
| david | infrastructure | `/bin/bash` |
| emma | softdevs | `/bin/bash` |
| ryan | security_team | `/bin/bash` |
| sophia | softdevs | `/bin/sh` |

**Requirements:**
- All users must have home directories.
- All users must have valid passwords.
- Their primary groups and login shells must match the table.

**Commands:**
```bash
users=("david" "emma" "ryan" "sophia")
grpids=(3000 3001 3002)

for i in "${!users[@]}"; do
    u="${users[$i]}"
    grpid="${grpids[$i]}"

    if [[ "$u" == "sophia" ]]; then
        echo "Creating user $u and assigning Primary Group no. $grpid (developers) with /bin/sh"
        useradd -m -s /bin/sh -g "$grpid" "$u"
    else
        echo "Creating user $u and assigning Primary Group no. $grpid with /bin/bash"
        useradd -m -s /bin/bash -g "$grpid" "$u"
    fi
done
```

**Verify:**
```bash
tail -n 4 /etc/passwd
```

**Expected output:**
```text
david:x:1012:3000::/home/dave:/bin/bash
emma:x:1009:3001::/home/emma:/bin/bash
ryan:x:1010:3002::/home/ryan:/bin/bash
sophia:x:1011:3001::/home/sophia:/bin/sh
```

---

## Task 3: Supplementary Group Membership

Configure the following supplementary group memberships:

| Username | Supplementary Groups |
|---|---|
| david | softdevs, security_team |
| emma | infrastructure |
| ryan | softdevs, infrastructure |
| sophia | security_team |

**Requirements:**
- Assign all supplementary group memberships correctly.
- Do not accidentally replace existing supplementary memberships when adding another group.

**Verify:**
```bash
cat /etc/group
```

**Expected output:**
```text
infrastructure:x:3000:emma,ryan
softdevs:x:3001:ryan,david
security_team:x:3002:david,sophia
```

---

## Task 4: Password Aging Configuration

Configure the following password-aging policies:

| User | Minimum Days | Maximum Days | Warning Days |
|---|---:|---:|---:|
| david | 5 | 43 | 10 |
| emma | 7 | 60 | 14 |
| ryan | 2 | 30 | 7 |
| sophia | 1 | 90 | 15 |

**Requirements:**
- Apply the exact values.
- Verify the settings for all users.
- Do not confuse password expiration with account expiration.

**Syntax:**
```bash
chage -m [num] -M [num] -W [num] [USER]
```

**Verify David:**
```bash
chage -l david
```

**Expected output:**
```text
Last password change                    : Nov 17, 2026
Password expires                        : Dec 30, 2026
Password inactive                       : never
Account expires                          : never
Minimum number of days between password change        : 5
Maximum number of days between password change        : 43
Number of days of warning before password expires     : 10
```

**Verify Emma:**
```bash
chage -l emma
```

**Expected output:**
```text
Last password change                    : Nov 17, 2026
Password expires                        : Jan 16, 2027
Password inactive                       : never
Account expires                          : never
Minimum number of days between password change        : 7
Maximum number of days between password change        : 60
Number of days of warning before password expires     : 14
```

**Verify Ryan:**
```bash
chage -l ryan
```

**Expected output:**
```text
Last password change                    : Nov 17, 2026
Password expires                        : Dec 17, 2026
Password inactive                       : never
Account expires                          : never
Minimum number of days between password change        : 2
Maximum number of days between password change        : 30
Number of days of warning before password expires     : 7
```

**Verify Sophia:**
```bash
chage -l sophia
```

**Expected output:**
```text
Last password change                    : Nov 17, 2026
Password expires                        : Feb 15, 2027
Password inactive                       : never
Account expires                          : never
Minimum number of days between password change        : 1
Maximum number of days between password change        : 90
Number of days of warning before password expires     : 15
```

---

## Task 5: Account Expiration and Password Reset

Configure the following account settings.

### 1. David: Account expiration

Configure David's account to expire on January 31, 2027.

**Commands:**
```bash
chage -E 2027-02-01 david
```

**Verify:**
```bash
chage -l david
```

**Expected output:**
```text
Last password change                    : Nov 17, 2026
Password expires                        : Dec 30, 2026
Password inactive                       : never
Account expires                          : Jan 31, 2027
Minimum number of days between password change        : 5
Maximum number of days between password change        : 43
Number of days of warning before password expires     : 10
```

### 2. Emma: Force password change at next login

Configure Emma so she must change her password at the next login.

**Commands:**
```bash
chage -d 0 emma
```

**Verify:**
```bash
chage -l emma
```

**Expected output:**
```text
Last password change                    : password must be changed
Password expires                        : password must be changed
Password inactive                       : password must be changed
Account expires                          : never
Minimum number of days between password change        : 7
Maximum number of days between password change        : 60
Number of days of warning before password expires     : 14
```

### 3. Ryan: Account expiration

Configure Ryan's account to expire on March 15, 2027.

**Commands:**
```bash
chage -E 2027-03-16 ryan
```

**Verify:**
```bash
chage -l ryan
```

**Expected output:**
```text
Last password change                    : Nov 17, 2026
Password expires                        : Dec 17, 2026
Password inactive                       : never
Account expires                          : Mar 15, 2027
Minimum number of days between password change        : 2
Maximum number of days between password change        : 30
Number of days of warning before password expires     : 7
```

### 4. Sophia: Password inactivity

Configure Sophia's password to become inactive 14 days after password expiration.

**Commands:**
```bash
chage -I 14 sophia
```

**Verify:**
```bash
chage -l sophia
```

**Expected output:**
```text
Last password change                    : Nov 17, 2026
Password expires                        : Feb 15, 2027
Password inactive                       : Mar 01, 2027
Account expires                          : never
Minimum number of days between password change        : 1
Maximum number of days between password change        : 90
Number of days of warning before password expires     : 15
```

**Requirement:** Verify all account expiration and password reset configurations.

---

## Task 6: Account Security and Shell Modification

Perform the following account modifications.

### 1. Change David's login shell to `/bin/sh`

**Commands:**
```bash
usermod -s /bin/sh david
```

**Verify:**
```bash
cat /etc/passwd
```

**Expected output:**
```text
david:x:1012:3000::/home/david:/bin/sh
```

### 2. Lock Emma's password

**Commands:**
```bash
usermod -L emma
```

**Verify:**
```bash
cat /etc/shadow
```

**Expected output:**
```text
emma:!$y$j9T$vqVdYeo0qHnkzieMIFny9/$s65tleMEeT9TFyf9gsruk.X.GltMDTzsKXU0RNS7NP1:0:7:60:14:::
```

### 3. Unlock Emma's password

**Commands:**
```bash
usermod -U emma
```

**Verify:**
```bash
cat /etc/shadow
```

**Expected output:**
```text
emma:$y$j9T$vqVdYeo0qHnkzieMIFny9/$s65tleMEeT9TFyf9gsruk.X.GltMDTzsKXU0RNS7NP1:0:7:60:14:::
```

### 4. Lock Ryan's password

**Commands:**
```bash
usermod -L ryan
```

**Verify:**
```bash
cat /etc/shadow
```

**Expected output:**
```text
ryan:!$y$j9T$Qe6q6.G8G0qdJO8.8X4ka/$NGXm2x8riDwwqU8h1S1yx4IMBmZdicEzBMlPpmOwXD3:20774:2:30:7::20892:
```

### 5. Change Sophia's login shell to `/bin/bash`

**Commands:**
```bash
usermod -s /bin/bash sophia
```

**Verify:**
```bash
cat /etc/passwd
```

**Expected output:**
```text
sophia:x:1011:3001::/home/sophia:/bin/bash
```

**Requirement:** Verify the final account configuration, password lock states, and login shells.

---

## Task 7: User Deletion and Ownership

Perform the following tasks.

### 1. Create the directory `/srv/project-data`

**Commands:**
```bash
mkdir -p /srv/project-data
```

### 2. Create the file `/srv/project-data/notes.txt`

**Commands:**
```bash
touch /srv/project-data/notes.txt
```

### 3. Change ownership of the directory and its contents

Change ownership to `david:softdevs`.

**Commands:**
```bash
chown david:softdevs /srv/project-data/notes.txt
```

### 4. Delete David's account but preserve his home directory

**Commands:**
```bash
userdel david
```

### 5. Verify the following requirements

#### David no longer exists as a local user

**Commands:**
```bash
tail -n 3 /etc/passwd
```

**Expected output:**
```text
emma:x:1009:3001::/home/emma:/bin/bash
ryan:x:1010:3002::/home/ryan:/bin/bash
sophia:x:1011:3001::/home/sophia:/bin/bash
```

#### David's home directory remains

**Commands:**
```bash
ls -lR /home/david
```

**Expected output:**
```text
/home/david:
total 0
```

#### `/srv/project-data/notes.txt` still exists

**Commands:**
```bash
ls -l /srv/project-data/notes.txt
```

**Expected output:**
```text
-rw-r--r--. 1 1012 softdevs 0 Nov 17 22:22 /srv/project-data/notes.txt
```

#### The file retains its original numeric UID and GID

**Commands:**
```bash
ls -ln /srv/project-data/notes.txt
```

**Expected output:**
```text
-rw-r--r--. 1 1012 3001 0 Nov 17 22:22 notes.txt
```

**Final requirements:**
- David's local user account must no longer exist.
- His home directory must remain intact.
- The project directory and file must retain the intended ownership.
- The file must retain its original numeric UID and GID after David's account is deleted.

