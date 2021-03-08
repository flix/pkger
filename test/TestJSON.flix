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
use Pkger/Examples.examplePackage2;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/SemVer.SemVer;
use Pkger/Author.Author;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.PackageDependency;
use Pkger/JSON.{stringifySemver,stringifyAuthors,stringifyDependency};

    pub def testStringify(): String & Impure = 
        let package1 = {
                name = "MyPackageNameOne",
                version = SemVer(1,0,0), 
                authors = Author({name = "Peter", email = None, website = None}) :: Author({name = "Lily", email = None, website = None}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "MyPackageNameTwo",version =SemVer(2,0,0)}) :: Nil,
                url = "www.google.com"};
        /// let a = examplePackage2();
        /// let PackageInfo(package1) = a;

        let name = package1.name;
        let version = stringifySemver(package1.version);
        let authors = stringifyAuthors(package1.authors);
        let edition = stringifySemver(package1.edition);
        let dependencies = stringifyDependency(package1.dependencies);
        let url = package1.url;
        
        let packageInfoString = Char.toString('"')+"name"+Char.toString('"') + ":" + Char.toString('"')+name+Char.toString('"') + "," + String.lineSeparator()+
                                Char.toString('"')+"version"+Char.toString('"') + ":" + Char.toString('"')+version+Char.toString('"') + "," +String.lineSeparator()+
                                Char.toString('"')+"authors"+Char.toString('"') + ":" + "["+authors+"]" + "," +String.lineSeparator()+
                                Char.toString('"')+"edition"+Char.toString('"') + ":" + Char.toString('"')+edition+Char.toString('"') + "," +String.lineSeparator()+
                                Char.toString('"')+"dependencies"+Char.toString('"') + ":" + "["+dependencies+"]" + "," +String.lineSeparator()+
                                Char.toString('"')+"url"+Char.toString('"') + ":" + Char.toString('"')+url+Char.toString('"');
        let indentString = String.indent(3,packageInfoString);
        let finalPretty = "{" + String.lineSeparator() + indentString + String.lineSeparator()+ "}" ;
        finalPretty |> println;
        finalPretty
    
    @test
    def testJSON01(): Bool & Impure = 
        testStringify();     
        true

    