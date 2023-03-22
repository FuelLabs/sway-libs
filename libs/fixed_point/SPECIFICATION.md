# Overview

This document provides an overview of the Fixed Number Point library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Fixed Point type can be used anytime a developer needs fixed-point numbers.

## Public Functions

### `bits()`

The size of this type in bits.

### `max()`

The largest value that can be represented by this fixed-point type.

### `min()`

The smallest value that can be represented by this fixed-point type.

### `round()`

Returns the nearest integer to this fixed-point type. 

### `recip()`

Takes the reciprocal (inverse) of a number, `1/x`.

### `trunc()`

Returns the integer part of a fixed-point number. 

### `from()`

Creates a fixed-point value from the underlying type, as is.

### `into()`

Returns a the underlying value of a fixed-point number, as is.

### `denominator()`

Returns a the value of the standard denominator of a fixed-point number, in the underlying type.

### `zero()`

Returns a zero value of type.

### `from_uint()`

Returns a fixed-point value equal to some unsigned value.

### `floor()`

Returns the biggest integer fixed-point value, that is smaller than the argument.

### `fract()`

Returns the fractional part of the fixed-point value.

### `ceil()`

Returns the smallest integer fixed-point value, that is bigger than the argument.


### Basic arithmetic operations

`+`, `-`, `*`, `/`

### Mathematical functions

### `sqrt`

Square root of a fixed-point number.

### `exp`

Exponent of a fixed-point number.

### `pow`

Power of a fixed-point number.
