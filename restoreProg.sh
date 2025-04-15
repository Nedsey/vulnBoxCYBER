#!/bin/bash

pass1="ZmlyZQ=="
pass2="bW9vbg=="
pass3="dHJlZQ=="
pass4="c25vdw=="
pass5="Ym9vaw=="
pass6="d2luZA=="

echo "Enter the chapter number to recover (1-6):"
read chapter

verify_password() {
  echo "Enter the teacher passkey for Chapter $1:"
  read -s input_pass
  decoded_pass=$(echo "${!2}" | base64 -d)
  if [ "$input_pass" != "$decoded_pass" ]; then
    echo "Incorrect passkey. Exiting."
    exit 1
  fi
}

if [ "$chapter" -ge 1 ]; then
  verify_password 1 pass1
  sudo systemctl start apache2
  cd /var/www/html
fi

if [ "$chapter" -ge 2 ]; then
  verify_password 2 pass2
  echo "<h1>HELLO WORLD!!!</h1>" | sudo tee /var/www/html/index.html >/dev/null
fi

if [ "$chapter" -ge 3 ]; then
  verify_password 3 pass3
  sudo tee /var/www/html/index.html >/dev/null <<EOF
<h1>Login Page</h1>
<h2>Please provide your username & password.</h2>
<form action="/bouncer.php" method="POST">
<div>
<label for="name">Username:</label>
<input type="text" name="name" id="name" required />
</div>
<div>
<label for="password">Password:</label>
<input type="password" name="password" id="password" required />
</div>
<div>
<input type="submit" value="Log In" />
</div>
</form>
EOF
fi

if [ "$chapter" -ge 4 ]; then
  verify_password 4 pass4
  sudo apt update -y && sudo apt install php libapache2-mod-php -y
  sudo systemctl restart apache2
  sudo touch /var/www/html/bouncer.php
fi

if [ "$chapter" -ge 5 ]; then
  verify_password 5 pass5
  sudo mkdir -p /var/www/db
  sudo sqlite3 /var/www/db/users.db <<EOF
CREATE TABLE users (username TEXT, password TEXT);
INSERT INTO users VALUES ('alice', 'password123');
INSERT INTO users VALUES ('bob', 'hunter2');
INSERT INTO users VALUES ('charlie', 'lemon');
EOF
fi

if [ "$chapter" -ge 6 ]; then
  verify_password 6 pass6
  sudo touch /var/www/html/secretPage.php
  sudo touch /var/www/html/denied.php
fi

echo "Recovery complete up to Chapter $chapter."
