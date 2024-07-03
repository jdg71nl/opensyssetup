//= ./project/jest-hints.test.js

// - - - - - - = = = - - - - - -
// https://jestjs.io/
// https://jestjs.io/docs/getting-started
// npm install --save-dev jest
//
const jest_is_run_from_package_json = {
  scripts: {
    test: "jest --verbose",
    testwatch: "jest --watchAll --verbose",
    start: "node app.js",
    devstart: "nodemon app.js",
  },
  jest_my_hint1: "include below to prevent error, see: https://stackoverflow.com/questions/51554366/jest-securityerror-localstorage-is-not-available-for-opaque-origins ",
  jest_my_hint2: "see: https://jestjs.io/docs/configuration ",
  jest: {
    verbose: true,
    jest_my_hint2: "Deprecation Warning: Option 'testURL' was replaced by passing the URL via 'testEnvironmentOptions.url'",
    NOT__testURL: "http://localhost/",
    "testEnvironmentOptions.url": "http://localhost/",
  },
};
//
// > cat run_test.sh
// #!/bin/bash
// #= run_test.sh
// NODE_ENV=development CONFIG_JWT_PRIVKEY=some CONFIG_APP_PORT=3000 CONFIG_MONGODB_URL=mongodb://localhost:27052/apitest npm run test
//
// > cat run_testwatch.sh
// #!/bin/bash
// #= run_testwatch.sh
// NODE_ENV=development CONFIG_JWT_PRIVKEY=some CONFIG_APP_PORT=3000 CONFIG_MONGODB_URL=mongodb://localhost:27052/apitest npm run testwatch
//
// > cat jest_run_here.sh
// #!/bin/bash
// #= jest_run_here.sh
// JEST_RT="./node_modules/jest/bin/jest.js "
// NODE_ENV=development $JEST_RT --watchAll --verbose
//
// PASS  ./jest-hints.test.js
// ✓ our first test (1 ms)
// ✓ adds 1 + 2 to equal 3 (1 ms)
// some unit/module we are testing
//   ✓ should do or return something specific which we test here (1 ms)
// what tests() we have for different types or situations
//   ✓ for integers use toBe() and friends (2 ms)
//   ✓ for floats use toBeCloseTo() (2 ms)
//   ✓ for strings use toMatch() or toContain() (2 ms)
//   ✓ for arrays ... (1 ms)
//   ✓ for objects ... (2 ms)
//   ✓ for exceptions ... (2 ms)
//   ✓ for integers use toBe() and friends (2 ms)
//   ✓ for integers use toBe() and friends (3 ms)

// Test Suites: 1 passed, 1 total
// Tests:       11 passed, 11 total
// Snapshots:   0 total
// Time:        0.673 s
// Ran all test suites.

// Watch Usage
// › Press f to run only failed tests.
// › Press o to only run tests related to changed files.
// › Press p to filter by a filename regex pattern.
// › Press t to filter by a test name regex pattern.
// › Press q to quit watch mode.
// › Press Enter to trigger a test run.

// - - - - - - = = = - - - - - -
test("our first test", () => {});
// > ./run_test.sh
// > api_server@1.0.0 test
// > jest --verbose
//  PASS  tests/unit/lib/functions.test.js
//   ✓ our first test
// Test Suites: 1 passed, 1 total
// Tests:       1 passed, 1 total
// Snapshots:   0 total
// Time:        0.351 s
// Ran all test suites.

// - - - - - - = = = - - - - - -
function sum(a, b) {
  return a + b;
}
it("adds 1 + 2 to equal 3", () => {
  expect(sum(1, 2)).toBe(3);
});

// - - - - - - = = = - - - - - -
describe("some unit/module we are testing", () => {
  it("should do or return something specific which we test here", () => {
    expect(1).toBe(1);
  });
});

