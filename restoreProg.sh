#!/bin/bash

declare -A CODES
CODES[1]="dare"
CODES[2]="quiz"
CODES[3]="hazy"
CODES[4]="yuzu"
CODES[5]="jaws"
CODES[6]="puck"

echo "Choose chapter to restore progress up to (1-6): "
read CHAPTER

if [[ "$CHAPTER" -lt 1 || "$CHAPTER" -gt 6 ]]; then
  echo "Invalid chapter number."
  exit 1
fi

echo -n "Enter teacher code for Chapter $CHAPTER: "
read -s INPUT_CODE
echo

if [[ "${CODES[$CHAPTER]}" != "$INPUT_CODE" ]]; then
  echo "❌ Incorrect code. Access denied for Chapter $CHAPTER."
  exit 1
fi

echo "✅ Code accepted. Restoring Chapter $CHAPTER..."

sudo systemctl start apache2
cd /var/www/html || exit

if [[ $CHAPTER -ge 1 ]]; then
  echo "[1] Creating hello world page..."
  echo '<h1>HELLO WORLD!!!</h1>' | sudo tee index.html > /dev/null
fi

if [[ $CHAPTER -ge 2 ]]; then
  echo "[2] Creating login form..."
  cat <<EOF | sudo tee index.html > /dev/null
<h1>Login Page</h1>
<h2>Please provide your username & password.</h2>
<form action="/bouncer.php" method="POST" class="form-example"> 
  <div class="form-example">
    <label for="name">Username:</label>
    <input type="text" name="name" id="name" required />
  </div>
  <div class="form-example">
    <label for="password">Password:</label>
    <input type="password" name="password" id="password" required />
  </div>
  <div class="form-example">
    <input type="submit" value="Log In" />
  </div>
</form>
EOF
fi

if [[ $CHAPTER -ge 3 ]]; then
  echo "[3] Installing PHP..."
  sudo apt update -y && sudo apt install php libapache2-mod-php -y
  sudo systemctl restart apache2
  sudo touch bouncer.php
fi

if [[ $CHAPTER -ge 4 ]]; then
  echo "[4] Creating SQLite DB and inserting users..."
  sudo mkdir -p /var/www/db
  cd /var/www/db || exit
  sudo sqlite3 users.db <<EOF
CREATE TABLE users (username TEXT, password TEXT);
INSERT INTO users VALUES ('alice', 'password123');
INSERT INTO users VALUES ('bob', 'hunter2');
INSERT INTO users VALUES ('charlie', 'lemon');
EOF
fi

if [[ $CHAPTER -ge 5 ]]; then
  echo "[5] Creating secretPage and deniedPage..."
  cd /var/www/html || exit
  sudo touch secretPage.php denied.php
fi

if [[ $CHAPTER -ge 6 ]]; then
  echo "[6] Setting up basic PHP logic in bouncer.php..."
  cat <<'EOF' | sudo tee /var/www/html/bouncer.php > /dev/null
<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["name"];
    $password = $_POST["password"];

    $db = new SQLite3('/var/www/db/users.db');
    $stmt = $db->prepare('SELECT * FROM users WHERE username = :username AND password = :password');
    $stmt->bindValue(':username', $username, SQLITE3_TEXT);
    $stmt->bindValue(':password', $password, SQLITE3_TEXT);
    $result = $stmt->execute();

    if ($result->fetchArray()) {
        header("Location: /secretPage.php");
    } else {
        header("Location: /denied.php");
    }
    exit();
}
?>
EOF
fi

echo "[✓] Chapter $CHAPTER restored successfully."
