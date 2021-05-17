/*
Михайлов Илья
Лабораторная работа №4
«Исследование и создание семантических сетей»
Вариант 7

Представить данные  в виде  семантической  сети. Написать программу, которая отвечала бы на вопрос пользователя.
Вопрос, заданный на естественном  языке, представить в виде фрагмента семантической сети и написать программу поиска этого фрагмента в заданной семантической сети.
Вопрос и данные выбираются по варианту задания. 

Построить семантическую модель (сеть) представления знаний в предметной области «Университет» (учебный процесс). 
*/

//Класс человека
class Human {
    constructor(name) {
        this.name = name;
        this.className = "Человек";
      }
    
    getName() {
        return this.name;
    }
}

//Класс студента
class Student extends Human {
    constructor(name, faculty) {
        super(name);
        this.className = "Студент";
        this.faculty= faculty;
    }
    
    getName() {
        return this.name;
    }

    getInfo() {
           return `${this.name} - это ${this.className}, который учится на ${this.faculty.getName()}е`;
    }
}
     
//Класс преподователя    
class Lecturer extends Human {
    constructor(name) {
        super(name);
        this.className = "Преподователь";
    }
    
    getName() {
        return this.name;
    }

    getInfo() {
        return `${this.name} - это ${this.className}`;
    }
}

//Класс факультета
class Faculty {
    constructor(name) {
        this.name = name;
        this.className = "Факультет";
    }

    getName() {
            return this.name;
    }

    getInfo() {
        return `${this.name} - это ${this.className}`;
    }
}

//Класс оценки
class Appraisals {
    constructor(value,lesson,student) {
        this.value=value;
        this.lesson=lesson;
        this.student=student;
        this.className = "оценка";
    }

    getName() {
            return this.value;
    }

    getInfo() {
        return `${this.value} - это ${this.className}, которую поставили за ${this.lesson.getName()} студенту ${this.student.getName()}`;
    }
}

//Класс пара
class Lesson {
    constructor(name,lecturer) {
        this.name = name;
        this.lecturer=lecturer;
        this.className = "пара";
    }

    getName() {
            return this.name;
    }

    getInfo() {
        return `${this.name } - это ${this.className}, который ведёт ${this.lecturer.getName()}`;
    }
    
    
}

(async function main() {
    
    let Philology = new Faculty ("Филфак");
    let Matfak = new Faculty ("Матфак");

    let New = new Lecturer ("Новый В.В");
    let Old = new Lecturer ("Старый З.У");

    let DBMS = new Lesson ("СУБД",New);
    let German = new Lesson ("Немецкий язык",Old);

    let Kris = new Student ("Кристина П.К", Matfak);
    let Vas = new Student ("Василий Д.К", Philology);

    let Nine = new Appraisals ("9",DBMS,Kris);
    let Six = new Appraisals ("6",German,Vas);


    console.log(Six.getInfo());
    console.log(Kris.getInfo());
    console.log(German.getInfo());


})();