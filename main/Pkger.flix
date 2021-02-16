use PackageInfo.PackageInfo.PackageInfo;
use PackageInfo.PackageInfo;
use Author.Author;
use Author.Author.Author;
use SemVer.SemVer;
use SemVer.SemVer.SemVer;
use Dependency.Dependency;
use Core/Io/File.{File, new => newFile, readLines, writeLines,mkdirs,exists};
use GetOpt.{ArgDescr, OptionDescr};
use GetOpt.ArgDescr.{NoArg, ReqArg, OptArg};
use GetOpt.ArgOrder.{RequireOrder, Permute, ReturnInOrder};
use GetOpt.{getOpt, usageInfo};
use Core/Io/IOError.IOError;
use Core/Io/File.File.File;
use String.replace;

namespace Pkger {

    pub def mkPackage(x: Option[String]): Int32 & Impure = 
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

    //Need a way to return current directory to end this madness
    pub def initPackage(): Int32 & Impure = 
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
            0
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
            javaLock.createNewFile();1}
            

    pub def isValidProject(): Bool & Impure = 
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
        if (handleSrc and handleBenches and handleExamples and handleTests and handleManifest and handleLock) "It's valid package" |> println 
        else "It's invalid package" |> println; false
    
    def isValidHelper(file: File): Bool & Impure = 
    match exists(file) {
        case Ok(t) => t 
        case Err(_e) => "error in File exists()"|> println;false
    }

    pub def uninstallPackage(x: Option[String]): Bool & Impure = 
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

}