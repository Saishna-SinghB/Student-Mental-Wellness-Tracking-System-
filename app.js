

function goTo(page) {
  window.location.href = page;
}

function showError(fieldId, message) {
  const el = document.getElementById(fieldId + "-error");
  if (el) el.textContent = message || "";
}

function validateRegisterForm(event) {
  event.preventDefault();
  let valid = true;

  const fullName = document.getElementById("fullName").value.trim();
  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value;
  const confirmPassword = document.getElementById("confirmPassword").value;
  const popiaChecked = document.getElementById("popiaAgree").checked;

  showError("fullName", "");
  showError("email", "");
  showError("password", "");
  showError("confirmPassword", "");
  showError("popiaAgree", "");

  if (!fullName) {
    showError("fullName", "Please enter your full name.");
    valid = false;
  }
  if (!/^[^\s@]+@richfield\.ac\.za$/i.test(email)) {
    showError("email", "Please use your Richfield university email.");
    valid = false;
  }
  if (password.length < 8) {
    showError("password", "Password must be at least 8 characters.");
    valid = false;
  }
  if (confirmPassword !== password) {
    showError("confirmPassword", "Passwords do not match.");
    valid = false;
  }
  if (!popiaChecked) {
    showError("popiaAgree", "You must agree to the POPIA Privacy Policy.");
    valid = false;
  }

  if (valid) {
    goTo("dashboard.html");
  }
  return false;
}

function validateLoginForm(event) {
  event.preventDefault();
  let valid = true;

  const email = document.getElementById("loginEmail").value.trim();
  const password = document.getElementById("loginPassword").value;

  showError("loginEmail", "");
  showError("loginPassword", "");

  if (!/^[^\s@]+@richfield\.ac\.za$/i.test(email)) {
    showError("loginEmail", "Please use your Richfield university email.");
    valid = false;
  }
  if (!password) {
    showError("loginPassword", "Please enter your password.");
    valid = false;
  }

  if (valid) {
    goTo("dashboard.html");
  }
  return false;
}

function biometricLogin() {
  alert("Biometric login is not yet implemented - coming in a later sprint.");
}
