// Copyright 2019 Tetsuo Kiso. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// TODO: Implement InputFileStream

public struct OutputFileStream: TextOutputStream {
  internal var fp: UnsafeMutablePointer<FILE>?

  init?(_ name: String) {
    if name.isEmpty {
      return nil
    }
    var fp: UnsafeMutablePointer<FILE>?
    _ = name.utf8.withContiguousStorageIfAvailable { utf8 in
       fp = swift_fopen(utf8.baseAddress!)
    }
    if fp == nil {
      return nil
    }
    self.fp = fp
  }

  public mutating func _lock() {}
  public mutating func _unlock() {}

  public mutating func write(_ string: String) {
    if string.isEmpty {
      return
    }
    var string = string
    // TODO: remove this once Swift 5.1 is released.
#if swift(<5.1)
    _ = string.utf8.withContiguousStorageIfAvailable { utf8 in
      swift_fwrite_stream(utf8.baseAddress!, 1, utf8.count, self.fp)
    }
#else
    _ = string.withUTF8 { utf8 in
      swift_fwrite_stream(utf8.baseAddress!, 1, utf8.count, self.fp)
    }
#endif
  }

  func close() {
    swift_fclose(self.fp)
  }
}
