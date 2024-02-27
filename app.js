//JS

//Object projection refactor and calendar api access key

//Task 1.1
// 1.1.	Extend JS Date object with a method daysTo() which returns number of complete days between any pair of JS date objects: d1.daysTo(d2) should return quantity of complete days from d1 to d2.

Date.prototype.daysTo = daysTo;

function daysTo(secondDay) {
  const differenceTime = this - secondDay;
  const differenceDays = Math.floor(
    Math.abs(differenceTime) / (1000 * 3600 * 24)
  );

  return differenceDays;
}

const d1 = new Date();
const d2 = new Date("18 February 2024 11:33");

const diff = d1.daysTo(d2);
console.log(`Complete days between ${d1} and ${d2} is ${diff} days`);

//Task 1.2
// 1.2.	Please order by Total
// Develop a program which produces ordered array of sales. Input: array of objects with the following structure {amount: 10000, quantity: 10}. Output: new array of ordered sales. Array element structure should be: {amount: 10000, quantity: 10, Total: 100000}, where Total = amount * quantity. Please order by Total and note that input array shall remain intact.

const array = [
  { amount: 10000, quantity: 10 },
  { amount: 1000, quantity: 8 },
  { amount: 53000, quantity: 2 },
  { amount: 21000, quantity: 5 },
  { amount: 3000, quantity: 7 },
];

function orderByTotal(array, bigtoSmall = true) {
  //i'm gonna do a shallow copy reffering to given example
  const arrayCopy = array.map((item) => ({
    ...item,
    Total: item.amount * item.quantity,
  }));

  //deep copy
  const arrayJSONCopy = JSON.parse(JSON.stringify(array));

  // arrayCopy.forEach((item) => {
  //   item.total = item.amount * item.quantity;
  // });

  if (bigtoSmall) {
    arrayCopy.sort((a, b) => b.total - a.total);
  } else {
    arrayCopy.sort((a, b) => a.total - b.total);
  }

  return arrayCopy;
}

const orderedArray = orderByTotal(array);

const orederToSmall = orderByTotal(array, false);

console.log(array, "original");

console.log(orderedArray, "orderedArray");

console.log(orederToSmall, "orederToSmall");

console.log(array);

// Task 1.3
// 1.3.	Develop a program “Object Projection”. Input: any JSON object; prototype object. Output: projected object. Projected object structure shall be intersection of source object and prototype object structures. Values of properties in projected object shall be the same as values of respective properties in source object.
// const src = {
//   prop11: {
//     prop21: 21,
//     prop22: {
//       prop31: new Date(),
//       prop32: 32,
//       prop33: {
//         test: "lol",
//       },
//     },
//   },
//   prop12: 12,
// };

// const proto = {
//   prop11: {
//     prop22: null,
//   },
//   prop12: null,
// };

const src = {
  prop22: null, //prop22
  prop33: {
    prop331: 1, //prop33.prop331
    prop332: 2, //prop33.prop332
  },
  prop11: {
    prop111: "value", //prop11.prop111
    prop112: {
      prop112: null, //prop11.prop112.prop112
    },
  },
};

const proto = {
  prop11: {
    prop22: null, //prop11.prop22
    prop111: {
      prop111: null, //prop11.prop111.prop111
    },
    prop112: null, //prop11.prop112
  },
  prop33: {}, //prop33
  prop22: 2, //prop22
};

const result = {
  prop11: {
    prop112: {
      prop112: null,
    },
  },
  prop22: null,
  prop33: {
    prop331: 1,
    prop332: 2,
  },
};

function objectProjection(sourceObj, prototypeObj) {
  function deepClone(source, prototype) {
    console.log(source, "SRC", prototype, "PROTO");
    if (
      source === null ||
      prototype === null ||
      typeof source !== "object" ||
      typeof prototype !== "object" ||
      Object.keys(prototype).length === 0
    ) {
      return source;
    }

    return Object.keys(prototype).reduce((projectedObj, key) => {
      if (
        typeof source[key] === "object" &&
        typeof prototype[key] === "object"
      ) {
        projectedObj[key] = deepClone(source[key], prototype[key]);
      } else if (
        prototype[key] !== source[key] &&
        prototype[key] !== undefined &&
        source[key] !== null
      ) {
        return projectedObj;
      } else {
        projectedObj[key] = source[key];
      }
      return projectedObj;
    }, {});
  }

  return deepClone(sourceObj, prototypeObj);
}

const projectedObject = objectProjection(src, proto);
console.log(projectedObject);

//Task 2.1
// Function to check free/busy

const button = document.querySelector(".google__busy");
button.addEventListener("click", checkFreeBusy);

function checkFreeBusy() {
  fetch("http://localhost:3000/freebusy", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      calendar: "primary",
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      console.log("Free/Busy Intervals:", data);
    })
    .catch((error) => console.error("Error:", error));
}
