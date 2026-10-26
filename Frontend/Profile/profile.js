if (!getToken()) location.href = "../login/login.html";

const profileForm = document.getElementById("profile_form");
const cvForm = document.getElementById("cv_form");
const profileMessage = document.getElementById("profile_message");
const cvMessage = document.getElementById("cv_message");
const viewCvBtn = document.getElementById("view_cv");

function showMessage(element, text, success = false) {
  element.textContent = text;
  element.classList.toggle("success", success);
}

// FastAPI sends a text for our own errors, and a list when a field has the wrong format
function errorText(data) {
  return typeof data.detail === "string" ? data.detail : "Please check the fields and try again.";
}

function showAge(age) {
  document.getElementById("age").textContent = age === null ? "" : `Age: ${age} years`;
}

function showCv(hasCv) {
  document.getElementById("cv_status").textContent = hasCv ? "CV uploaded" : "No CV uploaded yet";
  viewCvBtn.hidden = !hasCv;
}

async function loadProfile() {
  try {
    let response = await apiFetch("/api/profile");
    let data = await response.json();
    document.getElementById("email").value = data.email;
    profileForm.full_name.value = data.full_name ?? "";
    profileForm.birth_date.value = data.birth_date ?? "";
    showAge(data.age);
    showCv(data.has_cv);
  } catch (error) {
    showMessage(profileMessage, "Could not reach the server. Is the backend running?");
  }
}

profileForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  try {
    let response = await apiFetch("/api/profile", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ full_name: profileForm.full_name.value, birth_date: profileForm.birth_date.value })
    });
    let data = await response.json();
    if (!response.ok) {
      showMessage(profileMessage, errorText(data));
      return;
    }
    showMessage(profileMessage, "Profile saved!", true);
    showAge(data.age);
  } catch (error) {
    showMessage(profileMessage, "Could not reach the server. Is the backend running?");
  }
});

cvForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  let file = cvForm.cv.files[0];
  if (file.size > 5 * 1024 * 1024) {
    showMessage(cvMessage, "The CV must be 5 MB or less");
    return;
  }
  try {
    let response = await apiFetch("/api/profile/cv", {
      method: "PUT",
      headers: { "Content-Type": "application/pdf" },
      body: file
    });
    let data = await response.json();
    if (!response.ok) {
      showMessage(cvMessage, errorText(data));
      return;
    }
    showMessage(cvMessage, "CV uploaded!", true);
    showCv(true);
    cvForm.reset();
  } catch (error) {
    showMessage(cvMessage, "Could not reach the server. Is the backend running?");
  }
});

viewCvBtn.addEventListener("click", async () => {
  // open the tab before the await, otherwise the browser blocks it as a popup
  let tab = window.open("", "_blank");
  let response = await apiFetch("/api/profile/cv");
  if (!response.ok) {
    tab.close();
    showMessage(cvMessage, "Could not load your CV");
    return;
  }
  tab.location = URL.createObjectURL(await response.blob());
});

loadProfile();
