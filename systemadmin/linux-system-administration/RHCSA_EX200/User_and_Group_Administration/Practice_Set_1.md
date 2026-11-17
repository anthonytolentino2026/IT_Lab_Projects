
# RHCSA EX200 Exam Practice Set 1

## Task 1: Create a Group

Create a group named `webadmins`.

**Syntax:**
```bash
groupadd [GROUP-NAME]
```

**Commands:**
```bash
groupadd webadmins
```

**Verify:**
```bash
cat /etc/group
```

---

## Task 2: Create User Alex

Create a user named `alex` with `/bin/bash` as the login shell.

**Syntax:**
```bash
useradd -m -s /path/to/shell [USER]
```

**Commands:**
```bash
useradd -m -s /bin/bash alex
```

**Verify:**
```bash
cat /etc/passwd
```

---

## Task 3: Create User Marcus

Create a user named `marcus` with `/bin/bash` as the login shell.

**Syntax:**
```bash
useradd -m -s /path/to/shell [USER]
```

**Commands:**
```bash
useradd -m -s /bin/bash marcus
```

**Verify:**
```bash
cat /etc/passwd
```

---

## Task 4: Configure Supplementary Group Memberships

Add both users to the supplementary group `webadmins`.

**Syntax:**
```bash
usermod -aG [GROUP] [USER]
```

**Commands:**
```bash
usermod -aG webadmins alex
usermod -aG webadmins marcus
```

**Verify:**
```bash
cat /etc/group
```

---

## Task 5: Configure Password Expiration for Alex

Configure `alex` so that the password expires after 30 days.

**Syntax:**
```bash
passwd --maxdays [NUMBER] [USER]
```

**Commands:**
```bash
passwd --maxdays 30 alex
```

**Verify:**
```bash
chage -l alex
```

---

## Task 6: Force Marcus to Change His Password at Next Login

Configure `marcus` so that the account requires a password change at the next login.

**Syntax:**
```bash
chage -d 0 [USER]
```

**Commands:**
```bash
chage -d 0 marcus
```

**Verify:**
```bash
chage -l marcus
```

**Expected output:**
```text
Last password change                    : password must be changed
Password expires                        : password must be changed
Password inactive                       : password must be changed
```

---

## Task 7: Set Valid Passwords for Both Accounts

Ensure both accounts have valid passwords.

**Syntax:**
```bash
passwd [USER]
passwd -S [USER]
```

**Commands:**
```bash
passwd alex
passwd marcus
```

Enter and confirm a new password for each account.

**Verify:**
```bash
passwd -S alex
passwd -S marcus
```

**Expected result:**

The password status should indicate `P` (password set) in the password status column.

---

## Final Requirements

- Both users must remain local accounts.
- Both users must belong to the supplementary group `webadmins`.
- Alex's password must expire after 30 days.
- Marcus must be required to change his password at the next login.
- Both accounts must have valid passwords.

