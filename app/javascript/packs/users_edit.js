const user = document.getElementById('user').value

history.replaceState('', '', `/users/${user}/edit`)
require("../packs/users_edit")
