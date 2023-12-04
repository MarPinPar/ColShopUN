import { query } from '/scripts/Fetch.js'

const login = document.getElementById('btLogIn');

login.onclick = async () => {
  const username = document.getElementById('nam').value;
  const password = document.getElementById('psw').value;

  const loginResponse = await query(
    `token`,
    {
      username: username,
      password: password,
    },
    'POST',
    'application/x-www-form-urlencoded'
  )

  // Save token in localstorage
  const token = loginResponse.access_token;
  localStorage.setItem("token", token);

  // Redirect to home page
  window.location.href = '/index.html';
}