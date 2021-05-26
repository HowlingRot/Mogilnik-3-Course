/*
Михайлов Илья
Лабораторная работа №2
«ПРЕДСТАВЛЕНИЕ ЗНАНИЙ В ВИДЕ ПРАВИЛ»
Вариант 7

Для предметной области сформировать базу знаний.
Компьютерные сети.

Переменные:
1.Тип протокола(protocol) - http\https\ftp\pop3\smtp
2.Вид приложения(application) - браузер\почтовый клиент\загрущик
3.Скорость сети(speed) - высокая\средняя\низкая
4.Тип сети(networkType) - локальная\городская\глобальная
5.Шифрование данных(crypto) - да\нет
6.Топология(topology) - звезда\полносвязная\неполносвязная\смешанная
7.ip-адрес(ip-adress) - внутренний\внешний
8.Постоянность соединения(connectionPersistence) - да\нет
9.Результат(result)

Правила:
1.ЕСЛИ protocol = http, ТО application = браузер
2.ЕСЛИ protocol = pop3 И crypto = нет, ТО result = Пришёл спам
3.ЕСЛИ networkType = городская И topology = звезда, ТО speed = низкая
4.ЕСЛИ application = почтовый клиент И speed = высокая, ТО protocol = smtp
5.ЕСЛИ ip = внутренний, ТО networkType = локальная
6.ЕСЛИ topology = смешанная И ip = внешний, ТО networkType = глобальная
7.ЕСЛИ connectionPersistence = да И crypto = нет, ТО result = устройство под хакерской атакой 
8.ЕСЛИ topology = полносвязная, ТО connectionPersistence = да
9.ЕСЛИ connectionPersistence = да И protocol = ftp, ТО application = загрущик
10.ЕСЛИ application = почтовый клиент И speed = низкая, ТО protocol = pop3
11.ЕСЛИ connectionPersistence = нет И topology = полносвязная, ТО result = есть неполадка в сети
12.ЕСЛИ crypto = да И application = браузер, ТО protocol = https
*/

var readline = require("readline");

var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

async function askParam(paramName) {
    let answer;
    while (!answer) {
      answer = await question(paramName);
    }
    return answer;
}
  
function question(paramName) {
    return new Promise((res, req) => {
      rl.question(`Укажите значение параметра ${paramName}: `, (answer) => {
        res(answer);
      });
    });
}
  
function checkFinishConditions() {
    //Если определён результат
    if (knowledgeBase.result.value) {
      return true;
    }
  
    //Если исключены все правила или не исключено ни одного
    if (rules.length === 0 || rules.length === oldRulesLength) {
      return true;
    }
  
    //Если определены все переменнные
    for (key in knowledgeBase) {
      if (!knowledgeBase[key].value) {
        return false;
      }
    }
  
    return true;
}

function prepareData() {
    knowledgeBase = {
        protocol: {
        name: "protocol",
        value: null,
      },
      application: {
        name: "application",
        value: null,
      },
      speed: {
        name: "speed",
        value: null,
      },
      networkType: {
        name: "networkType",
        value: null,
      },
      crypto: {
        name: "crypto",
        value: null,
      },
      topology: {
        name: "topology",
        value: null,
      },
      ip: {
        name: "ip",
        value: null,
      },
      connectionPersistence: {
        name: "connectionPersistence",
        value: null,
      },
      result: {
        name: "result",
        value: null,
      },
    };
  
    rules.push(rule1);
    rules.push(rule2);
    rules.push(rule3);
    rules.push(rule4);
    rules.push(rule5);
    rules.push(rule6);
    rules.push(rule7);
    rules.push(rule8);
    rules.push(rule9);
    rules.push(rule10);
    rules.push(rule11);
    rules.push(rule12);
}

let knowledgeBase = {};
let rules = [];
let currentParams = [];
let nextIterParams = [];
let factsFromUser = [];
let factsFromRules = [];

let rule1 = {
    name: "rule1",
    conditions: ["protocol"],
    resultVar: "application",
  
    checkCondition(conditionName) {
        if (
        conditionName === "protocol" &&
        knowledgeBase[conditionName].value === "http"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.protocol.value) {
        knowledgeBase.protocol.value = await askParam("protocol");
  
        nextIterParams.push(knowledgeBase.protocol.name);
  
        factsFromUser.push({
          name: knowledgeBase.protocol.name,
          value: knowledgeBase.protocol.value,
        });
      }
      if (
        knowledgeBase.protocol.value == "http"
      ) {
        if (!knowledgeBase.application.value) {
          knowledgeBase.application.value = "браузер";
          nextIterParams.push(knowledgeBase.application.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.application.name,
            value: knowledgeBase.application.value,
          });
          return true;
        }
      }
    },
};

