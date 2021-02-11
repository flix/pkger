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

use Core/Io/File.{File, new => newFile, readLines, writeLines,mkdirs};
use GetOpt.{ArgDescr, OptionDescr};
use GetOpt.ArgDescr.{NoArg, ReqArg, OptArg};
use GetOpt.ArgOrder.{RequireOrder, Permute, ReturnInOrder};
use GetOpt.{getOpt, usageInfo};
use Core/Io/IOError.IOError;



enum Flag {
    case Version
}

instance ToString[Flag]{
    def toString(x: Flag): String = match x {
        case Version => "Version"
    }
}

instance Eq[Flag]{
    def eq(x: Flag, y: Flag): Bool = match (x,y){
        case (Version, Version) => true
    }
    def neq(x:Flag, y:Flag) : Bool = false
}


def options(): List[OptionDescr[Flag]] = 
    {optionIds = 'v' :: Nil, optionNames = "Version" :: Nil, argDescriptor = NoArg(Version), explanation = "prints the version number"} :: Nil
   


def handleOptions(x: List[Flag]): Int32 & Impure = 
    use Pkger.{SemVer};
    let flipVersion = "The current version is 0,1,0";
    if(List.head(x) == Some(Version)) flipVersion |> println else "no flag" |> println; 123

def handleNonOption(x: List[String]): Int32 & Impure = 
    match x {
        case Nil => 0
        case n :: rest => 
           if (n == "new") let fileName = List.head(rest); mkPackage(fileName);0 else 0
    }

def mkPackage(x: Option[String]): Int32 & Impure = 
    match x{
        case None => 0
        case Some(y) => 
        let root = newFile(y);
        let srcfile = newFile(y + "/src");
        let benches = newFile(y + "/benches");
        let examples = newFile(y + "/examples");
        let tests = newFile(y + "/tests");
        let manifest = newFile(y + "/manifest.txt");
        let lock = newFile(y + "/lockfile.txt");
        mkdirs(root);
        mkdirs(srcfile);
        mkdirs(benches);
        mkdirs(tests);
        mkdirs(examples);
        mkdirs(manifest);
        mkdirs(lock);
        
        "Package has been made" |> println; 0
    }
    

def main(args: Array[String]): Int32 & Impure =
    let args2 = GetOpt.preprocess({quoteOpen = "'", quoteClose = "'", stripQuoteMarks = false}, args);  
    let header = "Usage: <program> [OPTION...] files...";
    let options1 = options();
    match getOpt(Permute,options1,args2){
        case Success(opts) => {
            Console.printLine("Optionals: ${opts.options}");
            Console.printLine("Non-optionals: ${opts.nonOptions}");
            handleOptions(opts.options);
            handleNonOption(opts.nonOptions); 0}
        case Failure(errs) => {Console.printLine("Errors: ${errs}");  Console.printLine(usageInfo(header, options1)); 1}
    }

namespace Pkger {
    ///TODO pre-release version
    pub enum SemVer{
        case SemVer(Int32, Int32, Int32)
    }

    pub enum Repository{
        case Repository(Map[String,List[PackageInfo]])
    }

   
    // Any field that's only require by the registry is ignore for now
    pub enum PackageInfo{
        case PackageInfo({
            name: String,
            version: SemVer,
            authors: List[Author],
            edition: SemVer,
            dependencies: List[Dependency],
            url : String
        })
    }

    pub enum Author{
        case Author({name: String, email: Option[String]})
    }

    pub enum Dependency{
        case PackageDependecy(String,SemVer)  
        case FileDependency(String,String)  
    }

    pub def examplePackage(): PackageInfo = 
        PackageInfo({
            name = "MyPackageName",
            version = SemVer(1,2,3), 
            authors = Author({name = "peter", email = None}) :: Nil,
            edition = SemVer(0,14,6),
            dependencies = Nil,
            url = "Nil"})
    

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
