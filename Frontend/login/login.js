const form = document.getElementById("login_form");
const message = document.getElementById("form_message");

if (new URLSearchParams(location.search).has("registered")) {
  message.textContent = "Account created! You can now log in.";
  message.classList.add("success");
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();
  message.classList.remove("success");
  message.textContent = "";
  try {
    let response = await fetch("http://127.0.0.1:8000/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: form.email.value, password: form.password.value })
    });
    let data = await response.json();
    if (!response.ok) {
      message.textContent = data.detail;
      return;
    }
    localStorage.setItem("token", data.token);
    localStorage.setItem("user", JSON.stringify({ email: data.email, role: data.role }));
    location.href = "../home_page/home_page.html";
  } catch (error) {
    message.textContent = "Could not reach the server. Is the backend running?";
  }
});