let rule2 = {
    name: "rule2",
    conditions: ["protocol", "crypto"],
    resultVar: "result",
  
    checkCondition(conditionName) {
      if (
        conditionName === "protocol" &&
        knowledgeBase[conditionName].value === "pop3"
      ) {
        return true;
      }
      if (
        conditionName === "crypto" &&
        knowledgeBase[conditionName].value === "нет"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.protocol.value) {
        knowledgeBase.protocol.value = await askParam("protocol");
        nextIterParams.push(knowledgeBase.protocol.name);
  
        factsFromUser.push({
          name: knowledgeBase.protocol.name,
          value: knowledgeBase.protocol.value,
        });
      }
      if (!knowledgeBase.crypto.value) {
        knowledgeBase.crypto.value = await askParam("crypto");
        nextIterParams.push(knowledgeBase.crypto.name);
  
        factsFromUser.push({
          name: knowledgeBase.crypto.name,
          value: knowledgeBase.crypto.value,
        });
      }
      if (
        knowledgeBase.protocol.value == "pop3" &&
        knowledgeBase.crypto.value == "нет"
      ) {
        if (!knowledgeBase.result.value) {
          knowledgeBase.result.value = "Пришёл спам";
          nextIterParams.push(knowledgeBase.result.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.result.name,
            value: knowledgeBase.result.value,
          });
          return true;
        }
      }
    },
};

let rule3 = {
    name: "rule3",
    conditions: ["networkType", "topology"],
    resultVar: "speed",
  
    checkCondition(conditionName) {
      if (
        conditionName === "networkType" &&
        knowledgeBase[conditionName].value === "городская"
      ) {
        return true;
      }
      if (
        conditionName === "topology" &&
        knowledgeBase[conditionName].value === "звезда"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.networkType.value) {
        knowledgeBase.networkType.value = await askParam("networkType");

        nextIterParams.push(knowledgeBase.networkType.name);
  
        factsFromUser.push({
          name: knowledgeBase.networkType.name,
          value: knowledgeBase.networkType.value,
        });
      }
      if (!knowledgeBase.topology.value) {
        knowledgeBase.topology.value = await askParam("topology");
        
        nextIterParams.push(knowledgeBase.topology.name);
  
        factsFromUser.push({
          name: knowledgeBase.topology.name,
          value: knowledgeBase.topology.value,
        });
      }
  
      if (
        knowledgeBase.networkType.value == "городская" &&
        knowledgeBase.topology.value == "звезда"
      ) {
        knowledgeBase.speed.value = "низкая";
        nextIterParams.push(knowledgeBase.speed.name);

        factsFromRules.push({
          name: this.name,
          paramName: knowledgeBase.speed.name,
          value: knowledgeBase.speed.value,
        });
        return true;
      }
    },
};

let rule4 = {
    name: "rule4",
    conditions: ["application", "speed"],
    resultVar: "protocol",
  
    checkCondition(conditionName) {
      if (
        conditionName === "application" &&
        knowledgeBase[conditionName].value === "почтовый клиент"
      ) {
        return true;
      }
      if (
        conditionName === "speed" &&
        knowledgeBase[conditionName].value === "высокая"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.application.value) {
        knowledgeBase.application.value = await askParam("application");
        nextIterParams.push(knowledgeBase.application.name);
  
        factsFromUser.push({
          name: knowledgeBase.application.name,
          value: knowledgeBase.application.value,
        });
      }
      if (!knowledgeBase.speed.value) {
        knowledgeBase.speed.value = await askParam("speed");
        nextIterParams.push(knowledgeBase.speed.name);
  
        factsFromUser.push({
          name: knowledgeBase.speed.name,
          value: knowledgeBase.speed.value,
        });
      }
  
      if (
        knowledgeBase.application.value == "почтовый клиент" &&
        knowledgeBase.speed.value == "высокая"
      ) {
        if (!knowledgeBase.protocol.value) {
          knowledgeBase.protocol.value = "smtp";
          nextIterParams.push(knowledgeBase.protocol.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.protocol.name,
            value: knowledgeBase.protocol.value,
          });
          return true;
        }
      }
    },
};

