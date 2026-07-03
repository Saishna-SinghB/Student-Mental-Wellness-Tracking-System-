<?php
session_start();
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once 'db.php';

$action = $_GET['action'] ?? '';

match($action) {
    'register' => handleRegister($pdo),
    'login'    => handleLogin($pdo),
    'logout'   => handleLogout(),
    'me'       => handleMe($pdo),
    default    => jsonResponse(false, 'Invalid action.')
};

// HELPERS 

function jsonResponse(bool $success, string $message, array $data = []): void {
    echo json_encode(['success' => $success, 'message' => $message, 'data' => $data]);
    exit;
}

function sanitize(string $value): string {
    return htmlspecialchars(strip_tags(trim($value)));
}

// REGISTER 

function handleRegister(PDO $pdo): void {
    $full_name      = sanitize($_POST['full_name'] ?? '');
    $student_number = sanitize($_POST['student_number'] ?? '');
    $email          = sanitize($_POST['email'] ?? '');
    $password       = $_POST['password'] ?? '';

    if (empty($full_name) || empty($student_number) || empty($email) || empty($password)) {
        jsonResponse(false, 'Make sure you do not leave an empty field.');
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        jsonResponse(false, 'Invalid email address.');
    }

    if (strlen($password) < 8) {
        jsonResponse(false, 'Password must be at least 8 characters long.');
    }

    // Check if email already exists
    $stmt = $pdo->prepare('SELECT user_id FROM users WHERE email = ?');
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        jsonResponse(false, 'An account with this email already exists.');
    }

    // Check if student number already exists
    $stmt = $pdo->prepare('SELECT user_id FROM users WHERE student_number = ?');
    $stmt->execute([$student_number]);
    if ($stmt->fetch()) {
        jsonResponse(false, 'This student number is already registered.');
    }

    $password_hash = password_hash($password, PASSWORD_BCRYPT);

    $stmt = $pdo->prepare('
        INSERT INTO users (full_name, student_number, email, password_hash, role_id)
        VALUES (?, ?, ?, ?, 1)
    ');
    $stmt->execute([$full_name, $student_number, $email, $password_hash]);

    jsonResponse(true, 'Registration successful. You can now log in.');
}

// LOGIN 

function handleLogin(PDO $pdo): void {
    $email    = sanitize($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($email) || empty($password)) {
        jsonResponse(false, 'Email and password are required.');
    }

    $stmt = $pdo->prepare('
        SELECT u.user_id, u.full_name, u.email, u.password_hash, r.role_name
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        WHERE u.email = ?
    ');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($password, $user['password_hash'])) {
        jsonResponse(false, 'Invalid email or password.');
    }

    $_SESSION['user_id']   = $user['user_id'];
    $_SESSION['full_name'] = $user['full_name'];
    $_SESSION['email']     = $user['email'];
    $_SESSION['role']      = $user['role_name'];

    $session_id = session_id();
    $expires_at = date('Y-m-d H:i:s', strtotime('+2 hours'));

    $stmt = $pdo->prepare('
        INSERT INTO sessions (session_id, user_id, expires_at)
        VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE expires_at = ?
    ');
    $stmt->execute([$session_id, $user['user_id'], $expires_at, $expires_at]);

    jsonResponse(true, 'Login successful.', [
        'full_name' => $user['full_name'],
        'role'      => $user['role_name']
    ]);
}

//  LOGOUT 

function handleLogout(): void {
    session_destroy();
    jsonResponse(true, 'Logged out successfully.');
}

// ME

function handleMe(PDO $pdo): void {
    if (empty($_SESSION['user_id'])) {
        jsonResponse(false, 'Not logged in.');
    }

    jsonResponse(true, 'Authenticated.', [
        'full_name' => $_SESSION['full_name'],
        'email'     => $_SESSION['email'],
        'role'      => $_SESSION['role']
    ]);
}
