function app_adv(s, f) {
var j;
	for (j = s; j <= f; j++) {
		var u_id = Math.floor(Math.random()*(1000000 - 1 + 1)) + 1;

		var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
		var charactersLength = characters.length;
		var name = '';
		for (var i = 0; i < 10; i++ ) {
			name += characters.charAt(Math.floor(Math.random() * charactersLength));
		}

		var ph = 'D:\5_sem\DB\Lab_7\photo1';
		ph += j + '.jpg';

		var value = Math.floor(Math.random()*2)+1;
		if (value == 1)
			s = 'Male';
		else if (value == 2)
			s = 'Female';
	

		var year = Math.floor(Math.random()*(2002-1965+1)) + 1965;
		var month = Math.floor(Math.random()*(12-1+1)) + 1;
		var day = Math.floor(Math.random()*(30-1+1)) + 1;
		
		if (month < 10)
			month = '0' + month;
		if (day < 10)
			day = '0' + day;
		
		DoB = year + '-' + month + '-' + day;

		var genre = Math.floor(Math.random()*5)+1;
		if (genre == 1)
			g = 'anime';
		else if (genre == 2)
			g = 'fantasy';
		else if (genre == 3)
			g = 'romance';
		else if (genre == 4)
			g = 'horror';
		else if (genre == 5)
			g = 'advanture';

		db.advertisements.insert([{_id: u_id, preview: ph, atext: name,creator_id:u_id}])
	}
}
