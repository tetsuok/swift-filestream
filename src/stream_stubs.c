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

#include "stream_stubs.h"

FILE* swift_fopen(const void* filename) {
  return fopen((const char*)filename, "w");
}

int swift_fclose(FILE* stream) { return fclose(stream); }

size_t swift_fwrite_fp(const void* ptr, size_t size, size_t nitems,
                       FILE* stream) {
  return fwrite(ptr, size, nitems, stream);
}
