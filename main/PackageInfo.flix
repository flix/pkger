use SemVer.SemVer;
use Author.Author;
use Dependency.Dependency;

namespace PackageInfo{
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
 }