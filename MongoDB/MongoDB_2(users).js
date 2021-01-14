function app_users(s, f) {
var j;
	for (j = s; j <= f; j++) {
		var u_id = Math.floor(Math.random()*(1000000 - 1 + 1)) + 1;

		var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
		var charactersLength = characters.length;
		var name = '';
		for (var i = 0; i < 10; i++ ) {
			name += characters.charAt(Math.floor(Math.random() * charactersLength));
		}

		var role = Math.floor(Math.random()*5)+1;
		if (role == 1)
			r = 1;
		else if (role == 2)
			r = 2;
		else if (role == 3)
			r = 3;

		db.users.insert([{_id: u_id, login: name, password: name, role_id: r}])
	}
}
