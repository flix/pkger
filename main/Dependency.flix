use SemVer.SemVer;
namespace Dependency{
    pub enum Dependency{
        case PackageDependecy(String,SemVer)  
        case FileDependency(String,String)  
    }
}