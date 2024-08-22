import { getLiteral, parseTypeName } from "./getTypeInfo";

describe(`test getLiteral`, () => {
  test.each`
    input                                                       | expected
    ${"enum std::option::Option"}                               | ${"option"}
    ${"enum std::option::Option<enum std::identity::Identity>"} | ${"option"}
    ${"struct ComplexStruct2<b256>"}                            | ${"object"}
    ${"struct std::vec::Vec"}                                   | ${"vector"}
    ${"bool"}                                                   | ${"bool"}
    ${"b256"}                                                   | ${"string"}
    ${"str[7]"}                                                 | ${"string"}
    ${"random string"}                                          | ${"string"}
  `("$input", ({ input, expected }) => {
    expect(getLiteral(input)).toEqual(expected);
  });
});

describe(`test parseTypeName`, () => {
  test.each`
    input                                                  | expected
    ${"std::option::Option"}                               | ${"Option"}
    ${"std::option::Option<enum std::identity::Identity>"} | ${"Option"}
    ${"ComplexStruct2<b256>"}                              | ${"ComplexStruct2"}
    ${"std::vec::Vec"}                                     | ${"Vec"}
    ${"bool"}                                              | ${"bool"}
    ${"b256"}                                              | ${"b256"}
    ${"str[7]"}                                            | ${"str[7]"}
    ${""}                                                  | ${""}
  `("$input", ({ input, expected }) => {
    expect(parseTypeName(input)).toEqual(expected);
  });
});
