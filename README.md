# swift-filestream

Provides efficient file stream API for reading from or writing to files on
Linux and macOS, which is currently missing in Swift's standard library. The
goals of this project can be summarized as

* Enable write command line tools or scrips easily to process text data.
* The output stream API conform to the `TextOutputStream` protocol.
* Runtime performance comparable to file I/O in Python.
* Minimal dependency. No dependency on Foundation.
* Easy to integrate into Xcode projects.

Non-goals

* Building more generalized abstraction layer
* Memory-mapped file I/O support.
* Windows support.

## Sample Usage

### Opening a file for writing

```
let filename = "/path/to/file"
guard var output = OutputFileStream(filename) else {
  print("Cannot open", filename)
  return
}
defer { output.close() }

// Print to the opened output stream
print("hello, world!", to: &output)
```

