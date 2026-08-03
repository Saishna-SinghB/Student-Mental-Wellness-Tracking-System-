

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
 

function initDashboard() {
  checkAuth();
  initMoodCheckin();
}

async function checkAuth() {
  const greetingEl = document.getElementById("userGreeting");

  try {
    const res = await fetch("api.php?action=me");
    const data = await res.json();

    if (data.success) {
      if (greetingEl) greetingEl.textContent = "Welcome back, " + data.data.full_name;
    } else {
      goTo("login.html");
    }
  } catch (err) {
    
    console.warn("Could not verify session:", err);
  }
}

async function logout() {
  try {
    await fetch("api.php?action=logout");
  } catch (err) {
    console.warn("Logout request failed:", err);
  }
  goTo("index.html");
}



let selectedMoodLabel = "Okay";

function initMoodCheckin() {
  const emojiButtons = document.querySelectorAll(".mood-emoji");
  const moodSlider = document.getElementById("moodSlider");
  const stressSlider = document.getElementById("stressSlider");
  const moodScoreValue = document.getElementById("moodScoreValue");
  const stressValue = document.getElementById("stressValue");

  emojiButtons.forEach((btn) => {
    btn.addEventListener("click", () => {
      emojiButtons.forEach((b) => b.classList.remove("selected"));
      btn.classList.add("selected");
      selectedMoodLabel = btn.dataset.label;
      if (moodSlider) {
        moodSlider.value = btn.dataset.score;
        moodScoreValue.textContent = moodSlider.value;
      }
    });
  });

  if (moodSlider) {
    moodSlider.addEventListener("input", () => {
      moodScoreValue.textContent = moodSlider.value;
    });
  }

  if (stressSlider) {
    stressSlider.addEventListener("input", () => {
      stressValue.textContent = stressSlider.value;
    });
  }
}

function submitMoodCheckin() {
  const moodSlider = document.getElementById("moodSlider");
  const stressSlider = document.getElementById("stressSlider");
  const statusEl = document.getElementById("moodStatus");

  const payload = {
    mood_score: Number(moodSlider.value),
    mood_label: selectedMoodLabel,
    stress_level: Number(stressSlider.value),
    date: new Date().toISOString().slice(0, 10)
  };

 
  const history = JSON.parse(localStorage.getItem("moodCheckins") || "[]");
  history.push(payload);
  localStorage.setItem("moodCheckins", JSON.stringify(history));

  if (statusEl) statusEl.textContent = "Mood logged for today. Thanks for checking in!";
}
