/*
 * Copyright 2021 Magnus Madsen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use Core/Io/File.{File};

def main(_args: Array[String]): Int32 & Impure =
    "Hello World!" |> println;
    123

namespace Pkger {
    ///TODO pre-release version
    pub enum SemVer{
        case SemVer(Int32,Int32,Int32)
    }
    ///
    /// Initializes a new empty project in in the given `path`.
    ///
    pub def initProject(_path: File): Unit = ()

    ///
    /// Return true if SemVer a have higher precedence than b or same.
    ///
    pub def compare(a: SemVer, b: SemVer): Bool = 
    match (a,b){ 
        case (SemVer(a1,b1,c1),SemVer(a2,b2,c2)) => 
            if(a1 < a2){ false } else 
            if(b1 < b2){ false } else
            if(c1 < c2){ false } else { true }
    }

}