let rule5 = {
    name: "rule5",
    conditions: ["ip"],
    resultVar: "networkType",
  
    checkCondition(conditionName) {
      if (
        conditionName === "ip" &&
        knowledgeBase[conditionName].value === "внутренний"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.ip.value) {
        knowledgeBase.ip.value = await askParam("ip");

        nextIterParams.push(knowledgeBase.ip.name);
  
        factsFromUser.push({
          name: knowledgeBase.ip.name,
          value: knowledgeBase.ip.value,
        });
      }
      if (
        knowledgeBase.ip.value == "внутренний"
      ) {
        if (!knowledgeBase.networkType.value) {
          knowledgeBase.networkType.value = "локальная";
          nextIterParams.push(knowledgeBase.networkType.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.networkType.name,
            value: knowledgeBase.networkType.value,
          });
          return true;
        }
      }
    },
};

let rule6 = {
    name: "rule6",
    conditions: ["topology","ip"],
    resultVar: "networkType",
  
    checkCondition(conditionName) {
      if (
        conditionName === "topology" &&
        knowledgeBase[conditionName].value === "смешанная"
      ) {
        return true;
      }
      if (
        conditionName === "ip" &&
        knowledgeBase[conditionName].value === "внешний"
      ) {
        return true;
      }
    },
  
    async exec() {
        if (!knowledgeBase.topology.value) {
          knowledgeBase.topology.value = await askParam("topology");
          nextIterParams.push(knowledgeBase.topology.name);
    
          factsFromUser.push({
            name: knowledgeBase.topology.name,
            value: knowledgeBase.topology.value,
          });
        }
        if (!knowledgeBase.ip.value) {
          knowledgeBase.ip.value = await askParam("ip");
          nextIterParams.push(knowledgeBase.ip.name);
    
          factsFromUser.push({
            name: knowledgeBase.ip.name,
            value: knowledgeBase.ip.value,
          });
        }
    
        if (
          knowledgeBase.topology.value == "смешанная" &&
          knowledgeBase.ip.value == "внешний"
        ) {
          if (!knowledgeBase.networkType.value) {
            knowledgeBase.networkType.value = "глобальная";
            nextIterParams.push(knowledgeBase.networkType.name);
    
            factsFromRules.push({
              name: this.name,
              paramName: knowledgeBase.networkType.name,
              value: knowledgeBase.networkType.value,
            });
            return true;
          }
        }
      },
};

let rule7 = {
    name: "rule7",
    conditions: ["connectionPersistence", "crypto"],
    resultVar: "result",
  
    checkCondition(conditionName) {
      if (
        conditionName === "connectionPersistence" &&
        knowledgeBase[conditionName].value === "да"
      ) {
        return true;
      }
      if (
        conditionName === "crypto" &&
        knowledgeBase[conditionName].value === "нет"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.connectionPersistence.value) {
        knowledgeBase.connectionPersistence.value = await askParam("connectionPersistence");

        nextIterParams.push(knowledgeBase.connectionPersistence.name);
  
        factsFromUser.push({
          name: knowledgeBase.connectionPersistence.name,
          value: knowledgeBase.connectionPersistence.value,
        });
      }
      if (!knowledgeBase.crypto.value) {
        knowledgeBase.crypto.value = await askParam("crypto");

        nextIterParams.push(knowledgeBase.crypto.name);
  
        factsFromUser.push({
          name: knowledgeBase.crypto.name,
          value: knowledgeBase.crypto.value,
        });
      }
  
      if (
        knowledgeBase.connectionPersistence.value == "да" &&
        knowledgeBase.crypto.value == "нет"
      ) {
        if (!knowledgeBase.result.value) {
          knowledgeBase.result.value = "устройство под хакерской атакой";
          nextIterParams.push(knowledgeBase.result.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.result.name,
            value: knowledgeBase.result.value,
          });
          return true;
        }
      }
    },
};

