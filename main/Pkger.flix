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
use Pkger/Dependency.PackageDependency;
use Core/Io/File.{File, new => newFile, readLines, writeLines,mkdirs,exists,isDirectory => isDirectoryNoJava,getName => noJavaFileGetname,newOutputStream,newInputStream};
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
use Core/Io/ZipOutput.{new => newZipOut,ZipOutput,write,close => closeZipOutput};
use Core/Io/InputStream.{readAll,close => closeInput};
use Core/Io/OutputStream.{close => closeOutput};
use Core/Io/ZipOutput.ZipOutput.ZipOutput;


instance ToString[IOError]{
    def toString(x: IOError): String = match x {
        //case IOError.ElementNotFound(String) => "ElementNotFound"
        case IOError.MalformedZip => "MalformedZip" 

    }}

namespace Pkger {

    ///
    ///pack the current package into a jar file
    ///
    pub def makejar(): Result[Bool,IOError] & Impure=
        import java.io.File.listFiles();
        use Result.flatMap;
        let zipTo = newFile("flixCompress.jar");
        let* fos = newOutputStream(zipTo);
        let zipOut = newZipOut(fos);
        let fileToZip = newFile("target/flix");
        let File(javaFileToZip) = fileToZip;
        let flixChild = javaFileToZip.listFiles();
        let flixChildLength = Array.length(flixChild);
        let flixChildWrap = Array.map(File,flixChild);
        foreachHelper(zipFile,flixChildWrap,None,zipOut,flixChildLength,0);
        closeZipOutput(zipOut);
        closeOutput(fos);
        
        Ok(true)
    
    //
    // For each loop
    //
    def foreachHelper(f: (File,String,ZipOutput) ~> Result[Unit,IOError], a: Array[File], parentName: Option[String], b: ZipOutput, len: Int32, i: Int32): Result[Unit,IOError] & Impure =
        use Result.flatMap;
        if (i >= len)
            Ok(())
        else {
            let* fileName = noJavaFileGetname(a[i]); 
            let concateName = match parentName {
                case None => fileName
                case Some(y) => y + "/" + fileName
            }; 
            f(a[i],concateName,b);
            foreachHelper(f,a, parentName,b , len, i + 1);
            Ok(())
            
        }
    
    //
    //zip a file and if it's an directory, it'c childrens as well
    //
    pub def zipFile(f: File, fileName: String,zipOut: ZipOutput): Result[Unit,IOError] & Impure = 
        use Result.flatMap;
        import java.io.File.isDirectory();
        import java.io.File.listFiles();
        import new java.util.zip.ZipEntry(String) as newEntry;
        import java.util.zip.ZipOutputStream.putNextEntry(##java.util.zip.ZipEntry);
        import java.util.zip.ZipOutputStream.closeEntry();
        let File(javaFile) = f; 
        if (javaFile.isDirectory()) {
            if (String.endsWith(fileName,"/")){
                let ZipOutput(javaOutput) = zipOut;
                let dir = newEntry(fileName);
                javaOutput.putNextEntry(dir);
                javaOutput.closeEntry()
            } 
            else {
                let ZipOutput(javaOutput) = zipOut;
                let dir = newEntry(fileName + "/");
                javaOutput.putNextEntry(dir);
                javaOutput.closeEntry()
            };
            let children = javaFile.listFiles();
            let childrenWrap = Array.map(File,children);
            let childdrenLength = Array.length(childrenWrap);
            foreachHelper(zipFile,childrenWrap,Some(fileName),zipOut,childdrenLength,0);
            Ok(())
        } else {
            let* fis = newInputStream(f);
            let* bytes = readAll(fis);
            write(fileName,bytes,zipOut);
            closeInput(fis);
            Ok(())

        }
        
        

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
    // Give a directory and return all .flix files in the directory
    //
    
    pub def getFlixFiles(f: File): Result[List[File],InvalidPackageError] & Impure = {
        import java.io.File.list();
        import java.io.File.listFiles();
        if (checkDirectory(f)){
            let File(rootJavaFile) = f;
            let fileArray = Array.length(rootJavaFile.list());
            if (fileArray == 0) {
                "it's an empty directory" |> println;
                Ok(Nil)
            } 
            else {
                let javaFileArray = rootJavaFile.listFiles();
                let javaFileList = Array.toList(javaFileArray);
                let files = List.map(File,javaFileList);
                let flixFiles = removeNonFlix(files,Nil);
                List.map(noJavaFileGetname,flixFiles) |> println;
                Ok(flixFiles)
            }
        }
        else {
            Err(InvalidPackageError.FileNotExist)
        }   
    }

    
    def removeNonFlix(filelist: List[File], flixList: List[File]): List[File] & Impure = { 
        match filelist {
            case Nil => flixList
            case n :: rest =>   let fileName = match noJavaFileGetname(n){
                                    case Ok(r) => r
                                    case Err(_r) => ???
                                };
                                if(String.endsWith(fileName,".flix")){
                                    let flixList = flixList ::: n::Nil; 
                                    removeNonFlix(rest,flixList)
                                }
                                else {
                                    removeNonFlix(rest,flixList)
                                }                           
        
        }
    }
    

    //
    //return true if input file is a directory 
    //
    def checkDirectory(file: File): Bool & Impure = 
        match isDirectoryNoJava(file) {
            case Ok(t) => t 
            case Err(_e) => "error in File exists()"|> println; false
        }

 
    
    
    ///
    /// Generate a manifest 
    ///
    pub def makeManifest(_packgeInfo: List[PackageInfo], _dependencies: List[PackageDependency]): Unit = ()



    ///
    /// Initializes a new empty project in in the given `path`.
    ///
    pub def initProject(_path: File): Unit = ()

}