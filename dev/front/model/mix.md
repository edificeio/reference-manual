---
title: mix
id: mix
---
Mix is a basic tool for casting. When you retrieve data from the server, it’s sent as basic objects (if you log a JSON response in Chrome, it will show as Object). In Typescript, you can use type assertion (see type assertion in <https://www.typescriptlang.org/docs/handbook/basic-types.html>) to trick the compiler into ignoring the type difference :

``` typescript
const myObj = obj as MyClass;
```

But the new object is still a basic Object for the interpreter, and it still doesn’t contain all the methods you’ve added to your class. It’s also not an instance of your class:

``` typescript
console.log(myObj instanceof MyClass);
// false
```

You can use Mix to create a new instance of your class using your object:

``` typescript
import { Mix } from ‘entcore-toolkit’;

const myObj = Mix.castAs(MyClass, obj);
```

You can also cast arrays:

``` typescript
const myArray = Mix.castArrayAs(MyClass, arr);
```

And you can add properties from an object to an existing object:

``` typescript
Mix.extend(this, mixin);
```
