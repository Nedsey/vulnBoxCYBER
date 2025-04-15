#!/bin/bash

# Base64-encoded passkeys
pass1="ZmlyZQ=="
pass2="bW9vbg=="
pass3="dHJlZQ=="
pass4="c25vdw=="
pass5="Ym9vaw=="
pass6="d2luZA=="

# Single function to verify passkey for the chosen chapter
verify_password() {
  chapter_num="$1"
  encoded_pass="$2"
  echo "Enter the teacher passkey for Chapter $chapter_num:"
  read -r -s input_pass
  decoded_pass="$(echo -n "$encoded_pass" | base64 --decode)"
  echo
  if [ "$input_pass" != "$decoded_pass" ]; then
    echo "Incorrect passkey. Exiting."
    exit 1
  fi
}

# Steps for each chapter, placed in separate functions for clarity
doChapter1() {
  sudo systemctl start apache2
  cd /var/www/html || exit
}

doChapter2() {
  echo "<h1>HELLO WORLD!!!</h1>" | sudo tee /var/www/html/index.html >/dev/null
}

doChapter3() {
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
}

doChapter4() {
  sudo apt update -y && sudo apt install php libapache2-mod-php -y
  sudo systemctl restart apache2
  sudo touch /var/www/html/bouncer.php
}

doChapter5() {
  sudo mkdir -p /var/www/db
  sudo sqlite3 /var/www/db/users.db <<EOF
CREATE TABLE users (username TEXT, password TEXT);
INSERT INTO users VALUES ('alice', 'password123');
INSERT INTO users VALUES ('bob', 'hunter2');
INSERT INTO users VALUES ('charlie', 'lemon');
EOF
}

doChapter6() {
  sudo touch /var/www/html/secretPage.php
  sudo touch /var/www/html/denied.php
}

# Ask user which chapter they want to recover up to
echo "Enter the chapter number to recover (1-6):"
read -r chapter

case "$chapter" in
  1)
    verify_password 1 "$pass1"
    doChapter1
    ;;
  2)
    verify_password 2 "$pass2"
    doChapter1
    doChapter2
    ;;
  3)
    verify_password 3 "$pass3"
    doChapter1
    doChapter2
    doChapter3
    ;;
  4)
    verify_password 4 "$pass4"
    doChapter1
    doChapter2
    doChapter3
    doChapter4
    ;;
  5)
    verify_password 5 "$pass5"
    doChapter1
    doChapter2
    doChapter3
    doChapter4
    doChapter5
    ;;
  6)
    verify_password 6 "$pass6"
    doChapter1
    doChapter2
    doChapter3
    doChapter4
    doChapter5
    doChapter6
    ;;
  *)
    echo "Invalid chapter. Please pick 1-6."
    exit 1
    ;;
esac

echo "✅ Recovery complete up to Chapter $chapter."
