/*
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

use PackageInfo.PackageInfo.PackageInfo;
use PackageInfo.PackageInfo;
use SemVer.SemVer;
use SemVer.SemVer.SemVer;
use Dependency.PackageDependency;
use Core/Io/File.{File, new => newFile, readLines, writeLines,mkdirs,exists,isDirectory,getName};
use GetOpt.{ArgDescr, OptionDescr};
use GetOpt.ArgDescr.{NoArg, ReqArg, OptArg};
use GetOpt.ArgOrder.{RequireOrder, Permute, ReturnInOrder};
use GetOpt.{getOpt, usageInfo};
use Core/Io/IOError.IOError;
use Core/Io/File.File.File;
use String.replace;
use Pkger/Author.Author.Author;
use Pkger/Author.Author;
use Pkger/PkgerError.InvalidPackageError;

namespace Pkger {
    
    ///
    /// Create a directory name x, then create the skeleton files for a empty package
    ///
    pub def mkPackage(x: Option[String]): Result[Bool,String] & Impure = 
        import java.io.File.createNewFile();
        match x{
            case None => Ok(false)
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
            "Package has been made" |> println; Ok(true)
        }

    ///
    /// Create a new package is current directory is empty
    ///
    pub def initPackage(): Result[Bool,String] & Impure = 
        import java.io.File.list();
        import java.io.File.getAbsolutePath();
        import java.io.File.createNewFile();
        let pivot = newFile("Hi");
        let File(javaFile) = pivot;
        let rootPath = replace("/Hi","",javaFile.getAbsolutePath());
        rootPath |> println;
        let rootFile = newFile(rootPath);
        let File(rootJavaFile) = rootFile;
        if (Array.length(rootJavaFile.list()) > 1) {
            "It's not an empty directory"|> println;
            Ok(false)
            }
        else {
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
            Ok(true)}
            
    //
    // Return true if the package have valid structure
    //
    pub def isValidProject(): Result[Bool,InvalidPackageError] & Impure = 
        use Result.flatMap;
        let srcfile = newFile("src");
        let benches = newFile("benches");
        let examples = newFile("examples");
        let tests = newFile("tests");
        let manifest = newFile("manifest.txt");
        let lock = newFile("lockfile.txt");
        
        let* handleSrc = isValidHelper(srcfile);
        let* handleBenches = isValidHelper(benches);
        let* handleExamples = isValidHelper(examples);
        let* handleTests = isValidHelper(tests);
        let* handleManifest = isValidHelper(manifest);
        let* handleLock = isValidHelper(lock);
        if (handleSrc and handleBenches and handleExamples and handleTests and handleManifest and handleLock) {
            "It's valid package" |> println;
            Ok(true)}
        else {
            "It's invalid package" |> println;
            if (handleSrc == false){ "Missing src Directory"|> println} else {"hi" |> println};
            if (handleBenches == false){ "Missing benches Directory"|> println} else {"hi" |> println};
            if (handleExamples == false){ "Missing examples Directory"|> println} else {"hi" |> println};
            if (handleTests == false){ "Missing tests Directory"|> println} else {"hi" |> println};
            if (handleManifest == false){ "Missing manifest file"|> println} else {"hi" |> println};
            if (handleLock == false){ "Missing Lock file"|> println} else {"hi" |> println};
            Ok(false)}
        
    //
    //return true if the file exist 
    //
    def isValidHelper(file: File): Result[Bool,InvalidPackageError] & Impure = 
        match exists(file) {
            case Ok(t) => Ok(t)  
            case Err(_e) => Err(InvalidPackageError.FileNotExist)
            
        }


    //
    //Return true if package uninstall succesfully 
    //
    pub def uninstallPackage(x: Option[String]): Result[Bool,String] & Impure = 
        use Result.flatMap;
        match x{
            case None => Ok(false)
            case Some(y) => 
                let root = newFile(y);
                let checkExist = match exists(root){
                    case Ok(r) => r
                    case Err(_r) => "The file is not existe" |> println;false
                };
                if (checkExist){
                    deleteFolder(root);
                    Ok(true)
                }
                else {
                    "The file is not existe" |> println;
                    Err("File not exist")
                }
                
        }
    
    //
    //If f is an directory, delete everything inside it and eveything inside it
    //
    def deleteFolder(f: File): Result[Bool,String] & Impure =  {       
        import java.io.File.list();
        import java.io.File.delete();
        import java.io.File.listFiles();
        if (checkDirectory(f)) {
            let File(rootJavaFile) = f;
            let fileArray = Array.length(rootJavaFile.list());
                if (fileArray == 0){
                    "Delete empty directory" |> println; 
                    rootJavaFile.delete();
                    Ok(true)
                }
                else {
                    let javaFileList = rootJavaFile.listFiles();
                    Array.map(delete,javaFileList);
                    rootJavaFile.delete();
                    "Delete this directory and stuffs in it" |> println; Ok(false)
                }
            }
        else { Ok(false) }
    }

    //
    //deleteFolder helper, can't use let*
    //
    def checkDirectory(file: File): Bool & Impure = 
        match isDirectory(file) {
            case Ok(t) => t 
            case Err(_e) => "error in File exists()"|> println; false
        }

 
    pub def examplePackage(): PackageInfo = 
        PackageInfo({
            name = "MyPackageName",
            version = SemVer(1,2,3), 
            authors = Author({name = "peter", email = None, website = None}) :: Nil,
            edition = SemVer(0,14,6),
            dependencies = Nil,
            url = "Nil"})
    
    ///
    /// Generate a manifest 
    ///
    pub def makeManifest(_packgeInfo: List[PackageInfo], _dependencies: List[PackageDependency]): Unit = ()



    ///
    /// Initializes a new empty project in in the given `path`.
    ///
    pub def initProject(_path: File): Unit = ()

}