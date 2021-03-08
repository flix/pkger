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

use Pkger/PackageInfo.PackageInfo;
use Pkger/PackageInfo.PackageInfo.PackageInfo;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;

namespace Pkger{
    namespace Examples {
        pub def examplePackage1(): PackageInfo = 
            PackageInfo({
                name = "MyPackageNameOne",
                version = SemVer(1,0,0), 
                authors = Author({name = "Peter", email = None, website = None}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "MyPackageNameTwo",version = SemVer(2,0,0)}) :: Nil,
                url = "Nil"})

        pub def examplePackage2(): PackageInfo = 
                PackageInfo({
                    name = "MyPackageNameTwo",
                    version = SemVer(2,0,0), 
                    authors = Author({name = "Jens", email = None, website = None}) :: Nil,
                    edition = SemVer(0,14,6),
                    dependencies = Nil,
                    url = "Nil"})

        pub def examplePackage3(): PackageInfo = 
                PackageInfo({
                    name = "MyPackageNameThree",
                    version = SemVer(3,0,0), 
                    authors = Author({name = "Mathias", email = None, website = None}) :: Nil,
                    edition = SemVer(0,14,6),
                    dependencies = Nil,
                    url = "Nil"})

        pub def examplePackage4(): PackageInfo = 
                PackageInfo({
                    name = "MyPackageNameFour",
                    version = SemVer(4,0,0), 
                    authors = Author({name = "Paul", email = None, website = None}) :: Nil,
                    edition = SemVer(0,14,6),
                    dependencies = Nil,
                    url = "Nil"})

        pub def examplePackage5(): PackageInfo = 
                PackageInfo({
                    name = "MyPackageNameFive",
                    version = SemVer(5,0,0), 
                    authors = Author({name = "Simon", email = None, website = None}) :: Nil,
                    edition = SemVer(0,14,6),
                    dependencies = Nil,
                    url = "Nil"})


    }
}



