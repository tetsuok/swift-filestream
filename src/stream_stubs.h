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

#ifndef SWIFT_FILESTREAM_STREAM_STUBS_H_
#define SWIFT_FILESTREAM_STREAM_STUBS_H_

#include <stdio.h>
#include <stdlib.h>

FILE *swift_fopen(const void *filename);
int swift_fclose(FILE *stream);
size_t swift_fwrite_stream(const void *ptr, size_t size, size_t nitems,
                           FILE *stream);

#endif  // SWIFT_FILESTREAM_STREAM_STUBS_H_
