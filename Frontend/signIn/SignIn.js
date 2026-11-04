const form = document.getElementById("register_form");
const message = document.getElementById("form_message");

form.addEventListener("submit", async (event) => {
  event.preventDefault();
  message.textContent = "";
  try {
    let response = await fetch("/api/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: form.email.value, password: form.password.value })
    });
    let data = await response.json();
    if (!response.ok) {
      message.textContent = data.detail;
      return;
    }
    location.href = "../login/login.html?registered";
  } catch (error) {
    message.textContent = "Could not reach the server. Is the backend running?";
  }
});