let rule8 = {
    name: "rule8",
    conditions: ["topology"],
    resultVar: "connectionPersistence",
  
    checkCondition(conditionName) {
      if (
        conditionName === "topology" &&
        knowledgeBase[conditionName].value === "полносвязная"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.topology.value) {
        knowledgeBase.topology.value = await askParam("topology");
        nextIterParams.push(knowledgeBase.topology.name);
  
        factsFromUser.push({
          name: knowledgeBase.topology.name,
          value: knowledgeBase.topology.value,
        });
      }
      if (
        knowledgeBase.topology.value == "полносвязная" 
      ) {
        if (!knowledgeBase.connectionPersistence.value) {
          knowledgeBase.connectionPersistence.value = "да";
          nextIterParams.push(knowledgeBase.connectionPersistence.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.connectionPersistence.name,
            value: knowledgeBase.connectionPersistence.value,
          });
          return true;
        }
      }
    },
};

let rule9 = {
    name: "rule9",
    conditions: ["connectionPersistence", "protocol"],
    resultVar: "application",
  
    checkCondition(conditionName) {
      if (
        conditionName === "connectionPersistence" &&
        knowledgeBase[conditionName].value === "да"
      ) {
        return true;
      }
      if (
        conditionName === "protocol" &&
        knowledgeBase[conditionName].value === "ftp"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.connectionPersistence.value) {
        knowledgeBase.connectionPersistence.value = await askParam("connectionPersistence");

        nextIterParams.push(knowledgeBase.connectionPersistence.name);
  
        factsFromUser.push({
          name: knowledgeBase.connectionPersistence.name,
          value: knowledgeBase.connectionPersistence.value,
        });
      }
      if (!knowledgeBase.protocol.value) {
        knowledgeBase.protocol.value = await askParam("protocol");
        nextIterParams.push(knowledgeBase.protocol.name);
  
        factsFromUser.push({
          name: knowledgeBase.protocol.name,
          value: knowledgeBase.protocol.value,
        });
      }
  
      if (
        knowledgeBase.connectionPersistence.value == "да" &&
        knowledgeBase.protocol.value == "ftp"
      ) {
        if (!knowledgeBase.application.value) {
          knowledgeBase.application.value = "загрущик";
          nextIterParams.push(knowledgeBase.application.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.application.name,
            value: knowledgeBase.application.value,
          });
          return true;
      }
    }
  },
};

let rule10 = {
    name: "rule10",
    conditions: ["application","speed"],
    resultVar: "protocol",
  
      checkCondition(conditionName) {
      if (
        conditionName === "application" &&
        knowledgeBase[conditionName].value === "почтовый клиент"
      ) {
        return true;
      }
      if (
        conditionName === "speed" &&
        knowledgeBase[conditionName].value === "низкая"
      ) {
        return true;
      }
    },

    async exec(){
         if (!knowledgeBase.application.value) {
        knowledgeBase.application.value = await askParam("application");
        nextIterParams.push(knowledgeBase.application.name);
  
        factsFromUser.push({
          name: knowledgeBase.application.name,
          value: knowledgeBase.application.value,
        });
      }
      if (!knowledgeBase.speed.value) {
        knowledgeBase.speed.value = await askParam("speed");
        nextIterParams.push(knowledgeBase.speed.name);
  
        factsFromUser.push({
          name: knowledgeBase.speed.name,
          value: knowledgeBase.speed.value,
        });
      }
  
      if (
        knowledgeBase.application.value == "почтовый клиент" &&
        knowledgeBase.speed.value == "низкая"
      ) {
        if (!knowledgeBase.protocol.value) {
          knowledgeBase.protocol.value = "pop3";
          nextIterParams.push(knowledgeBase.protocol.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.protocol.name,
            value: knowledgeBase.protocol.value,
          });
          return true;
        }
      }
    },
};

let rule11 = {
    name: "rule11",
    conditions: ["connectionPersistence", "topology"],
    resultVar: "result",
  
    checkCondition(conditionName) {
      if (
        conditionName === "connectionPersistence" &&
        knowledgeBase[conditionName].value === "нет"
      ) {
        return true;
      }
      if (
        conditionName === "topology" &&
        knowledgeBase[conditionName].value === "полносвязная"
      ) {
        return true;
      }
    },
  
    async exec() {
      if (!knowledgeBase.connectionPersistence.value) {
        knowledgeBase.connectionPersistence.value = await askParam("connectionPersistence");
        nextIterParams.push(knowledgeBase.connectionPersistence.name);
  
        factsFromUser.push({
          name: knowledgeBase.connectionPersistence.name,
          value: knowledgeBase.connectionPersistence.value,
        });
      }

      if (!knowledgeBase.topology.value) {
        knowledgeBase.topology.value = await askParam("topology");
        nextIterParams.push(knowledgeBase.topology.name);
  
        factsFromUser.push({
          name: knowledgeBase.topology.name,
          value: knowledgeBase.topology.value,
        });
      }

      if (
        knowledgeBase.connectionPersistence.value == "нет" &&
        knowledgeBase.topology.value == "полносвязная"
      ) {
        if (!knowledgeBase.result.value) {
          knowledgeBase.result.value = "есть неполадка в сети";
          nextIterParams.push(knowledgeBase.result.name);
  
          factsFromRules.push({
            name: this.name,
            paramName: knowledgeBase.result.name,
            value: knowledgeBase.result.value,
          });
          return true;
      }
    }
  },
};
 
