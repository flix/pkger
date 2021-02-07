/*
 * Copyright 2021 Magnus Madsen
 * Copyright 2021 Zhiwei Zeng
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
        case SemVer(Int32, Int32, Int32)
    }

    // Any field that's only require by the registry is ignore for now
    pub enum PackageInfo{
        case Name(String)           //name of the package
        case Version(SemVer)        //semantic versioning 
        case Author(String)         //the author of the package 
        case Edition(String)        //the Flix edition 
        //case ReadMe(String)         //path of the README file
        case Repository(String)     //since we don't have a registry(yet?) here is where we fetch package
        // case Workspace?
        // case build script?
        // case link?
        // case exclude/ include
        // case metadata 
        // case default-run field
    }

    pub enum Dependency{
        case Git(String,String)   //name of the library and git repository. How to fetch package with correspond SemVer from git?
        case Local(String,String) //name and file path
        case DevDependencies(String,String) //Can be either git or local dependency but only use for compiling tests,examples,and benchmarks.
    }


    ///
    /// Generate a manifest 
    ///
    pub def makeManifest(_packgeInfo: List[PackageInfo], _dependencies: List[Dependency]): Unit = ()



    ///
    /// Initializes a new empty project in in the given `path`.
    ///
    pub def initProject(_path: File): Unit = ()

    ///
    /// Return true if SemVer a have higher precedence than b or same.
    ///
    pub def lessEqual(a: SemVer, b: SemVer): Bool = 
    match (a,b){ 
        case (SemVer(majorA,minorA,patchA),SemVer(majorB,minorB,patchB)) => 
        let major = majorA <=> majorB;
        let minor = minorA <=> minorB;
        let patch = patchA <=> patchB;
        match major{
            case GreaterThan => true
            case EqualTo => match minor {
                case GreaterThan => true
                case EqualTo => match patch{
                    case GreaterThan => true
                    case EqualTo => true
                    case LessThan => false
                }
                case LessThan => false
            }
            case LessThan => false
        } 
    
    }

}
