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

use String.replace;
use Core/Io/File.{File, new => newFile, readLines, writeLines,mkdirs,exists};
use GetOpt.{ArgDescr, OptionDescr};
use GetOpt.ArgDescr.{NoArg, ReqArg, OptArg};
use GetOpt.ArgOrder.{RequireOrder, Permute, ReturnInOrder};
use GetOpt.{getOpt, usageInfo};
use Core/Io/IOError.IOError;
use Core/Io/File.File.File;
use Author.Author;
use Author.Author.Author;
use SemVer.SemVer;
use SemVer.SemVer.SemVer;
use Dependency.Dependency;
//use PackageInfo.PackageInfo.PackageInfo;
//use PackageInfo.PackageInfo;


enum Flag {
    case Version
    //case Help
}


instance ToString[Flag]{
    def toString(x: Flag): String = match x {
        case Version => "Version"
    }}

instance Eq[Flag]{
    def eq(x: Flag, y: Flag): Bool = match (x,y){
        case (Version, Version) => true
        //case (Help,Help) => true
    }
    def neq(x:Flag, y:Flag) : Bool = false
}
def options(): List[OptionDescr[Flag]] = 
    {optionIds = 'v' :: Nil, optionNames = "Version" :: Nil, argDescriptor = NoArg(Version), explanation = "prints the version number"} ::
    {optionIds = 'h' :: Nil, optionNames = "Help" :: Nil, argDescriptor = NoArg(Version), explanation = "Show the commands"} :: Nil
   


def handleOptions(x: List[Flag]): Int32 & Impure = 
    let flipVersion = "The current version is 0,1,0";
    match List.head(x) {
        case Some(Version) => "Welcome to Flip" |> println; flipVersion |> println; 1
        //case Some(Help) => "Flip [Command] [argument]" |> println; "Command list:"|> println; "new" |> println; "uninstall"|> println; 1
        case _ => 1
    }
    //if(List.head(x) == Some(Version)) flipVersion |> println else "no flag" |> println; 123

def handleNonOption(x: List[String]): Int32 & Impure = 
    match x {
        case Nil => 0
        case n :: rest => 
            match n {
                case "new" => let fileName = List.head(rest); mkPackage(fileName);1
                case "uninstall" => let fileName = List.head(rest); uninstallPackage(fileName);1
                case "init" => initPackage();1
                case "checkvalid" => isValidProject();1
                case _ => 0
            }
    }

def isValidProject(): Bool & Impure = 
    let srcfile = newFile("src");
    let benches = newFile("benches");
    let examples = newFile("examples");
    let tests = newFile("tests");
    let manifest = newFile("manifest.txt");
    let lock = newFile("lockfile.txt");
    let handleSrc = isValidHelper(srcfile);
    let handleBenches = isValidHelper(benches);
    let handleExamples = isValidHelper(examples);
    let handleTests = isValidHelper(tests);
    let handleManifest = isValidHelper(manifest);
    let handleLock = isValidHelper(lock);
    if (handleSrc and handleBenches and handleExamples and handleTests and handleManifest and handleLock) "It's valid package" |> println else "It's invalid package" |> println; false


def isValidHelper(file: File): Bool & Impure = 
    match exists(file) {
        case Ok(t) => t 
        case Err(_e) => "error in File exists()"|> println;false
    }

//Need a way to return current directory to end this madness
def initPackage(): Int32 & Impure = 
            import java.io.File.list();
            import java.io.File.getAbsolutePath();
            import java.io.File.createNewFile();
            let pivot = newFile("Hi");
            let File(javaFile) = pivot;
            let rootPath = replace("/Hi","",javaFile.getAbsolutePath());
            rootPath |> println;
            let rootFile = newFile(rootPath);
            let File(rootJavaFile) = rootFile;
            if (Array.length(rootJavaFile.list()) > 0) 
                "It's not an empty directory"|> println 
            else
                "The Package has been initialized" |> println;
                let srcfile = newFile("src");
                let benches = newFile("benches");
                let examples = newFile("examples");
                let tests = newFile("tests");
                let manifest = newFile("manifest.txt");
                let lock = newFile("lockfile.txt");
                let File(javaFile) = manifest;
                let File(javaLock) = lock;
                mkdirs(srcfile);
                mkdirs(benches);
                mkdirs(tests);
                mkdirs(examples);
                javaFile.createNewFile();
                javaLock.createNewFile();
            0
            
    


def uninstallPackage(x: Option[String]): Bool & Impure = 
    match x{
        case None => false
        case Some(y) => 
        let root = newFile(y);
        deleteFolder(root)
    }

def deleteFolder(f: File): Bool & Impure =  {
    import java.io.File.delete();
    import java.io.File.getPath();
    //import java.io.File.listFiles();
    let File(javaFile) = f;
    //TODO support delete folder that's not empty
    //for ( subFile <- javaFile.listFiles()) 
    javaFile.getPath() |> println;
    if (javaFile.delete()) "Package has been deleted" |> println else "Package has not been deleted" |> println;
    true
}

def mkPackage(x: Option[String]): Int32 & Impure = 
    import java.io.File.createNewFile();
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
        let File(javaFile) = manifest;
        let File(javaLock) = lock;
        mkdirs(root);
        mkdirs(srcfile);
        mkdirs(benches);
        mkdirs(tests);
        mkdirs(examples);
        javaFile.createNewFile();
        javaLock.createNewFile();
        "Package has been made" |> println; 1
    }


    

def main(args: Array[String]): Int32 & Impure =
    let args2 = GetOpt.preprocess({quoteOpen = "'", quoteClose = "'", stripQuoteMarks = false}, args);  
    let header = "Usage: <program> [OPTION...] files...";
    let options1 = options();
    match getOpt(Permute,options1,args2){
        case Success(opts) => {
            //Console.printLine("Optionals: ${opts.options}");
            //Console.printLine("Non-optionals: ${opts.nonOptions}");
            handleOptions(opts.options);
            handleNonOption(opts.nonOptions); 0}
        case Failure(errs) => {Console.printLine("Errors: ${errs}");  Console.printLine(usageInfo(header, options1)); 1}
    }


namespace Pkger {
    /*
    pub def examplePackage(): PackageInfo = 
        PackageInfo({
            name = "MyPackageName",
            version = SemVer(1,2,3), 
            authors = Author({name = "peter", email = None}) :: Nil,
            edition = SemVer(0,14,6),
            dependencies = Nil,
            url = "Nil"})*/
    
    ///
    /// Generate a manifest 
    ///
    //pub def makeManifest(_packgeInfo: List[PackageInfo], _dependencies: List[Dependency]): Unit = ()



    ///
    /// Initializes a new empty project in in the given `path`.
    ///
    pub def initProject(_path: File): Unit = ()

}