let rule12 = {
    name: "rule12",
    conditions: ["crypto","application"],
    resultVar: "protocol",
  
    checkCondition(conditionName) {
      if (
        conditionName === "crypto" &&
        knowledgeBase[conditionName].value === "да"
      ) {
        return true;
      }
      if (
        conditionName === "application" &&
        knowledgeBase[conditionName].value === "браузер"
      ) {
        return true;
      }
    },
  
    async exec() {
        if (!knowledgeBase.crypto.value) {
          knowledgeBase.crypto.value = await askParam("crypto");
          nextIterParams.push(knowledgeBase.crypto.name);
    
          factsFromUser.push({
            name: knowledgeBase.crypto.name,
            value: knowledgeBase.crypto.value,
          });
        }
        if (!knowledgeBase.application.value) {
          knowledgeBase.application.value = await askParam("application");
          nextIterParams.push(knowledgeBase.application.name);
    
          factsFromUser.push({
            name: knowledgeBase.application.name,
            value: knowledgeBase.application.value,
          });
        }
    
        if (
          knowledgeBase.crypto.value == "да" &&
          knowledgeBase.application.value == "браузер"
        ) {
          if (!knowledgeBase.protocol.value) {
            knowledgeBase.protocol.value = "https";
            nextIterParams.push(knowledgeBase.protocol.name);
    
            factsFromRules.push({
              name: this.name,
              paramName: knowledgeBase.protocol.name,
              value: knowledgeBase.protocol.value,
            });
            return true;
        }
      }
    },
};

oldRulesLength = rules.length;

async function straightChain() {
    console.log(
        "1. protocol - Тип протокола = http\\https\\ftp\\pop3\\smtp" +
        "\n" +
        "2. application - Вид приложения - браузер\\почтовый клиент\\загрущик" +
        "\n" +
        "3. speed - Скорость сети - высокая\\cредняя\\низкая" +
        "\n" +
        "4. networkType - Тип сети - локальная\\городская\\глобальная" +
        "\n" +
        "5. crypto - Шифрование - да\\нет" +
        "\n" +
        "6. topology - Топология - звезда\\полносвязная\\неполносвязная\\смешанная" +
        "\n" +
        "7. ip - ip-адрес - внутренний\\внешний" +
        "\n" +
        "8. connectionPersistence - Постоянность соединения - да\\нет" +
        "\n"
    );
  
    let paramName = await askParam("ИМЯ ИСХОДНОЙ ПЕРЕМЕННОЙ");
    let paramValue = await askParam(paramName);
  
    currentParams.push(paramName);
  
    knowledgeBase[paramName].value = paramValue;
  
    factsFromUser.push({ name: paramName, value: paramValue });
  
    let isFinish = false;
  
    let iterCount = 1;
  
    while (!isFinish) {
      console.log(`${iterCount}-я итерация.`);
  
      oldRulesLength = rules.length;
      for (let i = 0; i < rules.length; i++) {
        console.log(`Просматривается правило ${rules[i].name}.`);
  
        let shouldExecute = false;
        console.log(`Искомые параметры = ${currentParams}`);
        for (let j = 0; j < currentParams.length; j++) {
          if (rules[i].conditions.includes(currentParams[j])) {
            shouldExecute = rules[i].checkCondition(currentParams[j]);
          }
        }
  
        if (shouldExecute) {
          let ruleSucceed = await rules[i].exec();
  
          if (ruleSucceed) {
            rules.splice(i, 1);
            i--;
          }
  
          if (knowledgeBase.result.value) {
            break;
          }
        }
      }
  
      currentParams = nextIterParams;
      nextIterParams = [];
      if (rules.length === oldRulesLength) {
        break;
      }
  
      iterCount++;
      isFinish = checkFinishConditions();
    }
  
    if (knowledgeBase.result.value) {
      console.log(`\nУ вас следующая проблема – ${knowledgeBase.result.value}`);
    } else {
      console.log("\nНе удалось выявить проблему");
    }
  
    console.log("\nФакты, определённые пользователем:");
    for (let i = 0; i < factsFromUser.length; i++) {
      console.log(`${factsFromUser[i].name} = ${factsFromUser[i].value}`);
    }
  
    console.log("Факты, выведенные из правил:");
    for (let i = 0; i < factsFromRules.length; i++) {
      console.log(
        `Из правила ${factsFromRules[i].name} выведен факт - ${factsFromRules[i].paramName} = ${factsFromRules[i].value}`
      );
    }
}

