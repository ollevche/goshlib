## goshlib - Go Shared Library Example

This is an example of how to build shared libraries (**.dll**, **.so**) in **Go** and **C** using **Linux**.

You have to install `x86_64-w64-mingw32-gcc` compiler to build a shared library for **Windows** (**.dll**).

**Makefile** has had targets for building **libraries** (**Go**, **C**) and a **client app** as an example. Here is how you can try it:

Target                      | Action
-------                     |--------
`make (all)`                | builds **Go** and **C** **.so** libraries, the **client app**, then **runs** the app
`make run`                  | **runs** the app
`make usego` / `make usec`  | swaps the shared library for **Go** / **C**
`make win`                  | builds **Go** and **C** **.dll** libraries for **Windows**
`make clean`                | deletes object files
`make fclean`               | deletes object files, binaries and libraries
`make re`                   | `make fclean` + `make (all)`

### Useful resources

* [How to - C libraries](https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_C_libraries.html)

* [Fun building shared libraries in Go](https://medium.com/@walkert/fun-building-shared-libraries-in-go-639500a6a669)

* [Cross-Compiling Golang (CGO) Projects](https://dh1tw.de/2019/12/cross-compiling-golang-cgo-projects)
