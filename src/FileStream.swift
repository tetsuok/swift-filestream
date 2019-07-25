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

public struct InputFileStream {
  private var fp: UnsafeMutablePointer<FILE>?
  private var isEOF: Bool
  private var fileSize: Int64
  private var buf: UnsafeMutableBufferPointer<UInt8>

  static public let defaultCapacity = 4096

  init?(_ name: String, capacity: Int = InputFileStream.defaultCapacity) {
    if name.isEmpty {
      return nil
    }
    var fp: UnsafeMutablePointer<FILE>?
    var fileSize: Int64 = 0
    _ = name.utf8.withContiguousStorageIfAvailable { utf8 in
       fp = swift_fopen_for_read(utf8.baseAddress!)
       fileSize = swift_file_size(utf8.baseAddress!)
    }
    if fp == nil || fileSize < 0 {
      return nil
    }
    self.fp = fp
    self.isEOF = false
    self.fileSize = fileSize
    self.buf = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: capacity)
    self.buf.initialize(repeating: 0)
  }

  private mutating func _read(_ buf: UnsafeMutableBufferPointer<UInt8>) -> String? {
    let utf8Count = swift_fread_stream(buf.baseAddress!, 1, buf.count, self.fp)
    guard utf8Count > 0 else {
      self.isEOF = true
      return nil
    }
    let utf8 = UnsafePointer<UInt8>(buf.baseAddress!)
    return String(cString: utf8)
  }

  public mutating func read(size: Int = InputFileStream.defaultCapacity) -> String? {
    if self.isEOF {
      return nil
    }
    if InputFileStream.defaultCapacity < size {
      reallocBuf(size)
    }
    return _read(self.buf)
  }

  public mutating func readAll() -> String? {
    if self.isEOF {
      return nil
    }
    let cap = Int64(InputFileStream.defaultCapacity) + self.fileSize
    if cap > Int.max {
      return nil
    }
    reallocBuf(Int(cap))
    return _read(self.buf)
  }

  public mutating func close() {
    swift_fclose(self.fp)
    self.buf.deallocate()
  }

  private mutating func reallocBuf(_ cap: Int) {
    self.buf.deallocate()
    self.buf = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: cap)
  }
}

public struct OutputFileStream: TextOutputStream {
  private var fp: UnsafeMutablePointer<FILE>?

  init?(_ name: String) {
    if name.isEmpty {
      return nil
    }
    var fp: UnsafeMutablePointer<FILE>?
    _ = name.utf8.withContiguousStorageIfAvailable { utf8 in
       fp = swift_fopen_for_write(utf8.baseAddress!)
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

  public mutating func close() {
    swift_fclose(self.fp)
  }
}