// - - - - - - = = = - - - - - -
describe("what tests() we have for different types or situations", () => {
  //
  it("for integers use toBe() and friends", () => {
    expect(1).toBe(1);
    expect(2).toBeGreaterThan(1);
    expect(2).toBeGreaterThanOrEqual(2);
    expect(1).toBeLessThan(2);
    expect(2).toBeLessThanOrEqual(2);
    // toBe() and toEqual() are equivalent for numbers:
    expect(4).toBe(4);
    expect(4).toEqual(4);
  });
  //
  it("for floats use toBeCloseTo()", () => {
    expect(1.001).toBeCloseTo(1.0);
  });
  //
  it("for strings use toMatch() or toContain()", () => {
    expect("Hello Mosh").toMatch(/Mosh/);
    expect("Hello Mosh").toContain("Mosh");
  });
  //
  it("for arrays ...", () => {
    const currencies = ["USD", "EUR", "AUD"];
    // Too general
    expect(currencies).toBeDefined();
    expect(currencies).not.toBeNull();
    // Too specific:
    expect(currencies[0]).toBe("USD");
    expect(currencies.length).toBe(3);
    // Proper way:
    expect(currencies).toContain("USD");
    expect(currencies).toContain("EUR");
    // Ideal way:
    expect(currencies).toEqual(expect.arrayContaining(["USD", "EUR", "AUD"]));
    //
  });
  it("for objects ...", () => {
    const getProduct = function (ProductId) {
      return { id: ProductId, price: 10 };
    };
    const result = getProduct(1);
    // requires ALL keys to be present:
    expect(result).toEqual({ id: 1, price: 10 });
    // only requires the given keys to be present:
    expect(result).toMatchObject({ id: 1, price: 10 });
    // test one property (with optional value):
    expect(result).toHaveProperty("id");
    expect(result).toHaveProperty("id", 1);
    //
  });
  it("for exceptions ...", () => {
    const throwing_func = function () {
      throw "some error";
    };
    expect(() => {
      throwing_func();
    }).toThrow();
    //
    const args = [null, undefined, NaN, "", 0, false];
    args.forEach((a) => {
      expect(() => {
        throwing_func();
      }).toThrow();
    });
    //
  });
  //
});

// - - - - - - = = = - - - - - -
const lib = require("./lib-under-test");
const db = require("./db-semi-mock");
const mail = require("./mail-semi-mock");
//
describe("what tests() we have for different types or situations", () => {
  it("for integers use toBe() and friends", () => {
    //
    // method-1: manually override/REDFINE specific methods of library functions:
    db.getCustomerSync = function () {
      return { email: "a" };
    };
    // another redefine, with run-flag:
    let mailSent = false;
    mail.send = function (email, message) {
      mailSent = true;
    };
    // call the Function-Under-Test (FUT), which itself will call above db.getCustomerSync() function:
    lib.notifyCustomers({ customerId: 1 });
    //
    expect(mailSent).toBe(true);
  });
});

// - - - - - - = = = - - - - - -
//
describe("what tests() we have for different types or situations", () => {
  it("for integers use toBe() and friends", () => {
    //
    // const mockFunction = jest.fn();
    // mockFunction.mockReturnValue(1);
    // mockFunction.mockResolvedValue(1);
    // mockFunction.mockRejectedValue(new Error('some error'));
    //
    db.getCustomerSync = jest.fn().mockReturnValue({ email: "a" });
    mail.send = jest.fn();
    //
    lib.notifyCustomers({ customerId: 1 });
    //
    expect(mail.send).toHaveBeenCalled();
    expect(mail.send).toHaveBeenCalledWith("some", "thing");
    // jest.fn().mock.calls = array of function-calls/runs, so call[0] is first time func is called
    // jest.fn().mock.calls[n] = array of arguments that where send with call, so call[0][0] is first argument of first call
    expect(mail.send.mock.calls[0][0]).toBe("some");
    expect(mail.send.mock.calls[0][1]).toMatch(/thing/);
    //
  });
});

// - - - - - - = = = - - - - - -
//-eof
