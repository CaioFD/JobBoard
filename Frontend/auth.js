// Shared by every page with the header: keeps the login token and swaps Login/Register for Profile/Logout
const API_URL = "http://127.0.0.1:8000";

function getToken() {
  return localStorage.getItem("token");
}

function getUser() {
  return JSON.parse(localStorage.getItem("user"));
}

function logout() {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
  location.href = "../login/login.html";
}

// fetch that sends the token; an expired or invalid token sends the user back to the login page
async function apiFetch(path, options = {}) {
  let response = await fetch(API_URL + path, {
    ...options,
    headers: { ...options.headers, Authorization: "Bearer " + getToken() }
  });
  if (response.status === 401) logout();
  return response;
}

if (getToken()) {
  const loginBtn = document.getElementById("login_btn");
  const registerBtn = document.getElementById("Register_btn");
  loginBtn.textContent = "Profile";
  loginBtn.onclick = () => location.href = "../Profile/profile.html";
  registerBtn.textContent = "Logout";
  registerBtn.onclick = logout;
}
