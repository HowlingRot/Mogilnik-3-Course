function app_profile(s, f) {
var j;
	for (j = s; j <= f; j++) {
		var u_id = Math.floor(Math.random()*(1000000 - 1 + 1)) + 1;

		var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
		var charactersLength = characters.length;
		var name = '';
		for (var i = 0; i < 10; i++ ) {
			name += characters.charAt(Math.floor(Math.random() * charactersLength));
		}

		var ph = 'A:\Foto\Downloaded\NmiVMyIwFnE';
		ph += j + '.jpg';

		var value = Math.floor(Math.random()*2)+1;
		if (value == 1)
			s = 'М';
		else if (value == 2)
			s = 'Ж';
	

		var year = Math.floor(Math.random()*(2002-1965+1)) + 1965;
		var month = Math.floor(Math.random()*(12-1+1)) + 1;
		var day = Math.floor(Math.random()*(30-1+1)) + 1;
		
		if (month < 10)
			month = '0' + month;
		if (day < 10)
			day = '0' + day;
		
		DoB = year + '-' + month + '-' + day;

		var profession = Math.floor(Math.random()*4)+1;
		if (profession == 1)
			p = 'designer';
		else if (profession == 2)
			p = 'programmer';
		else if (profession == 3)
			p = 'screenwriter';
		else if (profession == 4)
			p = 'editor';

		db.profiles.insert([{user_id: u_id, nickname: name, photo: ph, sex: s, birth_date:ISODate(DoB), dossier: name, profession: p}])
	}
}
