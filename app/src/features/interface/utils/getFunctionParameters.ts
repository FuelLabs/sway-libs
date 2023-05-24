import { FieldValues, UseFormWatch } from 'react-hook-form';
// import { getInstantiableType, isFunctionPrimitive } from '.';

// function primitiveParameter(
//   input: any,
//   name: string,
//   watch: UseFormWatch<FieldValues>
// ) {
//   let watchedValue = watch(name);
//   return getInstantiableType(input).create(
//     input.type.type === 'bool' && watchedValue === 'on' ? 'false' : watch(name)
//   );
// }

// function nestedParameter(
//   input: any,
//   name: string,
//   watch: UseFormWatch<FieldValues>
// ) {
//   let key = input.name.toString();
//   if (!isFunctionPrimitive(input)) {
//     input.components.map((nested: any) => {
//       return nestedParameter(nested, `${name}.${nested.name}`, watch);
//     });
//   }
//   let value = isFunctionPrimitive(input)
//     ? primitiveParameter(input, name, watch)
//     : Object.assign(
//         {},
//         ...input.components.map((nested: any) => {
//           return nestedParameter(nested, `${name}.${nested.name}`, watch);
//         })
//       );
//   return { [key]: value };
// }

// export function getFunctionParameters(
//   inputInstances: { [k: string]: any }[],
//   watch: UseFormWatch<FieldValues>,
//   functionName: string
// ) {
//   const params = inputInstances.map((input: any) => {
//     let name = `${functionName}.${input.name}`;
//     return Object.values(nestedParameter(input, name, watch))[0];
//   });

//   return params;
// }
