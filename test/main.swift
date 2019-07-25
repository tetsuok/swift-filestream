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

import FileStream

func main() {
    let name = "/tmp/swift_filestream_test"
    // write()
    do {
        guard var output = OutputFileStream(name) else {
            print("Cannot open", name)
            return
        }
        defer { output.close() }
        print("hello", to: &output)
    }
    // read()
    do {
        guard var input = InputFileStream(name) else {
            print("Cannot open", name)
            return
        }
        defer { input.close() }
        while let data = input.read() {
            print(data)
        }
    }
    // readAll()
    do {
        guard var input = InputFileStream(name) else {
            print("Cannot open", name)
            return
        }
        defer { input.close() }
        guard let data = input.readAll() else {
          return
        }
        print(data, terminator: "")
    }
    print("OK")
}

main()
