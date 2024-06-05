export function modifyJsonStringify(key: any, value: any) {
  // JSON.stringify omits the key when value === undefined
  if (value === undefined) {
    return "undefined";
  }
  // possibilities for values:
  // undefined => Option::None
  // [] => ()
  return value;
}
