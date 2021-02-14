use PackageInfo.PackageInfo;

namespace Repository{
    pub enum Repository{
        case Repository(Map[String,List[PackageInfo]])
    }
}