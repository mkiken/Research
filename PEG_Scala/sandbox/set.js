var mySet = new Set();

mySet.add(1);
mySet.add(5);
mySet.add("some text");

mySet.has(1); // true
mySet.has(3); // false, 3 has not been added to the set
mySet.has(5);              // true
mySet.has(Math.sqrt(25));  // true
mySet.has("Some Text".toLowerCase()); // true

mySet.size; // 3

mySet.delete(5); // removes 5 from the set
mySet.has(5);    // false, 5 has been removed

mySet.size; // 2, we just removed one value

// iterate over items in set
for (let item of mySet) console.log(item); // logs the items in the order: 1, "some text"

// convert set to plain Array
var myArr = [v for (v of mySet)]; // [1, "some text"]

// the following will also work if run in an HTML document
mySet.add(document.body);
mySet.has(document.querySelector("body")); // true

// converting between Set and Array
mySet2 = Set([1,2,3,4]);
mySet2.size; // 4
[...mySet2]; // [1,2,3,4]

// intersect can be simulated via
var intersection = new Set([for (x of set1) if (set2.has(x)) x]);

// NOTE: SpiderMonkey does not yet support the ES6 Array Comprehension syntax shown here


// Iterate set entries with forEach
mySet.forEach(function(value) {
  console.log(value);
});

// 1
// 2
// 3
// 4
