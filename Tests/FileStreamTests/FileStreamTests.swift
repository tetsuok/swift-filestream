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

import XCTest
@testable import FileStream

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

final class TempFile {
  let name: String

  init(suffix: String) {
    let pid = getpid()
    self.name = "/tmp/\(pid).tmp.\(suffix)"
  }

  deinit {
    unlink(self.name)
  }
}

final class FileStreamTests: XCTestCase {
    func testInputOutputFileStream() {
      let file = TempFile(suffix: "testOutputFileStream")
      do {
        guard var output = OutputFileStream(file.name) else {
          XCTFail("cannot open \(file.name)")
          return
        }
        defer { output.close() }
        print("hello, world!", to: &output)
      }
      do {
        guard var input = InputFileStream(file.name) else {
          XCTFail("cannot open \(file.name)")
          return
        }
        defer { input.close() }
        if let data = input.readAll() {
          XCTAssertEqual(data, "hello, world!\n")
        } else {
          XCTFail("readAll failed")
        }
      }
    }

    static var allTests = [
        ("testInputOutputFileStream", testInputOutputFileStream),
    ]
}
