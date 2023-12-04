import { query } from '/scripts/Fetch.js'

const register = document.getElementById('btRegister');

register.onclick = async () => {
  const name = document.getElementById('name').value;
  const nickname = document.getElementById('nickname').value;
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;
  

    const allProducts = await query(
      
      `create_user?username=${name}&alias=${nickname}&correo=${email}&pswd=${password}`,
      null , 'POST'
    )
  console.log(allProducts)

}
