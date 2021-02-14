 ///TODO pre-release version
 namespace SemVer{
    pub enum SemVer{
        case SemVer(Int32, Int32, Int32)
    }

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