async function defineParam(paramName) {
    console.log(` Trying to define ${paramName}`);
  
    //Если параметр определён, просто его возвращаем.
    if (knowledgeBase[paramName].value) {
      console.log(`   ${paramName} already defined`);
      return knowledgeBase[paramName];
    }
  
    //Если не определён:
    //  1. находим правило, которое определит данный параметр;
    //  2. определяем по очереди каждый параметр из условия той же функцией;
    //  3. если условная часть верна – выполняем правило.
    for (let i = 0; i < rules.length; i++) {
      if (rules[i].resultVar === paramName) {
        const conditions = rules[i].conditions;
        let shouldExecute = true;
  
        console.log(`Checking ${rules[i].name} for ${paramName}`);
  
        for (let j = 0; j < conditions.length; j++) {
          let param = await defineParam(conditions[j]);
  
          if (!rules[i].checkCondition(param.name)) {
            shouldExecute = false;
            break;
          }
        }
  
        if (shouldExecute) {
          await rules[i].exec();
  
          return knowledgeBase[paramName];
        }
      }
    }
  
    //Если правил, дающих значение параметра нет, запрашиваем его у пользователя.
    let paramValue = await askParam(paramName);
  
    knowledgeBase[paramName].value = paramValue;
  
    factsFromUser.push({
      name: knowledgeBase[paramName].name,
      value: knowledgeBase[paramName].value,
    });
  
    return knowledgeBase[paramName];
}

async function reversedChain() {
    console.log(
      "1. protocol - Тип протокола = http\\https\\ftp\\pop3\\smtp" +
        "\n" +
        "2. application - Вид приложения - браузер\\почтовый клиент\\загрущик" +
        "\n" +
        "3. speed - Скорость сети - высокая\\cредняя\\низкая" +
        "\n" +
        "4. networkType - Тип сети - локальная\\городская\\глобальная" +
        "\n" +
        "5. crypto - Шифрование - да\\нет" +
        "\n" +
        "6. topology - Топология - звезда\\полносвязная\\неполносвязная\\смешанная" +
        "\n" +
        "7. ip - ip-адрес - внутренний\\внешний" +
        "\n" +
        "8. connectionPersistence - Постоянность соединения - да\\нет" +
        "\n"
    );
  
    let targetParamName = await askParam("ИМЯ ПЕРЕМЕННОЙ ВЫВОДА");

    //factsFromRules = [];
    //factsFromUser = [];
  
    let targetParamValue = await defineParam(targetParamName);
  
    if (targetParamValue) {
      console.log(
        `Значение переменной вывода = ${knowledgeBase[targetParamName].value}`
      );
  
      console.log("Факты, определённые пользователем:");
      for (let i = 0; i < factsFromUser.length; i++) {
        console.log(`${factsFromUser[i].name} = ${factsFromUser[i].value}`);
      }
  
      console.log("Факты, выведенные из правил:");
      for (let i = 0; i < factsFromRules.length; i++) {
        console.log(
          `Из правила ${factsFromRules[i].name} выведен факт - ${factsFromRules[i].paramName} = ${factsFromRules[i].value}`
        );
      }
    } else {
      console.log("Не удалось определить значение параметра.");
    }
}

(async function main() {

  console.log("\nПрямая цепочка рассуждений: \n");

  prepareData();

  await straightChain();
    
  
  console.log("\nОбратная цепочка рассуждений: \n");

  await reversedChain();
    
  })();