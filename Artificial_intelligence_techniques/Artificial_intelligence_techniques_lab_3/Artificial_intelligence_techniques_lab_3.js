/*
Михайлов Илья
Лабораторная работа №3
«ФРЕЙМОВАЯ МОДЕЛЬ ПРЕДСТАВЛЕНИЯ ЗНАНИЙ»

Для выбранной самостоятельно предметной области разработать фреймы в виде взаимосвязанных таблици сложной иерархической структуры.
*/

//Фрейм человека
class Human{
    constructor(minHeigh,maxHeign,lifeLength){
        this.minHeigh = minHeigh;
        this.maxHeign = maxHeign;
        this.lifeLength = lifeLength;
    }
} 

//Фрейм негроидной расы
class negroidRace extends Human{
    constructor(minHeigh,maxHeign,lifeLength,typeHair,epicanthus){
        super(minHeigh,maxHeign,lifeLength);
        this.typeHair = typeHair;
        this.epicanthus = epicanthus;
    }
} 

//Фрейм европеоидной расы
class europeanRace extends Human{
    constructor(minHeigh,maxHeign,lifeLength,typeHair){
        super(minHeigh,maxHeign,lifeLength);
        this.typeHair = typeHair;
    }
} 

//Фрейм монголоидной расы
class mongolianRace extends Human{
    constructor(minHeigh,maxHeign,lifeLength,typeHair){
        super(minHeigh,maxHeign,lifeLength);
        this.typeHair = typeHair;
        this.epicanthus = epicanthus;
    }
} 

//Фрейм азиатского подтипа
class asianSubtype extends mongolianRace{
    constructor(minHeigh,maxHeign,lifeLength,typeHair,epicanthus,skull,lactoseTolerance){
        super(minHeigh,maxHeign,lifeLength,typeHair,epicanthus);
        this.skull = skull;
        this.lactoseTolerance = lactoseTolerance;
    }
} 

//Фрейм американского подтипа
class americanSubtype extends mongolianRace{
    constructor(minHeigh,maxHeign,lifeLength,typeHair,epicanthus,skull,lactoseTolerance){
        super(minHeigh,maxHeign,lifeLength,typeHair,epicanthus);
        this.skull = skull;
        this.lactoseTolerance = lactoseTolerance;
    }
} 

//Фрейм нордического подтипа
class nordicSubtype extends europeanRace{
    constructor(minHeigh,maxHeign,lifeLength,typeHair,skull,lactoseTolerance){
        super(minHeigh,maxHeign,lifeLength,typeHair);
        this.skull = skull;
        this.lactoseTolerance = lactoseTolerance;
    }
} 

//Фрейм восточно-балтийского подтипа
class eastBalticSubtype extends europeanRace{
    constructor(minHeigh,maxHeign,lifeLength,typeHair,skull,lactoseTolerance){
        super(minHeigh,maxHeign,lifeLength,typeHair);
        this.skull = skull;
        this.lactoseTolerance = lactoseTolerance;
    }
} 

//Фрейм негрского подтипа
class negroSubtype extends negroidRace{
    constructor(minHeigh,maxHeign,lifeLength,typeHair,epicanthus,skull,lactoseTolerance){
        super(minHeigh,maxHeign,lifeLength,typeHair,epicanthus);
        this.skull = skull;
        this.lactoseTolerance = lactoseTolerance;
    }
} 

//Фрейм южноафриканского подтипа
class southAfricanSubtype extends negroidRace{
    constructor(minHeigh,maxHeign,lifeLength,typeHair,epicanthus,skull,lactoseTolerance){
        super(minHeigh,maxHeign,lifeLength,typeHair,epicanthus);
        this.skull = skull;
        this.lactoseTolerance = lactoseTolerance;
    }
} 

let aboba = new southAfricanSubtype(1,1,1,1,1,1,1)
console.log(aboba)