//Михайлов Илья 31гр
//Лабораторная №1
//Выборка данных в MongoDB
//Задание. Для своей предметной области, разработать набор запросов на выборку данных.
//Все запросы должны быть написаны с использованием Аggregation framework и используя стандартные методы. К каждому запросу добавить комментарий ($comment).


//Создаём базу данных

//roles
db.createCollection("roles")

db.roles.insert([
  {_id:"1","position":"administrator"},
  {_id:"2","position":"manager"},
  {_id:"3","position":"user"}
  ])

//users
db.createCollection("users")

db.users.insert([
{ _id : 300 ,"login" : "persona1", "password" : "1111", "email" : "guzlo@mail.ru", "role_id" : 1},
{ _id : 301 ,"login" : "persona2", "password" : "2222", "email" : "fuflo@yandex.ru","role_id" : 2},
{ _id : 302 ,"login" : "persona3", "password" : "3333", "email" : "zrat@bk.ru","role_id" : 3}
])

//advertisements
db.createCollection("advertisements")

db.advertisements.insert([
{ _id : "600", "preview" : "A:\Foto\Downloaded\NmiVMyIwFnE.jpg", "atext" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard", "tags" : ["book","food","Orsha"],"creator_id": 301},
{ _id : "601", "preview" : "No", "atext" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard", "tags" : ["manga","anime"], "creator_id": 301},
{ _id : "602", "preview" : "No", "atext" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard", "tags" : ["book","travels"], "creator_id": 300}
])

//profiles
db.createCollection("profiles")

db.profiles.insert([
{ user_id : "500", "nickname" : "Fima", "foto" : "A:\Foto\Downloaded\NmiVMyIwFnE1.jpg", "sex" : "М", "birth_day" : ISODate("2001-08-17"), "dossier" : "text1", "hobbies" : ["book","food","Orsha"], "profession" : "designer"},
{ user_id : "501", "nickname" : "Ivan", "foto" : "A:\Foto\Downloaded\NmiVMyIwFnE2.jpg", "sex" : "M", "birth_day" : ISODate("2005-03-07"), "dossier" : "text2", "hobbies" : ["manga","anime"], "profession" : "programmer"},
{ user_id : "502", "nickname" : "Polina", "foto" : "A:\Foto\Downloaded\NmiVMyIwFnE3.jpg", "sex" : "Ж", "birth_day" : ISODate("2000-04-25"), "dossier" : "text3", "hobbies" : ["book","travels"], "profession" : "screenwriter"}
])

//messages
db.createCollection("messages")

db.messages.insert([
{ _id : "700" ,"mtext" : "Привет", "sender_id" : 301,"receiver_id" : 300, "create_at" : new Date()},
{ _id : "701" ,"mtext" : "Как дела?", "sender_id" : 302,"receiver_id" : 301, "create_at" : new Date()},
{ _id : "702" ,"mtext" : "Мде", "sender_id" : 300,"receiver_id" : 302, "create_at" : new Date()}
])


//1.Выборка всех данных, фильтрация по конкретному полю, массиву, встроенному объекту.

db.users.find({$comment: "Выборка всех данных"}).pretty()

db.profiles.find({profession:"programmer", $comment: "Выборка по конкретному полю"}).pretty()

db.profiles.find({hobbies:"anime", $comment: "Выборка по массиву"}).pretty()

db.advertisements.find({"preview":"A:\Foto\Downloaded\NmiVMyIwFnE.jpg", $comment: "Выборка по встроенному объекту"}).pretty()

//2.Выборка в интервале, выборка из заданного списка значений.

db.profiles.find({birth_day:{$gt:ISODate("2000-04-25"), $lte: ISODate("2003-04-25")}, $comment: "Выборка в интервале"}).pretty()

db.profiles.find({nickname: {$in:["Fima", "Jack"]},$comment: "Выборка из заданного списка значений"}).pretty()

//3.Выборка с использованием регулярных выражений.

db.profiles.find({"nickname":{$regex:"ma"}, $comment: "Выборка с использованием регулярных выражений"}).pretty()

//4.Выборка данных за конкретный период времени, на сегодняшний день, за последний месяц.

db.messages.find({"create_at": {$gte: new Date(ISODate("2021-01-01")), $lte: new Date(ISODate("2021-15-01"))}, $comment: "Выборка в интервале"}).pretty()

db.messages.find({"create_at": {$gte: new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate(), 0, 0, 0), $lte: new Date()},$comment: "Выборка на сегодняшний день"}).pretty()

db.messages.find({"create_at ": {$gte: new Date(new Date().getFullYear(),new Date().getMonth(), 1, 0, 0, 0), $lt: new Date(new Date().getFullYear(),new Date().getMonth()+1, 1, 0, 0, 0)}, $comment: "Выборка за последний месяц"}).pretty()

//5.Выборка данных из нескольких таблиц.

db.users.aggregate([{$lookup: {from: "advertisements", localField: "_id", foreignField: "creator_id", as: "new_table"}}], {comment: "Выборка данных из нескольких таблиц"}).pretty()

//6. Выборка из нескольких таблиц с фильтрацией.

db.users.aggregate([{$lookup: {from: "advertisements", localField: "_id", foreignField: "creator_id", as: "new_table"}}, {$match: { "_id": 300}}], {comment: "Выборка данных из нескольких таблиц c фильтрацией"}).pretty()

//7. Выборка ограниченного набора полей.

db.users.find({},{role_id: 1}).pretty() 

//8. Сортировка по 1 полю, по нескольким полям.

db.users.find({$comment: "Сортировка по 1 полю"}).sort({role_id: -1}).pretty()

db.messages.find({$comment: "Сортировка по нескольким полям"}).sort({sender_id: 1,receiver_id:-1}).pretty()

//9. Вывод данных с n-ого по m-ый номер.

db.profiles.find({$comment: "Выборка  с n-ого по m-ый номер"}).skip(1).limit(5).pretty()

//10. Написать запрос, который объединяет 1-9 пункты.

db.profiles.aggregate([{$match: {"birth_day": {$gte: ISODate("2000-01-01"), $lte: ISODate("2004-01-01")}}}, {$limit:5}, {$project:{tags: 1}}, {$sort: {"user_id": -1}}]).pretty()

