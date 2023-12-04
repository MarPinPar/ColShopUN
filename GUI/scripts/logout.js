import { query } from '/scripts/Fetch.js'

window.onload = async (event) => {
    await query(
        `logout_user`,
        null, 'POST'
    );

    localStorage.removeItem('token');

    window.location.href = '/pages/login.html';
};